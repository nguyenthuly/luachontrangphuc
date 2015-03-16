//
//  SWWardrobeDetailViewController.h
//  SwiftArchitecture
//
//  Created by Mac on 1/20/15.
//  Copyright (c) 2015 Nguyen Thu Ly. All rights reserved.
//

#import "SWBaseViewController.h"

@interface SWWardrobeDetailViewController : SWBaseViewController<UICollectionViewDataSource, UICollectionViewDelegate>

@property(assign, nonatomic) NSInteger categoryId;
@property(assign, nonatomic) TypeWardrobe typeWardrobe;

@end
