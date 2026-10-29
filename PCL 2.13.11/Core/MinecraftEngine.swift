import Foundation

nonisolated struct LibraryPlan: Sendable {
    var files: [DownloadItem] = []
    var classpath: [URL] = []
    var natives: [(URL, [String])] = []
}
nonisolated struct LaunchPlan: Sendable {
    let java: JavaRuntime
    let arguments: [String]
    let directory: URL
    var safeDescription: String {
        var output: [String] = []; var hideNext = false
        for argument in arguments {
            if hideNext { output.append("<已隐藏>"); hideNext = false; continue }
            output.append(argument); hideNext = ["--accessToken", "--clientId", "--xuid", "--session"].contains(argument)
        }
        return ([java.path] + output).map { "'" + $0.replacingOccurrences(of: "'", with: "'\\''") + "'" }.joined(separator: " ")
    }
}

actor MinecraftEngine {
    static let manifestURL = "https://piston-meta.mojang.com/mc/game/version_manifest_v2.json"
    let http = HTTPClient.shared
    func manifest() async throws -> Manifest { try await http.decode(Manifest.self, Self.manifestURL) }
    func localVersions(_ root: URL) -> [LocalVersion] {
        let folders = (try? FileManager.default.contentsOfDirectory(at: root.appendingPathComponent("versions"), includingPropertiesForKeys: [.isDirectoryKey])) ?? []
        return folders.filter { !$0.lastPathComponent.hasPrefix(".") }.compactMap { folder in
            let id = folder.lastPathComponent
            guard (try? folder.resourceValues(forKeys: [.isDirectoryKey]).isDirectory) == true else { return nil }
            do {
                let own = try JSONValue.read(Paths.versionJSON(root, id))
                let json = try Metadata.resolve(root: root, id: id)
                let names = json["libraries"].array.compactMap { $0["name"].string }.joined(separator: " ").lowercased()
                let loader = names.contains("fabric-loader") ? "Fabric" : names.contains("quilt-loader") ? "Quilt" : names.contains("neoforge") ? "NeoForge" : names.contains("minecraftforge") ? "Forge" : names.contains("optifine") ? "OptiFine" : "原版"
                let incomplete = FileManager.default.fileExists(atPath: folder.appendingPathComponent(".pcl-incomplete").path)
                return LocalVersion(id: id, type: own["type"].string ?? "release", baseVersion: json["jar"].string ?? id, loader: loader, error: incomplete ? "安装未完成，请修复" : nil)
            } catch { return LocalVersion(id: id, type: "error", baseVersion: id, loader: "未知", error: error.localizedDescription) }
        }.sorted { $0.id.localizedStandardCompare($1.id) == .orderedDescending }
    }
    static func supportsARM(_ json: JSONValue) -> Bool {
        json["libraries"].array.contains { lib in
            (lib["name"].string ?? "").contains("natives-macos-arm64") || lib["downloads"]["classifiers"].object.keys.contains(where: { $0.contains("osx-arm64") || $0.contains("macos-arm64") })
        }
    }
    static func libraries(_ json: JSONValue, root: URL, env: RuleEnvironment) throws -> LibraryPlan {
        var plan = LibraryPlan()
        let arm = env.arch == "arm64" || env.arch == "aarch64"
        let libs = json["libraries"].array
        let hasARM = supportsARM(json)
        for lib in libs {
            guard env.allows(lib["rules"]), let name = lib["name"].string else { continue }
            if name.contains("natives-macos") || name.contains("natives-osx") {
                let nativeARM = name.contains("arm64") || name.contains("aarch64")
                if nativeARM != arm && (hasARM || nativeARM) { continue }
            }
            let artifact = lib["downloads"]["artifact"]
            // A library with explicit downloads but no artifact can be native-only.
            if artifact != .null || lib["downloads"] == .null {
                let path = try artifact["path"].string ?? Metadata.mavenPath(name)
                let destination = try Paths.inside(root, "libraries/" + path)
                let url = artifact["url"].string ?? ((lib["url"].string ?? "https://libraries.minecraft.net/").trimmingCharacters(in: CharacterSet(charactersIn: "/")) + "/" + path)
                if !url.isEmpty {
                    plan.files.append(.init(url: url, destination: destination, sha1: artifact["sha1"].string, size: artifact["size"].int))
                } else if !FileManager.default.fileExists(atPath: destination.path) { throw LauncherError.message("缺少只能由安装器生成的支持库：\(name)") }
                plan.classpath.append(destination)
                if name.contains("natives-macos") || name.contains("natives-osx") { plan.natives.append((destination, ["META-INF/"])) }
            }
            if var classifier = lib["natives"]["osx"].string {
                classifier = classifier.replacingOccurrences(of: "${arch}", with: "64")
                if arm, lib["downloads"]["classifiers"][classifier + "-arm64"] != .null { classifier += "-arm64" }
                let artifact = lib["downloads"]["classifiers"][classifier]
                let path = try artifact["path"].string ?? Metadata.mavenPath(name + ":" + classifier)
                let destination = try Paths.inside(root, "libraries/" + path)
                let url = artifact["url"].string ?? ((lib["url"].string ?? "https://libraries.minecraft.net/").trimmingCharacters(in: CharacterSet(charactersIn: "/")) + "/" + path)
                plan.files.append(.init(url: url, destination: destination, sha1: artifact["sha1"].string, size: artifact["size"].int))
                plan.natives.append((destination, lib["extract"]["exclude"].array.compactMap(\.string) + ["META-INF/"]))
            }
        }
        return plan
    }
    func installVanilla(_ entry: RemoteVersion, root: URL, arch: String = RuleEnvironment.hostArchitecture, progress: @escaping ProgressHandler) async throws -> String {
        try Paths.validateID(entry.id)
        let jsonURL = try Paths.versionJSON(root, entry.id)
        try FileManager.default.createDirectory(at: jsonURL.deletingLastPathComponent(), withIntermediateDirectories: true)
        let marker = jsonURL.deletingLastPathComponent().appendingPathComponent(".pcl-incomplete")
        try Data().write(to: marker)
        await progress(.init(fraction: 0, message: "读取版本描述：\(entry.id)"))
        try await http.download(.init(url: entry.url, destination: jsonURL, sha1: entry.sha1))
        try await repair(entry.id, root: root, arch: arch, progress: progress)
        return entry.id
    }
    func repair(_ id: String, root: URL, arch: String, progress: @escaping ProgressHandler) async throws {
        let json = try Metadata.resolve(root: root, id: id)
        let actualArch = (arch == "arm64" || arch == "aarch64") && !Self.supportsARM(json) ? "x86_64" : arch
        let env = RuleEnvironment(arch: actualArch)
        let libs = try Self.libraries(json, root: root, env: env)
        var files = libs.files
        let jarID = json["jar"].string ?? id
        let client = json["downloads"]["client"]
        let jar = try Paths.inside(root, "versions/\(jarID)/\(jarID).jar")
        if let url = client["url"].string { files.append(.init(url: url, destination: jar, sha1: client["sha1"].string, size: client["size"].int)) }
        else if !FileManager.default.fileExists(atPath: jar.path) { throw LauncherError.message("缺少游戏客户端 JAR，且版本描述没有下载地址。") }
        let logging = json["logging"]["client"]["file"]
        if let file = logging["id"].string, let url = logging["url"].string {
            files.append(.init(url: url, destination: try Paths.inside(root, "assets/log_configs/" + file), sha1: logging["sha1"].string, size: logging["size"].int))
        }
        await progress(.init(fraction: 0.05, message: "下载客户端和支持库"))
        try await http.downloadAll(files, message: "客户端与支持库") { update in
            await progress(.init(fraction: 0.05 + update.fraction * 0.30, message: update.message))
        }
        let asset = json["assetIndex"]
        let assetID = asset["id"].string ?? json["assets"].string ?? "legacy"
        let indexURL = try Paths.inside(root, "assets/indexes/\(assetID).json")
        if let url = asset["url"].string {
            try await http.download(.init(url: url, destination: indexURL, sha1: asset["sha1"].string, size: asset["size"].int))
        }
        guard FileManager.default.fileExists(atPath: indexURL.path) else { throw LauncherError.message("缺少资源索引：\(assetID)。该旧版本需要手动导入资源索引。") }
        let index = try JSONValue.read(indexURL)
        let objects = try index["objects"].object.map { key, object -> DownloadItem in
            guard let hash = object["hash"].string, hash.count == 40, hash.allSatisfy(\.isHexDigit) else { throw LauncherError.message("资源索引包含无效 SHA-1：\(key)") }
            return .init(url: "https://resources.download.minecraft.net/\(hash.prefix(2))/\(hash)", destination: try Paths.inside(root, "assets/objects/\(hash.prefix(2))/\(hash)"), sha1: hash, size: object["size"].int)
        }
        try await http.downloadAll(objects, message: "游戏资源") { update in
            await progress(.init(fraction: 0.35 + update.fraction * 0.60, message: update.message))
        }
        try mapLegacyAssets(index: index, root: root, assetID: assetID, gameDirectory: root)
        let marker = try Paths.versionJSON(root, id).deletingLastPathComponent().appendingPathComponent(".pcl-incomplete")
        if FileManager.default.fileExists(atPath: marker.path) { try FileManager.default.removeItem(at: marker) }
        await progress(.init(fraction: 1, message: "安装完成：\(id)"))
    }
    func installFabric(game: String, loader: String? = nil, customID: String? = nil, root: URL, progress: @escaping ProgressHandler) async throws -> String {
        let entry = try await manifest().versions.first { $0.id == game }
        guard let entry else { throw LauncherError.message("找不到 Minecraft \(game)。") }
        _ = try await installVanilla(entry, root: root, progress: progress)
        let gameEncoded = game.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? game
        let versions = try await http.json("https://meta.fabricmc.net/v2/versions/loader/\(gameEncoded)")
        let selected = loader ?? versions.array.first(where: { $0["loader"]["stable"].bool == true })?["loader"]["version"].string ?? versions.array.first?["loader"]["version"].string
        guard let selected else { throw LauncherError.message("该游戏版本没有兼容的 Fabric Loader。") }
        try Paths.validateID(selected)
        let json = try await http.json("https://meta.fabricmc.net/v2/versions/loader/\(gameEncoded)/\(selected)/profile/json")
        guard let originalID = json["id"].string, json["mainClass"].string != nil else { throw LauncherError.message("Fabric 返回了无效的版本描述。") }
        let id = customID ?? originalID; try Paths.validateID(id)
        let jsonURL = try Paths.versionJSON(root, id)
        if customID != nil, FileManager.default.fileExists(atPath: jsonURL.path) { throw LauncherError.message("该实例已经存在：\(id)") }
        var object = json.object; object["id"] = .string(id)
        try JSONValue.object(object).write(jsonURL)
        try Data().write(to: jsonURL.deletingLastPathComponent().appendingPathComponent(".pcl-incomplete"))
        try await repair(id, root: root, arch: RuleEnvironment.hostArchitecture, progress: progress)
        return id
    }
    func createInstance(id: String, base: String, root: URL) throws {
        let url = try Paths.versionJSON(root, id)
        guard !FileManager.default.fileExists(atPath: url.deletingLastPathComponent().path) else { throw LauncherError.message("实例已经存在：\(id)") }
        try JSONValue.object(["id": .string(id), "inheritsFrom": .string(base), "type": .string("release")]).write(url)
    }
    private func mapLegacyAssets(index: JSONValue, root: URL, assetID: String, gameDirectory: URL) throws {
        let destinations = (index["virtual"].bool == true ? [try Paths.inside(root, "assets/virtual/\(assetID)")] : []) + (index["map_to_resources"].bool == true ? [gameDirectory.appendingPathComponent("resources")] : [])
        for destination in destinations {
            for (name, item) in index["objects"].object {
                guard let hash = item["hash"].string else { continue }
                let source = try Paths.inside(root, "assets/objects/\(hash.prefix(2))/\(hash)")
                let target = try Paths.inside(destination, name)
                if FileManager.default.fileExists(atPath: target.path) { continue }
                try FileManager.default.createDirectory(at: target.deletingLastPathComponent(), withIntermediateDirectories: true)
                try FileManager.default.copyItem(at: source, to: target)
            }
        }
    }
    func prepareLaunch(id: String, root: URL, settings: LauncherSettings, session: GameSession, runtimes: [JavaRuntime], progress: @escaping ProgressHandler) async throws -> LaunchPlan {
        let json = try Metadata.resolve(root: root, id: id)
        let major = Metadata.requiredJava(json)
        let mustUseIntel = RuleEnvironment.hostArchitecture == "arm64" && !Self.supportsARM(json)
        let candidates = runtimes.filter { runtime in
            (settings.javaPath.isEmpty || runtime.path == settings.javaPath) &&
            (major <= 8 ? runtime.major == 8 : runtime.major >= major) && (!mustUseIntel || !runtime.isARM)
        }.sorted { a, b in
            if a.major != b.major { return a.major < b.major }
            return a.isARM && !b.isARM
        }
        guard let java = candidates.first else {
            throw LauncherError.message("该版本需要 Java \(major)\(mustUseIntel ? "（Intel x64；Apple Silicon 需 Rosetta 2）" : "")。请在设置中安装或选择兼容 Java。")
        }
        guard !root.path.contains(":"), (1024...65536).contains(settings.memoryMB), (320...7680).contains(settings.width), (240...4320).contains(settings.height) else {
            throw LauncherError.message("游戏路径不可包含冒号，内存范围为 1024–65536 MB，窗口尺寸也必须有效。")
        }
        try await repair(id, root: root, arch: java.arch, progress: progress)
        let gameDir = try Paths.gameDirectory(root, id, isolated: settings.isolateVersions)
        try FileManager.default.createDirectory(at: gameDir, withIntermediateDirectories: true)
        let assetID = json["assetIndex"]["id"].string ?? json["assets"].string ?? "legacy"
        let index = try JSONValue.read(Paths.inside(root, "assets/indexes/\(assetID).json"))
        try mapLegacyAssets(index: index, root: root, assetID: assetID, gameDirectory: gameDir)
        var env = RuleEnvironment(arch: java.arch)
        env.features = ["is_demo_user": session.demo, "has_custom_resolution": !settings.fullscreen, "has_quick_plays_support": false, "is_quick_play_multiplayer": false]
        let libs = try Self.libraries(json, root: root, env: env)
        let natives = try Paths.inside(root, "versions/\(id)/natives-\(java.arch)")
        // Fresh extraction prevents stale libraries from another loader/version being loaded.
        if FileManager.default.fileExists(atPath: natives.path) { try FileManager.default.removeItem(at: natives) }
        try FileManager.default.createDirectory(at: natives, withIntermediateDirectories: true)
        for (archive, excludes) in libs.natives {
            try Task.checkCancellation()
            let temporary = FileManager.default.temporaryDirectory.appendingPathComponent("pcl-native-\(UUID().uuidString)")
            defer { try? FileManager.default.removeItem(at: temporary) }
            try await SafeArchive.extractZIP(archive, to: temporary)
            do {
                for file in FileTree.files(temporary) {
                    let relative = String(file.path.dropFirst(temporary.path.count + 1))
                    guard !excludes.contains(where: { relative.hasPrefix($0) }), (try file.resourceValues(forKeys: [.isRegularFileKey])).isRegularFile == true else { continue }
                    let target = try Paths.inside(natives, relative)
                    try FileManager.default.createDirectory(at: target.deletingLastPathComponent(), withIntermediateDirectories: true)
                    if FileManager.default.fileExists(atPath: target.path) { try FileManager.default.removeItem(at: target) }
                    try FileManager.default.copyItem(at: file, to: target)
                }
            }
        }
        let jarID = json["jar"].string ?? id
        let jar = try Paths.inside(root, "versions/\(jarID)/\(jarID).jar")
        let classpath = (libs.classpath + [jar]).map(\.path).joined(separator: ":")
        let substitutions: [String: String] = [
            "classpath": classpath, "classpath_separator": ":", "natives_directory": natives.path,
            "library_directory": root.appendingPathComponent("libraries").path,
            "libraries_directory": root.appendingPathComponent("libraries").path,
            "launcher_name": "PCL-macOS-Community", "launcher_version": "0.1.0",
            "version_name": id, "version_type": "PCL macOS Community", "game_directory": gameDir.path,
            "assets_root": root.appendingPathComponent("assets").path, "assets_index_name": assetID,
            "game_assets": root.appendingPathComponent("assets/virtual/\(assetID)").path,
            "auth_player_name": session.account.name, "auth_uuid": session.account.id,
            "auth_access_token": session.accessToken, "access_token": session.accessToken,
            "auth_session": session.accessToken, "user_type": session.account.kind == "msa" ? "msa" : "legacy",
            "user_properties": "{}", "clientid": session.account.clientID ?? "", "auth_xuid": "",
            "resolution_width": String(settings.width), "resolution_height": String(settings.height),
            "quickPlayPath": gameDir.appendingPathComponent("quickPlay/log.json").path,
            "primary_jar": jar.path
        ]
        func replace(_ value: String) throws -> String {
            var result = value
            for (key, text) in substitutions { result = result.replacingOccurrences(of: "${\(key)}", with: text) }
            guard result.range(of: #"\$\{[^}]+\}"#, options: .regularExpression) == nil else { throw LauncherError.message("未知启动参数占位符：\(value)") }
            return result
        }
        var jvm = Metadata.arguments(json["arguments"]["jvm"], env: env)
        if jvm.isEmpty { jvm = ["-Djava.library.path=${natives_directory}", "-cp", "${classpath}"] }
        jvm.removeAll { $0.hasPrefix("-Xmx") || $0.hasPrefix("-Xms") }
        if !jvm.contains("-XstartOnFirstThread") { jvm.insert("-XstartOnFirstThread", at: 0) }
        jvm += ["-Xms512M", "-Xmx\(settings.memoryMB)M", "-Dfile.encoding=UTF-8"]
        if let logging = json["logging"]["client"]["argument"].string, let name = json["logging"]["client"]["file"]["id"].string {
            jvm.append(logging.replacingOccurrences(of: "${path}", with: try Paths.inside(root, "assets/log_configs/" + name).path))
        }
        jvm += try Metadata.tokenize(settings.jvmArguments)
        var game = Metadata.arguments(json["arguments"]["game"], env: env)
        if let legacy = json["minecraftArguments"].string { game = try Metadata.tokenize(legacy) + game }
        if !game.contains("--width") && !settings.fullscreen { game += ["--width", String(settings.width), "--height", String(settings.height)] }
        if settings.fullscreen { game.append("--fullscreen") }
        if session.demo && !game.contains("--demo") { game.append("--demo") }
        if !settings.server.isEmpty {
            let date = json["releaseTime"].string ?? ""
            if date >= "2023-04-04" { game += ["--quickPlayMultiplayer", settings.server] }
            else {
                let parts = settings.server.split(separator: ":", maxSplits: 1).map(String.init)
                game += ["--server", parts[0], "--port", parts.count > 1 ? parts[1] : "25565"]
            }
        }
        game += try Metadata.tokenize(settings.gameArguments)
        guard let mainClass = json["mainClass"].string else { throw LauncherError.message("版本描述缺少 mainClass。") }
        let arguments = try (jvm + [mainClass] + game).map(replace)
        return LaunchPlan(java: java, arguments: arguments, directory: gameDir)
    }
}
