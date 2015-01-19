//
//  UILabel+Ext.h
//  SwiftArchitecture
//
//  Created by luan pham on 7/11/14.
//  Copyright (c) 2014 luan pham. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum VerticalAlignment {
    
    VerticalAlignmentTop,
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;


@interface UILabel (Ext)
{

}
@property (nonatomic, assign)VerticalAlignment verticalAlignment;

@end
