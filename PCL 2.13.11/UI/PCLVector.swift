import SwiftUI

// Reuses the original WPF/SVG path geometry rather than replacing it with SF Symbols.
nonisolated enum PCLIconData {
    static let values: [String: String] = {
        guard let url = Bundle.main.url(forResource: "PCLIcons", withExtension: "json"), let data = try? Data(contentsOf: url), let values = try? JSONDecoder().decode([String: String].self, from: data) else { return [:] }
        return values
    }()
}
struct PCLIcon: View {
    let name: String
    var stroke = false
    var body: some View {
        let shape = PCLVector(data: PCLIconData.values[name] ?? "")
        if stroke { shape.stroke(style: StrokeStyle(lineWidth: 1.5, lineCap: .round, lineJoin: .round)) }
        else { shape.fill(style: FillStyle(eoFill: false)) }
    }
}
nonisolated struct PCLVector: Shape {
    let data: String
    func path(in rect: CGRect) -> Path {
        let original = SVGGeometry.parse(data)
        let box = original.boundingRect
        guard box.width > 0, box.height > 0 else { return original }
        let scale = min(rect.width / box.width, rect.height / box.height)
        var transform = CGAffineTransform(translationX: rect.midX - box.width * scale / 2, y: rect.midY - box.height * scale / 2)
        transform = transform.scaledBy(x: scale, y: scale).translatedBy(x: -box.minX, y: -box.minY)
        return original.applying(transform)
    }
}

nonisolated enum SVGGeometry {
    static func parse(_ text: String) -> Path {
        let expression = try! NSRegularExpression(pattern: #"[AaCcFfHhLlMmQqSsTtVvZz]|[-+]?(?:\d*\.\d+|\d+\.?\d*)(?:[eE][-+]?\d+)?"#)
        let tokens = expression.matches(in: text, range: NSRange(text.startIndex..., in: text)).compactMap { Range($0.range, in: text).map { String(text[$0]) } }
        var i = 0, command = "", previous = "", current = CGPoint.zero, start = CGPoint.zero, control = CGPoint.zero
        var path = Path()
        func number() -> Double? {
            guard i < tokens.count, let value = Double(tokens[i]) else { return nil }; i += 1; return value
        }
        func point(relative: Bool) -> CGPoint? {
            guard let x = number(), let y = number() else { return nil }
            return CGPoint(x: x + (relative ? current.x : 0), y: y + (relative ? current.y : 0))
        }
        while i < tokens.count {
            if tokens[i].count == 1, tokens[i].first!.isLetter { command = tokens[i]; i += 1 }
            let relative = command == command.lowercased(), kind = command.uppercased(), before = i
            switch kind {
            case "F": _ = number()
            case "Z": path.closeSubpath(); current = start; command = ""
            case "M":
                guard let next = point(relative: relative) else { return path }
                path.move(to: next); current = next; start = next; command = relative ? "l" : "L"
            case "L":
                guard let next = point(relative: relative) else { return path }; path.addLine(to: next); current = next
            case "H":
                guard let x = number() else { return path }; current.x = x + (relative ? current.x : 0); path.addLine(to: current)
            case "V":
                guard let y = number() else { return path }; current.y = y + (relative ? current.y : 0); path.addLine(to: current)
            case "C":
                guard let first = point(relative: relative), let second = point(relative: relative), let next = point(relative: relative) else { return path }
                path.addCurve(to: next, control1: first, control2: second); control = second; current = next
            case "S":
                guard let second = point(relative: relative), let next = point(relative: relative) else { return path }
                let first = previous == "C" || previous == "S" ? CGPoint(x: 2 * current.x - control.x, y: 2 * current.y - control.y) : current
                path.addCurve(to: next, control1: first, control2: second); control = second; current = next
            case "Q":
                guard let first = point(relative: relative), let next = point(relative: relative) else { return path }
                path.addQuadCurve(to: next, control: first); control = first; current = next
            case "T":
                guard let next = point(relative: relative) else { return path }
                let first = previous == "Q" || previous == "T" ? CGPoint(x: 2 * current.x - control.x, y: 2 * current.y - control.y) : current
                path.addQuadCurve(to: next, control: first); control = first; current = next
            case "A":
                guard let rx = number(), let ry = number(), let angle = number(), let large = number(), let sweep = number(), let next = point(relative: relative) else { return path }
                addArc(path: &path, from: current, to: next, rx: rx, ry: ry, rotation: angle, large: large != 0, sweep: sweep != 0); current = next
            default: return path
            }
            previous = kind
            if i == before && kind != "Z" { break }
        }
        return path
    }
    private static func addArc(path: inout Path, from p: CGPoint, to q: CGPoint, rx originalRX: Double, ry originalRY: Double, rotation: Double, large: Bool, sweep: Bool) {
        var rx = abs(originalRX), ry = abs(originalRY)
        guard rx > 0, ry > 0, p != q else { path.addLine(to: q); return }
        let phi = rotation * .pi / 180, cosPhi = cos(phi), sinPhi = sin(phi)
        let dx = (p.x - q.x) / 2, dy = (p.y - q.y) / 2
        let x = cosPhi * dx + sinPhi * dy, y = -sinPhi * dx + cosPhi * dy
        let lambda = x * x / (rx * rx) + y * y / (ry * ry)
        if lambda > 1 { rx *= sqrt(lambda); ry *= sqrt(lambda) }
        let denominator = rx * rx * y * y + ry * ry * x * x
        let factor = (large == sweep ? -1.0 : 1.0) * sqrt(max(0, (rx * rx * ry * ry - denominator) / max(denominator, 1e-20)))
        let cxPrime = factor * rx * y / ry, cyPrime = factor * -ry * x / rx
        let cx = cosPhi * cxPrime - sinPhi * cyPrime + (p.x + q.x) / 2
        let cy = sinPhi * cxPrime + cosPhi * cyPrime + (p.y + q.y) / 2
        let start = atan2((y - cyPrime) / ry, (x - cxPrime) / rx)
        var delta = atan2((-y - cyPrime) / ry, (-x - cxPrime) / rx) - start
        if !sweep && delta > 0 { delta -= 2 * .pi }; if sweep && delta < 0 { delta += 2 * .pi }
        let segments = max(1, Int(ceil(abs(delta) / (.pi / 2))))
        func position(_ angle: Double) -> CGPoint { .init(x: cx + rx * cosPhi * cos(angle) - ry * sinPhi * sin(angle), y: cy + rx * sinPhi * cos(angle) + ry * cosPhi * sin(angle)) }
        func derivative(_ angle: Double) -> CGPoint { .init(x: -rx * cosPhi * sin(angle) - ry * sinPhi * cos(angle), y: -rx * sinPhi * sin(angle) + ry * cosPhi * cos(angle)) }
        for segment in 0..<segments {
            let a = start + delta * Double(segment) / Double(segments), b = start + delta * Double(segment + 1) / Double(segments)
            let factor = 4 / 3 * tan((b - a) / 4), first = position(a), last = position(b), da = derivative(a), db = derivative(b)
            path.addCurve(to: last, control1: CGPoint(x: first.x + factor * da.x, y: first.y + factor * da.y), control2: CGPoint(x: last.x - factor * db.x, y: last.y - factor * db.y))
        }
    }
}
