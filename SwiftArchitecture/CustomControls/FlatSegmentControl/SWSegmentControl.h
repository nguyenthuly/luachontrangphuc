//
//  SWSegmentControl.h
//  SwiftArchitecture
//
//  Created by luan pham on 7/11/14.
//  Copyright (c) 2014 luan pham. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWSegmentItem.h"
@class SWSegmentControl;

@protocol SWSegmentControlDelegate <NSObject>

@optional

- (void)swSegmentControl:(SWSegmentControl *)swControl clickAtIndex:(NSInteger )index onCurrentIndex:(BOOL)currentIndex;

@end

@interface SWSegmentControl : UIView
{

}
@property (nonatomic,strong) NSMutableArray *cells;
@property (nonatomic,strong) UIImageView *backgroundImageView;
@property (nonatomic,assign) NSInteger selectedIndex;
@property (nonatomic,assign) id<SWSegmentControlDelegate> delegate;

@end
