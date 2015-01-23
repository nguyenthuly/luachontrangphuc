//
//  SWTabbarItem.m
//  SwiftArchitecture
//
//  Created by Mac on 1/20/15.
//  Copyright (c) 2015 Nguyen Thu Ly. All rights reserved.
//

#import "SWTabbarItem.h"

@implementation SWTabbarItem

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame
        nomarlImage:(UIImage *)nomarl
      selectedImage:(UIImage *)hover {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        tabNomarl = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        tabSelected = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        tabNomarl.image = nomarl;
        tabSelected.image = hover;
        
        [self addSubview:tabNomarl];
        [self addSubview:tabSelected];
        [self setSelected:NO];
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    
    if (selected) {
        tabNomarl.hidden = YES;
        tabSelected.hidden = NO;
    }
    else {
        tabNomarl.hidden = NO;
        tabSelected.hidden = YES;
    }
}

@end
