import SwiftUI
import AppKit

struct PCLTitleBar: View {
    @EnvironmentObject var model: LauncherModel
    private var inner: Bool { [.versions, .mods, .accounts, .logs].contains(model.page) }
    private var selectedTab: Int {
        switch model.page { case .launch: 0; case .download, .resources: 1; case .link: 2; case .settings: 3; default: 4 }
    }
    var body: some View {
        ZStack {
            PCLTheme.topbar
            PCLDragArea()
            HStack(spacing: 0) {
                PCLIcon(name: "PCLLogo", stroke: true).frame(width: 39, height: 25).foregroundStyle(.white).padding(.leading, 19)
                if inner {
                    Button { model.page = .launch } label: {
                        HStack(spacing: 12) { PCLIcon(name: "BtnTitleInner").frame(width: 16, height: 16); Text(model.page == .versions ? "版本选择" : model.page.rawValue) }
                    }.buttonStyle(.plain).foregroundStyle(.white).padding(.leading, 25)
                }
                Spacer()
                Button { NSApp.keyWindow?.miniaturize(nil) } label: { PCLIcon(name: "BtnTitleMin").frame(width: 12, height: 12).frame(width: 28, height: 28) }.buttonStyle(.plain).help("最小化")
                Button { NSApp.keyWindow?.performClose(nil) } label: { PCLIcon(name: "BtnTitleClose").frame(width: 12, height: 12).frame(width: 28, height: 28) }.buttonStyle(.plain).help("关闭")
            }.foregroundStyle(.white).padding(.trailing, 12)
            if !inner {
                HStack(spacing: 5) {
                    ForEach(Array(["启动", "下载", "联机", "设置", "更多"].enumerated()), id: \.offset) { index, title in
                        PCLPill(title: title, icon: "BtnTitleSelect\(index)", selected: selectedTab == index) {
                            model.page = [LauncherPage.launch, .download, .link, .settings, .help][index]
                        }
                    }
                }
            }
        }.frame(height: 48)
    }
}

struct PCLPill: View {
    let title: String
    let icon: String
    let selected: Bool
    var blue = false
    let action: () -> Void
    @State private var hovered = false
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) { PCLIcon(name: icon).frame(width: 16, height: 16); Text(title) }
                .font(PCLTheme.font()).padding(.horizontal, 12).frame(height: 27)
                .foregroundStyle(blue ? (selected ? Color.white : PCLTheme.accent) : (selected ? PCLTheme.accent : Color.white))
                .background(selected ? (blue ? PCLTheme.accent : .white) : (hovered ? Color.white.opacity(0.2) : .clear), in: Capsule())
        }.buttonStyle(.plain).onHover { hovered = $0 }
    }
}

struct PCLSideRow: View {
    let title: String
    let icon: String
    let selected: Bool
    let action: () -> Void
    @State private var hovered = false
    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                PCLIcon(name: icon).frame(width: 18, height: 18)
                Text(title); Spacer(minLength: 0)
            }.padding(.leading, 18).padding(.trailing, 8).frame(height: 36)
                .foregroundStyle(selected ? PCLTheme.accent : PCLTheme.text)
                .background(selected ? PCLTheme.light : hovered ? Color.white.opacity(0.6) : .clear)
                .overlay(alignment: .leading) { if selected { Rectangle().fill(PCLTheme.accent).frame(width: 3).padding(.vertical, 7) } }
        }.buttonStyle(.plain).onHover { hovered = $0 }
    }
}

