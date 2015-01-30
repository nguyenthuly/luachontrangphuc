//
//  SWDressTimeViewController.m
//  SwiftArchitecture
//
//  Created by Mac on 1/20/15.
//  Copyright (c) 2015 Nguyen Thu Ly. All rights reserved.
//

#import "SWDressTimeViewController.h"
#import "SWWeatherView.h"

@interface SWDressTimeViewController ()
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

@implementation SWDressTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
    [self initData];
}

- (void)initUI{
    self.title = DressTime_Title;
    self.weatherScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 231, 400,128)];
    SWWeatherView *weatherView = [[SWWeatherView alloc] init];
    [self.weatherScrollView addSubview:weatherView];
    [weatherView setBackgroundColor:[UIColor greenColor]];
    [self.weatherScrollView setBackgroundColor:[UIColor redColor]];
    //[self.view addSubview:self.weatherScrollView];
    
    self.chooseView.hidden = YES;
    self.chooseView.alpha = 0;
}

- (void)initData{
    
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
