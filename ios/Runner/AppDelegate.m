#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import "GoogleMaps/GoogleMaps.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GMSServices provideAPIKey:@"AIzaSyClCtU-6hqTDAQ9OsWT708Ixsx80jAhUmk"];
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.

  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