struct PCLSideNavigation: View {
    @EnvironmentObject var model: LauncherModel
    var body: some View {
        VStack(spacing: 0) {
            if model.page == .download || model.page == .resources {
                row("原版游戏", "ItemInstall", model.page == .download) { model.page = .download }
                section("社区资源")
                ForEach(Array(zip(["Mod", "整合包", "数据包", "资源包", "光影包"], ["mod", "modpack", "datapack", "resourcepack", "shader"])), id: \.1) { title, kind in
                    row(title, ["mod": "ItemMod", "modpack": "ItemPack", "datapack": "ItemDataPack", "resourcepack": "ItemResourcePack", "shader": "ItemShader"][kind]!, model.page == .resources && model.resourceKind == kind) { model.resourceKind = kind; model.projects = []; model.page = .resources }
                }
            } else if model.page == .settings {
                ForEach(Array(zip(["启动", "联机", "个性化", "其他"], ["ItemLaunch", "ItemLink", "ItemUI", "ItemSystem"])), id: \.0) { title, icon in
                    row(title, icon, model.settingsSection == title) { model.settingsSection = title }
                }
            } else if model.page == .versions {
                section("游戏文件夹")
                row(model.root.lastPathComponent, "ItemOverall", true) {}
                row("添加文件夹", "ItemInstall", false) { model.chooseRoot() }
                row("刷新版本列表", "ItemSystem", false) { Task { await model.refreshLocal() } }
                row("打开文件夹", "ItemExport", false) { model.openDirectory(model.root) }
            } else if model.page == .mods {
                row("版本设置", "ItemSetup", false) { model.page = .settings }
                row("Mod 管理", "ItemMod", true) {}
                row("导出整合包", "ItemExport", false) { model.exportGameFiles() }
            } else if model.page == .accounts || model.page == .logs {
                row("返回启动页", "BtnExtraBack", false) { model.page = .launch }
            } else if model.page == .link {
                row("联机", "ItemLink", true) {}
            } else {
                row("帮助网页", "ItemHelp", model.page == .help) { model.openLink("https://space.bilibili.com/3546613016430791?spm_id_from=333.1007.0.0") }
                row("关于", "ItemAbout", model.page == .about) { model.page = .about }
                section("其他")
                row("日志", "ItemTest", false) { model.page = .logs }
                row("反馈", "ItemFeedback", false) { model.openLink("https://space.bilibili.com/3546613016430791?spm_id_from=333.1007.0.0") }
            }
            Spacer(minLength: 0)
        }.padding(.top, 12).frame(maxHeight: .infinity).background(Color.white.opacity(241 / 255))
    }
    private func row(_ title: String, _ icon: String, _ selected: Bool, _ action: @escaping () -> Void) -> some View { PCLSideRow(title: title, icon: icon, selected: selected, action: action) }
    private func section(_ title: String) -> some View { Text(title).foregroundStyle(PCLTheme.text.opacity(0.6)).font(PCLTheme.font(12)).frame(maxWidth: .infinity, alignment: .leading).padding(.leading, 13).padding(.top, 20).padding(.bottom, 4) }
}

