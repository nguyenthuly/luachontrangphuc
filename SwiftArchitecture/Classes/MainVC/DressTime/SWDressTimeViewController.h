//
//  SWDressTimeViewController.h
//  SwiftArchitecture
//
//  Created by Mac on 1/20/15.
//  Copyright (c) 2015 Nguyen Thu Ly. All rights reserved.
//

#import "SWBaseViewController.h"
#import "SWWeatherView.h"

@interface SWDressTimeViewController : SWBaseViewController<UIScrollViewDelegate, SWWeatherViewDelegate>
@property (assign, nonatomic) TypeChooseClothe typeChooseClothe;
@property (strong, nonatomic) NSString *skirtImageLink;
@property (strong, nonatomic) NSString *jeanImageLink;
@property (strong, nonatomic) NSString *shoeImageLink;

@end
