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
#import "WXManager.h"

@interface SWDressTimeViewController () <UIScrollViewDelegate>{
    SWWeatherView *weatherGrid;
    NSInteger categorySkirt;
    NSInteger categoryJean;
    NSInteger categoryShoe;
    NSString *subcategoryJean;
    NSString *subcategoryShoe;
    NSString *userId;
    NSInteger datetime;
    NSString *weatherImage;
    NSString *city;
    NSInteger temperature;
    NSString *description;
}

@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImageView;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UIView *chooseView;
@property (weak, nonatomic) IBOutlet UIButton *jeanButton;
@property (weak, nonatomic) IBOutlet UIButton *skirtButton;
@property (weak, nonatomic) IBOutlet UIButton *shoeButton;
@property (weak, nonatomic) IBOutlet UIImageView *skirtImageView;
@property (weak, nonatomic) IBOutlet UIImageView *jeanImageView;
@property (weak, nonatomic) IBOutlet UIImageView *shoeImageView;
@property (strong, nonatomic) IBOutlet UIScrollView *weatherScrollView;

@property (nonatomic, strong) NSDateFormatter *hourlyFormatter;
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) NSMutableArray *resultData;
@property (nonatomic, strong) NSMutableArray *colorData;
@property (nonatomic, strong) NSString *linkImageJean;
@property (nonatomic, strong) NSString *linkImage;

@property (nonatomic, strong) NSString *jeanColor;
@property (nonatomic, strong) NSString *skirtColor;
@property (nonatomic, strong) NSString *shoeColor;

- (IBAction)skirtButton:(id)sender;
- (IBAction)jeanButton:(id)sender;
- (IBAction)shoeButton:(id)sender;
- (IBAction)suggestButton:(id)sender;
- (IBAction)AcceptButton:(id)sender;

@end

@implementation SWDressTimeViewController {
    NSMutableArray *weatherArr;
    NSMutableArray *timeArr;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [[SWUtil appDelegate] hideTabbar:NO];
    [[SWUtil sharedUtil] showLoadingView];
    
    _hourlyFormatter = [[NSDateFormatter alloc] init];
    _hourlyFormatter.dateFormat = @"h a";
    
    [self currentDateTime];
    
    [[RACObserve([WXManager sharedManager], currentCondition)
      deliverOn:RACScheduler.mainThreadScheduler]
     subscribeNext:^(WXCondition *newCondition) {
         float temp = newCondition.temperature.floatValue-273.15;
         if (temp >= 0) {
             self.temperatureLabel.text = [NSString stringWithFormat:@"%.0f°C",newCondition.temperature.floatValue-273.15];
         } else {
             self.temperatureLabel.text = @"";
         }
         
         self.descriptionLabel.text = [newCondition.conditionDescription capitalizedString];
         self.cityLabel.text = [newCondition.locationName capitalizedString];
         NSString *imageStringCurrent = [NSString stringWithFormat:@"%@",[newCondition imageName]];
         self.weatherImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@",imageStringCurrent, Gray_Weather]];
         //if didnot select
         city = self.cityLabel.text;
         weatherImage = imageStringCurrent;
         temperature = [self.temperatureLabel.text integerValue];
         description = self.descriptionLabel.text;
         
     }];
    
    [[RACObserve([WXManager sharedManager], hourlyForecast)
      deliverOn:RACScheduler.mainThreadScheduler]
     subscribeNext:^(NSArray *newForecast) {
         [self initScroll];
         [[SWUtil sharedUtil] hideLoadingView];
     }];
    
    [[WXManager sharedManager] findCurrentLocation];
    
    switch (self.typeChooseClothe) {
        case skirt:
            [self.skirtImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_IMAGE,self.skirtImageLink]]];
            break;
        case jean:
            [self.jeanImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_IMAGE,self.jeanImageLink]]];
            break;
        case shoe:
            [self.shoeImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_IMAGE,self.shoeImageLink]]];
            break;
        default:
            break;
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
    [[SWUtil sharedUtil] showLoadingView];
    
}

- (void)initUI{
    self.title = DressTime_Title;
    self.weatherScrollView.delegate = self;
    self.weatherScrollView.hidden = NO;
    
    self.chooseView.hidden = YES;
    self.chooseView.alpha = 0;
    
    [self currentDateTime];
}

