//
//  Generated file. Do not edit.
//

// clang-format off

#import "GeneratedPluginRegistrant.h"

#if __has_include(<flutter_boost/FlutterBoostPlugin.h>)
#import <flutter_boost/FlutterBoostPlugin.h>
#else
@import flutter_boost;
#endif

#if __has_include(<sd_hybrid_base/SdHybridBasePlugin.h>)
#import <sd_hybrid_base/SdHybridBasePlugin.h>
#else
@import sd_hybrid_base;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [FlutterBoostPlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterBoostPlugin"]];
  [SdHybridBasePlugin registerWithRegistrar:[registry registrarForPlugin:@"SdHybridBasePlugin"]];
}

@end
