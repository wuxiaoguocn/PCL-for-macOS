# 原版界面恢复记录

本轮以 PCL-2.13.1.1 源码中的默认蓝色主题和默认窗口状态为基准。

| 原作定义 | SwiftUI 实现 | 对齐参数 |
|---|---|---|
| FormMain.xaml | ContentView、PCLTitleBar、PCLWindowChrome | 默认 900×550，最小 810×470，顶栏 48，圆角 6，外边距 18，五项顶部导航 |
| PageLaunchLeft.xaml、PageLoginMs/Legacy.xaml | PCLLaunchLeft、PCLSteveHead | 左栏 300，正版/离线选项，像素皮肤，54 高描边启动按钮，35 高版本按钮，边距 20 |
| ModBase.MyColor.FromHSL2、ModSecret.ThemeRefresh | PCLTheme | 原作 HSL2 算法、默认 Hue 210/Sat 85、顶部和正文渐变、文本/边框/悬停颜色 |
| MyCard、MyButton、MyRadioButton | PCLCard、PCLButtonStyle、PCLPill | 白卡片圆角 5，按钮圆角 3，卡片阴影，27 高导航胶囊 |
| FormMain 与各 PageLeft 图标 | PCLIcons.json、PCLVector | 35 个原作矢量路径，支持 SVG/WPF 曲线与椭圆弧 |
| Resources/Font.ttf、Steve.png、Blocks | Resources、Assets.xcassets | 原作 PCL English 字体、Steve 皮肤、草方块与加载器图像 |
| PageDownloadInstall.xaml/.vb | PCLDownloadPage | 最新版本、正式版/预览版/远古版/愚人节版折叠卡；62 高选择栏、40 高加载器卡 |
| PageSelectRight、PageResource | PCLVersionsPage、PCLResourcesPage | 25 页边距、15 卡间距、白卡片列表、页内资源详情 |
| PageInstanceMod.xaml | PCLModsPage | 44 高 Mod 行、原版管理按钮和空列表提示卡片 |
| PageSetupLaunch/UI/System | PCLSettingsPage | 启动/联机/个性化/其他左栏分类，28 高设置行，内存/Java/启动参数等卡片 |

原作默认 UiCustomType=0、UiCustomPreset=0 时，启动页右侧没有自定义内容，因此这里保留原作的空白渐变区域。

## 当前验证边界

已通过实际 Xcode Swift 6 构建；原作所有页面、弹窗和动画尚未逐像素验收。macOS 没有随项目提供 Windows 的 Microsoft YaHei UI，中文使用系统字体回退，因此字形和文字度量仍可能不同。

未迁移功能（邀请码联机、XAML 自定义主页、完整皮肤更换、部分加载器等）保留明确说明。不能将主要页面布局恢复等同于原作全部功能及全部状态完全一致。
