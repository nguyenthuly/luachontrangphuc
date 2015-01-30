//
//  SWWardrobeViewController.m
//  SwiftArchitecture
//
//  Created by Mac on 1/20/15.
//  Copyright (c) 2015 Nguyen Thu Ly. All rights reserved.
//

#import "SWWardrobeViewController.h"

@interface SWWardrobeViewController ()
@property (weak, nonatomic) IBOutlet UITableView *wardrobeTableView;

@end

@implementation SWWardrobeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
    [self initData];
}

- (void)initUI{
    self.title = Wardrobe_Title;
    [self setBackButtonWithImage:Search highlightedImage:nil target:self action:@selector(searchButtonTapped:)];
    [self setRightButtonWithImage:Add highlightedImage:nil target:self action:@selector(addButtonTapped:)];
}

- (void)initData{
    
}

- (void)searchButtonTapped:(id)sender{
    
}

- (void)addButtonTapped:(id)sender{
    
}

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 4;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 3;
            break;
            
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = [NSString stringWithFormat:@"Cell-Index%ld",(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH_PORTRAIT, 40)];
    [view setBackgroundColor:[UIColor colorWithHex:Green_Color alpha:1.0]];
    UILabel *sectionTitle  = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH_PORTRAIT, 25)];
    [view addSubview:sectionTitle];
    sectionTitle.textAlignment = NSTextAlignmentCenter;
    sectionTitle.textColor = [UIColor whiteColor];
    sectionTitle.font = [UIFont fontHelveticaNeue_Medium:15];
    
    switch (section) {
        case 0:
            sectionTitle.text = Skirt;
            break;
        case 1:
            sectionTitle.text = Jeans;
            break;
        case 2:
            sectionTitle.text = Shoe;
            break;
            
        default:
            break;
    }
    return view;
}

@end
