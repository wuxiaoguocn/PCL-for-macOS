import SwiftUI

// PageInstanceMod.xaml: 25-point sides, 35-point management buttons,
// white cards and 44-point MyLocalModItem rows.
struct PCLModsPage: View {
    @EnvironmentObject private var model: LauncherModel
    @State private var query = ""
    @State private var filter = "全部"

    private var editable: Bool { model.selectedVersion != nil && !model.busy && !model.running }
    private var filteredMods: [LocalMod] {
        model.mods.filter { mod in
            let matchesText = query.isEmpty || [mod.name, mod.modID, mod.version, mod.url.lastPathComponent].contains { $0.localizedCaseInsensitiveContains(query) }
            return matchesText && (filter == "全部" || (filter == "已启用" && mod.enabled) || (filter == "已禁用" && !mod.enabled))
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            versionMenu.padding(.horizontal, 25).padding(.top, 10)
            if model.mods.isEmpty {
                Spacer(minLength: 20)
                emptyCard.padding(.horizontal, 40)
                Spacer(minLength: 20)
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 15) {
                        TextField("搜索 Mod 名称 / 文件名 / 版本", text: $query)
                            .textFieldStyle(PCLTextFieldStyle()).padding(.top, 15)
                        managementCard
                        listCard
                    }
                    .padding(.horizontal, 25)
                    .padding(.bottom, 10)
                }
            }
        }
        .font(PCLTheme.font())
        .foregroundStyle(PCLTheme.text)
        .buttonStyle(PCLButtonStyle())
    }

    private var versionMenu: some View {
        Menu {
            ForEach(model.versions) { version in
                Button(version.id) { model.settings.selectedVersion = version.id }
            }
        } label: {
            HStack {
                Text(model.settings.selectedVersion.isEmpty ? "选择游戏版本" : model.settings.selectedVersion)
                    .lineLimit(1)
                Spacer()
                Image(systemName: "chevron.down").font(.system(size: 9))
            }
            .padding(.horizontal, 8).frame(height: 28)
            .background(Color.white.opacity(0.33), in: RoundedRectangle(cornerRadius: 3))
            .overlay(RoundedRectangle(cornerRadius: 3).stroke(PCLTheme.border, lineWidth: 1))
        }
        .menuStyle(.borderlessButton).menuIndicator(.hidden)
        .disabled(model.busy || model.running)
    }

    private var managementCard: some View {
        HStack(spacing: 15) {
            Button("打开文件夹") { model.openDirectory(model.gameDirectory?.appendingPathComponent("mods")) }
                .buttonStyle(PCLButtonStyle(highlight: true, height: 35)).frame(minWidth: 110)
            Button("从文件安装") { model.importModFiles() }
                .buttonStyle(PCLButtonStyle(height: 35)).frame(minWidth: 110)
            Button("下载新 Mod") { downloadMods() }
                .buttonStyle(PCLButtonStyle(height: 35)).frame(minWidth: 110)
            Spacer(minLength: 0)
        }
        .padding(15)
        .background(cardBackground)
        .shadow(color: PCLTheme.text.opacity(0.12), radius: 3, x: 0, y: 1)
        .disabled(!editable)
    }

    private var listCard: some View {
        VStack(alignment: .leading, spacing: 7) {
            HStack(spacing: 4) {
                ForEach(["全部", "已启用", "已禁用"], id: \.self) { title in
                    Button { filter = title } label: {
                        Text(title).padding(.horizontal, 12).frame(height: 27)
                            .foregroundStyle(filter == title ? Color.white : PCLTheme.accent)
                            .background(filter == title ? PCLTheme.accent : Color.clear, in: Capsule())
                    }
                    .buttonStyle(.plain)
                }
                Spacer()
                Text("\(filteredMods.count) 个").font(PCLTheme.font(11)).opacity(0.6)
            }
            .padding(.leading, 17).padding(.trailing, 20).padding(.top, 13)
            LazyVStack(spacing: 0) {
                ForEach(filteredMods) { mod in
                    PCLLocalModRow(mod: mod, editable: editable,
                                   toggle: { model.toggleMod(mod) },
                                   trash: { model.trashMod(mod) })
                }
                if filteredMods.isEmpty {
                    Text("没有符合筛选条件的 Mod").opacity(0.6)
                        .frame(maxWidth: .infinity).padding(.vertical, 20)
                }
            }
            .padding(.leading, 20).padding(.trailing, 18).padding(.bottom, 22)
        }
        .background(cardBackground)
        .shadow(color: PCLTheme.text.opacity(0.12), radius: 3, x: 0, y: 1)
    }

    private var emptyCard: some View {
        VStack(spacing: 0) {
            Text(model.selectedVersion == nil ? "尚未选择游戏版本" : "尚未安装 Mod")
                .font(PCLTheme.font(19)).foregroundStyle(PCLTheme.accent).padding(.bottom, 9)
            Rectangle().fill(PCLTheme.accent).frame(height: 2)
            Text(model.selectedVersion == nil ? "请先选择一个游戏版本，再安装或管理 Mod。" : "你可以下载新的 Mod，或者从已经下载好的文件安装 Mod。\n如果你已经安装了 Mod，可能是版本隔离设置有误，请在设置中调整版本隔离选项。")
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 10).padding(.top, 10)
            HStack(spacing: 17) {
                Button("下载 Mod") { downloadMods() }
                    .buttonStyle(PCLButtonStyle(highlight: true, height: 35))
                Button("从文件安装 Mod") { model.importModFiles() }
                    .buttonStyle(PCLButtonStyle(height: 35))
                Button("打开 Mod 文件夹") { model.openDirectory(model.gameDirectory?.appendingPathComponent("mods")) }
                    .buttonStyle(PCLButtonStyle(height: 35))
            }
            .padding(.top, 20).padding(.bottom, 5).disabled(!editable)
        }
        .padding(.horizontal, 20).padding(.vertical, 17)
        .background(cardBackground)
        .shadow(color: PCLTheme.text.opacity(0.12), radius: 3, x: 0, y: 1)
    }

    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 5).fill(Color.white.opacity(245 / 255))
    }
    private func downloadMods() { model.resourceKind = "mod"; model.page = .resources }
}

