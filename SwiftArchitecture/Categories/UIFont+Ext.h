//
//  UIFont+Ext.h
//  SwiftArchitecture
//
//  Created by luan pham on 7/11/14.
//  Copyright (c) 2014 luan pham. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (Ext)
{
    
}

+ (void)printAllSystemFonts;
+ (UIFont *)fontHelveticaWithSize:(CGFloat)fontSize;
+ (UIFont *)fontHelveticaNeue_Light:(CGFloat)fontSize;
+ (UIFont *)fontHelveticaNeue_UltraLight:(CGFloat)fontSize;
+ (UIFont *)fontHelveticaNeue_Medium:(CGFloat)fontSize;
+ (UIFont *)fontHelveticaBoldObliqueWithSize:(CGFloat)fontSize;
+ (UIFont *)fontHelveticaBoldWithSize:(CGFloat)fontSize;
+ (UIFont *)fontHelveticaObliqueWithSize:(CGFloat)fontSize;

@end