- (void)currentDateTime{
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    self.dateTimeLabel.text = [SWUtil convertDate:date toStringFormat:Date_Format];
    self.currentTimeLabel.text = [SWUtil convertDate:date toStringFormat:Time_Format];
    datetime = [[SWUtil convertDateToNumber:date] integerValue];
}

- (void)initScroll {
    
    for (UIView *subview in self.weatherScrollView.subviews) {
        [subview removeFromSuperview];
    }
    
    int xPos = 0;
    
    for (int i = 0; i < [[WXManager sharedManager].hourlyForecast count]; i++) {
        WXCondition *weather = [WXManager sharedManager].hourlyForecast[i];
        
        SWWeatherView *weatherView = [[SWWeatherView alloc] initWithFrame:CGRectZero];
        weatherView.delegate = self;
        
        NSString *temperatureString = @"";
        float temp = weather.temperature.floatValue - 273.15;
        if (temp >= 0) {
            temperatureString = [NSString stringWithFormat:@"%.0f°",weather.temperature.floatValue - 273.15];
        }
        
        NSString *time = [self.hourlyFormatter stringFromDate:weather.date];
        
        weatherView.city = weather.locationName;
        weatherView.descrip = weather.conditionDescription;
        weatherView.datetime = [[SWUtil convertDateToNumber:weather.date] integerValue];
        weatherView.temperatureLabel.text = temperatureString;
        weatherView.timeLabel.text = time;
        weatherView.imageString = [NSString stringWithFormat:@"%@",[weather imageName]];
        weatherView.weatherImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@",[weather imageName],Gray_Weather]];
        
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

- (void)configureHourlyCell:(UITableViewCell *)cell weather:(WXCondition *)weather {
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
    cell.textLabel.text = [self.hourlyFormatter stringFromDate:weather.date];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.0f°",weather.temperature.floatValue];
    cell.imageView.image = [UIImage imageNamed:[weather imageName]];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
}


#pragma mark - WeatherViewDelegate

- (void)didSelect:(id)grid{
    for (UIView *view in [self.weatherScrollView subviews]) {
        if ([view isKindOfClass:[SWWeatherView class]]) {
            SWWeatherView *optionGrid = (SWWeatherView *)view;
            if ([grid isEqual:optionGrid]) {
                [optionGrid setGridSelected:YES];
                
                //send data
                temperature = [optionGrid.temperatureLabel.text integerValue];
                weatherImage = optionGrid.imageString;
                datetime = optionGrid.datetime;
                description = optionGrid.descrip;
                
            } else {
                [optionGrid setGridSelected:NO];
            }
        }
    }
}

#pragma mark - Action

- (IBAction)skirtButton:(id)sender {
    SWWardrobeDetailViewController *wardrobeVC = [[SWWardrobeDetailViewController alloc] initWithNibName:@"SWWardrobeDetailViewController" bundle:nil];
    wardrobeVC.categoryId = categorySkirt;
    wardrobeVC.typeWardrobe = choose;
    self.typeChooseClothe = skirt;
    [self.navigationController pushViewController:wardrobeVC animated:YES];
    
}

- (IBAction)jeanButton:(id)sender {
    SWWardrobeDetailViewController *wardrobeVC = [[SWWardrobeDetailViewController alloc] initWithNibName:@"SWWardrobeDetailViewController" bundle:nil];
    wardrobeVC.categoryId = categoryJean;
    wardrobeVC.typeWardrobe = choose;
    self.typeChooseClothe = jean;
    [self.navigationController pushViewController:wardrobeVC animated:YES];
}

- (IBAction)shoeButton:(id)sender {
    SWWardrobeDetailViewController *wardrobeVC = [[SWWardrobeDetailViewController alloc] initWithNibName:@"SWWardrobeDetailViewController" bundle:nil];
    wardrobeVC.categoryId = categoryShoe;
    wardrobeVC.typeWardrobe = choose;
    self.typeChooseClothe = shoe;
    [self.navigationController pushViewController:wardrobeVC animated:YES];
}

- (NSInteger)randomWithMin:(NSInteger)min andMax:(NSInteger)max{
    NSInteger random = (arc4random() % (max - min + 1)) + min;
    
    return random;
}

- (NSString *)checkSubCategory:(NSInteger)sub{
    NSString *subCategory;
    switch (sub) {
        case subQuan:
            subCategory = Quan;
            break;
        case subChanvay:
            subCategory = Chanvay;
            break;
        case subGiaycaogot:
            subCategory = Giaycaogot;
            break;
        case subGiaybet:
            subCategory = Giaybet;
            break;
        default:
            subCategory = Ko;
            break;
    }
    return subCategory;
}

- (void)chooseWork {
    
    //Rat lanh
    if (temperature < 12) {
        categoryJean = Quan_Chanvay;
        categorySkirt = Aokhoac;
        categoryShoe = Giaybot;
        subcategoryJean = Quan;
        subcategoryShoe = Ko;
    
    //Lanh
    } else if (temperature < 15) {
        categoryJean = Quan_Chanvay;
        categorySkirt = [self randomWithMin:Aokhoac andMax:Aolen];
        categoryShoe = [self randomWithMin:Giayhai andMax:Giaybot];
        subcategoryJean = Quan;
        
        if (categoryShoe == Giayhai) {
            subcategoryShoe = [self checkSubCategory:[self randomWithMin:subGiaycaogot andMax:subGiaybet]];
        } else{
            subcategoryShoe = Ko;
        }
        
    //Se lanh
    } else if (temperature < 20){
        categoryJean = Quan_Chanvay;
        categoryShoe = Giayhai;
        categorySkirt = Aolen;
        
        NSInteger subJean = [self randomWithMin:subQuan andMax:subChanvay];
        subcategoryJean = [self checkSubCategory:subJean];
        if (subJean == subChanvay) {
            subcategoryShoe = Giaycaogot;
        } else{
            subcategoryShoe = [self checkSubCategory:[self randomWithMin:subGiaycaogot andMax:subGiaybet]];
        }
    
    //Khong lanh
    } else{
        categoryJean = [self randomWithMin:Quan_Chanvay andMax:Vay];
        categoryShoe = Giayhai;
        
        if (categoryJean == Vay) {
            categorySkirt = 0;
            self.skirtImageView.image = [UIImage imageNamed:@"Ko"];
            self.skirtButton.enabled = NO;
            subcategoryJean = Ko;
            subcategoryShoe = Giaycaogot;
            
        }else {
            categorySkirt = Aosomi;
            self.skirtButton.enabled = YES;
            NSInteger subJean = [self randomWithMin:subQuan andMax:subChanvay];
            subcategoryJean = [self checkSubCategory:subJean];
            
            if (subJean == subChanvay) {
                subcategoryShoe = Giaycaogot;
            } else{
                subcategoryShoe = [self checkSubCategory:[self randomWithMin:subGiaycaogot andMax:subGiaybet]];
            }
        }
    }
    
    [self chooseClothesWithCategoryId:categoryJean andSubcategoryJean:subcategoryJean];
}

- (void)chooseGoout{
    
    //Rat lanh
    if (temperature < 12) {
        categoryJean = Quan_Chanvay;
        categorySkirt = Aokhoac;
        categoryShoe = Giaybot;
        subcategoryJean = Quan;
        subcategoryShoe = Ko;
        
        //Lanh
    } else if (temperature < 15) {
        categoryJean = Quan_Chanvay;
        categorySkirt = [self randomWithMin:Aokhoac andMax:Aolen];
        categoryShoe = [self randomWithMin:Giaythethao andMax:Giaybot];
        subcategoryJean = Quan;
        
        if (categoryShoe == Giayhai) {
            subcategoryShoe = Giaybet;
        } else{
            subcategoryShoe = Ko;
        }
        
        
        //Se lanh
    } else if (temperature < 20){
        categoryJean = Quan_Chanvay;
        categoryShoe = [self randomWithMin:Giaythethao andMax:Giayhai];
        categorySkirt = Aolen;
        subcategoryJean = Quan;
        
        if (categoryShoe == Giayhai) {
            subcategoryShoe = Giaybet;
        } else{
            subcategoryShoe = Ko;
        }
        
        //Khong lanh
    } else{
        categoryJean = Quan_Chanvay;
        categorySkirt = Aophong;
        categoryShoe = [self randomWithMin:Giaythethao andMax:Giayhai];
        NSInteger subJean = [self randomWithMin:subQuan andMax:subChanvay];
        subcategoryJean = [self checkSubCategory:subJean];
        
        if (categoryShoe == Giayhai) {
            if (subJean == subChanvay) {
                subcategoryShoe = Giaycaogot;
            } else{
                subcategoryShoe = Giaybet;
            }
        } else{
            subcategoryShoe = Ko;
        }
           
    }
    
    [self chooseClothesWithCategoryId:categoryJean andSubcategoryJean:subcategoryJean];
}

- (void)chooseParty{
    
    //Rat lanh
    if (temperature < 12) {
        categoryJean = Quan_Chanvay;
        categorySkirt = Aokhoac;
        categoryShoe = Giaybot;
        subcategoryJean = Quan;
        subcategoryShoe = Ko;
        
        //Lanh
    } else if (temperature < 15) {
        categoryJean = Quan_Chanvay;
        categorySkirt = [self randomWithMin:Aokhoac andMax:Aolen];
        categoryShoe = [self randomWithMin:Giayhai andMax:Giaybot];
        
        if (categorySkirt == Aokhoac) {
            subcategoryJean = Quan;
        } else{
            subcategoryJean = Chanvay;
        }
        
        if (categoryShoe == Giayhai) {
            subcategoryShoe = Giaycaogot;
        } else{
            subcategoryShoe = Ko;
        }
        
        //Se lanh
    } else if (temperature < 20){
        categoryJean = Quan_Chanvay;
        categoryShoe = Giayhai;
        categorySkirt = Aolen;
        subcategoryJean = Chanvay;
        subcategoryShoe = Giaycaogot;
        
        //Khong lanh
    } else{
        categoryJean = Vay;
        categoryShoe = Giayhai;
        categorySkirt = 0;
        self.skirtImageView.image = [UIImage imageNamed:@"Ko"];
        self.skirtButton.enabled = NO;
        subcategoryJean = Ko;
        subcategoryShoe = Giaycaogot;
    }
    
    [self chooseClothesWithCategoryId:categoryJean andSubcategoryJean:subcategoryJean];
}

- (void)chooseClothesWithCategoryId:(NSInteger)categoryId andSubcategoryJean:(NSString *)subCategoryJean{
    
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, URL_SUGGEST_BY_CATEGORYID];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSDictionary *parameters = @{@"userid":[NSNumber numberWithInteger:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] integerValue]],
                                 @"categoryid":[NSNumber numberWithInteger:categoryId],
                                 @"subcategoryid":subCategoryJean
                                 };
    [manager GET:url
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if ([responseObject isKindOfClass:[NSArray class]]) {
                 self.data = (NSMutableArray *)responseObject;
                 NSLog(@"Data: %@",responseObject);
             }
             
             NSInteger randNum = [self randomWithMin:0 andMax:self.data.count - 1];
             self.linkImageJean = [[self.data objectAtIndex:randNum] objectForKey:@"image"];
             self.jeanImageLink = self.linkImageJean;
             [self.jeanImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_IMAGE,self.jeanImageLink]]];
             self.jeanColor = [[self.data objectAtIndex:randNum] objectForKey:@"colorid"];
             
             for (int i = 1; i < 3; i++) {
                TypeChooseClothe type = i;
                switch (type) {
                    case skirt:
                    {
                        if (categorySkirt != 0) {
                            [self chooseColor:categorySkirt withCategory:skirt andColor:self.jeanColor andSubcategory:Ko];
                        }
                    }
                        break;
                    case shoe:
                        [self chooseColor:categoryShoe withCategory:shoe andColor:self.jeanColor andSubcategory:subcategoryShoe];
                        break;
                    default:
                        break;
                }
            }

         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             [SWUtil showConfirmAlert:Title_Alert_Validate message:@"Fail" delegate:nil];
             [[SWUtil sharedUtil] hideLoadingView];
         }];
    
}


