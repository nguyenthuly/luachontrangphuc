//
//  SWAddClotheViewController.m
//  SwiftArchitecture
//
//  Created by Mac on 1/20/15.
//  Copyright (c) 2015 Nguyen Thu Ly. All rights reserved.
//

#import "SWAddClotheViewController.h"
#import "SWUtil.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "SWWardrobeDetailViewController.h"

@interface SWAddClotheViewController (){
    NSMutableArray *tableViewArr;
    NSString *imageNameStr;
    NSString *colorId;
    NSString *materialId;
}

@property (weak, nonatomic) IBOutlet UILabel *colorLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *materialLabel;

@property (weak, nonatomic) IBOutlet UITableView *addClotheTableView;
@property (weak, nonatomic) IBOutlet UIImageView *colorImageView;
@property (weak, nonatomic) IBOutlet UIImageView *categoryImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sizeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *materialImageView;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *colorButton;
@property (weak, nonatomic) IBOutlet UIButton *categoryButton;
@property (weak, nonatomic) IBOutlet UIButton *sizeButton;
@property (weak, nonatomic) IBOutlet UIButton *materialButton;

@property (nonatomic, strong) NSDictionary *dataDict;

- (IBAction)addButton:(id)sender;
- (IBAction)colorButton:(id)sender;
- (IBAction)categoryButton:(id)sender;
- (IBAction)sizeButton:(id)sender;
- (IBAction)materialButtonTapped:(id)sender;

@end

@implementation SWAddClotheViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[SWUtil appDelegate] hideTabbar:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
}

- (void)initUI{
    
    [self setBackButtonWithImage:Back_Button highlightedImage:nil target:self action:@selector(backButtonTapped:)];
    self.addClotheTableView.hidden = YES;
    self.addClotheTableView.alpha = 0;
    self.nameTextField.textColor = [UIColor colorWithHex:Gray_Color alpha:1.0];
    
    switch (self.typeClothe) {
        case newClothe:
        {
            self.title = AddClothe_Title;
            [self setRightButtonWithImage:Check_Mark highlightedImage:nil target:self action:@selector(checkButtonTapped:)];

            if (self.typeCategory == addClotherDetail) {
                self.categoryImageView.hidden = YES;
                self.categoryLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"category"];
            }
            [self checkSizeLabel];

        }
            break;
        case detailClothe:
        {
            self.title = DetailClothe_Title;
            self.categoryButton.enabled = NO;
            self.sizeButton.enabled = NO;
            self.colorButton.enabled = NO;
            self.materialButton.enabled = NO;
            self.nameTextField.enabled = NO;

            self.addButton.hidden = YES;
            self.colorImageView.hidden = YES;
            self.categoryImageView.hidden = YES;
            self.sizeImageView.hidden = YES;
            self.materialImageView.hidden = YES;
            [self initDataFromServer];
        }
            break;
        default:
            break;
    }
    
    if (self.typeCategory == addClother) {
        self.categoryId = 1;
    }
    
}

- (void)initDataFromServer{
 
    
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, URL_WARDROBE_DETAIL];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSDictionary *parameters = @{@"userid":[NSNumber numberWithInteger:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] integerValue]],
                                 @"wardrobeid":[[NSUserDefaults standardUserDefaults] objectForKey:@"wardrobeid"]
                                 };
    [[SWUtil sharedUtil] showLoadingView];
    [manager GET:url
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
             NSMutableArray *arr = (NSMutableArray *)responseObject;
             self.dataDict = [arr objectAtIndex:0];
             [self loadDetail];
             NSLog(@"WARDROBE DETAIL JSON: %@", responseObject);
             [[SWUtil sharedUtil] hideLoadingView];
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             NSLog(@"Error: %@", error);
             [SWUtil showConfirmAlert:Title_Alert_Validate message:@"Fail" delegate:nil];
             [[SWUtil sharedUtil] hideLoadingView];
         }];

}

- (void)loadDetail{
    
    NSString *imageLink = [NSString stringWithFormat:@"%@%@",URL_IMAGE,[self.dataDict objectForKey:@"image"]];
    self.nameTextField.text = [self.dataDict objectForKey:@"name"];
    self.colorLabel.text    = [self.dataDict objectForKey:@"color"];
    self.categoryLabel.text = [self.dataDict objectForKey:@"category"];
    self.materialLabel.text = [self.dataDict objectForKey:@"material"];
    self.sizeLabel.text     = [self.dataDict objectForKey:@"size"];
    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:imageLink]];
}

