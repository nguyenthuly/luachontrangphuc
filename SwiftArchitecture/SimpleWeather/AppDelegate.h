//
//  AppDelegate.h
//  SimpleWeather
//
//  Created by Ryan Nystrom on 11/11/13.
//  Copyright (c) 2013 Ryan Nystrom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWUtil.h"
#import "SWMultiSelectContactViewController.h"
#import "SWAwesomeTableViewController.h"
#import "SWTabbarController.h"
#import "SWLogViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) SWTabbarController *tabbarController;
@property (nonatomic, strong) SWLogViewController *loginViewController;

- (void)initTabbar;
- (void)hideTabbar:(BOOL)hide;
- (void)logoutFunction;

@end
