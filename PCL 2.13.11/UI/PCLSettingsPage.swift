import SwiftUI
import Foundation

// The card titles, 25-point page inset, 15-point card gaps and 28-point
// setting rows follow PageSetupLaunch/UI/System.xaml in PCL 2.13.1.1.
struct PCLSettingsPage: View {
    @EnvironmentObject private var model: LauncherModel
    @State private var javaMajor = 21
    @State private var intel = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                switch model.settingsSection {
                case "个性化": personalization
                case "其他": systemSettings
                case "联机": linkSettings
                default: launchSettings
                }
            }
            .padding(.horizontal, 25)
            .padding(.top, 25)
            .padding(.bottom, 10)
        }
        .font(PCLTheme.font())
        .foregroundStyle(PCLTheme.text)
        .textFieldStyle(PCLTextFieldStyle())
        .buttonStyle(PCLButtonStyle())
        .toggleStyle(PCLCheckStyle())
        .tint(PCLTheme.accent)
    }

    @ViewBuilder private var launchSettings: some View {
        PCLCard(title: "启动选项") {
            VStack(alignment: .leading, spacing: 9) {
                settingRow("默认版本隔离") {
                    selectionMenu(model.settings.isolateVersions ? "隔离所有版本" : "关闭") {
                        Button("关闭") { model.settings.isolateVersions = false }
                        Button("隔离所有版本") { model.settings.isolateVersions = true }
                    }
                }
                settingRow("窗口大小") {
                    HStack(spacing: 10) {
                        selectionMenu(model.settings.fullscreen ? "全屏" : "自定义尺寸") {
                            Button("全屏") { model.settings.fullscreen = true }
                            Button("自定义尺寸") { model.settings.fullscreen = false }
                        }
                        if !model.settings.fullscreen {
                            TextField("宽", value: $model.settings.width, format: .number)
                                .frame(width: 60)
                            Text("×").font(PCLTheme.font(18))
                            TextField("高", value: $model.settings.height, format: .number)
                                .frame(width: 60)
                        }
                    }
                }
                settingRow("自动加入服务器") {
                    TextField("不自动加入", text: $model.settings.server)
                }
            }
            .padding(.horizontal, 5)
            .padding(.bottom, 10)
        }
        .disabled(model.busy || model.running)

        PCLCard(title: "内存分配") {
            VStack(alignment: .leading, spacing: 11) {
                HStack(spacing: 20) {
                    Text("自定义").frame(width: 110, alignment: .leading)
                    Slider(value: Binding(get: { Double(model.settings.memoryMB) }, set: { model.settings.memoryMB = Int($0) }), in: 1024...65536, step: 512)
                }
                GeometryReader { geometry in
                    HStack(spacing: 0) {
                        Rectangle().fill(PCLTheme.accent.opacity(0.5))
                            .frame(width: geometry.size.width * memoryFraction)
                        Rectangle().fill(PCLTheme.lightest)
                    }
                }
                .frame(height: 4)
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("游戏分配").font(PCLTheme.font(11)).opacity(0.7)
                        Text(String(format: "%.1f GB", Double(model.settings.memoryMB) / 1024)).font(PCLTheme.font(16))
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 3) {
                        Text("电脑总内存").font(PCLTheme.font(11)).opacity(0.7)
                        Text(String(format: "%.1f GB", Double(ProcessInfo.processInfo.physicalMemory) / 1_073_741_824)).font(PCLTheme.font(16))
                    }
                }
            }
            .padding(.horizontal, 5)
        }
        .disabled(model.busy || model.running)

        PCLCard(title: "高级选项") {
            VStack(alignment: .leading, spacing: 9) {
                settingRow("Java 虚拟机参数") { TextField("默认", text: $model.settings.jvmArguments) }
                settingRow("游戏参数") { TextField("默认", text: $model.settings.gameArguments) }
                settingRow("Java 列表") {
                    selectionMenu(javaLabel) {
                        Button("自动选择兼容 Java") { model.settings.javaPath = "" }
                        ForEach(model.runtimes) { runtime in
                            Button(runtime.display + " · " + runtime.path) { model.settings.javaPath = runtime.path }
                        }
                    }
                }
                HStack(spacing: 20) {
                    Button("手动导入") { model.chooseJava() }.frame(minWidth: 140)
                    Button("搜索 Java") { Task { await model.discoverJava() } }.frame(minWidth: 140)
                }
                .padding(.top, 5)
                settingRow("下载 Java") {
                    HStack(spacing: 12) {
                        selectionMenu("Java \(javaMajor)") {
                            ForEach([8, 16, 17, 21, 25], id: \.self) { major in
                                Button("Java \(major)") { javaMajor = major }
                            }
                        }
                        .frame(width: 110)
                        Toggle("Intel x64", isOn: $intel)
                        Button("下载") { model.installJava(javaMajor, intel: intel) }
                    }
                }
                Text("旧版 Minecraft 在 Apple Silicon 上可能需要 Intel Java 与 Rosetta 2。")
                    .font(PCLTheme.font(11)).opacity(0.7).fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, 5)
            .padding(.bottom, 10)
        }
        .disabled(model.busy || model.running)

        PCLCard(title: "游戏目录") {
            VStack(alignment: .leading, spacing: 9) {
                settingRow("Minecraft 文件夹") { TextField("路径", text: $model.settings.gameRoot) }
                HStack(spacing: 20) {
                    Button("选择文件夹") { model.chooseRoot() }.frame(minWidth: 140)
                    Button("重新扫描") { Task { await model.refreshLocal() } }.frame(minWidth: 140)
                }
                Text("隔离版本的存档、Mod 与配置保存在 versions/<实例>/game。整合包使用独立档案。")
                    .font(PCLTheme.font(11)).opacity(0.7).fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, 5)
            .padding(.bottom, 10)
        }
        .disabled(model.busy || model.running)
    }

    @ViewBuilder private var personalization: some View {
        PCLCard(title: "主题") {
            HStack(spacing: 12) {
                Circle().fill(PCLTheme.primary).frame(width: 20, height: 20)
                Text("默认蓝色")
                Spacer()
            }
            .padding(.horizontal, 5)
        }
        PCLCard(title: "背景音乐") {
            VStack(alignment: .leading, spacing: 14) {
                Text(model.musicName.isEmpty ? "尚未添加背景音乐" : model.musicName)
                    .opacity(model.musicName.isEmpty ? 0.7 : 1)
                HStack(spacing: 20) {
                    Button("添加音乐") { model.chooseMusic() }.frame(minWidth: 140)
                    if !model.musicName.isEmpty {
                        Button(model.musicPlaying ? "暂停音乐" : "播放音乐") { model.toggleMusic() }
                            .frame(minWidth: 140)
                    }
                }
            }
            .padding(.horizontal, 5)
            .padding(.bottom, 10)
        }
        PCLCard(title: "主页") {
            Text("空白").padding(.horizontal, 5)
        }
    }

    @ViewBuilder private var systemSettings: some View {
        PCLCard(title: "Microsoft 登录") {
            VStack(alignment: .leading, spacing: 9) {
                settingRow("应用 Client ID") { TextField("Client ID", text: $model.settings.microsoftClientID) }
                Text("填写允许个人微软账号、启用公共客户端登录并获准访问 Minecraft 服务的应用注册 Client ID。")
                    .font(PCLTheme.font(11)).opacity(0.7).fixedSize(horizontal: false, vertical: true)
                Button("查看登录文档") {
                    model.openLink("https://learn.microsoft.com/entra/identity-platform/v2-oauth2-device-code")
                }
            }
            .padding(.horizontal, 5)
            .padding(.bottom, 10)
        }
        .disabled(model.busy || model.running)
        PCLCard(title: "启动器") {
            VStack(alignment: .leading, spacing: 14) {
                Button("打开配置文件夹") { model.openDirectory(Paths.support) }.frame(minWidth: 140)
                Text("设置自动保存。登录凭据保存在 macOS 钥匙串。")
                    .font(PCLTheme.font(11)).opacity(0.7)
            }
            .padding(.horizontal, 5)
            .padding(.bottom, 10)
        }
    }

    @ViewBuilder private var linkSettings: some View {
        PCLCard(title: "联机设置") {
            VStack(alignment: .leading, spacing: 9) {
                settingRow("自动加入服务器") { TextField("服务器地址，可留空", text: $model.settings.server) }
                Text("启动时自动加入指定的 Minecraft 服务器。邀请码联机功能尚在迁移中。")
                    .font(PCLTheme.font(11)).opacity(0.7).fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, 5)
            .padding(.bottom, 10)
        }
        .disabled(model.busy || model.running)
    }

    private var javaLabel: String {
        if model.settings.javaPath.isEmpty { return "自动选择兼容 Java" }
        return model.runtimes.first { $0.path == model.settings.javaPath }?.display ?? model.settings.javaPath
    }
    private var memoryFraction: Double {
        min(1, max(0, Double(model.settings.memoryMB) * 1_048_576 / Double(ProcessInfo.processInfo.physicalMemory)))
    }

    private func settingRow<Content: View>(_ name: String, @ViewBuilder content: () -> Content) -> some View {
        HStack(spacing: 25) {
            Text(name).frame(width: 110, alignment: .leading)
            content().frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(minHeight: 28)
    }

    private func selectionMenu<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        Menu(content: content) {
            HStack(spacing: 8) {
                Text(title).lineLimit(1).truncationMode(.middle)
                Spacer(minLength: 3)
                Image(systemName: "chevron.down").font(.system(size: 9))
            }
            .padding(.horizontal, 8)
            .frame(height: 28)
            .background(Color.white.opacity(0.33), in: RoundedRectangle(cornerRadius: 3))
            .overlay(RoundedRectangle(cornerRadius: 3).stroke(PCLTheme.border, lineWidth: 1))
        }
        .menuStyle(.borderlessButton)
        .menuIndicator(.hidden)
        .font(PCLTheme.font())
    }
}