- (void)initData{
    
    switch (self.typeTableView) {
        case color:
            tableViewArr = [[NSMutableArray alloc] initWithArray:Color_Arr];
            break;
        case category:
            tableViewArr = [[NSMutableArray alloc] initWithArray:Clothes_Arr];
            break;
        case size:
        {
            if ([self.categoryLabel.text containsString:@"Giày"]) {
                tableViewArr = [[NSMutableArray alloc] initWithArray:Size_Shoes_Arr];

            } else if ([self.categoryLabel.text containsString:@"Quần"]){
                tableViewArr = [[NSMutableArray alloc] initWithArray:Size_Jean_Arr];
            }else {
                tableViewArr = [[NSMutableArray alloc] initWithArray:Size_Clothes_Arr];
            }
        }
            break;
        case material:
        {
            if ([self.categoryLabel.text containsString:@"Giày"]) {
                tableViewArr = [[NSMutableArray alloc] initWithArray:Material_Shoes_Arr];
                
            } else {
                tableViewArr = [[NSMutableArray alloc] initWithArray:Material_Clothes_Arr];
            }

        }
            break;
        default:
            break;
    }
}

- (void)checkSizeLabel{
    if ([self.categoryLabel.text containsString:@"Giày"]) {
        self.sizeLabel.text = @"36";
    }
}

- (void)backButtonTapped:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showPopupWithImageView:(UIImageView *)imageView{
    if (self.addClotheTableView.hidden) {
        
        self.addClotheTableView.hidden = NO;
        imageView.image = [UIImage imageNamed:Up];
        [UIView animateWithDuration:.3 animations:^{
            
            self.addClotheTableView.alpha = 1;
        } completion:^(BOOL finished) {
        }];
    }
    else {
        
        [UIView animateWithDuration:.3 animations:^{
            
            self.addClotheTableView.alpha = 0;
        } completion:^(BOOL finished) {
            imageView.image = [UIImage imageNamed:Down];
            self.addClotheTableView.hidden = YES;
        }];
    }
}

- (void)takePhoto{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)chooseFromLibrary{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma mark - Action

- (void)checkButtonTapped:(id)sender{
    if (self.nameTextField.text.length == 0) {
        [SWUtil showConfirmAlert:Title_Alert_Validate
                         message:Message_Alert_Validate
                    cancelButton:OK_Button
                     otherButton:nil
                             tag:1 delegate:self];
        return;
    }
    if (self.photoImageView.image == nil) {
        [SWUtil showConfirmAlert:Title_Alert_Validate
                         message:Message_Alert_Camera
                    cancelButton:OK_Button
                     otherButton:nil
                             tag:2
                        delegate:self];

    }else{
        
        [[SWUtil sharedUtil] showLoadingView];
        
        NSData *imageData = UIImageJPEGRepresentation(self.photoImageView.image, 0.5);
        NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, URL_ADD_WARDROBE];
        
        colorId = [SWUtil checkColorId:self.colorLabel.text];
        materialId = [SWUtil checkMaterialId:self.materialLabel.text];
        if (imageData) {
            NSDictionary *parameters = @{@"userid": [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],
                                         @"name":self.nameTextField.text,
                                         @"category":self.categoryLabel.text,
                                         @"color":self.colorLabel.text,
                                         @"size":self.sizeLabel.text,
                                         @"material":self.materialLabel.text,
                                         @"categoryid":[NSNumber numberWithInteger:self.categoryId],
                                         @"colorid":colorId,
                                         @"materialid":materialId};
            
            
            AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:url]];
            
            AFHTTPRequestOperation *op = [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                [formData appendPartWithFileData:imageData name:@"image" fileName:imageNameStr mimeType:@"image/jpeg"];
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                switch (self.typeCategory) {
                    case addClother:
                    {
                        SWWardrobeDetailViewController *detailVC = [[SWWardrobeDetailViewController alloc] init];
                        detailVC.categoryId = self.categoryId;
                        [self.navigationController pushViewController:detailVC animated:YES];
                    }
                        
                        break;
                    case addClotherDetail:
                    {
                        NSArray *viewControllers = [self.navigationController viewControllers];
                        for (UIViewController *controller in viewControllers) {
                            if ([controller isKindOfClass:[SWWardrobeDetailViewController class]]) {
                                
                                SWWardrobeDetailViewController *detailVC = (SWWardrobeDetailViewController*)controller;
                                detailVC.categoryId = self.categoryId;
                                [self.navigationController popToViewController:controller animated:YES];
                                break;
                            }
                        }
                    }
                        break;
                    default:
                        break;
                }
                
                
                [[SWUtil sharedUtil] hideLoadingView];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                //[SWUtil showConfirmAlert:@"Lỗi!" message:[error localizedDescription] delegate:nil];
                [[SWUtil sharedUtil] hideLoadingView];
            }];
            [op start];
        }


    }
    
}
- (IBAction)addButton:(id)sender {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//        [SWUtil showConfirmAlert:Title_Alert_Validate
//                         message:Message_Camera
//                    cancelButton:OK_Button
//                     otherButton:nil
//                             tag:3
//                        delegate:self];
        [self chooseFromLibrary];
    }else {
        UIActionSheet *addPhotoActionSheet = [[UIActionSheet alloc] initWithTitle:Title_ActionSheet
                                                                     delegate:self
                                                            cancelButtonTitle:Cancel_ActionSheet
                                                       destructiveButtonTitle:nil
                                                            otherButtonTitles:TakePhoto_ActionSheet,PhotoLibrary_ActionSheet,nil];
        [addPhotoActionSheet showInView:self.view];
    }
}

