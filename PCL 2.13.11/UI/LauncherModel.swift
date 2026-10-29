import Foundation
import SwiftUI
import AppKit
import Combine
import AVFoundation
import UniformTypeIdentifiers

struct LogEntry: Identifiable { let id = UUID(); let text: String; let date = Date() }
struct LauncherNotice: Identifiable { let id = UUID(); let title: String; let text: String }
enum LauncherPage: String, CaseIterable, Identifiable {
    case launch = "启动", link = "联机", help = "帮助", versions = "版本", download = "下载", resources = "资源", mods = "Mod 管理", accounts = "账号", settings = "设置", logs = "日志", about = "关于"
    var id: String { rawValue }
    var icon: String {
        switch self { case .launch: return "play.fill"; case .link: return "wifi"; case .help: return "questionmark.circle"; case .versions: return "square.stack.3d.up"; case .download: return "arrow.down.circle"; case .resources: return "square.grid.2x2"; case .mods: return "puzzlepiece.extension"; case .accounts: return "person.crop.circle"; case .settings: return "slider.horizontal.3"; case .logs: return "terminal"; case .about: return "info.circle" }
    }
}

@MainActor
final class LauncherModel: ObservableObject {
    @Published var settings = LauncherSettings() { didSet { if loaded { persist() } } }
    @Published var page: LauncherPage = .launch
    @Published var resourceKind = "mod"
    @Published var settingsSection = "启动"
    @Published var versions: [LocalVersion] = []
    @Published var remoteVersions: [RemoteVersion] = []
    @Published var runtimes: [JavaRuntime] = []
    @Published var mods: [LocalMod] = []
    @Published var logs: [LogEntry] = []
    @Published var busy = false
    @Published var running = false
    @Published var progress = InstallProgress(fraction: 0, message: "准备就绪")
    @Published var notice: LauncherNotice?
    @Published var device: DeviceAuthorization?
    @Published var buyPrompt = false
    @Published var sponsorPrompt = false
    @Published var projects: [ResourceProject] = []
    @Published var resourceVersions: [ResourceVersion] = []
    @Published var resourceSearching = false
    @Published var musicPlaying = false
    @Published var musicName = ""
    let engine = MinecraftEngine(), javaService = JavaService(), accounts = AccountService(), resources = ResourceService()
    private var operation: Task<Void, Never>?
    private var searchTask: Task<Void, Never>?
    private var process: Process?
    private var processReader: Task<Void, Never>?
    private var player: AVAudioPlayer?
    private var logFile: FileHandle?
    private var secretTokens: [String] = []
    private var loaded = false
    private var restoring = false
    var root: URL { URL(fileURLWithPath: (settings.gameRoot as NSString).expandingTildeInPath).standardizedFileURL }
    var selectedVersion: LocalVersion? { versions.first { $0.id == settings.selectedVersion } }
    var selectedAccount: GameAccount? { settings.accounts.first { $0.id == settings.selectedAccount } }
    var gameDirectory: URL? { try? Paths.gameDirectory(root, settings.selectedVersion, isolated: effectiveIsolation) }
    var effectiveIsolation: Bool {
        guard let url = try? Paths.versionJSON(root, settings.selectedVersion).deletingLastPathComponent().appendingPathComponent("instance.json"), let json = try? JSONValue.read(url) else { return settings.isolateVersions }
        return json["isolate"].bool ?? settings.isolateVersions
    }
    init() {
        if FileManager.default.fileExists(atPath: Paths.settings.path) {
            do { settings = try JSONDecoder().decode(LauncherSettings.self, from: Data(contentsOf: Paths.settings)) }
            catch {
                // Preserve unreadable settings rather than silently overwriting them.
                let backup = Paths.support.appendingPathComponent("settings-unreadable-\(Int(Date().timeIntervalSince1970)).json")
                do { try FileManager.default.copyItem(at: Paths.settings, to: backup) }
                catch { restoring = true }
                notice = .init(title: "配置读取失败", text: "原配置无法读取。\(restoring ? "已停止自动保存，请检查文件权限。" : "已保留备份并使用默认配置。")")
            }
        }
        loaded = true
        Task { await refreshLocal(); await discoverJava() }
    }
    func persist() {
        guard !restoring else { return }
        do {
            try FileManager.default.createDirectory(at: Paths.support, withIntermediateDirectories: true)
            let encoder = JSONEncoder(); encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            try encoder.encode(settings).write(to: Paths.settings, options: .atomic)
        } catch { notice = .init(title: "保存设置失败", text: error.localizedDescription) }
    }
    func appendLog(_ raw: String) {
        var text = raw
        for token in secretTokens where !token.isEmpty && token != "0" { text = text.replacingOccurrences(of: token, with: "<令牌已隐藏>") }
        text = text.replacingOccurrences(of: #"(?i)(Bearer\s+)[A-Za-z0-9_.\-]+"#, with: "$1<已隐藏>", options: .regularExpression)
        for line in text.split(separator: "\n", omittingEmptySubsequences: false) where !line.isEmpty {
            logs.append(.init(text: String(line)))
            if let data = (String(line) + "\n").data(using: .utf8) { try? logFile?.write(contentsOf: data) }
        }
        if logs.count > 3000 { logs.removeFirst(logs.count - 3000) }
    }
    func refreshLocal() async {
        versions = await engine.localVersions(root)
        if !versions.contains(where: { $0.id == settings.selectedVersion }) { settings.selectedVersion = versions.first?.id ?? "" }
        await refreshMods()
    }
    func discoverJava() async { runtimes = await javaService.discover(custom: settings.javaPath) }
    func refreshMods() async {
        guard let directory = gameDirectory else { mods = []; return }
        mods = await resources.localMods(directory)
    }
    func runOperation(_ title: String, _ action: @escaping @MainActor () async throws -> Void) {
        guard !busy else { return }
        busy = true; progress = .init(fraction: 0, message: title)
        appendLog(title)
        operation = Task {
            defer { busy = false; operation = nil; device = nil }
            do { try await action(); try Task.checkCancellation() }
            catch is CancellationError { progress.message = "已取消"; appendLog("操作已取消。") }
            catch {
                if Task.isCancelled { progress.message = "已取消"; appendLog("操作已取消。") }
                else { progress.message = "操作失败"; appendLog("错误：" + error.localizedDescription); notice = .init(title: "操作失败", text: error.localizedDescription) }
            }
            await refreshLocal()
        }
    }
    func cancel() { operation?.cancel() }
    private func updateProgress(_ value: InstallProgress) { progress = value }
    var progressHandler: ProgressHandler { { [weak self] update in await self?.updateProgress(update) } }
    func loadManifest() {
        runOperation("读取 Minecraft 官方版本列表") {
            self.remoteVersions = try await self.engine.manifest().versions
            self.progress = .init(fraction: 1, message: "已读取 \(self.remoteVersions.count) 个版本")
        }
    }
    func install(_ entry: RemoteVersion, loader: String, loaderVersion: String = "") {
        runOperation("安装 \(entry.id) \(loader)") {
            let id: String
            if loader == "Fabric" { id = try await self.engine.installFabric(game: entry.id, root: self.root, progress: self.progressHandler) }
            else if loader == "Forge" || loader == "NeoForge" {
                guard !loaderVersion.isEmpty else { throw LauncherError.message("请填写要安装的加载器版本号。") }
                id = try await LoaderInstaller(engine: self.engine).install(game: entry.id, kind: loader, version: loaderVersion, root: self.root, runtimes: self.runtimes, progress: self.progressHandler)
            } else { id = try await self.engine.installVanilla(entry, root: self.root, progress: self.progressHandler) }
            self.settings.selectedVersion = id
        }
    }
    func repairSelected() {
        let id = settings.selectedVersion
        runOperation("检查并修复 \(id)") { try await self.engine.repair(id, root: self.root, arch: RuleEnvironment.hostArchitecture, progress: self.progressHandler) }
    }
    func login() {
        runOperation("等待微软账号登录") {
            let session = try await self.accounts.login(clientID: self.settings.microsoftClientID) { device in
                await MainActor.run { self.device = device }
            }
            self.settings.accounts.removeAll { $0.id == session.account.id }
            self.settings.accounts.append(session.account)
            self.settings.selectedAccount = session.account.id
            self.settings.hasVerifiedOwnership = true
            self.progress = .init(fraction: 1, message: "已登录：\(session.account.name)")
            self.appendLog("微软账号登录成功：\(session.account.name)")
        }
    }
    func removeAccount(_ account: GameAccount) {
        do {
            try SecureStore.remove(id: account.id)
            settings.accounts.removeAll { $0.id == account.id }
            if settings.selectedAccount == account.id { settings.selectedAccount = "offline" }
        } catch { notice = .init(title: "移除账号失败", text: error.localizedDescription) }
    }
    func launch() {
        guard !busy, !running, !settings.selectedVersion.isEmpty else { return }
        if settings.selectedAccount == "offline" && !settings.hasVerifiedOwnership { buyPrompt = true; return }
        startGame(demo: false)
    }
    func startGame(demo: Bool) {
        guard !running else { return }
        let id = settings.selectedVersion
        runOperation("准备启动 \(id)") {
            let session: GameSession
            if let account = self.selectedAccount { session = try await self.accounts.refresh(account) }
            else { session = try GameSession.offline(self.settings.offlineName, demo: demo) }
            self.secretTokens = [session.accessToken]
            var config = self.settings; config.isolateVersions = self.effectiveIsolation
            let plan = try await self.engine.prepareLaunch(id: id, root: self.root, settings: config, session: session, runtimes: self.runtimes, progress: self.progressHandler)
            try Task.checkCancellation()
            try self.spawn(plan)
            self.settings.launchCount += 1
            let milestones = [10, 20, 40, 60, 80, 100, 120, 150, 200, 250, 300, 350, 400, 500, 600, 700, 800, 900, 1000, 1200, 1400, 1600, 1800, 2000]
            if milestones.contains(self.settings.launchCount) { self.sponsorPrompt = true }
        }
    }
    private func spawn(_ plan: LaunchPlan) throws {
        let logsRoot = Paths.support.appendingPathComponent("logs")
        try FileManager.default.createDirectory(at: logsRoot, withIntermediateDirectories: true)
        let logURL = logsRoot.appendingPathComponent("game-\(Int(Date().timeIntervalSince1970)).log")
        FileManager.default.createFile(atPath: logURL.path, contents: nil)
        try? logFile?.close(); logFile = try FileHandle(forWritingTo: logURL)
        appendLog("Java：\(plan.java.display)\n游戏目录：\(plan.directory.path)\n" + plan.safeDescription)
        let p = Process(), pipe = Pipe()
        p.executableURL = URL(fileURLWithPath: plan.java.path); p.arguments = plan.arguments
        p.currentDirectoryURL = plan.directory; p.standardOutput = pipe; p.standardError = pipe; p.standardInput = FileHandle.nullDevice
        var environment = ProcessInfo.processInfo.environment
        environment["JAVA_HOME"] = URL(fileURLWithPath: plan.java.path).deletingLastPathComponent().deletingLastPathComponent().path
        // User-supplied shell injection variables should not alter the selected JVM.
        environment.removeValue(forKey: "JAVA_TOOL_OPTIONS"); environment.removeValue(forKey: "_JAVA_OPTIONS"); environment.removeValue(forKey: "JDK_JAVA_OPTIONS")
        p.environment = environment
        try p.run(); process = p; running = true
        progress = .init(fraction: 1, message: "游戏正在运行")
        processReader = Task.detached { [weak self] in
            var buffer = Data()
            do {
                while let data = try pipe.fileHandleForReading.read(upToCount: 8192), !data.isEmpty {
                    buffer.append(data)
                    while let newline = buffer.firstIndex(of: 10) {
                        let line = String(decoding: buffer[..<newline], as: UTF8.self)
                        buffer.removeSubrange(...newline)
                        await self?.appendLog(line)
                    }
                    if buffer.count > 1024 * 1024 { await self?.appendLog(String(decoding: buffer, as: UTF8.self)); buffer.removeAll() }
                }
                if !buffer.isEmpty { await self?.appendLog(String(decoding: buffer, as: UTF8.self)) }
            } catch { await self?.appendLog("游戏日志读取失败：\(error.localizedDescription)") }
            p.waitUntilExit()
            await self?.gameExited(p.terminationStatus)
        }
    }
    private func gameExited(_ status: Int32) {
        running = false; process = nil; processReader = nil
        appendLog("游戏已退出，退出码：\(status)")
        progress.message = status == 0 ? "游戏已退出" : "游戏异常退出（\(status)）"
        try? logFile?.close(); logFile = nil
        if status != 0 { notice = .init(title: "游戏异常退出", text: crashAdvice + "\n详细信息请查看日志。") }
    }
    var crashAdvice: String {
        let text = logs.suffix(200).map(\.text).joined(separator: "\n")
        if text.contains("OutOfMemoryError") { return "Java 内存不足，请在设置中提高分配内存。" }
        if text.contains("UnsupportedClassVersionError") { return "Java 版本不兼容，请选择该游戏版本要求的 Java。" }
        if text.contains("UnsatisfiedLinkError") || text.contains("incompatible architecture") { return "原生库或 Java 架构不兼容。旧版本在 Apple Silicon 上需要 Intel Java 和 Rosetta 2。" }
        if text.contains("Incompatible mods") || text.contains("ModResolutionException") { return "Mod 的依赖或版本不兼容，请检查 Mod 管理页。" }
        if text.contains("Mixin") { return "可能存在 Mixin 或 Mod 冲突，请检查日志中的 Mod 名称。" }
        return "请检查 Java、Mod 和游戏日志中的首个异常。"
    }
    func stopGame() { process?.terminate() }
    func chooseRoot() {
        let panel = NSOpenPanel(); panel.canChooseDirectories = true; panel.canChooseFiles = false; panel.prompt = "选择 Minecraft 目录"
        guard panel.runModal() == .OK, let url = panel.url else { return }
        settings.gameRoot = url.path; Task { await refreshLocal() }
    }
    func chooseJava() {
        let panel = NSOpenPanel(); panel.message = "选择 JDK 的 Contents/Home/bin/java"; panel.canChooseDirectories = false
        guard panel.runModal() == .OK, let url = panel.url else { return }
        settings.javaPath = url.path; Task { await discoverJava() }
    }
    func installJava(_ major: Int, intel: Bool) {
        runOperation("安装 Java \(major)") { _ = try await self.javaService.install(major: major, intel: intel, progress: self.progressHandler); await self.discoverJava() }
    }
    func openDirectory(_ url: URL?) {
        guard let url else { return }
        do { try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true); NSWorkspace.shared.open(url) }
        catch { notice = .init(title: "打开目录失败", text: error.localizedDescription) }
    }
    func openLink(_ string: String) { if let url = URL(string: string), url.scheme == "https" { NSWorkspace.shared.open(url) } }
    func importModFiles() {
        guard let directory = gameDirectory, !busy, !running else { return }
        let panel = NSOpenPanel(); panel.allowsMultipleSelection = true; panel.allowedContentTypes = [UTType(filenameExtension: "jar") ?? .data]
        guard panel.runModal() == .OK else { return }
        let files = panel.urls
        runOperation("导入 Mod") { try await self.resources.importMods(files, directory: directory) }
    }
    func toggleMod(_ mod: LocalMod) {
        guard !busy, !running else { return }
        runOperation("切换 Mod：\(mod.name)") { try await self.resources.toggle(mod) }
    }
    func trashMod(_ mod: LocalMod) {
        guard !busy, !running else { return }
        do { try FileManager.default.trashItem(at: mod.url, resultingItemURL: nil); Task { await refreshMods() } }
        catch { notice = .init(title: "移除 Mod 失败", text: error.localizedDescription) }
    }
    func importPack(id: String) {
        guard !busy, !running else { return }
        let panel = NSOpenPanel(); panel.allowedContentTypes = [.zip, UTType(filenameExtension: "mrpack") ?? .data]
        guard panel.runModal() == .OK, let url = panel.url else { return }
        runOperation("导入整合包：\(id)") {
            let newID = try await ModpackService(engine: self.engine).install(url, id: id, root: self.root, runtimes: self.runtimes, progress: self.progressHandler)
            self.settings.selectedVersion = newID
        }
    }
    func exportGameFiles() {
        guard let directory = gameDirectory else { return }
        let panel = NSSavePanel(); panel.allowedContentTypes = [.zip]; panel.nameFieldStringValue = settings.selectedVersion + "-game.zip"
        guard panel.runModal() == .OK, let url = panel.url else { return }
        runOperation("导出游戏目录") {
            let result = try await Command.run("/usr/bin/ditto", ["-c", "-k", "--keepParent", directory.path, url.path], timeout: 300)
            guard result.status == 0 else { throw LauncherError.message("导出失败：\(result.output.prefix(500))") }
        }
    }
    func searchResources(query: String, kind: String, compatibleOnly: Bool) {
        searchTask?.cancel(); resourceSearching = true
        let version = selectedVersion
        searchTask = Task {
            defer { resourceSearching = false }
            do {
                let loader = compatibleOnly && kind == "mod" && version?.loader != "原版" ? version?.loader.lowercased() ?? "" : ""
                let result = try await resources.search(query: query, kind: kind, game: compatibleOnly ? version?.baseVersion ?? "" : "", loader: loader)
                try Task.checkCancellation(); projects = result.hits
            } catch { if !Task.isCancelled { notice = .init(title: "搜索失败", text: error.localizedDescription) } }
        }
    }
    func loadResourceVersions(_ project: ResourceProject, compatibleOnly: Bool) async {
        do {
            let loader = compatibleOnly && project.project_type == "mod" && selectedVersion?.loader != "原版" ? selectedVersion?.loader.lowercased() ?? "" : ""
            resourceVersions = try await resources.versions(project: project.id, game: compatibleOnly ? selectedVersion?.baseVersion ?? "" : "", loader: loader)
        } catch { notice = .init(title: "读取资源版本失败", text: error.localizedDescription) }
    }
    func installResource(_ version: ResourceVersion, kind: String) {
        guard !running else { return }
        let directory = gameDirectory, selected = selectedVersion
        runOperation("安装资源：\(version.name)") {
            if kind == "modpack" {
                guard let file = version.files.first(where: \.primary) ?? version.files.first else { throw LauncherError.message("整合包缺少下载文件。") }
                let temp = FileManager.default.temporaryDirectory.appendingPathComponent("pcl-\(UUID().uuidString).mrpack")
                defer { try? FileManager.default.removeItem(at: temp) }
                try await HTTPClient.shared.download(.init(url: file.url, destination: temp, sha1: file.hashes["sha1"], sha512: file.hashes["sha512"], size: file.size))
                let id = "Pack-" + version.id
                self.settings.selectedVersion = try await ModpackService(engine: self.engine).install(temp, id: id, root: self.root, runtimes: self.runtimes, progress: self.progressHandler)
            } else {
                guard let directory, let selected else { throw LauncherError.message("请先选择游戏版本。") }
                if kind == "mod", selected.loader == "原版" { throw LauncherError.message("原版 Minecraft 无法加载 Mod，请先安装 Fabric、Forge 或 NeoForge。") }
                try await self.resources.install(version, kind: kind, game: selected.baseVersion, loader: kind == "mod" ? selected.loader.lowercased() : "", directory: directory, progress: self.progressHandler)
            }
        }
    }
    func exportLogs() {
        let panel = NSSavePanel(); panel.nameFieldStringValue = "PCL-macOS.log"; panel.allowedContentTypes = [.plainText]
        guard panel.runModal() == .OK, let url = panel.url else { return }
        do { try logs.map(\.text).joined(separator: "\n").write(to: url, atomically: true, encoding: .utf8) }
        catch { notice = .init(title: "导出日志失败", text: error.localizedDescription) }
    }
    func chooseMusic() {
        let panel = NSOpenPanel(); panel.allowedContentTypes = [.audio]
        guard panel.runModal() == .OK, let url = panel.url else { return }
        do { player = try AVAudioPlayer(contentsOf: url); player?.numberOfLoops = -1; player?.play(); musicName = url.lastPathComponent; musicPlaying = true }
        catch { notice = .init(title: "音乐播放失败", text: error.localizedDescription) }
    }
    func toggleMusic() { if musicPlaying { player?.pause() } else { player?.play() }; musicPlaying = player?.isPlaying ?? false }
}
