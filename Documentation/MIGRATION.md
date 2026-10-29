# Windows PCL 到原生 macOS 的迁移记录

源目录：`/Users/wuxiaoguo/Code/MC/启动器转译/PCL-2.13.1.1`。
当前 Xcode 工程：`/Users/wuxiaoguo/Code/Xcode/00_Mac APP/PCL 2.13.11`。

原仓库包含 VB.NET/WPF 主程序、PCLCS C# 辅助类、资源和发行历史补丁；MeloongCore 子目录为空，因此其中实现不可从此快照逐行转译。ModSecret 的微软应用 Client ID 从环境变量获取，也未提供可用的官方凭据。原生代码重新实现已公开的核心流程，不调用原来的 Windows DLL。

| 原模块 / 页面 | Swift 原生实现 | 当前覆盖与差异 |
|---|---|---|
| Application、FormMain、Pages、Controls、ModAnimation | App 入口、ContentView、PCLTheme、PCLLayout、PCLVector、PCLCard | 按原作默认蓝色、顶部导航、左右分栏、按钮和白卡片恢复主要页面；部分动画、弹窗、字体回退和未迁移功能仍有差异 |
| ModMinecraft：实例与 JSON | Models.Metadata、MinecraftEngine | 版本扫描、递归继承、循环检测、Maven 库覆盖、版本分类；不解析 PCL 所有 INI 设置 |
| ModMinecraft：rules、natives | RuleEnvironment、MinecraftEngine.libraries | macOS 规则、功能条件、Intel/ARM 选择、旧版原生库分类器；无 Windows DLL 支持 |
| ModLaunch：启动流水线 | MinecraftEngine.prepareLaunch、LauncherModel.spawn | Java 选择、文件修复、资源、natives 解压、JVM/游戏参数、macOS 首线程、Process、日志、停止、退出码 |
| ModLaunch：微软登录 | AccountService、SecureStore | 设备码、轮询与取消、刷新、Xbox/XSTS、Minecraft 令牌、购买验证与玩家档案、钥匙串、多账号 |
| ModLaunch：离线 / 正版与赞助劝导 | GameSession.offline、LauncherModel | Java 同等离线 UUID；未经正版验证始终试玩；原作者赞助次数提示；行为比源码中文离线提示更严格 |
| ModJava、PCLCS.Java | JavaService | macOS JDK 目录和 java_home 检测、版本/架构检查、Temurin 安装与 SHA-256 校验；不迁移注册表搜索 |
| ModNet、ModLoader | HTTPClient、DownloadItem、InstallProgress | HTTPS、重试、取消、8 个并发文件、校验、临时文件原子替换、进度；没有逐块断点续传和 PCL CDN 签名 |
| ModDownload、ModDownloadLib | MinecraftEngine、LoaderInstaller | 官方版本清单、客户端、资源、库、Fabric 稳定版、现代 Forge/NeoForge 官方安装器 |
| ModModpack | ModpackService | Modrinth、MultiMC/Prism 和原版 HMCL，隔离实例，下载校验，覆盖文件、安全解压；部分格式和加载器不支持时明确报错 |
| LocalResource、ResourceProject/Version/Searcher | ResourceService、PCLResourcesPage、PCLModsPage | Modrinth 搜索、版本、兼容筛选、必需依赖、下载；本地 Fabric Mod 描述、JAR 导入、启停、废纸篓 |
| Settings、SettingService、PclLogger | LauncherSettings、LauncherModel | JSON 持久化、损坏配置备份、游戏日志、敏感令牌隐藏；不是全部原设置项 |
| ModWatcher、ModCrash | 进程输出读取、退出监控、crashAdvice | 常见内存、Java、原生库、Mod/Mixin 提示；未迁移完整的 1122 行崩溃规则库 |
| ModMusic | AVAudioPlayer | 本地背景音乐、循环、播放/暂停 |
| PageOtherAbout/Help | AboutPage 与随工程说明 | 原作者置顶署名、赞助、第三方声明、使用说明、原帮助库链接 |

## 尚未完成的功能等价

以下项目没有用假按钮或无效模拟来冒充实现：

- Authlib Injector、Nide 第三方账号与皮肤更换、完整皮肤预览。
- CurseForge API、API 密钥管理、CurseForge 整合包文件回退链接与下载禁用处理。
- OptiFine、OptiFabric、LiteLoader 自动安装；旧 Forge 安装助手和 Quilt 加载器。
- MCBBS、带启动器的 ZIP、部分 HMCL 与 MultiMC 自定义组件；导出的 ZIP 目前是游戏文件备份，不是标准 Modrinth 导出包。
- EasyTier 网络与邀请码联机。原生 Minecraft 本身的 LAN 联机和服务器参数仍可使用。
- XAML 自定义主页、远程自定义事件脚本、PCL 自更新服务、赞助解锁、Windows 音效和注册表迁移。
- 原作全部 UI 动画、视觉主题、下载速度统计、完整 Mod 冲突分析和崩溃分析规则。

## 必要的平台变化

- Windows `;` classpath 改为 macOS `:`；参数使用 Process.arguments 数组，不使用 cmd.exe 或拼接 shell 命令。
- `javaw.exe` 改为 JDK 的 `bin/java`，始终添加 `-XstartOnFirstThread`。
- `%AppData%`、注册表与 Windows Credential 存储改为 Application Support、JSON 与 Keychain。
- 区分 ARM64 和 Intel 原生库；仅存在 Intel 库的旧版选择 Intel JVM。
- 不将 Windows 音频、WebP 和 WPF DLL 包含到 App。
- ZIP 在解压前检查中央目录，拒绝越界路径、符号链接、加密文件和不支持的 ZIP64；下载按元数据哈希校验。
- Codable 数据类型和通用工具显式 nonisolated，后台服务 actor，SwiftUI 模型 MainActor，避免 Xcode 的默认隔离导致 Decodable/Sendable 连锁报错。

此文档记录实际代码覆盖，不代表遗漏项目已完成。所有原始文件保留在源目录，未覆盖原始 Windows 源码。