- (void)chooseColor:(NSInteger)categoryId withCategory:(TypeChooseClothe)type andColor:(NSString *)color andSubcategory:(NSString *)subcategory{
    
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, URL_CHOOSE_COLOR_BY_CATEGORY];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSDictionary *parameters = @{@"userid":[NSNumber numberWithInteger:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] integerValue]],
                                 @"categoryid":[NSNumber numberWithInteger:categoryId],
                                 @"subcategoryid":subcategory
                                 };
    [manager GET:url
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if ([responseObject isKindOfClass:[NSArray class]]) {
                 self.colorData = (NSMutableArray *)responseObject;
                 NSLog(@"Color: %@",responseObject);
             }
             NSString * colorChoose = [SWUtil chooseColor:color andArr:self.colorData];
             switch (type) {
                 case skirt:
                     [self chooseClothesWithCategoryId:categorySkirt colorId:colorChoose withType:skirt andSubcategory:Ko];
                     break;
                 case shoe:
                     [self chooseClothesWithCategoryId:categoryShoe colorId:colorChoose withType:shoe andSubcategory:subcategoryShoe];
                     break;
                 default:
                     break;
             }
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             [SWUtil showConfirmAlert:Title_Alert_Validate message:@"Fail" delegate:nil];
             [[SWUtil sharedUtil] hideLoadingView];
         }];
    
}


