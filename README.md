# PCL-for-macOS
PCL for macOS

# Plain Craft Launcher (PCL) macOS 社区迁移版

**MacOS转译：无所不能的无吴小果**。本 macOS 项目由 **wuxiaoguo** 负责转译、开发与维护，[帮助网页与问题反馈](https://space.bilibili.com/3546613016430791?spm_id_from=333.1007.0.0)由本项目维护者提供。

这是第三方基于 PCL 2.13.1.1 独立进行二次创作的原生 macOS 工程。原版 PCL 作者为**龙腾猫跃（LTCat）**，赞助原作者：https://meloong.com/afd/a/LTCat 。本 macOS 项目与 PCL 官方无隶属关系，保留原仓库 LICENCE。源码随工程提供；此处没有发布或分发软件。

## 工程位置与运行


用 Xcode 26 或更新版本打开工程，Scheme 选择 `PCL 2.13.11`，运行目标选择 `My Mac`，按 **Command + R**。Swift 6 的数据模型与通用工具使用显式 `nonisolated`，UI 状态放在 `@MainActor`，后台服务使用 `actor`，兼容 Xcode 的默认 MainActor 隔离配置。

最低系统为 macOS 14。macOS 启动器使用 Foundation Process 直接启动 Java，不依赖 Windows、Wine 或 .NET。启动器为本地桌面分发配置，关闭 App Sandbox，以读写用户选择的 Minecraft 目录、管理 Java 和启动游戏进程。没有加入后台联网遥测。

直接编译（当前机器安装的是 Xcode-beta）：

```sh
cd '你本机上的此项目目录'
DEVELOPER_DIR=/Applications/Xcode-beta.app/Contents/Developer xcodebuild \
  -project 'PCL 2.13.11.xcodeproj' -scheme 'PCL 2.13.11' \
  -configuration Debug -destination 'platform=macOS' -derivedDataPath Build \
  CODE_SIGN_IDENTITY=- CODE_SIGN_STYLE=Manual DEVELOPMENT_TEAM= build
open 'Build/Build/Products/Debug/PCL 2.13.11.app'
```

如果 Xcode 安装在 `Xcode.app`，将命令中的 `Xcode-beta.app` 改成 `Xcode.app`。Xcode 自动签名保留用户原本的团队配置；以上命令采用本机临时签名。发布签名、公证和分发尚未执行。

## 使用

1. 到设置页选择 Minecraft 目录。默认使用 `~/Library/Application Support/minecraft`。
2. 检测或安装 Temurin Java。游戏版本元数据指定所需 Java；1.12.2 使用 8、1.20.1 使用 17、1.21.1 使用 21、26.2 使用 25。
3. 到下载页自动读取官方清单，点击版本后展开 Fabric、Forge 或 NeoForge 卡片选择加载器版本，再开始下载。Forge/NeoForge 调用官方 JAR 安装器。
4. 在启动页选择正版登录，或使用离线试玩。源码的微软 Client ID 未提供，需在设置中配置自己的应用注册，并拥有 Minecraft 服务访问权限；仅开启设备码登录并不保证 Minecraft 服务会允许该应用。
5. 选择版本后启动。默认使用独立目录 `versions/<实例>/game` 保存存档、Mod 和配置；需要使用官方启动器的既有存档时，可在设置关闭默认版本隔离。整合包实例始终隔离。
6. 资源页可下载 Modrinth Mod、资源包、光影和整合包。Mod 必需依赖会递归下载；光影仍需 Iris/OptiFine。Mod 管理可导入、启用、禁用和移至废纸篓。

Apple Silicon 上的旧版 Minecraft 缺少 ARM 原生库时使用 Intel x64 Java，并需要系统已安装 Rosetta 2。当前程序不自动安装 Rosetta，也不修改系统开发工具选择。

配置：`~/Library/Application Support/PCL-macOS-Community/settings.json`。
Java：同目录 `runtime`。日志：同目录 `logs`。账号刷新令牌与游戏访问令牌存放于 macOS 钥匙串；不会写入设置或导出的游戏目录。


主窗口、启动页、下载页、版本选择、资源搜索与设置页按原作 XAML 的默认配色和尺寸迁移。具体源码映射和仍存在的差异见 [Documentation/UI_RESTORATION.md](Documentation/UI_RESTORATION.md)。

