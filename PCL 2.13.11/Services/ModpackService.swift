import Foundation

actor ModpackService {
    let engine: MinecraftEngine
    init(engine: MinecraftEngine) { self.engine = engine }
    func install(_ archive: URL, id: String, root: URL, runtimes: [JavaRuntime], progress: @escaping ProgressHandler) async throws -> String {
        try Paths.validateID(id)
        let targetJSON = try Paths.versionJSON(root, id)
        guard !FileManager.default.fileExists(atPath: targetJSON.deletingLastPathComponent().path) else { throw LauncherError.message("实例已经存在，请换一个名称。") }
        let work = FileManager.default.temporaryDirectory.appendingPathComponent("pcl-pack-\(UUID().uuidString)")
        defer { try? FileManager.default.removeItem(at: work) }
        await progress(.init(fraction: 0.01, message: "安全检查并解压整合包"))
        try await SafeArchive.extractZIP(archive, to: work)
        let manifestNames = ["modrinth.index.json", "mmc-pack.json", "modpack.json", "mcbbs.packmeta", "manifest.json"]
        var base = work
        if !manifestNames.contains(where: { FileManager.default.fileExists(atPath: work.appendingPathComponent($0).path) }) {
            let children = try FileManager.default.contentsOfDirectory(at: work, includingPropertiesForKeys: [.isDirectoryKey]).filter { !$0.lastPathComponent.hasPrefix(".") && $0.lastPathComponent != "__MACOSX" }
            if let child = children.first, children.count == 1 { base = child }
        }
        let mr = base.appendingPathComponent("modrinth.index.json")
        var game: String, loader = "", loaderVersion = "", overlays: [URL] = [], files: [DownloadItem] = []
        let preparedGame = work.appendingPathComponent(".prepared-game")
        try FileManager.default.createDirectory(at: preparedGame, withIntermediateDirectories: true)
        if FileManager.default.fileExists(atPath: mr.path) {
            let index = try JSONValue.read(mr)
            guard index["formatVersion"].int == 1, index["game"].string == "minecraft", let mc = index["dependencies"]["minecraft"].string else { throw LauncherError.message("无效的 Modrinth 整合包格式。") }
            game = mc
            for (key, value) in index["dependencies"].object where key != "minecraft" {
                guard loader.isEmpty else { throw LauncherError.message("不支持同一整合包安装多个加载器。") }
                switch key { case "fabric-loader": loader = "Fabric"; case "forge": loader = "Forge"; case "neoforge", "neo-forge": loader = "NeoForge"; default: throw LauncherError.message("未迁移的整合包加载器：\(key)") }
                loaderVersion = value.string ?? ""
            }
            for file in index["files"].array {
                if file["env"]["client"].string == "unsupported" || file["env"]["client"].string == "optional" { continue }
                guard let path = file["path"].string, let url = file["downloads"].array.first?.string, file["hashes"]["sha1"].string != nil || file["hashes"]["sha512"].string != nil else { throw LauncherError.message("整合包文件缺少路径、下载地址或哈希。") }
                files.append(.init(url: url, destination: try Paths.inside(preparedGame, path), sha1: file["hashes"]["sha1"].string, sha512: file["hashes"]["sha512"].string, size: file["fileSize"].int))
            }
            overlays = [base.appendingPathComponent("overrides"), base.appendingPathComponent("client-overrides")]
        } else if FileManager.default.fileExists(atPath: base.appendingPathComponent("mmc-pack.json").path) {
            let json = try JSONValue.read(base.appendingPathComponent("mmc-pack.json"))
            guard let mc = json["components"].array.first(where: { $0["uid"].string == "net.minecraft" })?["version"].string else { throw LauncherError.message("MultiMC 整合包缺少 Minecraft 版本。") }
            game = mc
            for component in json["components"].array {
                let uid = component["uid"].string ?? ""
                switch uid {
                case "net.minecraft", "org.lwjgl", "org.lwjgl3": continue
                case "net.fabricmc.fabric-loader": loader = "Fabric"
                case "net.minecraftforge": loader = "Forge"
                case "net.neoforged": loader = "NeoForge"
                default: throw LauncherError.message("未迁移的 MultiMC 组件：\(uid)")
                }
                loaderVersion = component["version"].string ?? ""
            }
            overlays = [base.appendingPathComponent(".minecraft"), base.appendingPathComponent("minecraft")]
        } else if FileManager.default.fileExists(atPath: base.appendingPathComponent("modpack.json").path) {
            let json = try JSONValue.read(base.appendingPathComponent("modpack.json"))
            guard let mc = json["gameVersion"].string else { throw LauncherError.message("HMCL 整合包缺少 gameVersion。") }
            game = mc; overlays = [base.appendingPathComponent("minecraft")]
            // HMCL stores a complete version JSON under minecraft; retain its libraries and arguments.
            let embedded = base.appendingPathComponent("minecraft/pack.json")
            if FileManager.default.fileExists(atPath: embedded.path) { throw LauncherError.message("此 HMCL 整合包包含自定义 pack.json，需先导出为 Modrinth 或 MultiMC 格式。") }
        } else { throw LauncherError.message("当前支持 Modrinth .mrpack、MultiMC/Prism 和原版 HMCL 整合包。CurseForge、MCBBS 与带 Windows 启动器的压缩包尚未完成迁移。") }
        try await HTTPClient.shared.downloadAll(files, message: "整合包文件", progress: progress)
        for source in overlays where FileManager.default.fileExists(atPath: source.path) { try copyOverlay(source, to: preparedGame) }
        try Task.checkCancellation()
        do {
            if loader == "Fabric" { _ = try await engine.installFabric(game: game, loader: loaderVersion.isEmpty ? nil : loaderVersion, customID: id, root: root, progress: progress) }
            else if loader == "Forge" || loader == "NeoForge" { _ = try await LoaderInstaller(engine: engine).install(game: game, kind: loader, version: loaderVersion, root: root, runtimes: runtimes, customID: id, progress: progress) }
            else {
                let manifest = try await engine.manifest()
                guard let entry = manifest.versions.first(where: { $0.id == game }) else { throw LauncherError.message("找不到整合包要求的 Minecraft。") }
                _ = try await engine.installVanilla(entry, root: root, progress: progress)
                try await engine.createInstance(id: id, base: game, root: root)
            }
            let gameDirectory = try Paths.gameDirectory(root, id, isolated: true)
            try FileManager.default.moveItem(at: preparedGame, to: gameDirectory)
            try JSONValue.object(["format": .string("pcl-macos-instance"), "isolate": .bool(true), "source": .string(archive.lastPathComponent)]).write(targetJSON.deletingLastPathComponent().appendingPathComponent("instance.json"))
            await progress(.init(fraction: 1, message: "整合包安装完成：\(id)"))
            return id
        } catch {
            // Only roll back the new named instance; shared Minecraft downloads remain reusable.
            if FileManager.default.fileExists(atPath: targetJSON.deletingLastPathComponent().path) { try? FileManager.default.removeItem(at: targetJSON.deletingLastPathComponent()) }
            throw error
        }
    }
    private func copyOverlay(_ source: URL, to target: URL) throws {
        if let files = FileManager.default.enumerator(at: source, includingPropertiesForKeys: [.isRegularFileKey]) {
            for case let file as URL in files {
                let relative = String(file.path.dropFirst(source.path.count + 1))
                let destination = try Paths.inside(target, relative)
                if (try file.resourceValues(forKeys: [.isRegularFileKey])).isRegularFile != true { continue }
                try FileManager.default.createDirectory(at: destination.deletingLastPathComponent(), withIntermediateDirectories: true)
                if FileManager.default.fileExists(atPath: destination.path) { try FileManager.default.removeItem(at: destination) }
                try FileManager.default.copyItem(at: file, to: destination)
            }
        }
    }
    func exportInstance(id: String, root: URL, destination: URL, isolated: Bool) async throws {
        let game = try Paths.gameDirectory(root, id, isolated: isolated)
        guard FileManager.default.fileExists(atPath: game.path) else { throw LauncherError.message("游戏目录尚未创建。") }
        let result = try await Command.run("/usr/bin/ditto", ["-c", "-k", "--sequesterRsrc", "--keepParent", game.path, destination.path], timeout: 300)
        guard result.status == 0 else { throw LauncherError.message("导出失败：\(result.output.prefix(300))") }
    }
}
