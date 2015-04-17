//
//  SWLogViewController.m
//  SwiftArchitecture
//
//  Created by Mac on 1/20/15.
//  Copyright (c) 2015 Nguyen Thu Ly. All rights reserved.
//

#import "SWLogViewController.h"
#import "SWFeelViewController.h"

@interface SWLogViewController ()
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImageView;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *skirtImageView;
@property (weak, nonatomic) IBOutlet UIImageView *jeanImageView;
@property (weak, nonatomic) IBOutlet UIImageView *shoeImageView;

@property (nonatomic, strong) NSDictionary *logDict;

- (IBAction)feelButtonTapped:(id)sender;

@end

@implementation SWLogViewController{
    NSString *skirtImageLink;
    NSString *jeanImageLink;
    NSString *shoeImageLink;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[SWUtil appDelegate] hideTabbar:YES];
    [self initData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
}

- (void)initUI{
    self.title = Log_Title;
    [self setBackButtonWithImage:Back_Button highlightedImage:nil target:self action:@selector(backButtonTapped:)];
}

- (void)initData{
    
    [[SWUtil sharedUtil] showLoadingView];
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, URL_HISTORYID];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"image/jpeg", nil];
    
    NSDictionary *parameters = @{@"historyid":self.historyId};
    [manager GET:url
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"Log JSON: %@", responseObject);
             if ([responseObject isKindOfClass:[NSArray class]]) {
                 NSMutableArray *logArr = (NSMutableArray *)responseObject;
                 self.logDict = [logArr objectAtIndex:0];
                 [self loadData];
             }
             [[SWUtil sharedUtil] hideLoadingView];
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             NSLog(@"Error: %@", error);
             [[SWUtil sharedUtil] hideLoadingView];
         }];
}

- (void)loadData{

    long long datetime = [[self.logDict objectForKey:@"datetime"] longLongValue];
    skirtImageLink = [NSString stringWithFormat:@"%@%@",URL_IMAGE,[self.logDict objectForKey:@"skirtImage"]];
    jeanImageLink  = [NSString stringWithFormat:@"%@%@",URL_IMAGE,[self.logDict objectForKey:@"jeanImage"]];
    shoeImageLink  = [NSString stringWithFormat:@"%@%@",URL_IMAGE,[self.logDict objectForKey:@"shoeImage"]];
    
    self.dateTimeLabel.text = [SWUtil convert:datetime toDateStringWithFormat:DateTime_Format];
    self.descriptionLabel.text = [self.logDict objectForKey:@"description"];
    self.cityLabel.text = [self.logDict objectForKey:@"city"];
    self.temperatureLabel.text = [NSString stringWithFormat:@"%@°C",[self.logDict objectForKey:@"temperature"]];
    self.weatherImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@",[self.logDict objectForKey:@"weatherImage"],Gray_Weather]];

    NSURL *url = [[NSBundle mainBundle] URLForResource:@"loading" withExtension:@"gif"];
    
    self.jeanImageView.contentMode = UIViewContentModeCenter;
    [self.jeanImageView sd_setImageWithURL:[NSURL URLWithString:jeanImageLink]
                          placeholderImage:[UIImage animatedImageWithAnimatedGIFData:[NSData dataWithContentsOfURL:url]]
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                     
                                     if (image) {
                                         self.jeanImageView.contentMode = UIViewContentModeScaleToFill;
                                     } else {
                                         
                                     }
                                 }];
    
    self.shoeImageView.contentMode = UIViewContentModeCenter;
    [self.shoeImageView sd_setImageWithURL:[NSURL URLWithString:shoeImageLink]
                          placeholderImage:[UIImage animatedImageWithAnimatedGIFData:[NSData dataWithContentsOfURL:url]]
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                     
                                     if (image) {
                                         self.shoeImageView.contentMode = UIViewContentModeScaleToFill;
                                     } else {
                                         
                                     }
                                 }];
    
    if (![skirtImageLink containsString:Ko]) {
        self.skirtImageView.contentMode = UIViewContentModeCenter;
        [self.skirtImageView sd_setImageWithURL:[NSURL URLWithString:skirtImageLink]
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

- (IBAction)feelButtonTapped:(id)sender {
    
    SWFeelViewController *feelVC = [[SWFeelViewController alloc] initWithNibName:@"SWFeelViewController" bundle:nil];
    feelVC.historyId = self.historyId;
    feelVC.skirtImage = skirtImageLink;
    feelVC.jeanImage = jeanImageLink;
    feelVC.shoeImage = shoeImageLink;
    feelVC.logData = self.logDict;
    [self.navigationController pushViewController:feelVC animated:YES];
}
@end