struct PCLLaunchLeft: View {
    @EnvironmentObject var model: LauncherModel
    @State private var microsoft = false
    var body: some View {
        VStack(spacing: 0) {
            if model.busy || model.running {
                Spacer()
                ProgressView().controlSize(.large).padding(.bottom, 15)
                Text(model.running ? "游戏正在运行" : "正在启动 / 下载").font(PCLTheme.font(20)).foregroundStyle(PCLTheme.accent)
                Text(model.progress.message).font(PCLTheme.font(13.5)).multilineTextAlignment(.center).padding(.horizontal, 30).padding(.top, 8)
                ProgressView(value: model.progress.fraction).padding(.horizontal, 30).padding(.top, 12)
                Spacer()
                Button(model.running ? "结束游戏" : "取消") { if model.running { model.stopGame() } else { model.cancel() } }.buttonStyle(PCLButtonStyle(height: 35)).padding(20)
            } else {
                HStack(spacing: 8) {
                    PCLPill(title: "正版", icon: "RadioLoginType5", selected: microsoft, blue: true) { microsoft = true; if let account = model.settings.accounts.first { model.settings.selectedAccount = account.id } }
                    PCLPill(title: "离线", icon: "RadioLoginType0", selected: !microsoft, blue: true) { microsoft = false; model.settings.selectedAccount = "offline" }
                }.padding(.top, 22)
                Spacer(minLength: 8)
                VStack(spacing: 15) {
                    if microsoft && model.selectedAccount == nil {
                        PCLIcon(name: "MicrosoftLogin").frame(width: 40, height: 40).foregroundStyle(PCLTheme.primary.opacity(0.7)).padding(.bottom, 10)
                    } else { PCLSteveHead().frame(width: 64, height: 64) }
                    if microsoft {
                        if model.settings.accounts.isEmpty {
                            HStack(spacing: 10) { Text("添加 Microsoft 账号").frame(maxWidth: .infinity, alignment: .leading); Button("登录") { model.login() }.buttonStyle(PCLButtonStyle(highlight: true, height: 28)) }
                        } else {
                            HStack { AccountPicker().labelsHidden(); Button("管理") { model.page = .accounts } }
                        }
                        HStack(spacing: 30) {
                            Button("» 购买正版") { model.openLink("https://www.minecraft.net/zh-hans/store/minecraft-java-bedrock-edition-pc") }
                            Button("» 前往官网") { model.openLink("https://www.minecraft.net/zh-hans") }
                        }.buttonStyle(.plain).foregroundStyle(PCLTheme.text.opacity(0.3)).font(PCLTheme.font(12))
                    } else {
                        TextField("玩家名", text: $model.settings.offlineName).textFieldStyle(PCLTextFieldStyle())
                    }
                }.padding(.horizontal, 20)
                Spacer(minLength: 8)
                Button { if model.versions.isEmpty { model.page = .download } else if microsoft && model.selectedAccount == nil { model.login() } else { model.launch() } } label: {
                    VStack(spacing: 3) {
                        Text(model.versions.isEmpty ? "下载游戏" : "启动游戏").font(PCLTheme.font(16))
                        Text(model.selectedVersion?.id ?? "请先下载游戏，或添加游戏文件夹").font(PCLTheme.font(11)).foregroundStyle(PCLTheme.gray).lineLimit(1)
                    }.frame(maxWidth: .infinity).frame(height: 54)
                }.buttonStyle(PCLButtonStyle(highlight: true, height: 54))
                    .padding(.horizontal, 20)
                HStack(spacing: 10) {
                    Button { model.page = .versions } label: { Text("版本选择").frame(maxWidth: .infinity) }
                    if model.selectedVersion != nil { Button { model.page = .mods } label: { Text("版本设置").frame(maxWidth: .infinity) } }
                }.buttonStyle(PCLButtonStyle(height: 35)).padding(.horizontal, 20).padding(.top, 10).padding(.bottom, 20)
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.white.opacity(241 / 255))
            .onAppear { microsoft = model.settings.selectedAccount != "offline" }
    }
}

struct PCLSteveHead: View {
    private func crop(_ x: CGFloat) -> NSImage? {
        guard let source = NSImage(named: "SteveSkin"), let cg = source.cgImage(forProposedRect: nil, context: nil, hints: nil), let cropped = cg.cropping(to: CGRect(x: x, y: 8, width: 8, height: 8)) else { return nil }
        return NSImage(cgImage: cropped, size: NSSize(width: 8, height: 8))
    }
    var body: some View {
        ZStack {
            if let face = crop(8) { Image(nsImage: face).resizable().interpolation(.none).frame(width: 48, height: 48) }
            if let hat = crop(40) { Image(nsImage: hat).resizable().interpolation(.none).frame(width: 56, height: 56) }
        }
    }
}

struct PCLLaunchRight: View {
    // UiCustomType=0 / UiCustomPreset=0 leaves the original default homepage empty.
    var body: some View { Color.clear.frame(maxWidth: .infinity, maxHeight: .infinity) }
}

struct PCLLinkPage: View {
    @EnvironmentObject var model: LauncherModel
    var body: some View {
        ScrollView { VStack(spacing: 15) {
            PCLCard(title: "联机") {
                Text("原作的 EasyTier 邀请码联机尚未迁移。当前可通过 Minecraft 服务器地址加入游戏。")
                TextField("服务器地址", text: $model.settings.server).textFieldStyle(PCLTextFieldStyle())
                Button("启动并加入服务器") { model.launch() }.disabled(model.selectedVersion == nil || model.busy || model.running)
            }
        }.padding(25) }
    }
}

struct PCLHelpPage: View {
    @EnvironmentObject var model: LauncherModel
    var body: some View {
        ScrollView { VStack(spacing: 15) {
            PCLCard(title: "帮助") {
                Text("选择游戏文件夹，在下载页安装版本，再返回启动页启动游戏。Java、内存与额外参数可在设置页调整。")
                Button("帮助网页") { model.openLink("https://space.bilibili.com/3546613016430791?spm_id_from=333.1007.0.0") }
            }
            PCLCard(title: "常见问题") {
                Text("游戏异常退出时，可打开日志页查看提示并导出日志。旧版 Minecraft 在 Apple Silicon 上可能需要 Intel Java。")
                Button("打开日志") { model.page = .logs }
            }
        }.padding(25) }
    }
}
