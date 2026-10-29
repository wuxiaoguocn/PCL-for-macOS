import AppKit
import Foundation
let output = URL(fileURLWithPath: CommandLine.arguments[1])
try FileManager.default.createDirectory(at: output, withIntermediateDirectories: true)
let sizes = [16, 32, 64, 128, 256, 512, 1024]
for side in sizes {
    let scale = CGFloat(side) / 1024
    let image = NSImage(size: NSSize(width: side, height: side))
    image.lockFocus()
    NSGraphicsContext.current?.imageInterpolation = .high
    let context = NSGraphicsContext.current!.cgContext
    context.scaleBy(x: scale, y: scale)
    NSColor(srgbRed: 0.09, green: 0.35, blue: 0.75, alpha: 1).setFill()
    NSBezierPath(roundedRect: NSRect(x: 20, y: 20, width: 984, height: 984), xRadius: 215, yRadius: 215).fill()
    func polygon(_ points: [CGPoint], _ color: NSColor) {
        let path = NSBezierPath(); path.move(to: points[0]); for point in points.dropFirst() { path.line(to: point) }; path.close(); color.setFill(); path.fill()
    }
    polygon([CGPoint(x: 512,y: 830), CGPoint(x: 755,y: 690), CGPoint(x: 512,y: 550), CGPoint(x: 269,y: 690)], NSColor(srgbRed: 0.41, green: 0.87, blue: 0.73, alpha: 1))
    polygon([CGPoint(x: 269,y: 690), CGPoint(x: 512,y: 550), CGPoint(x: 512,y: 300), CGPoint(x: 269,y: 440)], NSColor(srgbRed: 0.20, green: 0.64, blue: 0.65, alpha: 1))
    polygon([CGPoint(x: 512,y: 550), CGPoint(x: 755,y: 690), CGPoint(x: 755,y: 440), CGPoint(x: 512,y: 300)], NSColor(srgbRed: 0.12, green: 0.48, blue: 0.64, alpha: 1))
    let style = NSMutableParagraphStyle(); style.alignment = .center
    ("PCL" as NSString).draw(in: NSRect(x: 160, y: 120, width: 704, height: 155), withAttributes: [.font: NSFont.systemFont(ofSize: 140, weight: .bold), .foregroundColor: NSColor.white, .paragraphStyle: style])
    image.unlockFocus()
    let bitmap = NSBitmapImageRep(data: image.tiffRepresentation!)!
    try bitmap.representation(using: .png, properties: [:])!.write(to: output.appendingPathComponent("icon-\(side).png"))
}
