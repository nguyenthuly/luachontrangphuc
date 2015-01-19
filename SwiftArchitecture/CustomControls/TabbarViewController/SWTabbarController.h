//
//  SWTabbarController.h
//  SwiftArchitecture
//
//  Created by luan pham on 6/19/14.
//  Copyright (c) 2014 luan pham. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTabbarItem.h"

@interface SWTabbarController : UITabBarController
{

}
@property (nonatomic,assign) NSInteger oldSelectedIndex;
/*This method only chanr state of TabbarItem frome nomarl to selected*/
- (void)hoverAtIndex:(NSInteger)tabIndex;
//set background by color or image for tabbar
@property (nonatomic,strong) UIImageView *backGround;

- (id)initWithNomarlImages:(NSArray *)normalImages
              selectImages:(NSArray *)selectImages
                backGround:(UIColor *)ground;
@end
