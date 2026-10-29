import Foundation
import CryptoKit

// Native equivalents of McInstance, McVersion, McLibEntry and McJsonRuleCheck.
nonisolated enum LauncherError: LocalizedError {
    case message(String)
    var errorDescription: String? { if case .message(let text) = self { return text }; return nil }
}

nonisolated indirect enum JSONValue: Codable, Sendable, Equatable {
    case object([String: JSONValue]), array([JSONValue]), string(String), number(Double), bool(Bool), null
    init(from decoder: Decoder) throws {
        let c = try decoder.singleValueContainer()
        if c.decodeNil() { self = .null }
        else if let v = try? c.decode(Bool.self) { self = .bool(v) }
        else if let v = try? c.decode(String.self) { self = .string(v) }
        else if let v = try? c.decode(Double.self) { self = .number(v) }
        else if let v = try? c.decode([JSONValue].self) { self = .array(v) }
        else { self = .object(try c.decode([String: JSONValue].self)) }
    }
    func encode(to encoder: Encoder) throws {
        var c = encoder.singleValueContainer()
        switch self {
        case .object(let v): try c.encode(v)
        case .array(let v): try c.encode(v)
        case .string(let v): try c.encode(v)
        case .number(let v): try c.encode(v)
        case .bool(let v): try c.encode(v)
        case .null: try c.encodeNil()
        }
    }
    subscript(_ key: String) -> JSONValue { object[key] ?? .null }
    var object: [String: JSONValue] { if case .object(let v) = self { return v }; return [:] }
    var array: [JSONValue] { if case .array(let v) = self { return v }; return [] }
    var string: String? { if case .string(let v) = self { return v }; return nil }
    var int: Int? { if case .number(let v) = self, v.isFinite { return Int(exactly: v) }; return nil }
    var bool: Bool? { if case .bool(let v) = self { return v }; return nil }
    static func read(_ url: URL) throws -> JSONValue { try JSONDecoder().decode(Self.self, from: Data(contentsOf: url)) }
    func write(_ url: URL) throws {
        try FileManager.default.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true)
        let encoder = JSONEncoder(); encoder.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
        try encoder.encode(self).write(to: url, options: .atomic)
    }
}

nonisolated struct Manifest: Codable, Sendable {
    let latest: [String: String]
    let versions: [RemoteVersion]
}
nonisolated struct RemoteVersion: Codable, Identifiable, Sendable {
    let id: String
    let type: String
    let url: String
    let releaseTime: String
    let sha1: String?
    var typeName: String { ["release": "正式版", "snapshot": "快照", "old_beta": "旧 Beta", "old_alpha": "旧 Alpha"][type] ?? type }
}
nonisolated struct LocalVersion: Identifiable, Sendable {
    let id: String
    let type: String
    let baseVersion: String
    let loader: String
    let error: String?
    var subtitle: String { error ?? "\(baseVersion) · \(loader)" }
}
nonisolated struct JavaRuntime: Identifiable, Codable, Sendable {
    let path: String
    let version: String
    let major: Int
    let arch: String
    var id: String { path }
    var display: String { "Java \(version) · \(arch)" }
    var isARM: Bool { arch == "aarch64" || arch == "arm64" }
}
nonisolated struct GameAccount: Codable, Identifiable, Sendable {
    var id: String
    var name: String
    var kind: String // msa, offline
    var clientID: String?
}
nonisolated struct GameSession: Sendable {
    let account: GameAccount
    let accessToken: String
    var demo: Bool = false
    static func offline(_ name: String, demo: Bool) throws -> Self {
        guard name.range(of: "^[A-Za-z0-9_]{1,16}$", options: .regularExpression) != nil else {
            throw LauncherError.message("离线用户名必须为 1–16 个英文字母、数字或下划线。")
        }
        var bytes = Array(Insecure.MD5.hash(data: Data("OfflinePlayer:\(name)".utf8)))
        bytes[6] = (bytes[6] & 0x0f) | 0x30; bytes[8] = (bytes[8] & 0x3f) | 0x80
        let uuid = bytes.map { String(format: "%02x", $0) }.joined()
        return .init(account: .init(id: uuid, name: name, kind: "offline"), accessToken: "0", demo: demo)
    }
}
nonisolated struct LauncherSettings: Codable, Sendable {
    var gameRoot = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Library/Application Support/minecraft").path
    var javaPath = ""
    var memoryMB = 4096
    var width = 1280
    var height = 720
    var fullscreen = false
    var isolateVersions = true
    var jvmArguments = ""
    var gameArguments = ""
    var server = ""
    var microsoftClientID = ProcessInfo.processInfo.environment["PCL_MS_CLIENT_ID"] ?? ""
    var selectedVersion = ""
    var selectedAccount = "offline"
    var offlineName = "Player"
    var accounts: [GameAccount] = []
    var launchCount = 0
    var hasVerifiedOwnership = false
    var showSnapshots = false
    var appearance = "system"
}
nonisolated struct DownloadItem: Sendable, Hashable {
    let url: String
    let destination: URL
    var sha1: String? = nil
    var sha512: String? = nil
    var sha256: String? = nil
    var size: Int? = nil
}
nonisolated struct InstallProgress: Sendable {
    var fraction: Double
    var message: String
}
typealias ProgressHandler = @Sendable (InstallProgress) async -> Void

