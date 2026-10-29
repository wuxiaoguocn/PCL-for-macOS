import XCTest
@testable import PCLCore

final class CoreTests: XCTestCase {
    func fixture(_ version: String) throws -> JSONValue { try JSONValue.read(Bundle.module.url(forResource: version, withExtension: "json")!) }
    func testRealMetadataJavaVersions() throws {
        XCTAssertEqual(Metadata.requiredJava(try fixture("1.12.2")), 8)
        XCTAssertEqual(Metadata.requiredJava(try fixture("1.20.1")), 17)
        XCTAssertEqual(Metadata.requiredJava(try fixture("1.21.1")), 21)
        XCTAssertEqual(Metadata.requiredJava(try fixture("26.2")), 25)
    }
    func testAppleSiliconNativeSelection() throws {
        let plan = try MinecraftEngine.libraries(fixture("26.2"), root: URL(fileURLWithPath: "/private/tmp/game"), env: .init(arch: "aarch64"))
        XCTAssertTrue(plan.files.contains { $0.url.contains("natives-macos-arm64") })
        XCTAssertFalse(plan.files.contains { $0.url.contains("natives-windows") || $0.url.contains("natives-linux") })
        XCTAssertFalse(plan.files.contains { $0.url.hasSuffix("natives-macos.jar") })
    }
    func testIntelNativeSelection() throws {
        let plan = try MinecraftEngine.libraries(fixture("1.20.1"), root: URL(fileURLWithPath: "/private/tmp/game"), env: .init(arch: "amd64"))
        XCTAssertTrue(plan.files.contains { $0.url.hasSuffix("natives-macos.jar") })
        XCTAssertFalse(plan.files.contains { $0.url.contains("natives-macos-arm64") })
    }
    func testLegacyClassifierSelection() throws {
        let json = try fixture("1.12.2")
        XCTAssertFalse(MinecraftEngine.supportsARM(json))
        let plan = try MinecraftEngine.libraries(json, root: URL(fileURLWithPath: "/private/tmp/game"), env: .init(arch: "amd64"))
        XCTAssertTrue(plan.natives.contains { $0.0.lastPathComponent.contains("natives-osx") })
        XCTAssertFalse(plan.files.contains { $0.url.contains("natives-windows") || $0.url.contains("natives-linux") })
    }
    func testRulesLastMatchingRuleWins() throws {
        let rules = try JSONDecoder().decode(JSONValue.self, from: Data(#"[{"action":"allow"},{"action":"disallow","os":{"name":"windows"}},{"action":"disallow","features":{"is_demo_user":true}}]"#.utf8))
        XCTAssertTrue(RuleEnvironment(arch: "arm64").allows(rules))
        XCTAssertFalse(RuleEnvironment(arch: "arm64", features: ["is_demo_user": true]).allows(rules))
        XCTAssertFalse(RuleEnvironment(arch: "arm64").allows(.array([])))
    }
    func testInheritanceLibraryOverrides() throws {
        let parent = try JSONDecoder().decode(JSONValue.self, from: Data(#"{"id":"base","mainClass":"Main","libraries":[{"name":"a:b:1"},{"name":"x:y:1:natives-macos"}],"arguments":{"jvm":["-cp","${classpath}"],"game":["--username","${auth_player_name}"]}}"#.utf8))
        let child = try JSONDecoder().decode(JSONValue.self, from: Data(#"{"id":"fabric","inheritsFrom":"base","mainClass":"KnotClient","libraries":[{"name":"a:b:2"}],"arguments":{"game":["--extra"]}}"#.utf8))
        let result = Metadata.merge(parent: parent, child: child)
        XCTAssertEqual(result["jar"].string, "base")
        XCTAssertEqual(result["mainClass"].string, "KnotClient")
        XCTAssertEqual(result["libraries"].array.count, 2)
        XCTAssertFalse(result["libraries"].array.contains { $0["name"].string == "a:b:1" })
        XCTAssertEqual(result["arguments"]["game"].array.count, 3)
    }
    func testTraversalRejected() throws {
        let root = URL(fileURLWithPath: "/private/tmp/game")
        for path in ["../evil", "mods/../../evil", "/private/tmp/evil", "..\\evil", "C:\\evil"] { XCTAssertThrowsError(try Paths.inside(root, path)) }
        XCTAssertEqual(try Paths.inside(root, "mods/valid.jar").path, root.appendingPathComponent("mods/valid.jar").path)
    }
    func testArgumentsKeepPathsAndRejectBrokenQuotes() throws {
        XCTAssertEqual(try Metadata.tokenize(#"-Dname="目录 有空格" --server 'host:25565'"#), ["-Dname=目录 有空格", "--server", "host:25565"])
        XCTAssertThrowsError(try Metadata.tokenize("-Dname=\"broken"))
        XCTAssertEqual(try Metadata.tokenize("--name \"\""), ["--name", ""])
    }
    func testOfflineUUIDMatchesJavaNameUUID() throws {
        XCTAssertEqual(try GameSession.offline("Notch", demo: true).account.id, "b50ad385829d3141a2167e7d7539ba7f")
        XCTAssertThrowsError(try GameSession.offline("../bad", demo: true))
    }
    func testTokenRedaction() {
        let plan = LaunchPlan(java: .init(path: "/java", version: "21", major: 21, arch: "aarch64"), arguments: ["Main", "--accessToken", "secret-value"], directory: URL(fileURLWithPath: "/private/tmp"))
        XCTAssertFalse(plan.safeDescription.contains("secret-value"))
    }
    func testProcessDrainsOutputAndReturnsStatus() async throws {
        let result = try await Command.run("/usr/bin/seq", ["1", "20000"])
        XCTAssertEqual(result.status, 0)
        XCTAssertTrue(result.output.contains("20000"))
    }
}

extension CoreTests {
    func testMalformedCoordinatesThrowInsteadOfCrashing() {
        XCTAssertThrowsError(try Metadata.mavenPath(""))
        XCTAssertThrowsError(try Metadata.mavenPath("group:artifact"))
        XCTAssertEqual(Metadata.libraryKey(""), "")
    }
    func testSymlinkTraversalRejected() throws {
        let root = FileManager.default.temporaryDirectory.appendingPathComponent("pcl-path-test-\(UUID().uuidString)")
        try FileManager.default.createDirectory(at: root, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: root) }
        try FileManager.default.createSymbolicLink(atPath: root.appendingPathComponent("escape").path, withDestinationPath: "/")
        XCTAssertThrowsError(try Paths.inside(root, "escape/etc/passwd"))
    }
    func testArchiveRejectsSymlinksBeforeExtraction() async throws {
        let root = FileManager.default.temporaryDirectory.appendingPathComponent("pcl-zip-test-\(UUID().uuidString)")
        try FileManager.default.createDirectory(at: root, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: root) }
        try FileManager.default.createSymbolicLink(atPath: root.appendingPathComponent("link").path, withDestinationPath: "/private/tmp")
        let result = try await Command.run("/usr/bin/zip", ["-y", "unsafe.zip", "link"], directory: root)
        XCTAssertEqual(result.status, 0)
        XCTAssertThrowsError(try SafeArchive.validateZIP(root.appendingPathComponent("unsafe.zip")))
    }
    func testArchiveExtractsValidFiles() async throws {
        let root = FileManager.default.temporaryDirectory.appendingPathComponent("pcl-zip-valid-\(UUID().uuidString)")
        try FileManager.default.createDirectory(at: root, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: root) }
        try Data("hello".utf8).write(to: root.appendingPathComponent("test.txt"))
        let result = try await Command.run("/usr/bin/zip", ["valid.zip", "test.txt"], directory: root)
        XCTAssertEqual(result.status, 0)
        let destination = root.appendingPathComponent("extracted")
        try await SafeArchive.extractZIP(root.appendingPathComponent("valid.zip"), to: destination)
        XCTAssertEqual(try String(contentsOf: destination.appendingPathComponent("test.txt")), "hello")
    }
    func testHugeJSONIntegerDoesNotTrap() throws {
        let json = try JSONDecoder().decode(JSONValue.self, from: Data("1e100".utf8))
        XCTAssertNil(json.int)
    }
    func testOfficialMetadataDownloadAndChecksumLive() async throws {
        guard ProcessInfo.processInfo.environment["PCL_LIVE_TESTS"] == "1" else { throw XCTSkip("Set PCL_LIVE_TESTS=1 to run network validation") }
        let engine = MinecraftEngine(), manifest = try await engine.manifest()
        guard let entry = manifest.versions.first(where: { $0.id == "1.20.1" }) else { return XCTFail("Missing official test version") }
        let temp = FileManager.default.temporaryDirectory.appendingPathComponent("pcl-live-\(UUID().uuidString).json")
        defer { try? FileManager.default.removeItem(at: temp) }
        let item = DownloadItem(url: entry.url, destination: temp, sha1: entry.sha1)
        try await HTTPClient.shared.download(item)
        XCTAssertTrue(try FileIntegrity.valid(item))
        XCTAssertEqual(try JSONValue.read(temp)["id"].string, "1.20.1")
        // Repeat should accept the already verified cache.
        try await HTTPClient.shared.download(item)
    }
    func testFabricAndModrinthEndpointsLive() async throws {
        guard ProcessInfo.processInfo.environment["PCL_LIVE_TESTS"] == "1" else { throw XCTSkip("Set PCL_LIVE_TESTS=1 to run network validation") }
        let loaders = try await HTTPClient.shared.json("https://meta.fabricmc.net/v2/versions/loader/1.20.1")
        XCTAssertNotNil(loaders.array.first?["loader"]["version"].string)
        let resources = ResourceService()
        let result = try await resources.search(query: "sodium", kind: "mod", game: "1.20.1", loader: "fabric")
        XCTAssertFalse(result.hits.isEmpty)
        let versions = try await resources.versions(project: "sodium", game: "1.20.1", loader: "fabric")
        XCTAssertFalse(versions.isEmpty)
        XCTAssertTrue(versions.allSatisfy { $0.game_versions.contains("1.20.1") && $0.loaders.contains("fabric") })
    }
}
