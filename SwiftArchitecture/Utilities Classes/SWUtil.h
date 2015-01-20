//
//  SWUtil.h
//  SwiftArchitecture
//
//  Created by Mac on 1/20/15.
//  Copyright (c) 2015 luan pham. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SWAppDelegate;
#import "GCDispatch.h"

@interface SWUtil : NSObject

+ (SWUtil *)sharedUtil;
+ (SWAppDelegate *)appDelegate;

/*
 * Making univesal Viewcontroller with two .xib UI
 */
+ (UIViewController*)newUniversalViewControllerWithClassName:(NSString*)className;

@end