nonisolated struct RuleEnvironment: Sendable {
    var arch: String
    var osVersion: String = { let v = ProcessInfo.processInfo.operatingSystemVersion; return "\(v.majorVersion).\(v.minorVersion).\(v.patchVersion)" }()
    var features: [String: Bool] = [:]
    static var hostArchitecture: String {
        #if arch(arm64)
        return "arm64"
        #else
        return "x86_64"
        #endif
    }
    func allows(_ rules: JSONValue) -> Bool {
        if rules == .null { return true }
        var allowed = false
        for rule in rules.array {
            let os = rule["os"]
            var matches = true
            if let name = os["name"].string, name != "osx" { matches = false }
            if let pattern = os["arch"].string {
                let javaArch = ["arm64": "aarch64", "x86_64": "amd64"][arch] ?? arch
                matches = matches && javaArch.range(of: pattern, options: .regularExpression) != nil
            }
            if let pattern = os["version"].string { matches = matches && osVersion.range(of: pattern, options: .regularExpression) != nil }
            for (key, value) in rule["features"].object {
                matches = matches && ((features[key] ?? false) == (value.bool ?? false))
            }
            if matches { allowed = rule["action"].string == "allow" }
        }
        return allowed
    }
}

nonisolated enum Paths {
    static let support = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Library/Application Support/PCL-macOS-Community")
    static let settings = support.appendingPathComponent("settings.json")
    static func validateID(_ id: String) throws {
        guard !id.isEmpty, id != ".", id != "..", !id.contains("/"), !id.contains("\\"), !id.contains(":"), !id.contains("\0"), id.count <= 160 else {
            throw LauncherError.message("版本名或文件名包含无效字符：\(id)")
        }
    }
    static func inside(_ root: URL, _ relative: String) throws -> URL {
        // Reject traversal before normalizing; also reject a symlinked path escaping the root.
        let components = relative.replacingOccurrences(of: "\\", with: "/").split(separator: "/", omittingEmptySubsequences: false)
        guard !relative.isEmpty, !relative.hasPrefix("/"), !relative.contains("\0"), !relative.contains(":"), !components.contains("..") else {
            throw LauncherError.message("拒绝不安全的相对路径：\(relative)")
        }
        let result = root.appendingPathComponent(relative).standardizedFileURL
        let base = root.resolvingSymlinksInPath().standardizedFileURL.path + "/"
        guard result.resolvingSymlinksInPath().path.hasPrefix(base) else { throw LauncherError.message("文件路径越过游戏目录。") }
        return result
    }
    static func versionJSON(_ root: URL, _ id: String) throws -> URL {
        try validateID(id); return try inside(root, "versions/\(id)/\(id).json")
    }
    static func gameDirectory(_ root: URL, _ version: String, isolated: Bool) throws -> URL {
        try validateID(version)
        return isolated ? try inside(root, "versions/\(version)/game") : root
    }
}

