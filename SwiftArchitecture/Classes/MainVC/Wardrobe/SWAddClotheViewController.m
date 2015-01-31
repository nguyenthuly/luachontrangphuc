//
//  SWAddClotheViewController.m
//  SwiftArchitecture
//
//  Created by Mac on 1/20/15.
//  Copyright (c) 2015 Nguyen Thu Ly. All rights reserved.
//

#import "SWAddClotheViewController.h"

@interface SWAddClotheViewController ()

@end

@implementation SWAddClotheViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
    [self initData];
}

- (void)initUI{
    self.title = AddClothe_Title;
    [self setBackButtonWithImage:Back_Button highlightedImage:nil target:self action:@selector(backButtonTapped:)];
    [self setRightButtonWithImage:Check_Mark highlightedImage:nil target:self action:@selector(checkButtonTapped:)];
}

- (void)initData{
    
}

- (void)backButtonTapped:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)checkButtonTapped:(id)sender{
}
@end
