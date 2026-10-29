import Foundation

actor LoaderInstaller {
    let engine: MinecraftEngine
    init(engine: MinecraftEngine) { self.engine = engine }
    func versions(game: String, kind: String) async throws -> [String] {
        let url = kind == "Forge" ? "https://maven.minecraftforge.net/net/minecraftforge/forge/maven-metadata.xml" : "https://maven.neoforged.net/releases/net/neoforged/neoforge/maven-metadata.xml"
        let data = try await HTTPClient.shared.data(url)
        let xml = String(decoding: data, as: UTF8.self)
        let regex = try NSRegularExpression(pattern: "<version>([^<]+)</version>")
        let values = regex.matches(in: xml, range: NSRange(xml.startIndex..., in: xml)).compactMap { match -> String? in
            guard let range = Range(match.range(at: 1), in: xml) else { return nil }; return String(xml[range])
        }
        if kind == "Forge" { return values.filter { $0.hasPrefix(game + "-") }.reversed() }
        let parts = game.split(separator: ".")
        let prefix: String
        if parts.count >= 2 && parts[0] == "1" { prefix = "\(parts[1]).\(parts.count > 2 ? String(parts[2]) : "0")." }
        else { prefix = game + "." }
        return values.filter { $0.hasPrefix(prefix) }.reversed()
    }
    func install(game: String, kind: String, version: String, root: URL, runtimes: [JavaRuntime], customID: String? = nil, progress: @escaping ProgressHandler) async throws -> String {
        guard kind == "Forge" || kind == "NeoForge" else { throw LauncherError.message("无法识别加载器。") }
        try Paths.validateID(version)
        let manifest = try await engine.manifest()
        guard let entry = manifest.versions.first(where: { $0.id == game }) else { throw LauncherError.message("找不到基础游戏版本。") }
        _ = try await engine.installVanilla(entry, root: root, progress: progress)
        let base = try Metadata.resolve(root: root, id: game), required = Metadata.requiredJava(base)
        guard let java = runtimes.filter({ $0.major >= max(8, required) }).sorted(by: { $0.major < $1.major }).first else { throw LauncherError.message("安装 \(kind) 前需要安装 Java \(required) 或更高版本。") }
        let coordinate = kind == "Forge" ? (version.hasPrefix(game + "-") ? version : game + "-" + version) : version
        let path = kind == "Forge" ? "https://maven.minecraftforge.net/net/minecraftforge/forge/\(coordinate)/forge-\(coordinate)-installer.jar" : "https://maven.neoforged.net/releases/net/neoforged/neoforge/\(coordinate)/neoforge-\(coordinate)-installer.jar"
        let work = FileManager.default.temporaryDirectory.appendingPathComponent("pcl-loader-\(UUID().uuidString)")
        defer { try? FileManager.default.removeItem(at: work) }
        try FileManager.default.createDirectory(at: work, withIntermediateDirectories: true)
        let jar = work.appendingPathComponent("installer.jar")
        let hashData = try await HTTPClient.shared.data(path + ".sha1")
        guard let hash = String(decoding: hashData, as: UTF8.self).split(whereSeparator: \.isWhitespace).first.map(String.init), hash.count == 40, hash.allSatisfy(\.isHexDigit) else { throw LauncherError.message("安装器没有提供有效的 SHA-1。") }
        try await HTTPClient.shared.download(.init(url: path, destination: jar, sha1: hash))
        let profiles = root.appendingPathComponent("launcher_profiles.json")
        if !FileManager.default.fileExists(atPath: profiles.path) { try JSONValue.object(["profiles": .object([:]), "clientToken": .string(UUID().uuidString)]).write(profiles) }
        try SafeArchive.validateZIP(jar)
        let profileResult = try await Command.run("/usr/bin/unzip", ["-p", jar.path, "version.json"])
        guard profileResult.status == 0, let profile = try? JSONDecoder().decode(JSONValue.self, from: Data(profileResult.output.utf8)), let generatedID = profile["id"].string else {
            throw LauncherError.message("此旧版安装器未提供 version.json；原版 PCL 使用自定义 Java 安装助手，当前原生版需要手动安装该版本后扫描。")
        }
        let before = try Paths.versionJSON(root, generatedID)
        let existed = FileManager.default.fileExists(atPath: before.path)
        await progress(.init(fraction: 0.65, message: "运行官方 \(kind) 安装器，首次安装可能需要几分钟"))
        let result = try await Command.run(java.path, ["-Djava.awt.headless=true", "-jar", jar.path, "--installClient", root.path], directory: work, timeout: 900)
        guard result.status == 0, FileManager.default.fileExists(atPath: before.path) else { throw LauncherError.message("\(kind) 安装器失败：\n\(result.output.suffix(1800))") }
        var id = generatedID
        if let customID {
            try await engine.createInstance(id: customID, base: generatedID, root: root); id = customID
        }
        do { try await engine.repair(id, root: root, arch: RuleEnvironment.hostArchitecture, progress: progress) }
        catch {
            if !existed, let marker = try? Paths.versionJSON(root, generatedID).deletingLastPathComponent().appendingPathComponent(".pcl-incomplete") { try? Data().write(to: marker) }
            throw error
        }
        return id
    }
}
