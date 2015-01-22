//
//  SWAppDelegate.m
//  SwiftArchitecture
//
//  Created by Mac on 1/20/15.
//  Copyright (c) 2015 luan pham. All rights reserved.
//

#import "SWAppDelegate.h"
#import "SWLoginViewController.h"

@implementation SWAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    /*
     * Please don't remove backet {} setup Magical record DB
     */
    
    //Start setup Magical record Model
    NSString *modelName = @"SwiftModel.sqlite";//Replace this name with your model name.
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:modelName];
    [MagicalRecord setupAutoMigratingCoreDataStack];
    //End setup Magical record Model
    
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    UIImage *ios7Bg = [UIImage resizableImage:[UIImage imageNamed:@"nav_ios7"]];
    UIImage *iosBg = [UIImage resizableImage:[UIImage imageNamed:@"navbar_bg"]];
    UIImage *navBg = (SYSTEM_VERSION >= 7)?ios7Bg:iosBg;
    UIFont *font = [UIFont fontHelveticaNeue_Medium:18];
  
    SWLoginViewController *controller = [[SWLoginViewController alloc] init];
    SWNavigationViewController *rootNavigation = [[SWNavigationViewController alloc]initWithRootViewController:controller background:navBg font:font textColor:[UIColor colorWithHex:@"40CCBB" alpha:1.0] shadowColor:[UIColor colorWithHex:@"40CCBB" alpha:1.0]];
    
    self.window.rootViewController = rootNavigation;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
