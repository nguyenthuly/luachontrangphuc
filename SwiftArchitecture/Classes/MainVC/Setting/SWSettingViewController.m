//
//  SWSettingViewController.m
//  SwiftArchitecture
//
//  Created by Mac on 1/20/15.
//  Copyright (c) 2015 Nguyen Thu Ly. All rights reserved.
//

#import "SWSettingViewController.h"
#import "SWRegisterViewController.h"
#import "SWLoginViewController.h"
#import "SWAboutViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface SWSettingViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageUserImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UISwitch *locationSwitch;


- (IBAction)inforButton:(id)sender;
- (IBAction)userButton:(id)sender;
- (IBAction)inforAppButton:(id)sender;
- (IBAction)logoutButton:(id)sender;

@end

@implementation SWSettingViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[SWUtil appDelegate] hideTabbar:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
    [self initData];
}

- (void)initUI{
    self.title = Setting_Title;
}

- (void)initData{
    
    NSString *firstname = [[NSUserDefaults standardUserDefaults] objectForKey:@"firstname"];
    NSString *lastname = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastname"];
    NSString *email = [[NSUserDefaults standardUserDefaults] objectForKey:@"email"];
    NSString *avatar = [[NSUserDefaults standardUserDefaults] objectForKey:@"avatar"];
    NSString *avatarLink = [NSString stringWithFormat:@"%@%@",URL_IMAGE,avatar];
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@",firstname, lastname];
    self.emailLabel.text = email;
    
    if ([avatar length] > 0) {
        [self.imageUserImageView sd_setImageWithURL:[NSURL URLWithString:avatarLink]];
    } else{
        self.imageUserImageView.image = [UIImage imageNamed:@"user_female.png"];
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

- (IBAction)inforButton:(id)sender {
    
    SWRegisterViewController *inforVC = [[SWRegisterViewController alloc] initWithNibName:@"SWRegisterViewController" bundle:nil];
    inforVC.typeUser = edit_infor;
    [self.navigationController pushViewController:inforVC animated:YES];
}


- (IBAction)userButton:(id)sender {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self chooseFromLibrary];
        //[SWUtil showConfirmAlert:Title_Alert_Validate message:Message_Camera cancelButton:OK_Button otherButton:nil tag:3 delegate:self];
    }else{

        UIActionSheet *addPhotoActionSheet = [[UIActionSheet alloc] initWithTitle:Title_ActionSheet
                                                                     delegate:self
                                                            cancelButtonTitle:Cancel_ActionSheet
                                                       destructiveButtonTitle:nil
                                                            otherButtonTitles:TakePhoto_ActionSheet,PhotoLibrary_ActionSheet,nil];
        [addPhotoActionSheet showInView:self.view];
    }
}

- (IBAction)inforAppButton:(id)sender {
    SWAboutViewController *aboutVC = [[SWAboutViewController alloc] initWithNibName:@"SWAboutViewController" bundle:nil];
    [self.navigationController pushViewController:aboutVC animated:YES];
}

- (IBAction)logoutButton:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate logoutFunction];
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
    self.imageUserImageView.image = chosenImage;
    
    NSURL *refURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    
    // define the block to call when we get the asset based on the url (below)
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *imageAsset)
    {
        ALAssetRepresentation *imageRep = [imageAsset defaultRepresentation];
        NSLog(@"[imageRep filename] : %@", [imageRep filename]);
        
        NSData *imageData = UIImageJPEGRepresentation(chosenImage, 0.5);
        NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, URL_UPLOAD_AVARTAR];
        
        if (imageData) {
            NSDictionary *parameters = @{@"userid": [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]};
            
            AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:url]];
            
            AFHTTPRequestOperation *op = [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                [formData appendPartWithFileData:imageData name:@"avatar" fileName:[imageRep filename] mimeType:@"image/jpeg"];
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [[SWUtil sharedUtil] hideLoadingView];
                
                NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@ ***** %@", operation.responseString, error);
                [SWUtil showConfirmAlert:@"Lỗi!" message:[error localizedDescription] delegate:nil];
                [[SWUtil sharedUtil] hideLoadingView];
            }];
            [op start];
        }
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
@end
