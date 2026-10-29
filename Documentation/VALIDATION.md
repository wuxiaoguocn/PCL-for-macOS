# 本地验证记录

## 已验证

- Xcode Debug：主窗口、原版主题、原作矢量图标和启动页构建成功，见 ui-build.log。
- Xcode Release：下载、版本、资源与设置页面接入后，arm64 与 x86_64 通用构建成功，见 ui-release-build.log。
- 核心测试：18 项通过，包含 Mojang 元数据下载及哈希校验、Fabric 和 Modrinth 联网测试，见 core-tests.log。
- Codable 数据模型及通用工具已显式 nonisolated，先前报告的 Swift 6 MainActor/Sendable 错误已修复；此前强制 MainActor 配置构建见 target-xcode-build.log。

## 未验证

- 未登录用户实际微软账号，未替用户完成 OAuth 授权。
- 未完成所有 Minecraft、Mod、整合包版本的实际游戏启动兼容测试。
- 应用窗口的电脑操作权限未获批准，因此未读取实际窗口截图，也未进行逐像素视觉一致性验收。界面尺寸与颜色依据原作源码迁移。
- 未执行发布签名、公证或公开分发。
