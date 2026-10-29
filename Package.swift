// swift-tools-version: 5.9
import PackageDescription
let package = Package(name: "PCLNative", platforms: [.macOS(.v14)], products: [.library(name: "PCLCore", targets: ["PCLCore"])], targets: [
    .target(name: "PCLCore", path: "PCL 2.13.11", exclude: ["Assets.xcassets", "Resources", "UI", "ContentView.swift", "PCL_2_13_11App.swift"], sources: ["Core", "Services"]),
    .testTarget(name: "PCLCoreTests", dependencies: ["PCLCore"], path: "Tests", exclude: ["manifest-live.json"], resources: [.copy("1.12.2.json"), .copy("1.20.1.json"), .copy("1.21.1.json"), .copy("26.2.json")])
], swiftLanguageVersions: [.v5])
