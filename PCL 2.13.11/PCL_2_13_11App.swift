import SwiftUI
import AppKit

@main
struct PCL_2_13_11App: App {
    @StateObject private var model = LauncherModel()
    init() { PCLTheme.registerFont() }
    var body: some Scene {
        WindowGroup("PCL macOS 社区迁移版") {
            ContentView().environmentObject(model).ignoresSafeArea(.container, edges: .top)

        }.windowStyle(.hiddenTitleBar).defaultSize(width: 900, height: 550)
        .commands {
            CommandGroup(replacing: .newItem) {}
            CommandMenu("Minecraft") {
                Button("启动游戏") { model.launch() }.keyboardShortcut("r", modifiers: [.command]).disabled(model.busy || model.running || model.selectedVersion == nil)
                Button("停止游戏") { model.stopGame() }.disabled(!model.running)
                Divider()
                Button("刷新版本") { Task { await model.refreshLocal() } }.keyboardShortcut("r", modifiers: [.command, .shift]).disabled(model.busy)
                Button("打开游戏目录") { model.openDirectory(model.gameDirectory) }
                Button("查看日志") { model.page = .logs }.keyboardShortcut("l", modifiers: [.command])
            }
        }
        Settings { PCLSettingsPage().environmentObject(model).frame(width: 720, height: 680) }
    }
}
