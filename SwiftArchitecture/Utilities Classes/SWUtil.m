//
//  SWUtil.m
//  SwiftArchitecture
//
//  Created by Mac on 1/20/15.
//  Copyright (c) 2015 Nguyen Thu Ly. All rights reserved.
//

#import "SWUtil.h"

#define do_Color @"do"
#define hong_Color @"hong"
#define vang_Color @"vang"
#define xanh_Color @"xanh"
#define trang_Color @"trang"
#define den_Color @"den"
#define nau_Color @"nau"
#define ghi_Color @"ghi"
#define xam_Color @"xam"

@implementation SWUtil

+ (SWUtil *)sharedUtil {
    
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] init];
    });
}

- (void)dealloc {
    
}

+ (AppDelegate *)appDelegate {
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return appDelegate;
}

#pragma mark Loading View
- (MBProgressHUD *)progressView
{
    if (!_progressView) {
        _progressView = [[MBProgressHUD alloc] initWithView:[SWUtil appDelegate].window];
        if (IS_IPAD()) {
            _progressView.minSize = CGSizeMake(200.0f, 200.0f);
        }
        
        _progressView.animationType = MBProgressHUDAnimationFade;
        _progressView.dimBackground = NO;
        [[SWUtil appDelegate].window addSubview:_progressView];
    }
    return _progressView;
}

- (void)showLoadingView {
    [self showLoadingViewWithTitle:@""];
}

- (void)showLoadingViewWithTitle:(NSString *)title {
    self.progressView.labelText = title;
    if (self.loadingViewCount == 0) {
        [[SWUtil appDelegate].window bringSubviewToFront:self.progressView];
        [self.progressView show:NO];
    }
    self.loadingViewCount++;
}

- (void)hideLoadingView {
    if (self.loadingViewCount > 0) {
        if (self.loadingViewCount == 1) {
            [self.progressView hide:NO];
        }
        self.loadingViewCount--;
    }
}

+ (UIViewController*)newUniversalViewControllerWithClassName:(NSString*)className {
   
    if ([className length] > 0) {
        // Nib name from className
        Class c = NSClassFromString(className);
        NSString *nibName = @"";
        
        if (IS_IPAD()) {
            
            nibName = [NSString stringWithFormat:@"%@-iPad", className];
        }
        else if (IS_IPHONE_5) {
        
            nibName = [NSString stringWithFormat:@"%@-568h", className];
        }
        else {
            
            nibName = [NSString stringWithFormat:@"%@", className];

        }
        
        if([[NSBundle mainBundle] pathForResource:nibName ofType:@"nib"] != nil) {
            //file found
            return [[c alloc] initWithNibName:nibName bundle:nil];
            
        } else {
            
            return [[UIViewController alloc] init];
        }
    }
    return nil;
}

+ (void)showConfirmAlert:(NSString *)title message:(NSString *)message cancelButton:(NSString*)cancel otherButton:(NSString *)other tag: (NSInteger )tag delegate:(id)delegate {
    
    UIAlertView *alrt = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancel otherButtonTitles:other, nil];
    alrt.tag = tag;
    [alrt show];
}

+ (NSString*)convertDate:(NSDate*)date toStringFormat:(NSString*)format
{
    NSString *_dateString;
    NSDateFormatter *_dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:format];
    _dateString = [_dateFormatter stringFromDate:date];
    return _dateString;
}

+ (NSNumber*)convertFromDateStringToInt:(NSString *)date withDateFormat:(NSString*)format{
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:format];
    [objDateformat setTimeZone:[NSTimeZone systemTimeZone]];
    NSDate *objUTCDate = [objDateformat dateFromString:date];
    return [self convertDateToNumber:objUTCDate];
}

+ (NSNumber *)convertDateToNumber:(NSDate *)date {
    long long milliseconds = (long long)([date timeIntervalSince1970]);
    return [NSNumber numberWithLongLong:milliseconds];
}

+ (NSString*)convert:(long long)dateValue toDateStringWithFormat:(NSString*)format {
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:format];
    [objDateformat setTimeZone:[NSTimeZone systemTimeZone]];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:dateValue];
    NSString *stringFromDate = [objDateformat stringFromDate:date];
    
    return stringFromDate;
}

