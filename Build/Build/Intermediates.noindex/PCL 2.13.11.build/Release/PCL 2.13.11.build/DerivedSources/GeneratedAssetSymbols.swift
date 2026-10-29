import Foundation
#if canImport(AppKit)
import AppKit
#endif
#if canImport(UIKit)
import UIKit
#endif
#if canImport(SwiftUI)
import SwiftUI
#endif
#if canImport(DeveloperToolsSupport)
import DeveloperToolsSupport
#endif

#if SWIFT_PACKAGE
private let resourceBundle = Foundation.Bundle.module
#else
private class ResourceBundleClass {}
private let resourceBundle = Foundation.Bundle(for: ResourceBundleClass.self)
#endif

// MARK: - Color Symbols -

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension DeveloperToolsSupport.ColorResource {

    /// The "AccentColor" asset catalog color resource.
    static let accent = DeveloperToolsSupport.ColorResource(name: "AccentColor", bundle: resourceBundle)

}

// MARK: - Image Symbols -

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension DeveloperToolsSupport.ImageResource {

    /// The "FabricLoader" asset catalog image resource.
    static let fabricLoader = DeveloperToolsSupport.ImageResource(name: "FabricLoader", bundle: resourceBundle)

    /// The "ForgeLoader" asset catalog image resource.
    static let forgeLoader = DeveloperToolsSupport.ImageResource(name: "ForgeLoader", bundle: resourceBundle)

    /// The "LiteLoader" asset catalog image resource.
    static let liteLoader = DeveloperToolsSupport.ImageResource(name: "LiteLoader", bundle: resourceBundle)

    /// The "MinecraftGrass" asset catalog image resource.
    static let minecraftGrass = DeveloperToolsSupport.ImageResource(name: "MinecraftGrass", bundle: resourceBundle)

    /// The "NeoForgeLoader" asset catalog image resource.
    static let neoForgeLoader = DeveloperToolsSupport.ImageResource(name: "NeoForgeLoader", bundle: resourceBundle)

    /// The "OptiFineLoader" asset catalog image resource.
    static let optiFineLoader = DeveloperToolsSupport.ImageResource(name: "OptiFineLoader", bundle: resourceBundle)

    /// The "SteveSkin" asset catalog image resource.
    static let steveSkin = DeveloperToolsSupport.ImageResource(name: "SteveSkin", bundle: resourceBundle)

}

// MARK: - Color Symbol Extensions -

#if canImport(AppKit)
@available(macOS 14.0, *)
@available(macCatalyst, unavailable)
extension AppKit.NSColor {

    /// The "AccentColor" asset catalog color.
    static var accent: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .accent)
#else
        .init()
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

    /// The "AccentColor" asset catalog color.
    static var accent: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .accent)
#else
        .init()
#endif
    }

}
#endif

#if canImport(SwiftUI)
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.Color {

    /// The "AccentColor" asset catalog color.
    static var accent: SwiftUI.Color { .init(.accent) }

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.ShapeStyle where Self == SwiftUI.Color {

    /// The "AccentColor" asset catalog color.
    static var accent: SwiftUI.Color { .init(.accent) }

}
#endif

// MARK: - Image Symbol Extensions -

#if canImport(AppKit)
@available(macOS 14.0, *)
@available(macCatalyst, unavailable)
extension AppKit.NSImage {

    /// The "FabricLoader" asset catalog image.
    static var fabricLoader: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .fabricLoader)
#else
        .init()
#endif
    }

    /// The "ForgeLoader" asset catalog image.
    static var forgeLoader: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .forgeLoader)
#else
        .init()
#endif
    }

    /// The "LiteLoader" asset catalog image.
    static var liteLoader: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .liteLoader)
#else
        .init()
#endif
    }

    /// The "MinecraftGrass" asset catalog image.
    static var minecraftGrass: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .minecraftGrass)
#else
        .init()
#endif
    }

    /// The "NeoForgeLoader" asset catalog image.
    static var neoForgeLoader: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .neoForgeLoader)
#else
        .init()
#endif
    }

    /// The "OptiFineLoader" asset catalog image.
    static var optiFineLoader: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .optiFineLoader)
#else
        .init()
#endif
    }

    /// The "SteveSkin" asset catalog image.
    static var steveSkin: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .steveSkin)
#else
        .init()
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

    /// The "FabricLoader" asset catalog image.
    static var fabricLoader: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .fabricLoader)
#else
        .init()
#endif
    }

    /// The "ForgeLoader" asset catalog image.
    static var forgeLoader: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .forgeLoader)
#else
        .init()
#endif
    }

    /// The "LiteLoader" asset catalog image.
    static var liteLoader: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .liteLoader)
#else
        .init()
#endif
    }

    /// The "MinecraftGrass" asset catalog image.
    static var minecraftGrass: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .minecraftGrass)
#else
        .init()
#endif
    }

    /// The "NeoForgeLoader" asset catalog image.
    static var neoForgeLoader: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .neoForgeLoader)
#else
        .init()
#endif
    }

    /// The "OptiFineLoader" asset catalog image.
    static var optiFineLoader: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .optiFineLoader)
#else
        .init()
#endif
    }

    /// The "SteveSkin" asset catalog image.
    static var steveSkin: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .steveSkin)
#else
        .init()
#endif
    }

}
#endif

// MARK: - Thinnable Asset Support -

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@available(watchOS, unavailable)
extension DeveloperToolsSupport.ColorResource {

    private init?(thinnableName: Swift.String, bundle: Foundation.Bundle) {
#if canImport(AppKit) && os(macOS)
        if AppKit.NSColor(named: NSColor.Name(thinnableName), bundle: bundle) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#elseif canImport(UIKit) && !os(watchOS)
        if UIKit.UIColor(named: thinnableName, in: bundle, compatibleWith: nil) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}

#if canImport(AppKit)
@available(macOS 14.0, *)
@available(macCatalyst, unavailable)
extension AppKit.NSColor {

    private convenience init?(thinnableResource: DeveloperToolsSupport.ColorResource?) {
#if !targetEnvironment(macCatalyst)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

    private convenience init?(thinnableResource: DeveloperToolsSupport.ColorResource?) {
#if !os(watchOS)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

#if canImport(SwiftUI)
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.Color {

    private init?(thinnableResource: DeveloperToolsSupport.ColorResource?) {
        if let resource = thinnableResource {
            self.init(resource)
        } else {
            return nil
        }
    }

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.ShapeStyle where Self == SwiftUI.Color {

    private init?(thinnableResource: DeveloperToolsSupport.ColorResource?) {
        if let resource = thinnableResource {
            self.init(resource)
        } else {
            return nil
        }
    }

}
#endif

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@available(watchOS, unavailable)
extension DeveloperToolsSupport.ImageResource {

    private init?(thinnableName: Swift.String, bundle: Foundation.Bundle) {
#if canImport(AppKit) && os(macOS)
        if bundle.image(forResource: NSImage.Name(thinnableName)) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#elseif canImport(UIKit) && !os(watchOS)
        if UIKit.UIImage(named: thinnableName, in: bundle, compatibleWith: nil) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}

#if canImport(AppKit)
@available(macOS 14.0, *)
@available(macCatalyst, unavailable)
extension AppKit.NSImage {

    private convenience init?(thinnableResource: DeveloperToolsSupport.ImageResource?) {
#if !targetEnvironment(macCatalyst)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

    private convenience init?(thinnableResource: DeveloperToolsSupport.ImageResource?) {
#if !os(watchOS)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

