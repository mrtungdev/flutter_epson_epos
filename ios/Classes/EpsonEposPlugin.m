#import "EpsonEposPlugin.h"
#if __has_include(<epson_epos/epson_epos-Swift.h>)
#import <epson_epos/epson_epos-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "epson_epos-Swift.h"
#endif

@implementation EpsonEposPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftEpsonEposPlugin registerWithRegistrar:registrar];
}
@end
