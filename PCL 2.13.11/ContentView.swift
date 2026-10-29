import SwiftUI
import AppKit

struct ContentView: View {
    @EnvironmentObject var model: LauncherModel
    var body: some View {
        VStack(spacing: 0) {
            PCLTitleBar()
            HStack(spacing: 0) {
                if model.page == .launch { PCLLaunchLeft().frame(width: 300) }
                else { PCLSideNavigation().frame(width: model.page == .versions ? 250 : 152) }
                Rectangle().fill(LinearGradient(colors: [.black.opacity(0.04), .clear], startPoint: .leading, endPoint: .trailing)).frame(width: 4)
                ZStack(alignment: .bottomTrailing) {
                    Group {
                        switch model.page {
                        case .launch: PCLLaunchRight()
                        case .versions: PCLVersionsPage()
                        case .download: PCLDownloadPage()
                        case .resources: PCLResourcesPage()
                        case .mods: PCLModsPage()
                        case .accounts: AccountsPage()
                        case .settings: PCLSettingsPage()
                        case .logs: LogsPage()
                        case .about: AboutPage()
                        case .link: PCLLinkPage()
                        case .help: PCLHelpPage()
                        }
                    }.frame(maxWidth: .infinity, maxHeight: .infinity)
                    if model.busy || model.running || !model.logs.isEmpty {
                        Button { model.page = .logs } label: {
                            PCLIcon(name: "BtnExtraDownload").frame(width: 22, height: 22).foregroundStyle(PCLTheme.primary)
                                .frame(width: 40, height: 40).background(.white, in: Circle())
                                .shadow(color: .black.opacity(0.15), radius: 3, y: 1)
                        }.buttonStyle(.plain).padding(15).help("任务管理")
                    }
                }
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(PCLTheme.background)
        }
        .background(PCLTheme.background)
        .clipShape(RoundedRectangle(cornerRadius: 6))
        .shadow(color: .black.opacity(0.15), radius: 6)
        .padding(18)
        .background(PCLWindowChrome())
        .font(PCLTheme.font()).foregroundStyle(PCLTheme.text)
        .buttonStyle(PCLButtonStyle()).toggleStyle(PCLCheckStyle())
        .tint(PCLTheme.accent).preferredColorScheme(.light)
        .frame(minWidth: 810, minHeight: 470)
        .alert(item: $model.notice) { notice in Alert(title: Text(notice.title), message: Text(notice.text), dismissButton: .default(Text("好"))) }
        .sheet(isPresented: Binding(get: { model.device != nil }, set: { if !$0 { model.cancel() } })) { DeviceLoginSheet() }
        .confirmationDialog("请支持正版 Minecraft", isPresented: $model.buyPrompt, titleVisibility: .visible) {
            Button("登录已购买的微软账号") { model.page = .accounts }
            Button("购买正版") { model.openLink("https://www.minecraft.net/zh-hans/store/minecraft-java-bedrock-edition-pc") }
            Button("以试玩模式启动") { model.startGame(demo: true) }
            Button("返回", role: .cancel) {}
        } message: { Text("请先登录正版账号验证购买记录。未验证购买时，离线启动将使用试玩模式。") }
        .confirmationDialog("支持原作者龙腾猫跃", isPresented: $model.sponsorPrompt, titleVisibility: .visible) {
            Button("赞助原作者") { model.openLink("https://meloong.com/afd/a/LTCat") }
            Button("下次再说", role: .cancel) {}
        } message: { Text("PCL 已为你启动 \(model.settings.launchCount) 次游戏。感谢龙腾猫跃开发 PCL，欢迎支持原项目持续更新。") }
        .onChange(of: model.settings.selectedVersion) { _, _ in Task { await model.refreshMods() } }
    }
}

struct PCLCard<Content: View>: View {
    let title: String
    @ViewBuilder var content: Content
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title).font(PCLTheme.font(13, weight: .bold)).padding(.leading, 15).padding(.top, 12).padding(.bottom, 11)
            VStack(alignment: .leading, spacing: 12) { content }.padding(.horizontal, 20).padding(.bottom, 15)
        }.frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white.opacity(245 / 255), in: RoundedRectangle(cornerRadius: 5))
            .shadow(color: PCLTheme.text.opacity(0.12), radius: 3, x: 0, y: 1)
    }
}

