import SwiftUI
import AppKit

// Layout follows PageSelectRight.xaml and PageResource.xaml: 25 pt page insets,
// 15 pt between cards, and compact rows inside the original rounded white cards.
struct PCLVersionsPage: View {
    @EnvironmentObject var model: LauncherModel
    @State private var filter = ""
    @State private var instanceName = ""
    @State private var creatingInstance = false

    private var matching: [LocalVersion] {
        model.versions.filter { filter.isEmpty || $0.id.localizedCaseInsensitiveContains(filter) }
    }
    private var groups: [(String, [LocalVersion])] {
        let regular = matching.filter { $0.error == nil && $0.loader == "原版" }
        let modded = matching.filter { $0.error == nil && $0.loader != "原版" }
        let failed = matching.filter { $0.error != nil }
        let loaders = Set(modded.map(\.loader))
        let modTitle = loaders.count == 1 ? "\(loaders.first ?? "Mod") 版本" : "可安装 Mod"
        return [("常规版本", regular), (modTitle, modded), ("错误的版本", failed)].filter { !$0.1.isEmpty }
    }
    var body: some View {
        Group {
            if model.versions.isEmpty {
                PCLLibrarySurface {
                    VStack(spacing: 14) {
                        Text("无可用版本").font(PCLTheme.font(19)).foregroundStyle(PCLTheme.accent)
                        Rectangle().fill(PCLTheme.accent).frame(height: 2)
                        Text("未找到任何版本的游戏，请先下载任意版本的游戏。\n若有已存在的游戏，请在左边选择 Minecraft 文件夹将其导入。")
                            .frame(maxWidth: .infinity, alignment: .leading).lineSpacing(4).padding(.horizontal, 10)
                        Button("下载游戏") { model.page = .download }.buttonStyle(PCLButtonStyle(highlight: true, height: 35)).frame(minWidth: 140)
                    }.padding(.horizontal, 20).padding(.vertical, 17)
                }.padding(40)
            } else {
                ScrollView {
                    VStack(spacing: 15) {
                        if model.versions.count > 6 {
                            TextField("搜索版本", text: $filter).textFieldStyle(PCLTextFieldStyle())
                        }
                        ForEach(groups, id: \.0) { group in
                            PCLCard(title: "\(group.0) (\(group.1.count))") {
                                VStack(spacing: 0) {
                                    ForEach(group.1) { version in versionRow(version) }
                                }
                            }
                        }
                        if matching.isEmpty { PCLCard(title: "没有找到版本") { Text("试试其他关键词。").foregroundStyle(PCLTheme.gray) } }
                    }.padding(.horizontal, 25).padding(.top, 25).padding(.bottom, 10)
                }
            }
        }
        .disabled(model.busy || model.running)
        .sheet(isPresented: $creatingInstance) {
            VStack(alignment: .leading, spacing: 18) {
                Text("创建隔离实例").font(PCLTheme.font(15, weight: .bold))
                Text("基于：\(model.settings.selectedVersion)").foregroundStyle(PCLTheme.gray)
                TextField("新实例名称", text: $instanceName).textFieldStyle(PCLTextFieldStyle())
                HStack {
                    Spacer()
                    Button("取消") { creatingInstance = false }
                    Button("创建") { createInstance() }.buttonStyle(PCLButtonStyle(highlight: true)).disabled(instanceName.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }.padding(25).frame(width: 390).buttonStyle(PCLButtonStyle()).font(PCLTheme.font())
        }
    }
    private func versionRow(_ version: LocalVersion) -> some View {
        HStack(spacing: 0) {
            Button {
                model.settings.selectedVersion = version.id
                model.page = .launch
            } label: {
                HStack(spacing: 12) {
                    if version.error != nil {
                        Image(systemName: "exclamationmark.triangle.fill").resizable().scaledToFit().foregroundStyle(.orange).frame(width: 32, height: 32)
                    } else {
                        Image(version.loader == "Fabric" ? "FabricLoader" : "MinecraftGrass").resizable().interpolation(.none).scaledToFit().frame(width: 32, height: 32)
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        Text(version.id).font(PCLTheme.font(14)).foregroundStyle(model.settings.selectedVersion == version.id ? PCLTheme.primary : PCLTheme.text)
                        Text(version.subtitle).font(PCLTheme.font(12)).foregroundStyle(PCLTheme.gray).lineLimit(1)
                    }
                    Spacer(minLength: 8)
                    if model.settings.selectedVersion == version.id { Image(systemName: "checkmark").foregroundStyle(PCLTheme.primary).font(.system(size: 12)) }
                }.frame(minHeight: 58).contentShape(Rectangle())
            }.buttonStyle(PCLLibraryRowStyle())
            Menu {
                Button("选择此版本") { model.settings.selectedVersion = version.id; model.page = .launch }
                Button("检查 / 修复") { model.settings.selectedVersion = version.id; model.repairSelected() }
                Button("Mod 管理") { model.settings.selectedVersion = version.id; model.page = .mods }
                Button("打开游戏目录") { model.settings.selectedVersion = version.id; model.openDirectory(model.gameDirectory) }
                Button("导出游戏文件 ZIP") { model.settings.selectedVersion = version.id; model.exportGameFiles() }
                Button("创建隔离实例") { model.settings.selectedVersion = version.id; instanceName = ""; creatingInstance = true }
            } label: {
                PCLIcon(name: "ItemSetup").frame(width: 16, height: 16).foregroundStyle(PCLTheme.primary).frame(width: 30, height: 32)
            }.menuStyle(.borderlessButton).menuIndicator(.hidden).fixedSize().help("版本设置")
        }
    }
    private func createInstance() {
        let id = instanceName.trimmingCharacters(in: .whitespaces), base = model.settings.selectedVersion
        creatingInstance = false
        model.runOperation("创建实例：\(id)") {
            try await model.engine.createInstance(id: id, base: base, root: model.root)
            let jsonURL = try Paths.versionJSON(model.root, id).deletingLastPathComponent().appendingPathComponent("instance.json")
            try JSONValue.object(["isolate": .bool(true)]).write(jsonURL)
            model.settings.selectedVersion = id
        }
    }
}

struct PCLResourcesPage: View {
    @EnvironmentObject var model: LauncherModel
    @State private var query = ""
    @State private var compatibleOnly = false
    @State private var selected: ResourceProject?
    @State private var loadingVersions = false
    @State private var searched = false
    @State private var packName = "My Modpack"
    private var typeName: String {
        ["mod": "Mod", "resourcepack": "资源包", "shader": "光影包", "modpack": "整合包", "datapack": "数据包"][model.resourceKind] ?? "资源"
    }
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                if model.resourceKind == "datapack" {
                    PCLCard(title: "数据包") {
                        Text("数据包搜索与安装尚未迁移。可先前往 Modrinth 下载，将文件放入目标存档的 datapacks 文件夹。")
                            .foregroundStyle(PCLTheme.gray).lineSpacing(3)
                        Button("前往 Modrinth 数据包页面") { model.openLink("https://modrinth.com/datapacks") }
                            .buttonStyle(PCLButtonStyle(highlight: true, height: 35))
                    }
                } else if let project = selected {
                    detail(project)
                } else {
                    searchCard
                    if model.resourceKind == "modpack" {
                        PCLCard(title: "安装已有整合包") {
                            HStack(spacing: 18) {
                                Text("实例名称")
                                TextField("新实例名称", text: $packName).textFieldStyle(PCLTextFieldStyle())
                                Button("导入整合包") { model.importPack(id: packName.trimmingCharacters(in: .whitespaces)) }
                                    .buttonStyle(PCLButtonStyle(highlight: true, height: 35))
                                    .disabled(packName.trimmingCharacters(in: .whitespaces).isEmpty || model.busy || model.running)
                            }
                            Text("支持 Modrinth、MultiMC / Prism 和原版 HMCL 整合包。").font(PCLTheme.font(12)).foregroundStyle(PCLTheme.gray)
                        }
                    }
                    if model.resourceSearching {
                        PCLLibrarySurface { HStack(spacing: 12) { ProgressView().controlSize(.small); Text("正在获取\(typeName)列表") }.padding(20) }.padding(.horizontal, 40).padding(.top, 35)
                    } else if !model.projects.isEmpty {
                        PCLLibrarySurface {
                            LazyVStack(spacing: 0) { ForEach(model.projects) { project in projectRow(project) } }.padding(12)
                        }
                    } else if searched {
                        PCLCard(title: "没有找到符合条件的\(typeName)") { Text("请修改名称或版本条件后重新搜索。").foregroundStyle(PCLTheme.gray) }
                    }
                }
            }.padding(25)
        }
        .onAppear { if model.projects.isEmpty { search() } }
        .onChange(of: model.resourceKind) { _, _ in selected = nil; query = ""; model.projects = []; model.resourceVersions = []; search() }
    }
    private var searchCard: some View {
        PCLCard(title: "搜索\(typeName)") {
            VStack(spacing: 9) {
                HStack(spacing: 18) {
                    Text("名称").frame(width: 26, alignment: .leading)
                    TextField("", text: $query).textFieldStyle(PCLTextFieldStyle()).onSubmit(search)
                    Text("来源").padding(.leading, 12)
                    Text("Modrinth").frame(width: 110, height: 28, alignment: .leading)
                        .padding(.horizontal, 8).background(.white.opacity(0.33), in: RoundedRectangle(cornerRadius: 3))
                        .overlay(RoundedRectangle(cornerRadius: 3).stroke(PCLTheme.border, lineWidth: 1))
                }
                HStack(spacing: 18) {
                    Text("版本").frame(width: 26, alignment: .leading)
                    Picker("版本", selection: $compatibleOnly) {
                        Text("全部").tag(false)
                        Text(model.selectedVersion.map { "\($0.baseVersion) · \($0.loader)" } ?? "当前游戏版本").tag(true)
                    }.labelsHidden().frame(maxWidth: .infinity)
                    Text("类型").padding(.leading, 12)
                    Text(typeName).frame(width: 110, height: 28, alignment: .leading).padding(.horizontal, 8)
                }
                HStack(spacing: 20) {
                    Button { search() } label: { Text("搜索").frame(minWidth: 112) }.buttonStyle(PCLButtonStyle(highlight: true, height: 35)).disabled(model.resourceSearching)
                    Button { query = ""; compatibleOnly = false; search() } label: { Text("重置条件").frame(minWidth: 112) }.buttonStyle(PCLButtonStyle(height: 35))
                    Spacer(minLength: 0)
                }.padding(.top, 6).padding(.bottom, 6)
            }.padding(.horizontal, 5)
        }
    }
    private func projectRow(_ project: ResourceProject) -> some View {
        Button {
            selected = project; model.resourceVersions = []; loadingVersions = true
            Task {
                await model.loadResourceVersions(project, compatibleOnly: compatibleOnly)
                loadingVersions = false
            }
        } label: {
            HStack(alignment: .center, spacing: 14) {
                AsyncImage(url: URL(string: project.icon_url ?? "")) { image in image.resizable().scaledToFit() } placeholder: {
                    PCLIcon(name: "ItemMod").foregroundStyle(PCLTheme.primary).padding(8)
                }.frame(width: 48, height: 48).clipShape(RoundedRectangle(cornerRadius: 3))
                VStack(alignment: .leading, spacing: 4) {
                    Text(project.title).font(PCLTheme.font(14)).foregroundStyle(PCLTheme.text).lineLimit(1)
                    Text(project.description).font(PCLTheme.font(12)).foregroundStyle(PCLTheme.gray).lineLimit(2)
                    Text("\(project.downloads.formatted()) 次下载  ·  Modrinth").font(PCLTheme.font(11)).foregroundStyle(PCLTheme.gray)
                }.frame(maxWidth: .infinity, alignment: .leading)
            }.padding(.horizontal, 10).padding(.vertical, 10).contentShape(Rectangle())
        }.buttonStyle(PCLLibraryRowStyle())
    }
    @ViewBuilder private func detail(_ project: ResourceProject) -> some View {
        PCLLibrarySurface {
            HStack(spacing: 15) {
                Button { selected = nil } label: { PCLIcon(name: "BtnTitleInner").frame(width: 20, height: 20) }.buttonStyle(.plain).foregroundStyle(PCLTheme.primary).help("返回搜索")
                AsyncImage(url: URL(string: project.icon_url ?? "")) { image in image.resizable().scaledToFit() } placeholder: { PCLIcon(name: "ItemMod") }.frame(width: 32, height: 32)
                Text(project.title).font(PCLTheme.font(15)).lineLimit(1)
                Spacer()
            }.padding(.horizontal, 18).frame(height: 62)
        }
        PCLCard(title: "简介") {
            Text(project.description).lineSpacing(3)
            HStack(spacing: 20) {
                Button("转到 Modrinth") { model.openLink("https://modrinth.com/\(project.project_type)/\(project.slug)") }.buttonStyle(PCLButtonStyle(highlight: true, height: 35))
                Button("复制名称") { NSPasteboard.general.clearContents(); NSPasteboard.general.setString(project.title, forType: .string) }.buttonStyle(PCLButtonStyle(height: 35))
            }
        }
        if loadingVersions {
            PCLLibrarySurface { HStack(spacing: 12) { ProgressView().controlSize(.small); Text("正在获取版本列表") }.padding(20) }.padding(.horizontal, 40).padding(.top, 20)
        } else if model.resourceVersions.isEmpty {
            PCLCard(title: "没有可安装版本") {
                Text("当前版本条件下没有找到兼容文件。").foregroundStyle(PCLTheme.gray)
                Button("显示所有版本") {
                    loadingVersions = true
                    Task { await model.loadResourceVersions(project, compatibleOnly: false); loadingVersions = false }
                }
            }
        } else {
            PCLCard(title: "版本列表 (\(model.resourceVersions.count))") {
                LazyVStack(spacing: 0) {
                    ForEach(model.resourceVersions) { version in
                        HStack(spacing: 12) {
                            PCLIcon(name: "ItemInstall").frame(width: 28, height: 28).foregroundStyle(PCLTheme.primary)
                            VStack(alignment: .leading, spacing: 4) {
                                Text(version.name).font(PCLTheme.font(14)).lineLimit(1)
                                Text(version.game_versions.prefix(6).joined(separator: ", ") + " · " + version.loaders.joined(separator: ", ")).font(PCLTheme.font(12)).foregroundStyle(PCLTheme.gray).lineLimit(2)
                            }
                            Spacer(minLength: 8)
                            Button("安装") { model.installResource(version, kind: project.project_type) }.buttonStyle(PCLButtonStyle(highlight: true))
                                .disabled(model.busy || model.running || (model.selectedVersion == nil && project.project_type != "modpack"))
                        }.padding(.vertical, 10)
                    }
                }
                if project.project_type == "shader" { Text("光影文件需配合 Iris 或 OptiFine 使用。").font(PCLTheme.font(12)).foregroundStyle(PCLTheme.gray) }
                if model.selectedVersion == nil && project.project_type != "modpack" { Text("请先在启动页选择游戏版本。").foregroundStyle(PCLTheme.gray) }
            }
        }
    }
    private func search() {
        guard model.resourceKind != "datapack" else { return }
        searched = true
        model.searchResources(query: query, kind: model.resourceKind, compatibleOnly: compatibleOnly)
    }
}

private struct PCLLibrarySurface<Content: View>: View {
    @ViewBuilder var content: Content
    var body: some View {
        content.frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white.opacity(245 / 255), in: RoundedRectangle(cornerRadius: 5))
            .shadow(color: PCLTheme.text.opacity(0.12), radius: 3, x: 0, y: 1)
    }
}
private struct PCLLibraryRowStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View { Row(configuration: configuration) }
    private struct Row: View {
        let configuration: ButtonStyle.Configuration
        @State private var hovered = false
        var body: some View {
            configuration.label.background(hovered || configuration.isPressed ? PCLTheme.light : .clear, in: RoundedRectangle(cornerRadius: 3))
                .onHover { hovered = $0 }.animation(.easeOut(duration: 0.12), value: hovered)
        }
    }
}
