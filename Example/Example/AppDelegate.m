//
//  AppDelegate.m
//  https://github.com/LoongerTao/TLTransitions
//
//  Created by 故乡的云 on 2018/10/29.
//  Copyright © 2018 故乡的云. All rights reserved.
//

#import "AppDelegate.h"
#import "TLPopoverMenuController.h"
#import "TLModalMenuController.h"
#import "TLNavTransitionMenuController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    TLPopoverMenuController *popoverVC = [TLPopoverMenuController new];
    UINavigationController *popoverNav = [[UINavigationController alloc] initWithRootViewController:popoverVC];
    popoverNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"popover"
                                                image:[UIImage imageNamed:@"popover_normal"]
                                        selectedImage:[UIImage imageNamed:@"popover_selected"]];
    popoverVC.navigationItem.title = @"popover";
    
    TLModalMenuController *modalVC = [TLModalMenuController new];
    UINavigationController *modalNav = [[UINavigationController alloc] initWithRootViewController:modalVC];
    modalNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"modal-transition"
                                                          image:[UIImage imageNamed:@"modal_nomal"]
                                                  selectedImage:[UIImage imageNamed:@"modal_selected"]];
    modalVC.navigationItem.title = @"modal-transition";
    
    TLNavTransitionMenuController *navVC = [TLNavTransitionMenuController new];
    UINavigationController *navNav = [[UINavigationController alloc] initWithRootViewController:navVC];
    navNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"nav-transition"
                                                          image:[UIImage imageNamed:@"nav_t_normal"]
                                                  selectedImage:[UIImage imageNamed:@"nav_t_selected"]];
    navVC.navigationItem.title = @"nav-transition";
                                                                               
    UITabBarController *tabbarController = [[UITabBarController alloc] init];
    [tabbarController setViewControllers:@[popoverNav,modalNav,navNav]];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = tabbarController;
    [self.window makeKeyAndVisible];
    return YES;
}


@end
