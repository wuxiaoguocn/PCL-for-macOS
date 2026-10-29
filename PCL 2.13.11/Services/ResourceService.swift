import Foundation

nonisolated struct ResourceProject: Codable, Identifiable, Sendable {
    let project_id: String
    let slug: String
    let title: String
    let description: String
    let project_type: String
    let downloads: Int
    let icon_url: String?
    var id: String { project_id }
}
nonisolated struct ResourceSearch: Codable, Sendable { let hits: [ResourceProject]; let total_hits: Int }
nonisolated struct ResourceFile: Codable, Sendable {
    let filename: String
    let url: String
    let hashes: [String: String]
    let size: Int
    let primary: Bool
}
nonisolated struct ResourceDependency: Codable, Sendable {
    let version_id: String?
    let project_id: String?
    let dependency_type: String
}
nonisolated struct ResourceVersion: Codable, Identifiable, Sendable {
    let id: String
    let project_id: String
    let name: String
    let version_number: String
    let game_versions: [String]
    let loaders: [String]
    let files: [ResourceFile]
    let dependencies: [ResourceDependency]
}
nonisolated struct LocalMod: Identifiable, Sendable {
    let url: URL
    let name: String
    let version: String
    let modID: String
    let enabled: Bool
    var id: String { url.path }
}

