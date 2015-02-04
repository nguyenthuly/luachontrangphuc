//
//  SWUtil.h
//  SwiftArchitecture
//
//  Created by Mac on 1/20/15.
//  Copyright (c) 2015 Nguyen Thu Ly. All rights reserved.
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
+ (void)showConfirmAlert:(NSString *)title message:(NSString *)message cancelButton:(NSString*)cancel otherButton:(NSString *)other tag: (NSInteger )tag delegate:(id)delegate;
@end
