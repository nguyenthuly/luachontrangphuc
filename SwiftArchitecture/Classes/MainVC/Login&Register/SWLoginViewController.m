//
//  SWLoginViewController.m
//  SwiftArchitecture
//
//  Created by Mac on 1/20/15.
//  Copyright (c) 2015 Nguyen Thu Ly. All rights reserved.
//


#import <SystemConfiguration/SCNetworkReachability.h>
#import <Security/Security.h>

#import "SWLoginViewController.h"
#import "SWRegisterViewController.h"
#import "SWDressTimeViewController.h"

@interface SWLoginViewController ()
- (IBAction)loginButtonTapped:(id)sender;

- (IBAction)registerButtonTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;
@property (weak, nonatomic) IBOutlet UIView *loginView;

@end

@implementation SWLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
    [self initData];
}

- (void)initUI{
    self.title = Login_Title;

    self.loginView.layer.borderWidth = 1.0;
    self.loginView.layer.borderColor = [[UIColor colorWithHex:Gray_Color alpha:1.0] CGColor];
    self.loginView.layer.masksToBounds = YES;
    self.loginView.layer.cornerRadius = 5.0;
    
    [self.emailTextField resignFirstResponder];
    [self.passWordTextField resignFirstResponder];
}

- (void)initData{
    
}

- (IBAction)loginButtonTapped:(id)sender {
    
    [[SWUtil sharedUtil] showLoadingView];
    
    SCNetworkReachabilityFlags flags;
    SCNetworkReachabilityRef address = SCNetworkReachabilityCreateWithName(NULL, "www.google.com" );
    Boolean success = SCNetworkReachabilityGetFlags(address, &flags);
    CFRelease(address);
    
    bool canReachOnExistingConnection =     success
    && !(flags & kSCNetworkReachabilityFlagsConnectionRequired)
    && (flags & kSCNetworkReachabilityFlagsReachable);
    
    if( canReachOnExistingConnection ) {
        NSLog(@"Network available");
        
        NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, URL_LOGIN];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        
        NSDictionary *parameters = @{@"email": self.emailTextField.text,
                                     @"password": self.passWordTextField.text};
        
        [manager GET:url
          parameters:parameters
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
                 [[SWUtil appDelegate] initTabbar];
                 NSLog(@"LOGIN JSON: %@", responseObject);
                 [[SWUtil sharedUtil] hideLoadingView];
            
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
                NSLog(@"Error: %@", error);
                [SWUtil showConfirmAlert:Title_Alert_Validate message:@"Email hoặc tài khoản chưa đúng" delegate:nil];
                self.emailTextField.text = @"";
                self.passWordTextField.text = @"";
                [[SWUtil sharedUtil] hideLoadingView];
        }];
    } else {
        NSLog(@"Network not available");
        [SWUtil showConfirmAlert:Title_Alert_Validate message:@"Yêu cầu kết nối mạng để đăng nhập" delegate:nil];
        [[SWUtil sharedUtil] hideLoadingView];
    }
    
}

- (IBAction)registerButtonTapped:(id)sender {
    
    SWRegisterViewController *registerVC = [[SWRegisterViewController alloc] initWithNibName:@"SWRegisterViewController" bundle:nil];
    registerVC.typeUser = register_new;
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disableLoginbutton) name:UITextFieldTextDidChangeNotification object:nil];
    
    [self disableLoginbutton];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {

}

- (void)keyboardWillHide:(NSNotification *)notification {

}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self disableLoginbutton];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self disableLoginbutton];
}

- (void)disableLoginbutton {
    if (self.emailTextField.text.length == 0 || self.passWordTextField.text.length == 0) {
        self.loginButton.enabled = NO;
    } else {
        self.loginButton.enabled = YES;
    }
    
    //TODO: remove
    self.loginButton.enabled = YES;
}

@end
