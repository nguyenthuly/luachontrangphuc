//
//  SWSegmentItem.h
//  SwiftArchitecture
//
//  Created by luan pham on 7/11/14.
//  Copyright (c) 2014 luan pham. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWSegmentItem : UIControl
{
    
}

@property (nonatomic,strong)UIImageView *stateNomarl;
@property (nonatomic,strong)UIImageView *stateSelected;

-(id)initWithNormalImage:(UIImage*)anormal selectedImage:(UIImage*)ahover frame:(CGRect)aframe;
-(id)initWithNormalImage:(UIImage *)anormal selectedImage:(UIImage *)ahover startPoint:(CGPoint)apoint;

@end