- (void)chooseClothesWithCategoryId:(NSInteger)categoryId colorId:(NSString *)colorid withType:(TypeChooseClothe)type andSubcategory:(NSString *)subcategory{
    
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, URL_SUGGEST_BY_CATEGORYID_COLORID];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSDictionary *parameters = @{@"userid":[NSNumber numberWithInteger:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] integerValue]],
                                 @"categoryid":[NSNumber numberWithInteger:categoryId],
                                 @"colorid":colorid,
                                 @"subcategoryid":subcategory
                                 };
    [manager GET:url
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if ([responseObject isKindOfClass:[NSArray class]]) {
                 self.resultData = (NSMutableArray *)responseObject;
                 NSLog(@"ResultData: %@",responseObject);
             }
             
             NSInteger randNum = [self randomWithMin:0 andMax:self.resultData.count - 1];
             
             self.linkImage = [[self.resultData objectAtIndex:randNum] objectForKey:@"image"];
             
             switch (type) {
                 case skirt:
                 {
                     if (categorySkirt != 0) {
                         self.skirtImageLink = self.linkImage;
                         [self.skirtImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_IMAGE,self.skirtImageLink]]];
                     }
                 }
                     break;
                     
                 case shoe:
                 {
                     self.shoeImageLink = self.linkImage;
                     [self.shoeImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_IMAGE,self.shoeImageLink]]];
                     
                 }
                     break;
                 default:
                     break;
             }
             
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             [SWUtil showConfirmAlert:Title_Alert_Validate message:@"Fail" delegate:nil];
             [[SWUtil sharedUtil] hideLoadingView];
         }];
    
}

