//
//  SWDressTimeViewController.m
//  SwiftArchitecture
//
//  Created by Mac on 1/20/15.
//  Copyright (c) 2015 Nguyen Thu Ly. All rights reserved.
//

#import "SWDressTimeViewController.h"
#import "SWWeatherView.h"

@interface SWDressTimeViewController () <UIScrollViewDelegate>
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
//    self.weatherScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 231, 400,128)];
//    SWWeatherView *weatherView = [[SWWeatherView alloc] init];
//    [self.weatherScrollView addSubview:weatherView];
//    [weatherView setBackgroundColor:[UIColor greenColor]];
//    [self.weatherScrollView setBackgroundColor:[UIColor redColor]];
    //[self.view addSubview:self.weatherScrollView];
    self.weatherScrollView.delegate = self;
    self.weatherScrollView.hidden = NO;
    
    self.chooseView.hidden = YES;
    self.chooseView.alpha = 0;
}

- (void)initData{
    weatherArr = [[NSMutableArray alloc] initWithArray:@[@22,@23,@32,@21,@12,@13,@15,@16,@17]];
}

- (void)initScroll {
    int xPos = 0;
    
    for (int i=0; i < [weatherArr count]; i++) {
        SWWeatherView *weatherView = [[SWWeatherView alloc] initWithFrame:CGRectZero];
        weatherView.backgroundColor = [UIColor blueColor];
        NSString *temperature = [NSString stringWithFormat:@"%@ ºC", [weatherArr objectAtIndex:i]];
        weatherView.temperatureLabel.text = temperature;
        CGRect frame = [weatherView frame];
        frame.origin.x = xPos;
        xPos += frame.size.width;
        [weatherView setFrame:frame];
        [self.weatherScrollView addSubview:weatherView];
        
        NSLog(@"F:%@ - %d", NSStringFromCGRect(weatherView.frame), xPos);
    }
    
    CGSize contentSize = [self.weatherScrollView contentSize];
    contentSize.width = xPos;
    [self.weatherScrollView setContentSize:contentSize];
    NSLog(@"F:%@", NSStringFromCGRect(self.weatherScrollView.frame));
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
}

#pragma mark - Action

- (IBAction)skirtButton:(id)sender {
}

- (IBAction)jeanButton:(id)sender {
}

- (IBAction)shoeButton:(id)sender {
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
