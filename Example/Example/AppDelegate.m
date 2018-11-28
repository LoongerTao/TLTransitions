//
//  AppDelegate.m
//  https://github.com/LoongerTao/TLTransitions
//
//  Created by 故乡的云 on 2018/10/29.
//  Copyright © 2018 故乡的云. All rights reserved.
//

#import "AppDelegate.h"
#import "TLMenuViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    TLMenuViewController *vc = [TLMenuViewController new];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
//    nav.navigationBar.translucent = NO;
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    return YES;
}


@end
