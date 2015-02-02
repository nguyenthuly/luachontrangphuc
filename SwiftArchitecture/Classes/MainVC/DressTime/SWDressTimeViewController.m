//
//  SWDressTimeViewController.m
//  SwiftArchitecture
//
//  Created by Mac on 1/20/15.
//  Copyright (c) 2015 Nguyen Thu Ly. All rights reserved.
//

#import "SWDressTimeViewController.h"
#import "SWWeatherView.h"
#import "SWWardrobeDetailViewController.h"

@interface SWDressTimeViewController () <UIScrollViewDelegate>{
    SWWeatherView *weatherGrid;
}
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UIView *chooseView;
@property (weak, nonatomic) IBOutlet UIButton *jeanButton;
@property (weak, nonatomic) IBOutlet UIButton *skirtButton;
@property (weak, nonatomic) IBOutlet UIButton *shoeButton;
@property (strong, nonatomic) IBOutlet UIScrollView *weatherScrollView;

- (IBAction)skirtButton:(id)sender;
- (IBAction)jeanButton:(id)sender;
- (IBAction)shoeButton:(id)sender;
- (IBAction)suggestButton:(id)sender;
- (IBAction)chooseAgainButton:(id)sender;
- (IBAction)AcceptButton:(id)sender;

@end

@implementation SWDressTimeViewController {
    NSMutableArray *weatherArr;
    NSMutableArray *timeArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
    [self initData];
    [self initScroll];
}

- (void)initUI{
    self.title = DressTime_Title;
    self.weatherScrollView.delegate = self;
    self.weatherScrollView.hidden = NO;
    
    self.chooseView.hidden = YES;
    self.chooseView.alpha = 0;
}

- (void)initData{
    weatherArr = [[NSMutableArray alloc] initWithArray:@[@22,@23,@32,@21,@12,@13,@15,@16,@17]];
    timeArr = [[NSMutableArray alloc] initWithArray:@[@5,@6,@7,@8,@9,@10,@11,@12,@13]];
    
}

- (void)initScroll {
    
    int xPos = 0;
    for (int i=0; i < [weatherArr count]; i++) {
        SWWeatherView *weatherView = [[SWWeatherView alloc] initWithFrame:CGRectZero];
        weatherView.delegate = self;
        NSString *temperature = [NSString stringWithFormat:@"%@ ºC", [weatherArr objectAtIndex:i]];
        NSString *time = [NSString stringWithFormat:@"%@ PM",[timeArr objectAtIndex:i]];
        weatherView.temperatureLabel.text = temperature;
        weatherView.timeLabel.text = time;
        CGRect frame = [weatherView frame];
        frame.origin.x = xPos;
        xPos += frame.size.width;
        [weatherView setFrame:frame];
        [self.weatherScrollView addSubview:weatherView];
    }
    
    CGSize contentSize = [self.weatherScrollView contentSize];
    contentSize.width = xPos;
    [self.weatherScrollView setContentSize:contentSize];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
}

#pragma mark - WeatherViewDelegate

- (void)didSelect:(id)grid{
    for (UIView *view in [self.weatherScrollView subviews]) {
        if ([view isKindOfClass:[SWWeatherView class]]) {
            SWWeatherView *optionGrid = (SWWeatherView *)view;
            if ([grid isEqual:optionGrid]) {
                [optionGrid setGridSelected:YES];
            } else {
                [optionGrid setGridSelected:NO];
            }
        }
    }
}

#pragma mark - Action

- (IBAction)skirtButton:(id)sender {
    SWWardrobeDetailViewController *wardrobeVC = [[SWWardrobeDetailViewController alloc] initWithNibName:@"SWWardrobeDetailViewController" bundle:nil];
    [self.navigationController pushViewController:wardrobeVC animated:YES];
    
}

- (IBAction)jeanButton:(id)sender {
    SWWardrobeDetailViewController *wardrobeVC = [[SWWardrobeDetailViewController alloc] initWithNibName:@"SWWardrobeDetailViewController" bundle:nil];
    [self.navigationController pushViewController:wardrobeVC animated:YES];
}

- (IBAction)shoeButton:(id)sender {
    SWWardrobeDetailViewController *wardrobeVC = [[SWWardrobeDetailViewController alloc] initWithNibName:@"SWWardrobeDetailViewController" bundle:nil];
    [self.navigationController pushViewController:wardrobeVC animated:YES];
}

- (IBAction)suggestButton:(id)sender {
    if (self.chooseView.hidden) {
        
        self.chooseView.hidden = NO;
        [UIView animateWithDuration:.3 animations:^{
            
            self.chooseView.alpha = 1;
        } completion:^(BOOL finished) {}];
    }
    else {
        
        [UIView animateWithDuration:.3 animations:^{
            
            self.chooseView.alpha = 0;
        } completion:^(BOOL finished) {
            
            self.chooseView.hidden = YES;
        }];
    }

}

- (IBAction)chooseAgainButton:(id)sender {
}

- (IBAction)AcceptButton:(id)sender {
    [UIView animateWithDuration:.3 animations:^{
        
        self.chooseView.alpha = 0;
    } completion:^(BOOL finished) {
        
        self.chooseView.hidden = YES;
    }];
}
@end