+ (void)showConfirmAlert:(NSString *)title message:(NSString *)message delegate:(id)delegate {
    
    UIAlertView *alrt = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:@"Đóng" otherButtonTitles: nil];
    [alrt show];
}

+ (void)saveUserInfor:(id)responseObject{
    
    NSString *email = [[responseObject objectAtIndex:0] objectForKey:@"email"];
    NSString *firstname = [[responseObject objectAtIndex:0] objectForKey:@"firstname"];
    NSString *lastname = [[responseObject objectAtIndex:0] objectForKey:@"lastname"];
    NSString *avatar = [[responseObject objectAtIndex:0] objectForKey:@"avatar"];
    long long birthday = [[[responseObject objectAtIndex:0] objectForKey:@"birthday"] longLongValue];
    NSInteger gender = [[[responseObject objectAtIndex:0] objectForKey:@"gender"] integerValue];
    NSString *height = [[responseObject objectAtIndex:0] objectForKey:@"height"];
    NSString *weight = [[responseObject objectAtIndex:0] objectForKey:@"weight"];
    NSString *userid = [[responseObject objectAtIndex:0] objectForKey:@"userid"];
    NSString *telephone = [[responseObject objectAtIndex:0] objectForKey:@"telephone"];
    
    [[NSUserDefaults standardUserDefaults] setObject:email forKey:@"email"];
    [[NSUserDefaults standardUserDefaults] setObject:firstname forKey:@"firstname"];
    [[NSUserDefaults standardUserDefaults] setObject:lastname forKey:@"lastname"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithLongLong:birthday] forKey:@"birthday"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:gender] forKey:@"gender"];
    [[NSUserDefaults standardUserDefaults] setObject:height forKey:@"height"];
    [[NSUserDefaults standardUserDefaults] setObject:weight forKey:@"weight"];
    [[NSUserDefaults standardUserDefaults] setObject:userid forKey:@"userid"];
    [[NSUserDefaults standardUserDefaults] setObject:telephone forKey:@"telephone"];
    
    if (([avatar length ]> 0)) {
        [[NSUserDefaults standardUserDefaults] setObject:avatar forKey:@"avatar"];
    }

}

+ (NSString *)checkColorId:(NSString *)color{
    NSString *colorId;
    
    if (([color isEqualToString:@"Đỏ"]) || ([color isEqualToString:@"Cam"])) {
        colorId = @"do";
    }
    
    if ([color isEqualToString:@"Hồng"]) {
        colorId = @"hong";
    }
    
    if ([color isEqualToString:@"Vàng"]) {
        colorId = @"vang";
    }
    
    if (([color isEqualToString:@"Trắng"]) || ([color isEqualToString:@"Kem"])) {
        colorId = @"kem";
    }
    
    if ([color isEqualToString:@"Đen"]) {
        colorId = @"den";
    }
    
    if ([color isEqualToString:@"Xám"]) {
        colorId = @"xam";
    }
    
    if ([color isEqualToString:@"Nâu"]) {
        colorId = @"nau";
    }
    
    if ([color isEqualToString:@"Xanh"]) {
        colorId = @"xanh";
    }
    
    if (([color isEqualToString:@"Ghi"]) || ([color isEqualToString:@"Bạc"])) {
        colorId = @"ghi";
    }
    
    return colorId;
    
}
+ (NSString *)checkMaterialId:(NSString *)material;
{
    NSString *materialId;
    if ([material isEqualToString:@"Vải"]) {
        materialId = @"vai";
    }
    if ([material isEqualToString:@"Bò"]) {
        materialId = @"bo";
    }
    if ([material isEqualToString:@"Da"]) {
        materialId = @"da";
    }
    if ([material isEqualToString:@"Cotton"]) {
        materialId = @"cotton";
    }
    if ([material isEqualToString:@"Len"]) {
        materialId = @"len";
    }
    return materialId;
}

+ (NSInteger)randomWithMin:(NSInteger)min andMax:(NSInteger)max{
    NSInteger random = (arc4random() % (max - min + 1)) + min;
    
    return random;
}


