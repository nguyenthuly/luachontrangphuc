//
//  SWWardrobeCollectionViewCell.h
//  SwiftArchitecture
//
//  Created by Mac on 1/31/15.
//  Copyright (c) 2015 Nguyen Thu Ly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWWardrobeCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *clotheImageView;
@property (weak, nonatomic) NSString *imageLink;
@property (weak, nonatomic) IBOutlet UIImageView *checkImageView;
@end
