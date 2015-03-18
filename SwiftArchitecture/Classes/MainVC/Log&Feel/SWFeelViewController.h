//
//  SWFeelViewController.h
//  SwiftArchitecture
//
//  Created by Mac on 1/20/15.
//  Copyright (c) 2015 Nguyen Thu Ly. All rights reserved.
//

#import "SWBaseViewController.h"

@interface SWFeelViewController : SWBaseViewController<UITextFieldDelegate>

@property (nonatomic, strong) NSString *historyId;
@property (nonatomic, strong) NSString *skirtImage;
@property (nonatomic, strong) NSString *jeanImage;
@property (nonatomic, strong) NSString *shoeImage;
@property (nonatomic, strong) NSDictionary *logData;

@end
