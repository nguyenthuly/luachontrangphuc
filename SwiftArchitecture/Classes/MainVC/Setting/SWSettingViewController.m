//
//  SWSettingViewController.m
//  SwiftArchitecture
//
//  Created by Mac on 1/20/15.
//  Copyright (c) 2015 Nguyen Thu Ly. All rights reserved.
//

#import "SWSettingViewController.h"
#import "SWRegisterViewController.h"

@interface SWSettingViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageUserImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UISwitch *locationSwitch;


- (IBAction)inforButton:(id)sender;
- (IBAction)userButton:(id)sender;
- (IBAction)inforAppButton:(id)sender;
- (IBAction)activityAppButton:(id)sender;
- (IBAction)logoutButton:(id)sender;

@end

@implementation SWSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
    [self initData];
}

- (void)initUI{
    self.title = Setting_Title;
}

#pragma mark - Action

- (IBAction)inforButton:(id)sender {
    SWRegisterViewController *inforVC = [[SWRegisterViewController alloc] initWithNibName:@"SWRegisterViewController" bundle:nil];
    inforVC.title = InforUser_Title;
    inforVC.registerTableView.scrollEnabled = NO;
    inforVC.registerTableView.userInteractionEnabled = NO;
    [self.navigationController pushViewController:inforVC animated:YES];
}

- (IBAction)userButton:(id)sender {
}

- (IBAction)inforAppButton:(id)sender {
}

- (IBAction)activityAppButton:(id)sender {
}

- (IBAction)logoutButton:(id)sender {
}
@end
