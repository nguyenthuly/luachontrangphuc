//
//  SWAppDelegate.h
//  SwiftArchitecture
//
//  Created by Mac on 1/20/15.
//  Copyright (c) 2015 Nguyen Thu Ly. All rights reserved
//

#import <UIKit/UIKit.h>
#import "SWUtil.h"
#import "SWMultiSelectContactViewController.h"
#import "SWAwesomeTableViewController.h"
#import "SWTabbarController.h"
#import "SWLogViewController.h"

@interface SWAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) SWTabbarController *tabbarController;
@property (nonatomic, strong) SWLogViewController *loginViewController;

- (void)initTabbar;

@end
