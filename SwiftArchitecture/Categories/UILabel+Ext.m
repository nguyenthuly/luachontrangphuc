//
//  UILabel+Ext.m
//  SwiftArchitecture
//
//  Created by Mac on 1/20/15.
//  Copyright (c) 2015 Nguyen Thu Ly. All rights reserved
//

#import "UILabel+Ext.h"

@implementation UILabel (Ext)
@dynamic verticalAlignment;

- (void)setVerticalAlignment:(VerticalAlignment)verticalAlignment {
    
    verticalAlignment = verticalAlignment;
    
    switch (verticalAlignment) {
        case VerticalAlignmentTop:
        {
            CGRect rect = [self textRectForBounds:self.bounds limitedToNumberOfLines:999];
            
            CGRect newRect = self.frame;
            newRect.size.height = rect.size.height;
            
            self.frame = newRect;
        }
            break;
        case VerticalAlignmentMiddle:
        {
            CGRect rect = [self textRectForBounds:self.bounds limitedToNumberOfLines:999];
            
            CGRect newRect = self.frame;
            newRect.size.height = rect.size.height;
            newRect.origin.y = self.bounds.origin.y + (self.bounds.size.height - rect.size.height) / 2.0;
            
            self.frame = newRect;
        }
            break;
        case VerticalAlignmentBottom:
        {
            CGRect rect = [self textRectForBounds:self.bounds limitedToNumberOfLines:999];
            
            CGRect newRect = self.frame;
            newRect.size.height = rect.size.height;
            newRect.origin.y = self.bounds.origin.y + self.bounds.size.height - rect.size.height;
            
            self.frame = newRect;
        }
            break;
            
        default:
            break;
    }
    
    [self setNeedsDisplay];
}

@end
