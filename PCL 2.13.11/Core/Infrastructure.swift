import Foundation
import CryptoKit

nonisolated struct HTTPFailure: LocalizedError {
    let status: Int
    let body: Data
    let host: String
    var errorDescription: String? { "\(host) 返回 HTTP \(status)。" }
}

actor HTTPClient {
    static let shared = HTTPClient()
    private let session: URLSession
    init() {
        let config = URLSessionConfiguration.ephemeral
        config.timeoutIntervalForRequest = 45; config.timeoutIntervalForResource = 1800
        config.httpMaximumConnectionsPerHost = 8
        config.httpAdditionalHeaders = ["User-Agent": "PCL-macOS-Community/0.1 (native Swift port; local development)"]
        session = URLSession(configuration: config)
    }
    static func url(_ string: String) throws -> URL {
        guard let url = URL(string: string), url.scheme == "https", url.host != nil, url.user == nil, url.password == nil else {
            throw LauncherError.message("下载地址必须是有效的 HTTPS 地址。")
        }
        return url
    }
    func data(_ string: String, method: String = "GET", body: Data? = nil, headers: [String: String] = [:]) async throws -> Data {
        var request = URLRequest(url: try Self.url(string)); request.httpMethod = method; request.httpBody = body
        for (key, value) in headers { request.setValue(value, forHTTPHeaderField: key) }
        let (data, response) = try await session.data(for: request)
        try Task.checkCancellation()
        guard let response = response as? HTTPURLResponse else { throw LauncherError.message("服务器未返回 HTTP 响应。") }
        guard (200..<300).contains(response.statusCode) else { throw HTTPFailure(status: response.statusCode, body: data, host: response.url?.host ?? "服务器") }
        return data
    }
    func json(_ string: String) async throws -> JSONValue { try JSONDecoder().decode(JSONValue.self, from: await data(string)) }
    func decode<T: Decodable & Sendable>(_ type: T.Type, _ string: String) async throws -> T { try JSONDecoder().decode(type, from: await data(string)) }
    func post(_ string: String, json: JSONValue, headers: [String: String] = [:]) async throws -> JSONValue {
        var h = headers; h["Content-Type"] = "application/json"; h["Accept"] = "application/json"
        return try JSONDecoder().decode(JSONValue.self, from: await data(string, method: "POST", body: JSONEncoder().encode(json), headers: h))
    }
    func form(_ string: String, fields: [String: String]) async throws -> JSONValue {
        let allowed = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "-._~"))
        let body = fields.sorted(by: { $0.key < $1.key }).map { key, value in
            "\(key.addingPercentEncoding(withAllowedCharacters: allowed)!)=\(value.addingPercentEncoding(withAllowedCharacters: allowed)!)"
        }.joined(separator: "&")
        return try JSONDecoder().decode(JSONValue.self, from: await data(string, method: "POST", body: Data(body.utf8), headers: ["Content-Type": "application/x-www-form-urlencoded"]))
    }
    func download(_ item: DownloadItem) async throws {
        if try FileIntegrity.valid(item) { return }
        var lastError: Error = LauncherError.message("下载失败。")
        for attempt in 0..<3 {
            try Task.checkCancellation()
            do {
                let (temp, response) = try await session.download(from: Self.url(item.url))
                defer { try? FileManager.default.removeItem(at: temp) }
                guard let response = response as? HTTPURLResponse, response.url?.scheme == "https", (200..<300).contains(response.statusCode) else {
                    throw LauncherError.message("下载 \(item.destination.lastPathComponent) 失败：HTTP \((response as? HTTPURLResponse)?.statusCode ?? 0)")
                }
                let check = DownloadItem(url: item.url, destination: temp, sha1: item.sha1, sha512: item.sha512, sha256: item.sha256, size: item.size)
                guard try FileIntegrity.valid(check) else { throw LauncherError.message("文件校验失败：\(item.destination.lastPathComponent)") }
                try Task.checkCancellation()
                try FileManager.default.createDirectory(at: item.destination.deletingLastPathComponent(), withIntermediateDirectories: true)
                // Stage next to the target so the final replacement is on the same filesystem.
                let staging = item.destination.deletingLastPathComponent().appendingPathComponent(".pcl-download-\(UUID().uuidString)")
                try FileManager.default.copyItem(at: temp, to: staging)
                defer { try? FileManager.default.removeItem(at: staging) }
                if FileManager.default.fileExists(atPath: item.destination.path) {
                    _ = try FileManager.default.replaceItemAt(item.destination, withItemAt: staging)
                } else { try FileManager.default.moveItem(at: staging, to: item.destination) }
                return
            } catch {
                if Task.isCancelled || (error as? URLError)?.code == .cancelled { throw CancellationError() }
                lastError = error
                if attempt < 2 { try await Task.sleep(nanoseconds: UInt64(attempt + 1) * 700_000_000) }
            }
        }
        throw lastError
    }
    func downloadAll(_ items: [DownloadItem], message: String, progress: @escaping ProgressHandler) async throws {
        var byPath: [URL: DownloadItem] = [:]
        for item in items {
            if let old = byPath[item.destination], old.sha1 != item.sha1 || old.sha512 != item.sha512 {
                throw LauncherError.message("同一路径存在冲突的下载：\(item.destination.lastPathComponent)")
            }
            byPath[item.destination] = item
        }
        let queue = byPath.values.sorted { $0.destination.path < $1.destination.path }
        guard !queue.isEmpty else { await progress(.init(fraction: 1, message: message)); return }
        try await withThrowingTaskGroup(of: Void.self) { group in
            var next = 0, completed = 0
            func enqueue() {
                let item = queue[next]; next += 1
                group.addTask { try await self.download(item) }
            }
            for _ in 0..<min(8, queue.count) { enqueue() }
            while let _ = try await group.next() {
                completed += 1
                await progress(.init(fraction: Double(completed) / Double(queue.count), message: "\(message)（\(completed)/\(queue.count)）"))
                if next < queue.count { enqueue() }
            }
        }
    }
}

