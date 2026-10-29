import SwiftUI
import AppKit
import CoreText

// Ported from ModBase.MyColor.FromHSL/FromHSL2 and ModSecret.ThemeRefresh.
enum PCLTheme {
    static func hsl2(_ hue: Double, _ saturation: Double, _ lightness: Double) -> Color {
        let centers = [0.1, -0.06, -0.3, -0.19, -0.15, -0.24, -0.32, -0.09, 0.18, 0.05, -0.12, -0.02, 0.1, -0.06]
        let h = (hue + 3600000).truncatingRemainder(dividingBy: 360), section = h / 30
        let index = Int(floor(section))
        let center = 50 - ((1 - section + Double(index)) * centers[index] + (section - Double(index)) * centers[index + 1]) * saturation
        let l = (lightness < center ? lightness / center : 1 + (lightness - center) / (100 - center)) * 0.5
        let s = saturation / 100
        if s == 0 { return Color(red: l, green: l, blue: l) }
        let high = l < 0.5 ? s * l + l : s * (1 - l) + l, low = 2 * l - high
        func component(_ value: Double) -> Double {
            var v = value; if v < 0 { v += 1 }; if v > 1 { v -= 1 }
            if v < 0.16667 { return low + (high - low) * 6 * v }
            if v < 0.5 { return high }
            if v < 0.66667 { return low + (high - low) * (4 - v * 6) }
            return low
        }
        return Color(red: component(h / 360 + 1 / 3), green: component(h / 360), blue: component(h / 360 - 1 / 3))
    }
    static let text = hsl2(210, 17, 25)
    static let primary = hsl2(210, 85, 45)
    static let accent = hsl2(210, 85, 55)
    static let border = hsl2(210, 85, 80)
    static let light = hsl2(210, 85, 95)
    static let lightest = hsl2(210, 85, 97)
    static let gray = Color(red: 140 / 255, green: 140 / 255, blue: 140 / 255)
    static let topbar = LinearGradient(stops: [.init(color: hsl2(210, 85, 48), location: 0), .init(color: hsl2(210, 85, 54), location: 0.5), .init(color: hsl2(210, 85, 48), location: 1)], startPoint: .leading, endPoint: .trailing)
    static let background = LinearGradient(stops: [.init(color: hsl2(195, 68, 91), location: -0.1), .init(color: hsl2(210, 68, 91), location: 0.4), .init(color: hsl2(225, 68, 91), location: 1.1)], startPoint: UnitPoint(x: 0.9, y: 0), endPoint: UnitPoint(x: 0.1, y: 1))
    static func font(_ size: CGFloat = 13, weight: Font.Weight = .regular) -> Font { .custom("PCL English", size: size).weight(weight) }
    static func registerFont() {
        if let url = Bundle.main.url(forResource: "Font", withExtension: "ttf") { CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil) }
    }
}

struct PCLButtonStyle: ButtonStyle {
    var highlight = false
    var height: CGFloat = 30
    @Environment(\.isEnabled) var enabled
    func makeBody(configuration: Configuration) -> some View {
        PCLButtonBody(configuration: configuration, highlight: highlight, height: height, enabled: enabled)
    }
    private struct PCLButtonBody: View {
        let configuration: ButtonStyle.Configuration
        let highlight: Bool
        let height: CGFloat
        let enabled: Bool
        @State private var hovered = false
        var color: Color { !enabled ? .gray : hovered ? PCLTheme.accent : highlight ? PCLTheme.primary : PCLTheme.text }
        var body: some View {
            configuration.label.font(PCLTheme.font()).foregroundStyle(color).padding(.horizontal, 14).frame(minHeight: height)
                .background(hovered ? PCLTheme.light : Color.white.opacity(0.33), in: RoundedRectangle(cornerRadius: 3))
                .overlay(RoundedRectangle(cornerRadius: 3).stroke(color, lineWidth: 1))
                .scaleEffect(configuration.isPressed ? 0.97 : 1)
                .onHover { hovered = $0 }
                .animation(.easeOut(duration: 0.12), value: hovered)
        }
    }
}
struct PCLTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration.textFieldStyle(.plain).font(PCLTheme.font()).padding(.horizontal, 8).frame(minHeight: 28)
            .background(Color.white.opacity(0.33), in: RoundedRectangle(cornerRadius: 3))
            .overlay(RoundedRectangle(cornerRadius: 3).stroke(PCLTheme.border, lineWidth: 1))
    }
}
struct PCLCheckStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button { configuration.isOn.toggle() } label: {
            HStack(spacing: 8) {
                RoundedRectangle(cornerRadius: 2).stroke(configuration.isOn ? PCLTheme.accent : PCLTheme.text, lineWidth: 1.4).frame(width: 16, height: 16)
                    .overlay { if configuration.isOn { Image(systemName: "checkmark").font(.system(size: 11, weight: .bold)).foregroundStyle(PCLTheme.accent) } }
                configuration.label.font(PCLTheme.font())
            }
        }.buttonStyle(.plain)
    }
}

struct PCLWindowChrome: NSViewRepresentable {
    final class ChromeView: NSView {
        override func viewDidMoveToWindow() {
            super.viewDidMoveToWindow()
            guard let window else { return }
            window.titleVisibility = .hidden; window.titlebarAppearsTransparent = true
            window.styleMask.insert(.fullSizeContentView)
            window.standardWindowButton(.closeButton)?.isHidden = true
            window.standardWindowButton(.miniaturizeButton)?.isHidden = true
            window.standardWindowButton(.zoomButton)?.isHidden = true
            window.isOpaque = false; window.backgroundColor = .clear
            window.isMovableByWindowBackground = false
        }
    }
    func makeNSView(context: Context) -> NSView { ChromeView() }
    func updateNSView(_ view: NSView, context: Context) {}
}
struct PCLDragArea: NSViewRepresentable {
    final class DragView: NSView {
        override var mouseDownCanMoveWindow: Bool { true }
        override func mouseDown(with event: NSEvent) { window?.performDrag(with: event) }
    }
    func makeNSView(context: Context) -> NSView { DragView() }
    func updateNSView(_ view: NSView, context: Context) {}
}