struct VersionPicker: View {
    @EnvironmentObject var model: LauncherModel
    var body: some View {
        Picker("游戏版本", selection: $model.settings.selectedVersion) {
            Text("选择版本").tag("")
            ForEach(model.versions) { version in Text(version.id).tag(version.id) }
        }.disabled(model.busy || model.running)
    }
}
struct AccountPicker: View {
    @EnvironmentObject var model: LauncherModel
    var body: some View {
        Picker("账号", selection: $model.settings.selectedAccount) {
            Text("离线 / 试玩").tag("offline")
            ForEach(model.settings.accounts) { account in Text(account.name).tag(account.id) }
        }.disabled(model.busy || model.running)
    }
}

struct AccountsPage: View {
    @EnvironmentObject var model: LauncherModel
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                PCLCard(title: "Microsoft 账号") {
                    Text("通过系统浏览器输入设备码登录。访问令牌与刷新令牌保存在 macOS 钥匙串中。")
                    Button("添加微软账号") { model.login() }.buttonStyle(PCLButtonStyle(highlight: true)).disabled(model.busy)
                    if model.settings.microsoftClientID.isEmpty { Text("先到设置页填写你自己的 Microsoft 应用 Client ID。").foregroundStyle(.orange) }
                    ForEach(model.settings.accounts) { account in
                        HStack { Image(systemName: "person.crop.circle.fill").foregroundStyle(PCLTheme.primary); Text(account.name); Spacer(); Button("使用") { model.settings.selectedAccount = account.id }; Button("移除", role: .destructive) { model.removeAccount(account) } }
                    }
                }
                PCLCard(title: "离线 / 试玩") {
                    TextField("玩家名", text: $model.settings.offlineName).textFieldStyle(PCLTextFieldStyle())
                    Text("仅支持 1–16 个英文字母、数字和下划线。登录正版账号验证购买后可进行离线游玩。")
                        .font(.caption).foregroundStyle(.secondary)
                    Button("使用离线账号") { model.settings.selectedAccount = "offline" }
                    Button("购买 Minecraft") { model.openLink("https://www.minecraft.net/zh-hans/store/minecraft-java-bedrock-edition-pc") }
                }
            }.padding(25)
        }.disabled(model.running)
    }
}
struct DeviceLoginSheet: View {
    @EnvironmentObject var model: LauncherModel
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.badge.key.fill").font(.system(size: 44)).foregroundStyle(PCLTheme.primary)
            Text("登录 Microsoft 账号").font(.title2.bold())
            Text("在浏览器打开验证网址，并输入下面的设备码。")
            Text(model.device?.code ?? "").font(.system(size: 32, weight: .bold, design: .monospaced)).textSelection(.enabled)
            Text(model.device?.url ?? "").font(.caption).textSelection(.enabled)
            HStack {
                Button("复制设备码") { NSPasteboard.general.clearContents(); NSPasteboard.general.setString(model.device?.code ?? "", forType: .string) }
                Button("打开登录网页") { model.openLink(model.device?.url ?? "") }.buttonStyle(PCLButtonStyle(highlight: true))
                Button("取消") { model.cancel() }
            }
            ProgressView().controlSize(.small)
            Text("等待浏览器登录完成……").font(.caption).foregroundStyle(.secondary)
        }.padding(36).frame(width: 540)
    }
}