+ (NSMutableArray *)chooseArr1:(NSMutableArray *)arr1 andArr2:(NSMutableArray *)arr2{
    
    NSMutableArray *commonMutableArr = [[NSMutableArray alloc]  initWithCapacity:10];
    
    for (int i = 0; i < arr1.count; i ++) {
        for (int j = 0; j < arr2.count; j ++) {
            if ([[arr1 objectAtIndex:i] containsObject:[arr2 objectAtIndex:j]]) {
                [commonMutableArr addObject:[arr1 objectAtIndex:i]];
            }
        }
    }
    
    return commonMutableArr;
}

+ (NSString *)chooseColor:(NSString *)colorId andArr:(NSMutableArray *)colorArr{
    NSString *color;
    NSMutableArray *listColor;
    NSMutableArray *commonMutableArr = [[NSMutableArray alloc]  initWithCapacity:10];
    
        //Do
        if ([colorId isEqualToString:do_Color]) {
            listColor = [[NSMutableArray alloc] initWithArray:@[vang_Color,xanh_Color,trang_Color,den_Color,ghi_Color,xam_Color]];
            commonMutableArr = [self chooseArr1:colorArr andArr2:listColor];
        }
            
        //Hong
        if ([colorId isEqualToString:hong_Color]) {
            listColor = [[NSMutableArray alloc] initWithArray:@[vang_Color,xanh_Color,trang_Color,den_Color,ghi_Color,xam_Color]];
            commonMutableArr = [self chooseArr1:colorArr andArr2:listColor];
        }
            
        //Vang
            if ([colorId isEqualToString:vang_Color]) {
                listColor = [[NSMutableArray alloc] initWithArray:@[do_Color,hong_Color,xanh_Color,trang_Color,den_Color,ghi_Color,xam_Color,nau_Color]];
                commonMutableArr = [self chooseArr1:colorArr andArr2:listColor];
            }
            
            //Xanh
            if ([colorId isEqualToString:xanh_Color]) {
                listColor = [[NSMutableArray alloc] initWithArray:@[do_Color,hong_Color,vang_Color,xanh_Color,trang_Color,den_Color,ghi_Color,xam_Color,nau_Color]];

                commonMutableArr = [self chooseArr1:colorArr andArr2:listColor];
            }
            
            //Trang
            if ([colorId isEqualToString:trang_Color]) {
                listColor = [[NSMutableArray alloc] initWithArray:@[do_Color,hong_Color,vang_Color,xanh_Color,trang_Color,den_Color,ghi_Color,xam_Color,nau_Color]];
                commonMutableArr = [self chooseArr1:colorArr andArr2:listColor];
            }
            
            //Den
            if ([colorId isEqualToString:den_Color]) {
                listColor = [[NSMutableArray alloc] initWithArray:@[do_Color,hong_Color,vang_Color,xanh_Color,trang_Color,den_Color,ghi_Color,xam_Color]];

                commonMutableArr = [self chooseArr1:colorArr andArr2:listColor];
            }
            
            //Xam
            if ([colorId isEqualToString:do_Color]) {
                listColor = [[NSMutableArray alloc] initWithArray:@[do_Color,hong_Color,vang_Color,xanh_Color,trang_Color,den_Color,ghi_Color,xam_Color]];
                commonMutableArr = [self chooseArr1:colorArr andArr2:listColor];
            }
            
            //Nau
            if ([colorId isEqualToString:nau_Color]) {
                listColor = [[NSMutableArray alloc] initWithArray:@[do_Color,hong_Color,vang_Color,xanh_Color,trang_Color,den_Color,ghi_Color,xam_Color]];
                commonMutableArr = [self chooseArr1:colorArr andArr2:listColor];
            }
            
            //Ghi
            if ([colorId isEqualToString:ghi_Color]) {
                listColor = [[NSMutableArray alloc] initWithArray:@[do_Color,hong_Color,vang_Color,xanh_Color,trang_Color,den_Color,ghi_Color]];
                commonMutableArr = [self chooseArr1:colorArr andArr2:listColor];
            }
   
    NSInteger random = [self randomWithMin:0 andMax:commonMutableArr.count - 1];
    color = [[commonMutableArr objectAtIndex:random] objectForKey:@"colorid"];
    
    return color;
}


@end
