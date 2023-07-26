#import "SdHybridBasePlugin.h"
#if __has_include(<sd_hybrid_base/sd_hybrid_base-Swift.h>)
#import <sd_hybrid_base/sd_hybrid_base-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "sd_hybrid_base-Swift.h"
#endif

@implementation SdHybridBasePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftSdHybridBasePlugin registerWithRegistrar:registrar];
}
@end