struct LogsPage: View {
    @EnvironmentObject var model: LauncherModel
    @State private var filter = ""
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                TextField("筛选日志", text: $filter).textFieldStyle(PCLTextFieldStyle())
                Button("导出") { model.exportLogs() }
                Button("打开日志目录") { model.openDirectory(Paths.support.appendingPathComponent("logs")) }
                Button("清空显示") { model.logs = [] }
            }
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 5) {
                        ForEach(model.logs.filter { filter.isEmpty || $0.text.localizedCaseInsensitiveContains(filter) }) { entry in
                            Text(entry.text).font(.system(size: 11, design: .monospaced)).textSelection(.enabled).frame(maxWidth: .infinity, alignment: .leading).id(entry.id)
                        }
                    }.padding(14)
                }.background(Color.white, in: RoundedRectangle(cornerRadius: 5))
                    .onChange(of: model.logs.count) { _, _ in if let last = model.logs.last { proxy.scrollTo(last.id, anchor: .bottom) } }
            }
            Text(model.crashAdvice).font(.caption).foregroundStyle(.secondary).frame(maxWidth: .infinity, alignment: .leading)
        }.padding(25)
    }
}

struct AboutPage: View {
    @EnvironmentObject var model: LauncherModel
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                PCLCard(title: "原版 PCL 作者：龙腾猫跃（LTCat）") {
                    Text("本项目基于原版 Plain Craft Launcher 源码迁移，感谢原作者龙腾猫跃提供原版代码。macOS 转译与维护由 wuxiaoguo 负责。")
                    HStack { Button("赞助龙腾猫跃") { model.openLink("https://meloong.com/afd/a/LTCat") }; Button("原项目源码") { model.openLink("https://github.com/Meloong-Git/PCL") } }
                }
                PCLCard(title: "Plain Craft Launcher (PCL) macOS 社区迁移版") {
                    Text("MacOS转译：无所不能的无吴小果").font(PCLTheme.font(15, weight: .bold))
                    Text("本 macOS 项目由 wuxiaoguo 负责转译、开发与维护，是基于 PCL 2.13.1.1 独立进行二次创作的第三方项目，与 PCL 官方无隶属关系。使用帮助和问题反馈由本项目维护者提供。")
                    Button("维护者主页 / 反馈") { model.openLink("https://space.bilibili.com/3546613016430791?spm_id_from=333.1007.0.0") }
                    Text("使用 Swift、SwiftUI、AppKit、Foundation、Security 与 AVFoundation 实现。无需 Windows 或 Wine。")
                    Text("当前迁移版本：0.1.0 · 尚未达到 Windows 版的完整功能等价。完整源代码与迁移覆盖表随 Xcode 工程提供。")
                        .foregroundStyle(.secondary)
                }
                PCLCard(title: "帮助") {
                    Text("1. 设置 Minecraft 目录，并安装相应的 Java。\n2. 下载原版或加载器版本，或导入整合包。\n3. 配置微软 Client ID 并登录账号；未验证正版账号可使用试玩。\n4. 在启动页选择版本和账号，启动游戏。\n5. 遇到问题时，检查日志并导出诊断信息。")
                    Button("Minecraft 官网") { model.openLink("https://www.minecraft.net/zh-hans") }
                    Button("帮助网页") { model.openLink("https://space.bilibili.com/3546613016430791?spm_id_from=333.1007.0.0") }
                }
                PCLCard(title: "迁移覆盖") {
                    Text("已实现：原版与 Fabric 安装、现代 Forge/NeoForge 安装器接入、版本继承、Intel/ARM 原生库选择、Java 管理、微软登录与刷新、试玩、Modrinth 资源及必需依赖、Mod 启停、整合包导入、游戏日志与基础崩溃提示、配置、背景音乐。")
                    Text("尚未迁移：CurseForge API、第三方 Authlib/Nide 登录、OptiFine/LiteLoader 自动安装、EasyTier 邀请码联机、XAML 自定义主页、Windows 更新与赞助解锁系统、完整崩溃规则库和部分整合包格式。")
                        .font(.callout).foregroundStyle(.secondary)
                }
            }.padding(25)
        }
    }
}
