//
//  SWTabbarItem.h
//  SwiftArchitecture
//
//  Created by luan pham on 6/19/14.
//  Copyright (c) 2014 luan pham. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWTabbarItem : UIControl
{
@private
    /*Hold icon images and colors for text - only using for Part type*/
    UIImageView  *tabNomarl;
    UIImageView *tabSelected;
}

@property (nonatomic,assign) NSInteger tabIndex;

/*Using image contain icon,text for tabbar item*/
- (id)initWithFrame:(CGRect)frame
        nomarlImage:(UIImage *)nomarl
      selectedImage:(UIImage *)hover;

@end
