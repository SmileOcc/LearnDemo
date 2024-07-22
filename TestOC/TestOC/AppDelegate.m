//
//  AppDelegate.m
//  TestOC
//
//  Created by odd on 7/13/24.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor yellowColor];
    
    ViewController *ctrl = [[ViewController alloc] init];
    self.window.rootViewController = ctrl;
    [self.window makeKeyWindow];
    return YES;
}



@end