- (IBAction)suggestButton:(id)sender {
    
    self.skirtImageLink = @"Ko";
    
    UIActionSheet *addPhotoActionSheet = [[UIActionSheet alloc] initWithTitle:@"Chọn trang phục theo sự kiện"
                                                                     delegate:self
                                                            cancelButtonTitle:Cancel_ActionSheet
                                                       destructiveButtonTitle:nil
                                                            otherButtonTitles:@"Trang phục đi làm/đi học",@"Trang phục đi chơi thoải mái",@"Trang phục dự tiệc",nil];
    [addPhotoActionSheet showInView:self.view];
    
}

- (void)showView{
    
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

- (IBAction)AcceptButton:(id)sender {
    
    [UIView animateWithDuration:.3 animations:^{
        
        self.chooseView.alpha = 0;
    } completion:^(BOOL finished) {
        
        self.chooseView.hidden = YES;
    }];
    
    //insert to History
    userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, URL_HISTORY];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSDictionary *parameters = @{@"userid"      :userId,
                                 @"datetime"    :[NSNumber numberWithInteger:datetime],
                                 @"weatherImage":weatherImage,
                                 @"city"        :city,
                                 @"temperature" :[NSNumber numberWithInteger:temperature],
                                 @"description" :description,
                                 @"skirtImage"  :self.skirtImageLink,
                                 @"jeanImage"   :self.jeanImageLink,
                                 @"shoeImage"   :self.shoeImageLink};
    
    
    [manager POST:url
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"Insert success");
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              
          }];

}


#pragma mark - ActionSheet

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
        {
            [self chooseWork];
            [self showView];
            break;
        }
        case 1:
        {
            [self chooseGoout];
            [self showView];
        }
            break;
        case 2:
        {
            [self chooseParty];
            [self showView];
        }
            break;
        case 3:
            break;
        default:
            break;
    }
}

@end