actor ResourceService {
    let http = HTTPClient.shared
    func search(query: String, kind: String, game: String = "", loader: String = "") async throws -> ResourceSearch {
        var facets = [["project_type:" + kind]]
        if !game.isEmpty { facets.append(["versions:" + game]) }
        if !loader.isEmpty && kind == "mod" { facets.append(["categories:" + loader.lowercased()]) }
        var url = URLComponents(string: "https://api.modrinth.com/v2/search")!
        url.queryItems = [URLQueryItem(name: "query", value: query), URLQueryItem(name: "facets", value: String(decoding: try JSONEncoder().encode(facets), as: UTF8.self)), URLQueryItem(name: "limit", value: "40"), URLQueryItem(name: "index", value: query.isEmpty ? "downloads" : "relevance")]
        return try await http.decode(ResourceSearch.self, url.url!.absoluteString)
    }
    func versions(project: String, game: String = "", loader: String = "") async throws -> [ResourceVersion] {
        try Paths.validateID(project)
        var url = URLComponents(string: "https://api.modrinth.com/v2/project/\(project)/version")!
        var items: [URLQueryItem] = []
        if !game.isEmpty { items.append(.init(name: "game_versions", value: String(decoding: try JSONEncoder().encode([game]), as: UTF8.self))) }
        if !loader.isEmpty { items.append(.init(name: "loaders", value: String(decoding: try JSONEncoder().encode([loader.lowercased()]), as: UTF8.self))) }
        url.queryItems = items
        return try await http.decode([ResourceVersion].self, url.url!.absoluteString)
    }
    func install(_ version: ResourceVersion, kind: String, game: String, loader: String, directory: URL, progress: @escaping ProgressHandler) async throws {
        guard kind != "modpack" else { throw LauncherError.message("请通过整合包导入功能安装 .mrpack。") }
        let folder = ["mod": "mods", "resourcepack": "resourcepacks", "shader": "shaderpacks", "datapack": "datapacks"][kind]
        guard let folder else { throw LauncherError.message("无法识别资源类型。") }
        let target = try Paths.inside(directory, folder)
        var collected: [ResourceVersion] = []
        try await collect(version, game: game, loader: loader, seen: [], output: &collected)
        let items = try collected.map { v -> DownloadItem in
            guard let file = v.files.first(where: \.primary) ?? v.files.first else { throw LauncherError.message("资源版本没有可下载文件。") }
            try Paths.validateID(file.filename)
            if kind == "mod", !file.filename.lowercased().hasSuffix(".jar") { throw LauncherError.message("Mod 下载不是 JAR 文件。") }
            guard file.hashes["sha1"] != nil || file.hashes["sha512"] != nil else { throw LauncherError.message("资源没有提供校验哈希。") }
            return .init(url: file.url, destination: try Paths.inside(target, file.filename), sha1: file.hashes["sha1"], sha512: file.hashes["sha512"], size: file.size)
        }
        // Collect the dependency closure before writing; incompatible dependencies cannot half-install.
        let staging = directory.appendingPathComponent(".pcl-resources-\(UUID().uuidString)")
        defer { try? FileManager.default.removeItem(at: staging) }
        let staged = items.map { DownloadItem(url: $0.url, destination: staging.appendingPathComponent($0.destination.lastPathComponent), sha1: $0.sha1, sha512: $0.sha512, size: $0.size) }
        try await http.downloadAll(staged, message: "下载资源与必需依赖", progress: progress)
        try FileManager.default.createDirectory(at: target, withIntermediateDirectories: true)
        for (item, file) in zip(items, staged) {
            try Task.checkCancellation()
            if FileManager.default.fileExists(atPath: item.destination.path) { _ = try FileManager.default.replaceItemAt(item.destination, withItemAt: file.destination) }
            else { try FileManager.default.moveItem(at: file.destination, to: item.destination) }
        }
    }
    private func collect(_ version: ResourceVersion, game: String, loader: String, seen: Set<String>, output: inout [ResourceVersion]) async throws {
        if seen.contains(version.id) || output.contains(where: { $0.id == version.id }) { return }
        guard seen.count < 100 else { throw LauncherError.message("资源依赖链过深。") }
        if !game.isEmpty && !version.game_versions.contains(game) { throw LauncherError.message("\(version.name) 不兼容 Minecraft \(game)。") }
        if !loader.isEmpty && !version.loaders.contains(loader.lowercased()) { throw LauncherError.message("\(version.name) 不兼容 \(loader)。") }
        output.append(version)
        for dependency in version.dependencies where dependency.dependency_type == "required" {
            let next: ResourceVersion
            if let id = dependency.version_id { try Paths.validateID(id); next = try await http.decode(ResourceVersion.self, "https://api.modrinth.com/v2/version/\(id)") }
            else if let project = dependency.project_id, let compatible = try await versions(project: project, game: game, loader: loader).first { next = compatible }
            else { throw LauncherError.message("\(version.name) 的必需依赖没有兼容版本。") }
            try await collect(next, game: game, loader: loader, seen: seen.union([version.id]), output: &output)
        }
    }
    func localMods(_ directory: URL) async -> [LocalMod] {
        let files = (try? FileManager.default.contentsOfDirectory(at: directory.appendingPathComponent("mods"), includingPropertiesForKeys: [.isRegularFileKey])) ?? []
        var mods: [LocalMod] = []
        for file in files.sorted(by: { $0.lastPathComponent < $1.lastPathComponent }) {
            let lower = file.lastPathComponent.lowercased()
            guard lower.hasSuffix(".jar") || lower.hasSuffix(".jar.disabled"), (try? file.resourceValues(forKeys: [.isRegularFileKey]).isRegularFile) == true else { continue }
            var name = file.lastPathComponent, version = "", modID = ""
            if let result = try? await Command.run("/usr/bin/unzip", ["-p", file.path, "fabric.mod.json"], timeout: 10), result.status == 0,
               let json = try? JSONDecoder().decode(JSONValue.self, from: Data(result.output.utf8)) {
                name = json["name"].string ?? name; version = json["version"].string ?? ""; modID = json["id"].string ?? ""
            }
            mods.append(.init(url: file, name: name, version: version, modID: modID, enabled: lower.hasSuffix(".jar")))
        }
        return mods
    }
    func toggle(_ mod: LocalMod) throws {
        let target = mod.enabled ? URL(fileURLWithPath: mod.url.path + ".disabled") : URL(fileURLWithPath: String(mod.url.path.dropLast(".disabled".count)))
        guard !FileManager.default.fileExists(atPath: target.path) else { throw LauncherError.message("同名 Mod 已存在，无法切换。") }
        try FileManager.default.moveItem(at: mod.url, to: target)
    }
    func importMods(_ files: [URL], directory: URL) throws {
        let root = directory.appendingPathComponent("mods")
        try FileManager.default.createDirectory(at: root, withIntermediateDirectories: true)
        for file in files {
            guard file.pathExtension.lowercased() == "jar" else { throw LauncherError.message("请选择 JAR 格式的 Mod。") }
            try SafeArchive.validateZIP(file)
            let target = try Paths.inside(root, file.lastPathComponent)
            guard !FileManager.default.fileExists(atPath: target.path) else { throw LauncherError.message("同名 Mod 已存在：\(file.lastPathComponent)") }
            try FileManager.default.copyItem(at: file, to: target)
        }
    }
}