nonisolated enum Metadata {
    static func resolve(root: URL, id: String, seen: Set<String> = []) throws -> JSONValue {
        guard !seen.contains(id), seen.count < 32 else { throw LauncherError.message("版本继承循环：\(id)") }
        let child = try JSONValue.read(Paths.versionJSON(root, id))
        guard let parent = child["inheritsFrom"].string else { return child }
        return merge(parent: try resolve(root: root, id: parent, seen: seen.union([id])), child: child)
    }
    static func merge(parent: JSONValue, child: JSONValue) -> JSONValue {
        var result = parent.object
        for (key, value) in child.object where key != "inheritsFrom" { result[key] = value }
        // Merge library overrides by Maven identity, including classifier and extension.
        var libs = parent["libraries"].array
        for lib in child["libraries"].array {
            let key = libraryKey(lib["name"].string ?? "")
            libs.removeAll { libraryKey($0["name"].string ?? "") == key }; libs.append(lib)
        }
        result["libraries"] = .array(libs)
        var args = parent["arguments"].object
        for (key, value) in child["arguments"].object { args[key] = .array((args[key]?.array ?? []) + value.array) }
        if !args.isEmpty { result["arguments"] = .object(args) }
        if result["jar"] == nil { result["jar"] = parent["jar"] == .null ? parent["id"] : parent["jar"] }
        return .object(result)
    }
    static func libraryKey(_ name: String) -> String {
        let extensionParts = name.split(separator: "@", maxSplits: 1).map(String.init)
        guard let first = extensionParts.first else { return "" }
        let p = first.split(separator: ":").map(String.init)
        return p.prefix(2).joined(separator: ":") + (p.count > 3 ? ":\(p[3])" : "") + "@" + (extensionParts.count > 1 ? extensionParts[1] : "jar")
    }
    static func mavenPath(_ name: String) throws -> String {
        let ext = name.split(separator: "@", maxSplits: 1).map(String.init)
        guard let first = ext.first else { throw LauncherError.message("Maven 坐标为空。") }
        let p = first.split(separator: ":").map(String.init)
        guard p.count == 3 || p.count == 4 else { throw LauncherError.message("不支持的 Maven 坐标：\(name)") }
        return p[0].replacingOccurrences(of: ".", with: "/") + "/\(p[1])/\(p[2])/\(p[1])-\(p[2])" + (p.count == 4 ? "-\(p[3])" : "") + "." + (ext.count > 1 ? ext[1] : "jar")
    }
    static func requiredJava(_ json: JSONValue) -> Int {
        if let major = json["javaVersion"]["majorVersion"].int { return major }
        let version = (json["jar"].string ?? json["id"].string ?? "").split(separator: ".").compactMap { Int($0) }
        if version.first ?? 0 >= 26 { return 25 }
        if version.count >= 2 && version[0] == 1 {
            if version[1] > 20 || (version[1] == 20 && version.count >= 3 && version[2] >= 5) { return 21 }
            if version[1] >= 18 { return 17 }; if version[1] == 17 { return 16 }
        }
        return 8
    }
    static func arguments(_ values: JSONValue, env: RuleEnvironment) -> [String] {
        values.array.flatMap { item -> [String] in
            if let s = item.string { return [s] }
            guard env.allows(item["rules"]) else { return [] }
            if let s = item["value"].string { return [s] }
            return item["value"].array.compactMap(\.string)
        }
    }
    static func tokenize(_ text: String) throws -> [String] {
        var result: [String] = [], token = "", quote: Character?, escaped = false, active = false
        for c in text {
            if escaped { token.append(c); escaped = false; active = true }
            else if c == "\\", quote != "'" { escaped = true; active = true }
            else if let q = quote { if c == q { quote = nil } else { token.append(c) } }
            else if c == "\"" || c == "'" { quote = c; active = true }
            else if c.isWhitespace { if active { result.append(token); token = ""; active = false } }
            else { token.append(c); active = true }
        }
        guard quote == nil, !escaped else { throw LauncherError.message("自定义参数的引号或转义未闭合。") }
        if active { result.append(token) }; return result
    }
}
