//
//  SWRegisterViewController.m
//  SwiftArchitecture
//
//  Created by Mac on 1/20/15.
//  Copyright (c) 2015 Nguyen Thu Ly. All rights reserved.
//

#import "SWRegisterViewController.h"

#define CONTENT_VIEW_Y 20
#define Register_Arr @[@"Họ",@"Tên",@"Giới tính",@"Ngày sinh",@"Chiều cao",@"Cân nặng",@"Số điện thoại",@"Email",@"Mật khẩu",@"Nhắc lại mật khẩu"]

@interface SWRegisterViewController ()
{
    UIButton *maleButton;
    UIButton *femaleButton;
}
@property (weak, nonatomic) IBOutlet UITableView *registerTableView;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (strong, nonatomic) NSArray *registerArray;
- (IBAction)registerButtonTapped:(id)sender;

@end

@implementation SWRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
    [self initData];
}

- (void)initUI{
    self.title = Register_Title;
    [self setBackButtonWithImage:Back_Button highlightedImage:nil target:self action:@selector(backButtonTapped:)];
}

- (void)initData{
    self.registerArray = Register_Arr;
}

- (void)backButtonTapped:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)registerButtonTapped:(id)sender {
}

- (void)maleButtonTapped:(id)sender{
    [self setButton:femaleButton andBackground:@"EAEAEA" andTitleColor:@"000000"];
    [self setButton:maleButton andBackground:@"40CCBB" andTitleColor:@"FFFFFF"];
}

- (void)femaleButtonTapped:(id)sender{
    [self setButton:maleButton andBackground:@"EAEAEA" andTitleColor:@"000000"];
    [self setButton:femaleButton andBackground:@"40CCBB" andTitleColor:@"FFFFFF"];
}

- (void)setButton:(UIButton *)button andBackground:(NSString *)bg andTitleColor:(NSString *)title{
    [button setTitleColor:[UIColor colorWithHex:title alpha:1.0] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor colorWithHex:bg alpha:1.0]];
}

#pragma mark - TableView
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = [NSString stringWithFormat:@"Cell-Index%ld",(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    switch (indexPath.row) {
        case 0:
        case 1:
        case 4:
        case 5:
        case 6:
        case 7:
        {
            UITextField *registerTextField = [[UITextField alloc] initWithFrame:CGRectMake(50 , 3, 220, 30)];
            registerTextField.tag = indexPath.row;
            [cell addSubview:registerTextField];
            registerTextField.borderStyle = UITextBorderStyleNone;
            registerTextField.textAlignment = NSTextAlignmentRight;
            registerTextField.contentVerticalAlignment = UIControlContentHorizontalAlignmentRight;
            registerTextField.delegate = self;
        }
            break;
        case 2:
        {
            maleButton = [UIButton buttonWithType:UIButtonTypeSystem];
            [maleButton addTarget:self
                           action:@selector(maleButtonTapped:)
             forControlEvents:UIControlEventTouchUpInside];
            [maleButton setTitle:@"Nam" forState:UIControlStateNormal];
            maleButton.layer.masksToBounds = YES;
            maleButton.layer.cornerRadius = 5.0;
            [self setButton:maleButton andBackground:@"EAEAEA" andTitleColor:@"000000"];
            maleButton.frame = CGRectMake(120.0, 6, 80, 30.0);
            [cell addSubview:maleButton];
            
            femaleButton = [UIButton buttonWithType:UIButtonTypeSystem];
            [femaleButton addTarget:self
                           action:@selector(femaleButtonTapped:)
                 forControlEvents:UIControlEventTouchUpInside];
            [femaleButton setTitle:@"Nữ" forState:UIControlStateNormal];
            femaleButton.layer.masksToBounds = YES;
            femaleButton.layer.cornerRadius = 5.0;
            [self setButton:femaleButton andBackground:@"EAEAEA" andTitleColor:@"000000"];
            femaleButton.frame = CGRectMake(210.0, 6, 80, 30.0);
            [cell addSubview:femaleButton];
        }
            break;
        case 3:
            break;
        case 8:
        case 9:
        {
            UITextField *passWordTextField = [[UITextField alloc] initWithFrame:CGRectMake(160 , 3, 130, 30)];
            passWordTextField.tag = indexPath.row;
            [cell addSubview:passWordTextField];
            passWordTextField.borderStyle = UITextBorderStyleNone;
            passWordTextField.contentVerticalAlignment = UIControlContentHorizontalAlignmentRight;
            passWordTextField.textAlignment = NSTextAlignmentRight;
            passWordTextField.secureTextEntry = YES;
            passWordTextField.delegate = self;

        }
            break;
            
        default:
            break;
    }
    cell.textLabel.text = [self.registerArray objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

#pragma mark - TextField

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    self.registerTableView.contentInset =  UIEdgeInsetsMake(0, 0, 0, 0);
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:textField.tag inSection:0];
    self.registerTableView.contentInset =  UIEdgeInsetsMake(0, 0, 250, 0);
    [self.registerTableView scrollToRowAtIndexPath:indexPath
                                                           atScrollPosition:UITableViewScrollPositionTop
                                                                   animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.registerTableView.contentInset =  UIEdgeInsetsMake(0, 0, 0, 0);
}
@end
