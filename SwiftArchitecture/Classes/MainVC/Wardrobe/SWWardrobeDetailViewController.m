//
//  SWWardrobeDetailViewController.m
//  SwiftArchitecture
//
//  Created by Mac on 1/20/15.
//  Copyright (c) 2015 Nguyen Thu Ly. All rights reserved.
//

#import "SWWardrobeDetailViewController.h"
#import "SWAddClotheViewController.h"
#import "LXReorderableCollectionViewFlowLayout.h"
#import "SWWardrobeCollectionViewCell.h"
#import "SWDressTimeViewController.h"

@interface SWWardrobeDetailViewController ()
@property(nonatomic, strong) IBOutlet UICollectionView *wardrobeCollectionView;
@property (weak, nonatomic) IBOutlet UIView *contentWardrobeView;
@property (nonatomic, strong) NSMutableArray *data;
@property (weak, nonatomic) IBOutlet UILabel *noClotheLabel;

@end

@implementation SWWardrobeDetailViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[SWUtil appDelegate] hideTabbar:YES];
    //[[SWUtil sharedUtil] showLoadingView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
    [self initData];
}

- (void)initUI{
    [self setBackButtonWithImage:Back_Button highlightedImage:nil target:self action:@selector(backButtonTapped:)];
    [self setRightButtonWithImage:Add highlightedImage:nil target:self action:@selector(addButtonTapped:)];
    
    //Make machine collection
    LXReorderableCollectionViewFlowLayout *layout = [[LXReorderableCollectionViewFlowLayout alloc] init];
    [layout setMinimumLineSpacing:0];
    [layout setMinimumInteritemSpacing:0];
    layout.itemSize = CGSizeMake(70,90);
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    self.wardrobeCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH_PORTRAIT,self.contentWardrobeView.bounds.size.height ) collectionViewLayout:layout];
    self.wardrobeCollectionView.delegate = self;
    self.wardrobeCollectionView.dataSource = self;
    [self.wardrobeCollectionView setBackgroundColor:[UIColor colorWithHex:@"D3F2ED" alpha:1.0]];
    
    [self.wardrobeCollectionView registerClass:[SWWardrobeCollectionViewCell class] forCellWithReuseIdentifier:Cell];
    [self.wardrobeCollectionView registerNib:[UINib nibWithNibName:@"SWWardrobeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:Cell];
    
    [self.contentWardrobeView addSubview:self.wardrobeCollectionView];
    self.noClotheLabel.hidden = YES;
}

- (void)initData{
    
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, URL_WARDROBE_CATEGORY];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSDictionary *parameters = @{@"userid":[NSNumber numberWithInteger:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] integerValue]],
                                 @"categoryid":[NSNumber numberWithInteger:self.categoryId]
                                 };
    [[SWUtil sharedUtil] showLoadingView];
    [manager GET:url
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             if ([responseObject isKindOfClass:[NSArray class]]) {
                 self.data = (NSMutableArray *)responseObject;
             }
             
             NSDictionary *dict;
             if ([responseObject isKindOfClass:[NSDictionary class]]) {
                 dict = (NSDictionary *)responseObject;
             }
             
             NSInteger code = [[dict objectForKey:@"code"] integerValue];
             
             if (code == 0 && self.data.count == 0) {
                 self.noClotheLabel.hidden = NO;
                 
             } else {
                 self.noClotheLabel.hidden = YES;
                 [self.wardrobeCollectionView reloadData];
                 self.title = [[self.data objectAtIndex:0] objectForKey:@"category"];
                 NSLog(@"WARDROBE JSON: %@", responseObject);
             }
             [[SWUtil sharedUtil] hideLoadingView];
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             [SWUtil showConfirmAlert:Title_Alert_Validate message:@"Fail" delegate:nil];
             [[SWUtil sharedUtil] hideLoadingView];
         }];
    
}

- (void)backButtonTapped:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)addButtonTapped:(id)sender{
    SWAddClotheViewController *addClothesVC = [[SWAddClotheViewController alloc]
                                               initWithNibName:@"SWAddClotheViewController"
                                               bundle:nil];
    
    addClothesVC.typeCategory = addClotherDetail;
    addClothesVC.typeClothe = newClothe;
    [self.navigationController pushViewController:addClothesVC animated:YES];
}

#pragma mark - CollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.data count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *reuseIdentifier = Cell;
    SWWardrobeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    NSString *imageLink = [NSString stringWithFormat:@"%@%@",URL_IMAGE,[[self.data objectAtIndex:indexPath.row] objectForKey:@"image"]];
    cell.imageLink = [[self.data objectAtIndex:indexPath.row] objectForKey:@"image"];
    [cell.clotheImageView sd_setImageWithURL:[NSURL URLWithString:imageLink]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size = CGSizeMake(70,90);
    
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (self.typeWardrobe) {
        case detail:
        {
            SWAddClotheViewController *detailVC = [[SWAddClotheViewController alloc] init];
            NSString *wardrobeId = [[self.data objectAtIndex:indexPath.row] objectForKey:@"wardrobeid"];
            [[NSUserDefaults standardUserDefaults] setObject:wardrobeId forKey:@"wardrobeid"];
            detailVC.typeClothe = detailClothe;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
            break;
        case choose:
        {
            SWWardrobeCollectionViewCell *cell = (SWWardrobeCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
            NSArray *viewControllers = [self.navigationController viewControllers];
            for (UIViewController *controller in viewControllers) {
                if ([controller isKindOfClass:[SWDressTimeViewController class]]) {
                    SWDressTimeViewController *dressTimeVC = (SWDressTimeViewController *)controller;
                    switch (dressTimeVC.typeChooseClothe) {
                        case skirt:
                            dressTimeVC.skirtImageLink = cell.imageLink;
                            break;
                        case jean:
                            dressTimeVC.jeanImageLink = cell.imageLink;
                            break;
                        case shoe:
                            dressTimeVC.shoeImageLink = cell.imageLink;
                            break;
                        default:
                            break;
                    }
                    [self.navigationController popToViewController:controller animated:YES];
                    break;
                }
            }
            
        }
            
        default:
            break;
    }
  
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

@end
