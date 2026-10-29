#import <Foundation/Foundation.h>

#if __has_attribute(swift_private)
#define AC_SWIFT_PRIVATE __attribute__((swift_private))
#else
#define AC_SWIFT_PRIVATE
#endif

/// The resource bundle ID.
static NSString * const ACBundleID AC_SWIFT_PRIVATE = @"com.wuxiaoguo.PCL-2-13-11";

/// The "AccentColor" asset catalog color resource.
static NSString * const ACColorNameAccentColor AC_SWIFT_PRIVATE = @"AccentColor";

/// The "FabricLoader" asset catalog image resource.
static NSString * const ACImageNameFabricLoader AC_SWIFT_PRIVATE = @"FabricLoader";

/// The "ForgeLoader" asset catalog image resource.
static NSString * const ACImageNameForgeLoader AC_SWIFT_PRIVATE = @"ForgeLoader";

/// The "LiteLoader" asset catalog image resource.
static NSString * const ACImageNameLiteLoader AC_SWIFT_PRIVATE = @"LiteLoader";

/// The "MinecraftGrass" asset catalog image resource.
static NSString * const ACImageNameMinecraftGrass AC_SWIFT_PRIVATE = @"MinecraftGrass";

/// The "NeoForgeLoader" asset catalog image resource.
static NSString * const ACImageNameNeoForgeLoader AC_SWIFT_PRIVATE = @"NeoForgeLoader";

/// The "OptiFineLoader" asset catalog image resource.
static NSString * const ACImageNameOptiFineLoader AC_SWIFT_PRIVATE = @"OptiFineLoader";

/// The "SteveSkin" asset catalog image resource.
static NSString * const ACImageNameSteveSkin AC_SWIFT_PRIVATE = @"SteveSkin";

#undef AC_SWIFT_PRIVATE