nonisolated enum FileIntegrity {
    static func digest<H: HashFunction>(_ url: URL, using: H.Type) throws -> String {
        let handle = try FileHandle(forReadingFrom: url); defer { try? handle.close() }
        var hash = H()
        while let data = try handle.read(upToCount: 1024 * 1024), !data.isEmpty { hash.update(data: data) }
        return hash.finalize().map { String(format: "%02x", $0) }.joined()
    }
    static func valid(_ item: DownloadItem) throws -> Bool {
        guard FileManager.default.fileExists(atPath: item.destination.path) else { return false }
        let attrs = try FileManager.default.attributesOfItem(atPath: item.destination.path)
        guard attrs[.type] as? FileAttributeType == .typeRegular else { return false }
        let bytes = (attrs[.size] as? NSNumber)?.intValue ?? 0
        if let size = item.size, size != bytes { return false }
        if bytes == 0 { return false }
        if let hash = item.sha1, try digest(item.destination, using: Insecure.SHA1.self) != hash.lowercased() { return false }
        if let hash = item.sha512, try digest(item.destination, using: SHA512.self) != hash.lowercased() { return false }
        if let hash = item.sha256, try digest(item.destination, using: SHA256.self) != hash.lowercased() { return false }
        return true
    }
}

nonisolated private final class ProcessBox: @unchecked Sendable {
    let lock = NSLock()
    var process: Process?
    var cancelled = false
    func cancel() {
        lock.lock(); cancelled = true; let p = process; lock.unlock()
        if let p, p.isRunning { p.terminate() }
    }
    var isCancelled: Bool { lock.withLock { cancelled } }
    func start(_ p: Process) throws {
        lock.lock(); defer { lock.unlock() }
        if cancelled { throw CancellationError() }
        process = p; try p.run()
    }
}
nonisolated struct CommandResult: Sendable { let status: Int32; let output: String }
nonisolated enum Command {
    static func run(_ executable: String, _ arguments: [String], directory: URL? = nil, timeout: TimeInterval = 120) async throws -> CommandResult {
        let box = ProcessBox()
        return try await withTaskCancellationHandler {
            try await Task.detached(priority: .utility) {
                let process = Process(), pipe = Pipe()
                process.executableURL = URL(fileURLWithPath: executable); process.arguments = arguments
                process.currentDirectoryURL = directory
                process.standardOutput = pipe; process.standardError = pipe; process.standardInput = FileHandle.nullDevice
                try box.start(process)
                let deadline = DispatchWorkItem { box.cancel() }
                DispatchQueue.global().asyncAfter(deadline: .now() + timeout, execute: deadline)
                // Drain while running; never wait with a full pipe.
                let data = pipe.fileHandleForReading.readDataToEndOfFile()
                process.waitUntilExit(); deadline.cancel()
                let cancelled = box.isCancelled
                if cancelled { throw LauncherError.message("外部进程已取消或超时。") }
                return CommandResult(status: process.terminationStatus, output: String(decoding: data, as: UTF8.self))
            }.value
        } onCancel: { box.cancel() }
    }
}

