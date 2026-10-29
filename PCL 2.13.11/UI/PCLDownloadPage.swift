import SwiftUI

/// PageDownloadInstall.xaml and LoadMinecraft_OnFinish, translated to SwiftUI.
struct PCLDownloadPage: View {
    @EnvironmentObject private var model: LauncherModel
    @State private var expandedGroups: Set<String> = []
    @State private var selected: RemoteVersion?
    @State private var instanceName = ""
    @State private var expandedLoader: String?
    @State private var selectedLoader = "原版"
    @State private var selectedLoaderVersion = ""
    @State private var loaderVersions: [String: [String]] = [:]
    @State private var loaderErrors: [String: String] = [:]
    @State private var loadingLoaders: Set<String> = []
    @State private var loaderRequest: Task<Void, Never>?

    private let groups = ["正式版", "预览版", "远古版", "愚人节版"]
    private var pinned: [RemoteVersion] {
        let release = model.remoteVersions.first { category($0) == "正式版" }
        let snapshot = model.remoteVersions.first { category($0) == "预览版" }
        var values = release.map { [$0] } ?? []
        if let snapshot, release == nil || snapshot.releaseTime > release!.releaseTime { values.append(snapshot) }
        return values
    }
    var body: some View {
        ZStack(alignment: .bottom) {
            if model.remoteVersions.isEmpty {
                VStack(spacing: 14) {
                    if model.busy { ProgressView().controlSize(.small) }
                    Text(model.busy ? "正在获取版本列表" : "获取版本列表失败").font(PCLTheme.font())
                    if !model.busy { Button("重新获取") { model.loadManifest() } }
                }
                .padding(20)
                .background(cardBackground)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    VStack(spacing: 15) {
                        if let entry = selected { selectionPage(entry) }
                        else {
                            versionCard("最新版本", entries: pinned, expanded: true, pinned: true)
                            ForEach(groups, id: \.self) { group in
                                let entries = model.remoteVersions.filter { category($0) == group }
                                if !entries.isEmpty {
                                    versionCard(group, entries: entries, expanded: expandedGroups.contains(group))
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 25).padding(.top, 25).padding(.bottom, selected == nil ? 25 : 70)
                }
                if let entry = selected {
                    Button { install(entry) } label: {
                        HStack(spacing: 10) {
                            PCLIcon(name: "BtnExtraDownload").frame(width: 16, height: 16)
                            Text("开始下载").font(PCLTheme.font(15))
                        }
                        .foregroundStyle(.white).padding(.horizontal, 20).frame(height: 40)
                        .background(PCLTheme.accent, in: Capsule())
                        .shadow(color: PCLTheme.text.opacity(0.15), radius: 5, y: 2)
                    }
                    .buttonStyle(.plain).padding(.bottom, 15)
                    .disabled(model.busy || model.running || instanceName.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
        .task { if model.remoteVersions.isEmpty && !model.busy { model.loadManifest() } }
        .onDisappear { loaderRequest?.cancel(); loadingLoaders = [] }
    }

    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 5).fill(Color.white.opacity(245.0 / 255.0))
            .shadow(color: PCLTheme.text.opacity(0.12), radius: 3, y: 1)
    }

    private func versionCard(_ title: String, entries: [RemoteVersion], expanded: Bool, pinned: Bool = false) -> some View {
        VStack(spacing: 0) {
            Button {
                guard !pinned else { return }
                withAnimation(.easeOut(duration: 0.16)) {
                    if expandedGroups.contains(title) { expandedGroups.remove(title) }
                    else { expandedGroups.insert(title) }
                }
            } label: {
                HStack {
                    Text(title).font(PCLTheme.font(13, weight: .bold))
                    Spacer()
                    if !pinned { foldArrow(expanded) }
                }.padding(.leading, 15).padding(.trailing, 16).frame(height: 40)
            }.buttonStyle(.plain)
            if expanded {
                LazyVStack(spacing: 0) {
                    ForEach(entries) { entry in
                        PCLDownloadVersionRow(entry: entry, subtitle: pinned ? "最新\(category(entry))，发布于 \(releaseDate(entry))" : "发布于 " + releaseDate(entry)) {
                            selected = entry; instanceName = entry.id
                            selectedLoader = "原版"; selectedLoaderVersion = ""; expandedLoader = nil
                            loaderVersions = [:]; loaderErrors = [:]; loadingLoaders = []
                        }
                    }
                }.padding(.horizontal, 20).padding(.bottom, 18)
            }
        }.background(cardBackground)
    }

    private func selectionPage(_ entry: RemoteVersion) -> some View {
        VStack(spacing: 12) {
            HStack(spacing: 13) {
                Button {
                    selected = nil; loaderRequest?.cancel(); expandedLoader = nil
                } label: {
                    PCLIcon(name: "BtnTitleInner").frame(width: 23, height: 23).foregroundStyle(PCLTheme.text.opacity(0.6))
                }.buttonStyle(.plain)
                Image("MinecraftGrass").resizable().interpolation(.high).frame(width: 32, height: 32)
                TextField("版本名称", text: $instanceName).textFieldStyle(.plain).font(PCLTheme.font(15))
            }.padding(.leading, 13).padding(.trailing, 16).frame(height: 62).background(cardBackground)
            ForEach(["Forge", "NeoForge", "Fabric"], id: \.self) { kind in loaderCard(kind, entry: entry) }
            auxiliaryCard("Fabric API", text: "Fabric API 是许多 Fabric Mod 的运行依赖。") {
                model.resourceKind = "mod"; model.page = .resources
            }
            auxiliaryCard("OptiFine", text: "此加载器安装流程尚未完成 macOS 迁移。")
            auxiliaryCard("OptiFabric", text: "安装 Fabric 后，可在 Mod 下载中搜索 OptiFabric。") {
                model.resourceKind = "mod"; model.page = .resources
            }
            auxiliaryCard("LiteLoader", text: "此旧版加载器安装流程尚未完成 macOS 迁移。")
        }
    }

    private func loaderCard(_ kind: String, entry: RemoteVersion) -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Button { toggleLoader(kind, entry: entry) } label: {
                    HStack(spacing: 8) {
                        Text(kind).font(PCLTheme.font(13, weight: .bold)).frame(width: 109, alignment: .leading)
                        loaderIcon(kind).frame(width: 18, height: 18)
                        Text(selectedLoader == kind ? selectedLoaderVersion : "未选择")
                            .font(PCLTheme.font()).foregroundStyle(PCLTheme.text.opacity(0.7)).lineLimit(1)
                        Spacer(minLength: 0)
                    }
                    .padding(.leading, 15).frame(height: 40).contentShape(Rectangle())
                }.buttonStyle(.plain)
                if selectedLoader == kind {
                    Button {
                        selectedLoader = "原版"; selectedLoaderVersion = ""; instanceName = entry.id
                    } label: {
                        PCLIcon(name: "BtnTitleClose").frame(width: 10, height: 10)
                            .frame(width: 30, height: 30).contentShape(Rectangle())
                    }.buttonStyle(.plain)
                }
                Button { toggleLoader(kind, entry: entry) } label: {
                    foldArrow(expandedLoader == kind).frame(width: 32, height: 40).contentShape(Rectangle())
                }.buttonStyle(.plain).padding(.trailing, 5)
            }
            if expandedLoader == kind {
                VStack(alignment: .leading, spacing: 0) {
                    if loadingLoaders.contains(kind) {
                        HStack(spacing: 10) { ProgressView().controlSize(.small); Text("正在获取版本列表") }.padding(.vertical, 12)
                    } else if let error = loaderErrors[kind] {
                        Text(error).foregroundStyle(PCLTheme.text.opacity(0.7)).padding(.vertical, 12)
                        Button("重试") { loadLoader(kind, entry: entry) }
                    } else if let versions = loaderVersions[kind], !versions.isEmpty {
                        ForEach(Array(versions.prefix(40)), id: \.self) { version in
                            PCLDownloadLoaderRow(title: version, selected: selectedLoader == kind && selectedLoaderVersion == version) {
                                selectedLoader = kind; selectedLoaderVersion = version; expandedLoader = nil
                                instanceName = kind == "Forge" ? "\(entry.id)-Forge \(version.replacingOccurrences(of: entry.id + "-", with: ""))" : "\(entry.id)-\(kind) \(version)"
                            }
                        }
                    } else { Text("没有可用版本").foregroundStyle(PCLTheme.text.opacity(0.6)).padding(.vertical, 12) }
                }.padding(.horizontal, 20).padding(.bottom, 15)
            }
        }.background(cardBackground)
    }

    private func auxiliaryCard(_ title: String, text: String, action: (() -> Void)? = nil) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                withAnimation(.easeOut(duration: 0.16)) { expandedLoader = expandedLoader == title ? nil : title }
            } label: {
                HStack {
                    Text(title).font(PCLTheme.font(13, weight: .bold)).frame(width: 109, alignment: .leading)
                    Text("未选择").foregroundStyle(PCLTheme.text.opacity(0.7))
                    Spacer(); foldArrow(expandedLoader == title)
                }.padding(.horizontal, 15).frame(height: 40)
            }.buttonStyle(.plain)
            if expandedLoader == title {
                VStack(alignment: .leading, spacing: 12) {
                    Text(text).font(PCLTheme.font()).foregroundStyle(PCLTheme.text.opacity(0.7))
                    if let action { Button("前往 Mod 下载", action: action) }
                }.padding(.horizontal, 20).padding(.bottom, 15)
            }
        }.background(cardBackground)
    }

    private func foldArrow(_ expanded: Bool) -> some View {
        PCLVector(data: "M2,4 l-2,2 10,10 10,-10 -2,-2 -8,8 -8,-8 z")
            .fill(PCLTheme.text.opacity(0.6)).frame(width: 10, height: 6).rotationEffect(.degrees(expanded ? 0 : 180))
    }
    @ViewBuilder private func loaderIcon(_ kind: String) -> some View {
        if kind == "Fabric" { Image("FabricLoader").resizable().interpolation(.high) }
        else { Image(kind == "Forge" ? "ForgeLoader" : "NeoForgeLoader").resizable().interpolation(.high) }
    }
    private func toggleLoader(_ kind: String, entry: RemoteVersion) {
        withAnimation(.easeOut(duration: 0.16)) { expandedLoader = expandedLoader == kind ? nil : kind }
        if expandedLoader == kind && loaderVersions[kind] == nil && !loadingLoaders.contains(kind) { loadLoader(kind, entry: entry) }
    }
    private func loadLoader(_ kind: String, entry: RemoteVersion) {
        loaderRequest?.cancel(); loadingLoaders = [kind]; loaderErrors[kind] = nil
        loaderRequest = Task { @MainActor in
            defer { loadingLoaders.remove(kind) }
            do {
                let versions: [String]
                if kind == "Fabric" {
                    let encoded = entry.id.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? entry.id
                    let json = try await HTTPClient.shared.json("https://meta.fabricmc.net/v2/versions/loader/\(encoded)")
                    versions = json.array.compactMap { $0["loader"]["version"].string }
                } else { versions = try await LoaderInstaller(engine: model.engine).versions(game: entry.id, kind: kind) }
                try Task.checkCancellation()
                guard selected?.id == entry.id else { return }
                loaderVersions[kind] = versions
            } catch is CancellationError { }
            catch { if !Task.isCancelled { loaderErrors[kind] = error.localizedDescription } }
        }
    }

    private func install(_ entry: RemoteVersion) {
        let name = instanceName.trimmingCharacters(in: .whitespacesAndNewlines)
        let kind = selectedLoader, version = selectedLoaderVersion
        model.runOperation("安装 \(name)") {
            try Paths.validateID(name)
            let id: String
            if kind == "Fabric" {
                id = try await model.engine.installFabric(game: entry.id, loader: version, customID: name, root: model.root, progress: model.progressHandler)
            } else if kind == "Forge" || kind == "NeoForge" {
                id = try await LoaderInstaller(engine: model.engine).install(game: entry.id, kind: kind, version: version, root: model.root, runtimes: model.runtimes, customID: name, progress: model.progressHandler)
            } else {
                let base = try await model.engine.installVanilla(entry, root: model.root, progress: model.progressHandler)
                if name != base {
                    try await model.engine.createInstance(id: name, base: base, root: model.root)
                    try await model.engine.repair(name, root: model.root, arch: RuleEnvironment.hostArchitecture, progress: model.progressHandler)
                }
                id = name
            }
            model.settings.selectedVersion = id
        }
    }

    private func category(_ entry: RemoteVersion) -> String {
        if entry.type == "special" { return "愚人节版" }
        if entry.type == "release" { return "正式版" }
        guard entry.type == "snapshot" else { return "远古版" }
        let id = entry.id.lowercased()
        let fools: Set<String> = ["20w14infinite", "20w14∞", "3d shareware v1.34", "1.rv-pre1", "15w14a", "2.0", "22w13oneblockatatime", "23w13a_or_b", "24w14potato", "25w14craftmine", "26w14a"]
        if fools.contains(id) { return "愚人节版" }
        if let date = ISO8601DateFormatter().date(from: entry.releaseTime) {
            var calendar = Calendar(identifier: .gregorian); calendar.timeZone = TimeZone(secondsFromGMT: 7200)!
            let parts = calendar.dateComponents([.month, .day], from: date)
            if parts.month == 4 && parts.day == 1 { return "愚人节版" }
        }
        if id.hasPrefix("1.") && !["combat", "rc", "experimental", "pre"].contains(where: id.contains) { return "正式版" }
        return "预览版"
    }
    private func releaseDate(_ entry: RemoteVersion) -> String {
        guard let date = ISO8601DateFormatter().date(from: entry.releaseTime) else { return String(entry.releaseTime.prefix(10)) }
        let formatter = DateFormatter(); formatter.dateFormat = "yyyy/MM/dd HH:mm"
        return formatter.string(from: date)
    }
}