private struct PCLLocalModRow: View {
    let mod: LocalMod
    let editable: Bool
    let toggle: () -> Void
    let trash: () -> Void
    @State private var hovered = false

    var body: some View {
        HStack(spacing: 7) {
            PCLIcon(name: "ItemMod").frame(width: 26, height: 26)
                .frame(width: 34, height: 34)
                .foregroundStyle(mod.enabled ? PCLTheme.accent : PCLTheme.gray)
                .background(PCLTheme.lightest, in: RoundedRectangle(cornerRadius: 6))
            VStack(alignment: .leading, spacing: 1) {
                Text(mod.name).font(PCLTheme.font(14)).lineLimit(1)
                Text(mod.version.isEmpty ? mod.url.lastPathComponent : "\(mod.modID) · \(mod.version)")
                    .font(PCLTheme.font(12)).foregroundStyle(PCLTheme.gray).lineLimit(1)
            }
            .opacity(mod.enabled ? 1 : 0.55)
            Spacer(minLength: 5)
            Button(action: toggle) {
                Image(systemName: mod.enabled ? "minus.circle" : "checkmark.circle").font(.system(size: 17))
            }
            .buttonStyle(.plain).help(mod.enabled ? "禁用 Mod" : "启用 Mod")
            Button(action: trash) {
                Image(systemName: "trash").font(.system(size: 16))
            }
            .buttonStyle(.plain).help("移到废纸篓")
        }
        .padding(.leading, 6).padding(.trailing, 4).frame(height: 44)
        .background(hovered ? PCLTheme.light : Color.clear, in: RoundedRectangle(cornerRadius: 3))
        .onHover { hovered = $0 }
        .disabled(!editable)
    }
}
