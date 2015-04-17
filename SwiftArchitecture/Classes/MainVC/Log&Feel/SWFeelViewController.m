//
//  SWFeelViewController.m
//  SwiftArchitecture
//
//  Created by Mac on 1/20/15.
//  Copyright (c) 2015 Nguyen Thu Ly. All rights reserved.
//

#import "SWFeelViewController.h"
#import "SWUtil.h"
#import "StarRatingControl.h"
#import "SWListLogViewController.h"

#define Message_Alert_Feel @"Cảm ơn đánh giá của bạn!"
#define Message_Feel @"Mời bạn nhập cảm nhận về bộ trang phục!"
#define OK_Button @"OK"

@interface SWFeelViewController (){
    StarRatingControl *skirtRating;
    StarRatingControl *jeanRating;
    StarRatingControl *shoeRating;
}
@property (weak, nonatomic) IBOutlet UITextField *feelTextField;
@property (weak, nonatomic) IBOutlet UIImageView *skirtImageView;
@property (weak, nonatomic) IBOutlet UIImageView *jeanImageView;
@property (weak, nonatomic) IBOutlet UIImageView *shoeImageView;
@property (weak, nonatomic) IBOutlet UILabel *skirtLabel;

- (IBAction)sendButtonTapped:(id)sender;

@end

@implementation SWFeelViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
    [self initData];
}

- (void)initUI{
    self.title = Feel_Title;
    [self setBackButtonWithImage:Back_Button highlightedImage:nil target:self action:@selector(backButtonTapped:)];
    
    //Init Rating View
   
    skirtRating = [[StarRatingControl alloc] initWithLocation:CGPointMake(130, 175)
                                                                      emptyColor:[UIColor colorWithHex:Red_Color alpha:1.0]
                                                                      solidColor:[UIColor colorWithHex:Red_Color alpha:1.0]
                                                                   initialRating:[[self.logData objectForKey:@"skirtRate"] integerValue]
                                                                    andMaxRating:5];
    
    jeanRating = [[StarRatingControl alloc] initWithLocation:CGPointMake(130, 223)
                                                                     emptyColor:[UIColor colorWithHex:Red_Color alpha:1.0]
                                                                     solidColor:[UIColor colorWithHex:Red_Color alpha:1.0]
                                                                           initialRating:[[self.logData objectForKey:@"jeanRate"] integerValue]
                                                                            andMaxRating:5];
    shoeRating = [[StarRatingControl alloc] initWithLocation:CGPointMake(130, 271)
                                                                     emptyColor:[UIColor colorWithHex:Red_Color alpha:1.0]
                                                                     solidColor:[UIColor colorWithHex:Red_Color alpha:1.0]
                                                                           initialRating:[[self.logData objectForKey:@"shoeRate"] integerValue]
                                                                            andMaxRating:5];
    [self.view addSubview:skirtRating];
    [self.view addSubview:jeanRating];
    [self.view addSubview:shoeRating];
}

- (void)initData{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"loading" withExtension:@"gif"];
    
    self.jeanImageView.contentMode = UIViewContentModeCenter;
    [self.jeanImageView sd_setImageWithURL:[NSURL URLWithString:self.jeanImage]
                          placeholderImage:[UIImage animatedImageWithAnimatedGIFData:[NSData dataWithContentsOfURL:url]]
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                     
                                     if (image) {
                                         self.jeanImageView.contentMode = UIViewContentModeScaleToFill;
                                     } else {
                                         
                                     }
                                 }];
    
    self.shoeImageView.contentMode = UIViewContentModeCenter;
    [self.shoeImageView sd_setImageWithURL:[NSURL URLWithString:self.shoeImage]
                          placeholderImage:[UIImage animatedImageWithAnimatedGIFData:[NSData dataWithContentsOfURL:url]]
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                     
                                     if (image) {
                                         self.shoeImageView.contentMode = UIViewContentModeScaleToFill;
                                     } else {
                                         
                                     }
                                 }];

    
    self.feelTextField.text = [self.logData objectForKey:@"feel"];
    
    if ([self.skirtImage containsString:Ko]) {
        skirtRating.hidden = YES;
        self.skirtLabel.hidden = YES;
    }else{
        skirtRating.hidden = NO;
        self.skirtLabel.hidden = NO;
        
        self.skirtImageView.contentMode = UIViewContentModeCenter;
        [self.skirtImageView sd_setImageWithURL:[NSURL URLWithString:self.skirtImage]
                               placeholderImage:[UIImage animatedImageWithAnimatedGIFData:[NSData dataWithContentsOfURL:url]]
                                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                          self.skirtImageView.contentMode = UIViewContentModeScaleToFill;
                                          if (image) {
                                          } else {
                                              
                                          }
                                      }];
    }
}

- (void)backButtonTapped:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sendButtonTapped:(id)sender {
    
    if ([self.feelTextField.text length] > 0) {
        [self.view endEditing:YES];
        [[SWUtil sharedUtil] showLoadingView];
        NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, URL_FEEL];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"image/jpeg", nil];
        
        NSDictionary *parameters = @{@"historyid":self.historyId,
                                     @"skirtRate":[NSNumber numberWithInteger:skirtRating.rating],
                                     @"jeanRate":[NSNumber numberWithInteger:jeanRating.rating],
                                     @"shoeRate":[NSNumber numberWithInteger:shoeRating.rating],
                                     @"feel":self.feelTextField.text};
        
        [manager POST:url
           parameters:parameters
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  NSLog(@"Log JSON: %@", responseObject);
                  [SWUtil showConfirmAlert:nil message:Message_Alert_Feel cancelButton:OK_Button otherButton:nil tag:0 delegate:self];
                  [[SWUtil sharedUtil] hideLoadingView];
                  
              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  
                  NSLog(@"Error: %@", error);
                  [[SWUtil sharedUtil] hideLoadingView];
              }];

    } else {
        [SWUtil showConfirmAlert:Title_Alert_Validate message:Message_Feel cancelButton:OK_Button otherButton:nil tag:1 delegate:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[SWUtil appDelegate] hideTabbar:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    
    NSDictionary *keyboardInfo = [notification userInfo];
    CGSize keyboardSize = [[keyboardInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
        [UIView animateWithDuration:.3 animations:^{
            self.view.frame = CGRectMake(0, self.view.frame.origin.y - keyboardSize.height, self.view.bounds.size.width, self.view.bounds.size.height);
        }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary *keyboardInfo = [notification userInfo];
    CGSize keyboardSize = [[keyboardInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
        [UIView animateWithDuration:.3 animations:^{
            self.view.frame = CGRectMake(0, self.view.frame.origin.y + keyboardSize.height, self.view.bounds.size.width, self.view.bounds.size.height);
        }];
}

#pragma mark - TextField

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{

}

#pragma mark - UIAlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 0) {
        
        if (buttonIndex == 0) {
            NSArray *viewControllers = [self.navigationController viewControllers];
            for (UIViewController *controller in viewControllers) {
                if ([controller isKindOfClass:[SWListLogViewController class]]) {
                    [self.navigationController popToViewController:controller animated:YES];
                    break;
                }
            }
        }
    }
}


@end
