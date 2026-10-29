import Foundation

actor JavaService {
    func discover(custom: String = "") async -> [JavaRuntime] {
        var candidates = Set<String>()
        if !custom.isEmpty { candidates.insert(custom) }
        let fm = FileManager.default
        let home = fm.homeDirectoryForCurrentUser
        let roots = [URL(fileURLWithPath: "/Library/Java/JavaVirtualMachines"), home.appendingPathComponent("Library/Java/JavaVirtualMachines"), home.appendingPathComponent(".jdks"), home.appendingPathComponent(".sdkman/candidates/java"), Paths.support.appendingPathComponent("runtime")]
        for root in roots {
            for file in FileTree.files(root, maxDepth: 7) {
                if file.lastPathComponent == "java", file.deletingLastPathComponent().lastPathComponent == "bin" { candidates.insert(file.path) }
            }
        }
        for path in ["/opt/homebrew/opt/openjdk/bin/java", "/opt/homebrew/opt/openjdk@21/bin/java", "/opt/homebrew/opt/openjdk@17/bin/java", "/usr/local/opt/openjdk/bin/java", "/usr/local/opt/openjdk@8/bin/java"] where fm.isExecutableFile(atPath: path) { candidates.insert(path) }
        if let result = try? await Command.run("/usr/libexec/java_home", ["-V"], timeout: 15) {
            for line in result.output.split(separator: "\n") {
                if let index = line.range(of: " /"), !line.hasPrefix("/") {
                    let path = String(line[index.lowerBound...]).trimmingCharacters(in: .whitespacesAndNewlines)
                    candidates.insert(path + "/bin/java")
                } else if line.hasPrefix("/") { candidates.insert(String(line) + "/bin/java") }
            }
        }
        var runtimes: [JavaRuntime] = []
        for path in candidates.sorted() {
            if let runtime = try? await inspect(path) { runtimes.append(runtime) }
        }
        return runtimes.sorted { $0.major == $1.major ? $0.path < $1.path : $0.major > $1.major }
    }
    func inspect(_ path: String) async throws -> JavaRuntime {
        guard FileManager.default.isExecutableFile(atPath: path) else { throw LauncherError.message("Java 文件不可执行：\(path)") }
        let result = try await Command.run(path, ["-XshowSettings:properties", "-version"], timeout: 15)
        guard result.status == 0 else { throw LauncherError.message("Java 检查失败。") }
        func property(_ name: String) -> String? {
            result.output.split(separator: "\n").map { $0.trimmingCharacters(in: .whitespaces) }.first { $0.hasPrefix(name + " = ") }.map { String($0.dropFirst(name.count + 3)) }
        }
        guard let version = property("java.version"), let arch = property("os.arch") else { throw LauncherError.message("不能读取 Java 的版本和架构。") }
        let pieces = version.split(whereSeparator: { !$0.isNumber }).compactMap { Int($0) }
        guard let first = pieces.first else { throw LauncherError.message("Java 版本无效。") }
        let major = first == 1 && pieces.count > 1 ? pieces[1] : first
        guard major >= 8 else { throw LauncherError.message("Java 版本低于 8。") }
        return .init(path: path, version: version, major: major, arch: arch)
    }
    func install(major: Int, intel: Bool = false, progress: @escaping ProgressHandler) async throws -> JavaRuntime {
        let arch = RuleEnvironment.hostArchitecture == "arm64" && !intel ? "aarch64" : "x64"
        let http = HTTPClient.shared
        await progress(.init(fraction: 0.05, message: "查询 Temurin Java \(major)（\(arch)）"))
        let releases = try await http.json("https://api.adoptium.net/v3/assets/latest/\(major)/hotspot?architecture=\(arch)&image_type=jdk&os=mac&vendor=eclipse")
        guard let release = releases.array.first, let link = release["binary"]["package"]["link"].string, let checksum = release["binary"]["package"]["checksum"].string else { throw LauncherError.message("没有适用于 macOS 的 Java \(major) \(arch) 下载。") }
        let runtimeRoot = Paths.support.appendingPathComponent("runtime")
        let work = FileManager.default.temporaryDirectory.appendingPathComponent("pcl-java-\(UUID().uuidString)")
        try FileManager.default.createDirectory(at: work, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: work) }
        let archive = work.appendingPathComponent("runtime.tar.gz"), extracted = work.appendingPathComponent("extracted")
        await progress(.init(fraction: 0.15, message: "下载 Java \(major)，请稍候"))
        try await http.download(.init(url: link, destination: archive, sha256: checksum, size: release["binary"]["package"]["size"].int))
        try FileManager.default.createDirectory(at: extracted, withIntermediateDirectories: true)
        let listing = try await Command.run("/usr/bin/tar", ["-tzf", archive.path])
        guard listing.status == 0 else { throw LauncherError.message("Java 压缩包无法读取。") }
        for name in listing.output.split(separator: "\n") { _ = try Paths.inside(extracted, String(name)) }
        await progress(.init(fraction: 0.85, message: "解压并检查 Java"))
        let result = try await Command.run("/usr/bin/tar", ["-xzf", archive.path, "-C", extracted.path])
        guard result.status == 0 else { throw LauncherError.message("Java 解压失败。") }
        var executable: URL?
        do {
            for file in FileTree.files(extracted) {
                guard file.resolvingSymlinksInPath().path.hasPrefix(extracted.path + "/") else { throw LauncherError.message("Java 压缩包包含越界链接。") }
                if file.path.hasSuffix("/Contents/Home/bin/java") { executable = file }
            }
        }
        guard let executable else { throw LauncherError.message("Java 压缩包缺少 Contents/Home/bin/java。") }
        _ = try await inspect(executable.path)
        let bundle = executable.deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
        try FileManager.default.createDirectory(at: runtimeRoot, withIntermediateDirectories: true)
        let destination = runtimeRoot.appendingPathComponent("temurin-\(major)-\(arch)-\(UUID().uuidString.prefix(8)).jdk")
        try FileManager.default.moveItem(at: bundle, to: destination)
        let runtime = try await inspect(destination.appendingPathComponent("Contents/Home/bin/java").path)
        await progress(.init(fraction: 1, message: "Java 安装完成：\(runtime.display)"))
        return runtime
    }
}