- (IBAction)colorButton:(id)sender {
    
    UIButton *button = (UIButton*)sender;
    CGRect frame = self.addClotheTableView.frame;
    frame.origin.y = button.frame.origin.y + button.frame.size.height;
    self.addClotheTableView.frame = frame;
    
    self.typeTableView = color;
    [self initData];
    [self.addClotheTableView reloadData];
    [self showPopupWithImageView:self.colorImageView];
}

- (IBAction)categoryButton:(id)sender {
    
    if (self.typeCategory == addClother) {
        UIButton *button = (UIButton*)sender;
        CGRect frame = self.addClotheTableView.frame;
        frame.origin.y = button.frame.origin.y + button.frame.size.height;
        self.addClotheTableView.frame = frame;
        
        self.typeTableView = category;
        [self initData];
        [self.addClotheTableView reloadData];
        [self showPopupWithImageView:self.categoryImageView];
    }
}

- (IBAction)sizeButton:(id)sender {
    
    UIButton *button = (UIButton*)sender;
    CGRect frame = self.addClotheTableView.frame;
    frame.origin.y = button.frame.origin.y + button.frame.size.height;
    self.addClotheTableView.frame = frame;
    
    self.typeTableView = size;
    [self initData];
    [self.addClotheTableView reloadData];
    [self showPopupWithImageView:self.sizeImageView];
}

- (IBAction)materialButtonTapped:(id)sender {
    
    UIButton *button = (UIButton*)sender;
    CGRect frame = self.addClotheTableView.frame;
    frame.origin.y = button.frame.origin.y + button.frame.size.height;
    self.addClotheTableView.frame = frame;
    
    self.typeTableView = material;
    [self initData];
    [self.addClotheTableView reloadData];
    [self showPopupWithImageView:self.materialImageView];
}

#pragma mark - TableView
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [tableViewArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = [NSString stringWithFormat:@"Cell-Index%ld",(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.textColor = [UIColor colorWithHex:Gray_Color alpha:1.0];
    cell.textLabel.text = [tableViewArr objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    switch (self.typeTableView) {
        case color:
            self.colorLabel.text = cell.textLabel.text;
            break;
        case category:
        {
            self.categoryLabel.text = cell.textLabel.text;
            if (self.typeCategory == addClother) {
                self.categoryId = indexPath.row + 1;
            }
        }
            break;
        case size:
            self.sizeLabel.text = cell.textLabel.text;
            break;
        case material:
            self.materialLabel.text =  cell.textLabel.text;
            break;
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - TextField

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [self.addClotheTableView setHidden:YES];
    self.colorImageView.image = [UIImage imageNamed:Down];
    self.categoryImageView.image = [UIImage imageNamed:Down];
    self.sizeImageView.image = [UIImage imageNamed:Down];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {

}

- (void)textFieldDidEndEditing:(UITextField *)textField{
}

#pragma mark - ActionSheet

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self takePhoto];
            break;
        case 1:
            [self chooseFromLibrary];
            break;
        case 2:
            break;
        default:
            break;
    }
}

#pragma mark - UIImagePickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    self.photoImageView.image = chosenImage;
    
    NSURL *refURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    
    // define the block to call when we get the asset based on the url (below)
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *imageAsset)
    {
        ALAssetRepresentation *imageRep = [imageAsset defaultRepresentation];
        NSLog(@"[imageRep filename] : %@", [imageRep filename]);
        imageNameStr = [imageRep filename];
        };
    
    // get the asset library and fetch the asset based on the ref url (pass in block above)
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:refURL
                   resultBlock:resultblock
                  failureBlock:nil];
    
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

#pragma mark - UIAlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 0) {
        if (buttonIndex == 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}


@end