private struct PCLDownloadVersionRow: View {
    let entry: RemoteVersion
    let subtitle: String
    let action: () -> Void
    @State private var hovered = false
    var body: some View {
        Button(action: action) {
            HStack(spacing: 13) {
                Image("MinecraftGrass").resizable().interpolation(.high).frame(width: 32, height: 32)
                VStack(alignment: .leading, spacing: 3) {
                    Text(entry.id == "20w14infinite" ? "20w14∞" : entry.id).font(PCLTheme.font(14))
                    Text(subtitle).font(PCLTheme.font(12)).foregroundStyle(PCLTheme.text.opacity(0.6))
                }
                Spacer(minLength: 0)
            }.padding(.horizontal, 6).frame(height: 56).contentShape(Rectangle())
                .background(hovered ? PCLTheme.light : .clear, in: RoundedRectangle(cornerRadius: 3))
        }.buttonStyle(.plain).onHover { hovered = $0 }
    }
}
private struct PCLDownloadLoaderRow: View {
    let title: String
    let selected: Bool
    let action: () -> Void
    @State private var hovered = false
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title).font(PCLTheme.font(14))
                Spacer()
                if selected { Image(systemName: "checkmark").foregroundStyle(PCLTheme.primary) }
            }.padding(.horizontal, 10).frame(height: 40).contentShape(Rectangle())
                .background(hovered || selected ? PCLTheme.light : .clear, in: RoundedRectangle(cornerRadius: 3))
        }.buttonStyle(.plain).onHover { hovered = $0 }
    }
}
