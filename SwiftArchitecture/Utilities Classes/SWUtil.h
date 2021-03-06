//
//  SWUtil.h
//  SwiftArchitecture
//
//  Created by Mac on 1/20/15.
//  Copyright (c) 2015 Nguyen Thu Ly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@class AppDelegate;
#import "GCDispatch.h"


@interface SWUtil : NSObject
@property (atomic, readwrite) NSInteger loadingViewCount;
@property (strong, nonatomic) MBProgressHUD *progressView;

+ (SWUtil *)sharedUtil;
+ (AppDelegate *)appDelegate;

- (void)showLoadingView;
- (void)showLoadingViewWithTitle:(NSString *)title;
- (void)hideLoadingView;

/*
 * Making univesal Viewcontroller with two .xib UI
 */
+ (UIViewController*)newUniversalViewControllerWithClassName:(NSString*)className;
+ (void)showConfirmAlert:(NSString *)title message:(NSString *)message cancelButton:(NSString*)cancel otherButton:(NSString *)other tag: (NSInteger )tag delegate:(id)delegate;


/**
 *  Convert from NSDate to NSString
 */
+ (NSString*)convertDate:(NSDate*)date toStringFormat:(NSString*)format;

/**
 * Convert from date string to int
 */
+ (NSNumber*)convertFromDateStringToInt:(NSString*)date withDateFormat:(NSString*)format;
/**
 * Convert from date to int
 */
+ (NSNumber *)convertDateToNumber:(NSDate *)date;
/**
 *
 */
+ (NSString*)convert:(long long)dateValue toDateStringWithFormat:(NSString*)format;
/**
 *Get string data from server, used for table view
 */

+ (void)showConfirmAlert:(NSString *)title message:(NSString *)message delegate:(id)delegate;
+ (void)saveUserInfor:(id)responseObject;
+ (NSString *)checkColorId:(NSString *)color;
+ (NSString *)checkMaterialId:(NSString *)material;
+ (NSInteger)checkCategoryId:(NSString *)category;
+ (NSString *)checkSubcategoryid:(NSString *)subcategory;
+ (NSString *)checkCategory:(NSString *)category;
+ (NSString *)chooseColor:(NSString *)colorId andArr:(NSMutableArray *)colorArr;
+ (NSMutableArray *)chooseArr1:(NSMutableArray *)arr1 andArr2:(NSMutableArray *)arr2;
+ (NSInteger)randomWithMin:(NSInteger)min andMax:(NSInteger)max;

@end
