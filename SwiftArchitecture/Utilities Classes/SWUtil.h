//
//  SWUtil.h
//  SwiftArchitecture
//
//  Created by luan pham on 6/21/14.
//  Copyright (c) 2014 luan pham. All rights reserved.
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