// ZIP central-directory inspection prevents zip-slip and symlink attacks before ditto extracts anything.
nonisolated enum SafeArchive {
    static func validateZIP(_ url: URL) throws {
        let handle = try FileHandle(forReadingFrom: url); defer { try? handle.close() }
        let size = try handle.seekToEnd()
        guard size >= 22 else { throw LauncherError.message("ZIP 文件不完整。") }
        try handle.seek(toOffset: size > 65557 ? size - 65557 : 0)
        let tail = try handle.readToEnd() ?? Data()
        func integer(_ data: Data, _ offset: Int, _ count: Int) -> UInt64 {
            guard offset >= 0, offset + count <= data.count else { return UInt64.max }
            return (0..<count).reduce(UInt64(0)) { $0 | UInt64(data[offset + $1]) << ($1 * 8) }
        }
        var end: Int?
        if tail.count >= 22 {
            for i in stride(from: tail.count - 22, through: 0, by: -1) {
                if integer(tail, i, 4) == 0x06054b50, i + 22 + Int(integer(tail, i + 20, 2)) == tail.count { end = i; break }
            }
        }
        guard let end, integer(tail, end + 4, 2) == 0, integer(tail, end + 6, 2) == 0 else { throw LauncherError.message("不支持分卷或 ZIP64 压缩包。") }
        let count = integer(tail, end + 10, 2), length = integer(tail, end + 12, 4), offset = integer(tail, end + 16, 4)
        guard count < 65535, length < 64 * 1024 * 1024, offset + length <= size else { throw LauncherError.message("ZIP 目录过大或损坏。") }
        try handle.seek(toOffset: offset)
        let directory = try handle.read(upToCount: Int(length)) ?? Data()
        var cursor = 0, total: UInt64 = 0
        for _ in 0..<count {
            guard integer(directory, cursor, 4) == 0x02014b50, cursor + 46 <= directory.count else { throw LauncherError.message("ZIP 中央目录损坏。") }
            let nameLength = Int(integer(directory, cursor + 28, 2))
            let extraLength = Int(integer(directory, cursor + 30, 2)), commentLength = Int(integer(directory, cursor + 32, 2))
            guard cursor + 46 + nameLength + extraLength + commentLength <= directory.count else { throw LauncherError.message("ZIP 条目越界。") }
            let name = String(decoding: directory[(cursor + 46)..<(cursor + 46 + nameLength)], as: UTF8.self)
            let mode = (integer(directory, cursor + 38, 4) >> 16) & 0xf000
            let flags = integer(directory, cursor + 8, 2)
            guard mode != 0xa000, flags & 1 == 0, !name.contains("\n"), !name.contains("\r") else { throw LauncherError.message("压缩包包含符号链接或加密文件。") }
            _ = try Paths.inside(URL(fileURLWithPath: "/private/tmp/pcl-archive"), name)
            total += integer(directory, cursor + 24, 4)
            guard total < 8 * 1024 * 1024 * 1024 else { throw LauncherError.message("压缩包解压后超过 8 GB。") }
            cursor += 46 + nameLength + extraLength + commentLength
        }
    }
    static func extractZIP(_ archive: URL, to destination: URL) async throws {
        try validateZIP(archive)
        try FileManager.default.createDirectory(at: destination, withIntermediateDirectories: true)
        let result = try await Command.run("/usr/bin/ditto", ["-x", "-k", archive.path, destination.path])
        guard result.status == 0 else { throw LauncherError.message("解压失败：\(result.output.prefix(400))") }
        try validateExtracted(destination)
    }
    static func validateExtracted(_ root: URL) throws {
        let base = root.resolvingSymlinksInPath().path + "/"
        if let enumerator = FileManager.default.enumerator(at: root, includingPropertiesForKeys: [.isSymbolicLinkKey]) {
            for case let path as URL in enumerator {
                let values = try path.resourceValues(forKeys: [.isSymbolicLinkKey])
                guard values.isSymbolicLink != true, path.resolvingSymlinksInPath().path.hasPrefix(base) else { throw LauncherError.message("压缩包解压后包含不安全的路径。") }
            }
        }
    }
}


nonisolated enum FileTree {
    static func files(_ root: URL, maxDepth: Int? = nil) -> [URL] {
        guard let enumerator = FileManager.default.enumerator(at: root, includingPropertiesForKeys: [.isRegularFileKey, .isSymbolicLinkKey], options: [.skipsHiddenFiles]) else { return [] }
        var result: [URL] = []
        for case let file as URL in enumerator {
            if let maxDepth, file.pathComponents.count - root.pathComponents.count > maxDepth { enumerator.skipDescendants(); continue }
            result.append(file)
        }
        return result
    }
}
