#import "AdvancedCalculationPlugin.h"
#if __has_include(<advanced_calculation/advanced_calculation-Swift.h>)
#import <advanced_calculation/advanced_calculation-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "advanced_calculation-Swift.h"
#endif

@implementation AdvancedCalculationPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAdvancedCalculationPlugin registerWithRegistrar:registrar];
}
@end
