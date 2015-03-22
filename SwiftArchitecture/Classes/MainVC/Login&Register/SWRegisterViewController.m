//
//  SWRegisterViewController.m
//  SwiftArchitecture
//
//  Created by Mac on 1/20/15.
//  Copyright (c) 2015 Nguyen Thu Ly. All rights reserved.
//

#import "SWRegisterViewController.h"

#define DATE_FORMAT @"dd/MM/yyyy"

#define CONTENT_VIEW_Y 20
#define Register_Arr @[@"Họ",@"Tên",@"Giới tính",@"Ngày sinh",@"Chiều cao",@"Cân nặng",@"Số điện thoại",@"Email",@"Mật khẩu",@"Nhắc lại"]

@interface SWRegisterViewController ()
{
    UIButton *maleButton;
    UIButton *femaleButton;
    UITextField *registerTextField;
    NSString *birthdayString;
    NSString *firstname;
    NSString *lastname;
    NSInteger gender;
    NSNumber *birthday;
    NSString *height;
    NSString *weight;
    NSString *telephone;
    NSString *email;
    NSString *password;
}
@property (strong, nonatomic) NSArray *registerArray;
@property (weak, nonatomic) IBOutlet UITableView *registerTableView;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIView *datePickerView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

- (IBAction)hiddenDatePickerButtonTapped:(id)sender;
- (IBAction)completedDateButtonTapped:(id)sender;
- (IBAction)registerButtonTapped:(id)sender;

@end

@implementation SWRegisterViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[SWUtil appDelegate] hideTabbar:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self.registerTableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
    [self initData];
}

- (void)initUI{
    
    self.datePickerView.hidden = YES;
    self.datePickerView.alpha = 0;
    
    [self setBackButtonWithImage:Back_Button highlightedImage:nil target:self action:@selector(backButtonTapped:)];
    switch (self.typeUser) {
        case register_new:
        {
            self.title = Register_Title;
            [self.registerButton setTitle:Register_Button forState:UIControlStateNormal];
        }
            break;
        case edit_infor:
        {
            self.title = InforUser_Title;
            [self setRightButtonWithImage:Edit highlightedImage:nil target:self action:@selector(editButtonTapped:)];
            self.registerTableView.userInteractionEnabled = NO;
            
            CGRect frame = self.registerTableView.frame;
            frame.size.height = frame.size.height - 132;
            self.registerTableView.frame = frame;
            
            [self.registerButton setTitle:Complete_Button forState:UIControlStateNormal];
            CGRect frameButton = self.registerButton.frame;
            frameButton.origin.y = frameButton.origin.y - 128;
            self.registerButton.frame = frameButton;
          
        }
            break;
        default:
            break;
    }
}

- (void)initData{
    self.registerArray = Register_Arr;
}

- (void)backButtonTapped:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)editButtonTapped:(id)sender{
    self.registerTableView.userInteractionEnabled = YES;
}

- (IBAction)hiddenDatePickerButtonTapped:(id)sender {
    
    [UIView animateWithDuration:.3 animations:^{
        
        self.datePickerView.alpha = 0;
    } completion:^(BOOL finished) {
        
        self.datePickerView.hidden = YES;
    }];
}

- (IBAction)completedDateButtonTapped:(id)sender {
    
    [UIView animateWithDuration:.3 animations:^{
        
        self.datePickerView.alpha = 0;
    } completion:^(BOOL finished) {
        
        self.datePickerView.hidden = YES;
    }];
    
    //CurrentDate
    NSNumber *currentDatetime;
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    currentDatetime = [SWUtil convertDateToNumber:date];
    
    //ChooseDate
    NSString *_dateString;
    NSNumber *dateTimeChoose;
    NSDate *_chosenDate = [self.datePicker date];
    NSDateFormatter *_dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:DATE_FORMAT];
    _dateString = [_dateFormatter stringFromDate:_chosenDate];
    dateTimeChoose = [SWUtil convertDateToNumber:_chosenDate];
    
    if (dateTimeChoose > currentDatetime) {
       
        [SWUtil showConfirmAlert:Title_Alert_Validate message:Check_Datetime delegate:nil];
        
    } else{
        birthdayString = _dateString;
        birthday = [SWUtil convertDateToNumber:_chosenDate];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
        
        [self.registerTableView beginUpdates];
        [self.registerTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self.registerTableView endUpdates];
    }
    
}

- (IBAction)registerButtonTapped:(id)sender {
    
    if (self.typeUser == register_new) {
        
        NSString *errorMessage = [self validateForm];
        if (errorMessage) {
            [[[UIAlertView alloc] initWithTitle:nil message:errorMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
            return;
        }
        
        [[SWUtil sharedUtil] showLoadingView];
        NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, URL_REGISTER];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        NSDictionary *parameters = @{@"firstname"   : firstname,
                                     @"lastname"    : lastname,
                                     @"email"       : email,
                                     @"birthday"    : NULL_IF_NIL(birthday),
                                     @"gender"      : [NSNumber numberWithInteger:gender],
                                     @"height"      : height,
                                     @"weight"      : weight,
                                     @"password"    : password,
                                     @"telephone"   : telephone};
        
        [manager POST:url
           parameters:parameters
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  NSDictionary *dict = (NSDictionary*)responseObject;
                  
                  NSInteger code = [[dict objectForKey:@"code"] integerValue];
                                    
                  NSString *message;
                  switch (code) {
                      case 0:
                          message = Register_message_fail;
                          break;
                      case 1:
                          message = Register_message_success;
                          [self.navigationController popViewControllerAnimated:YES];
                          break;
                      case 2:
                      {
                          message = Email_existed_message;
                      }
                          break;
                      default:
                          break;
                  }
                  
                  [SWUtil showConfirmAlert:Title_Alert_Validate message:message delegate:nil];
                  [[SWUtil sharedUtil] hideLoadingView];
                  
              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  NSLog(@"Error: %@", error);
                  [SWUtil showConfirmAlert:Title_Alert_Validate message:[error localizedDescription] delegate:nil];
                  [[SWUtil sharedUtil] hideLoadingView];
              }];

    }else{
        
        [[SWUtil sharedUtil] showLoadingView];
        NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, URL_UPDATE_USER];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        NSLog(@"Firstname: %@",firstname);
        
        NSDictionary *parameters = @{@"userid"      :[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],
                                     @"firstname"   : firstname,
                                     @"lastname"    : lastname,
                                     @"birthday"    : NULL_IF_NIL(birthday),
                                     @"gender"      : [NSNumber numberWithInteger:gender],
                                     @"height"      : height,
                                     @"weight"      : weight,
                                     @"telephone"   : telephone};
        
        
        [manager POST:url
           parameters:parameters
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  [SWUtil showConfirmAlert:Title_Alert_Validate message:@"Cập nhật thông tin thành công" delegate:nil];
                  [SWUtil saveUserInfor:responseObject];
                  [self.registerTableView reloadData];                  
                  [[SWUtil sharedUtil] hideLoadingView];
                  
              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  NSLog(@"Error: %@", error);
                  [SWUtil showConfirmAlert:Title_Alert_Validate message:@"Cập nhật thông tin không thành công" delegate:nil];
                  [[SWUtil sharedUtil] hideLoadingView];
              }];
    }
    
  
}

- (void)maleButtonTapped:(id)sender{
    [self setButton:femaleButton andBackground:Button_bg andTitleColor:Black_Color];
    [self setButton:maleButton andBackground:Button_bg_Selected andTitleColor:White_Color];
    gender = 0;
}

- (void)femaleButtonTapped:(id)sender{
    [self setButton:maleButton andBackground:Button_bg andTitleColor:Black_Color];
    [self setButton:femaleButton andBackground:Button_bg_Selected andTitleColor:White_Color];
    gender = 1;
}

- (void)setButton:(UIButton *)button andBackground:(NSString *)bg andTitleColor:(NSString *)title{
    [button setTitleColor:[UIColor colorWithHex:title alpha:1.0] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor colorWithHex:bg alpha:1.0]];
}

- (BOOL)isValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (BOOL)isValidTelephoneNumber:(NSString *)phoneNumber{
    NSString *phoneRegex = @"^((\\+)|(0))[0-9]{6,14}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:phoneNumber];
}

- (BOOL)isValidPassword:(NSString *)passWord {
    return (passWord.length >= 5);
}

- (BOOL)isValidName:(NSString *)name {
    
    if (name.length == 0) {
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)isValidNumber:(NSString *)number{
    
    if ([number integerValue] <= 0) {
        return NO;
    } else {
        return YES;
    }
}

- (NSString *)validateForm {
    NSString *errorMessage;
    NSString *passWord;
    
    for (int i = 0; i < 10; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        UITableViewCell *cell = (UITableViewCell*)[self.registerTableView cellForRowAtIndexPath:indexPath];
        
        for (UIView *subview in cell.subviews) {
            if ([subview isKindOfClass:[UITextField class]]) {
                UITextField *tf = (UITextField*)subview;
                NSString *text = tf.text;
                switch (tf.tag) {
                    case First_Name:
                    {
                        if (![self isValidName:text]) {
                            errorMessage = First_Name_Message;
                        }
                    }
                        break;
                    case Last_Name:
                    {
                        if (![self isValidName:text]) {
                            errorMessage = Last_Name_Message;
                        }
                    }
                        break;
                    case Height:
                    {
                        if (![self isValidName:text]) {
                            errorMessage = Height_Message;
                        } else if (![self isValidNumber:text]){
                            errorMessage = Height_Error_Message;
                        }
                    }
                        break;
                    case Weight:
                    {
                        if (![self isValidName:text]) {
                            errorMessage = Weight_Message;
                        } else if (![self isValidNumber:text]){
                            errorMessage = Weight_Error_Message;
                        }
                    }
                        break;
                    case Telephone:
                    {
                        if (![self isValidTelephoneNumber:text]) {
                            errorMessage = Telephone_Message;
                        }
                    }
                        break;
                    case Email:
                    {
                        if (![self isValidEmail:text ]) {
                            errorMessage = Email_Message;
                        }
                    }
                        break;
                    case Password:
                    {
                        passWord = text;
                        if (![self isValidPassword:text]) {
                            errorMessage = Password_Message;
                        }
                    }
                        break;
                    case Re_Password:
                    {
                        if (![text isEqualToString:passWord]) {
                            errorMessage = Re_Password_Message;
                        }
                    }
                        break;
                    default:
                        break;
                }
                break;
            }
            
            if (errorMessage.length > 0) {
                return errorMessage;
            }
        }
    }
    
    
    return errorMessage;
}

#pragma mark - TableView
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.typeUser == register_new) {
        return 10;
    } else {
        return 7;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = [NSString stringWithFormat:@"Cell-Index%ld",(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        registerTextField = [[UITextField alloc] initWithFrame:CGRectMake(100 , 3, 190, 30)];
        [cell addSubview:registerTextField];
        
        registerTextField.borderStyle = UITextBorderStyleNone;
        registerTextField.textAlignment = NSTextAlignmentRight;
        registerTextField.contentVerticalAlignment = UIControlContentHorizontalAlignmentRight;
        registerTextField.delegate = self;
        registerTextField.tag = indexPath.row;
        
        switch (indexPath.row) {
            case First_Name:
                registerTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"firstname"];
                firstname = registerTextField.text;
                break;
            case Last_Name:
                registerTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastname"];
                lastname = registerTextField.text;

                break;
            case Telephone:
                registerTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"telephone"];
                telephone = registerTextField.text;

                break;
            case Email:
                registerTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"email"];
                break;
                
            case Height:
            {
                CGRect frame = registerTextField.frame;
                frame.size.width = 150;
                registerTextField.frame = frame;
                registerTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"height"];
                height = registerTextField.text;

                UILabel *heightLabel = [[UILabel alloc] initWithFrame:CGRectMake(260 , 7, 30, 30)];
                heightLabel.text = @"cm";
                [cell addSubview:heightLabel];
            }
                break;
            case Weight:
            {
                CGRect frame = registerTextField.frame;
                frame.size.width = 150;
                registerTextField.frame = frame;
                registerTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"weight"];
                weight = registerTextField.text;

                UILabel *weightLabel = [[UILabel alloc] initWithFrame:CGRectMake(260 , 7, 30, 30)];
                weightLabel.text = @"kg";
                [cell addSubview:weightLabel];
                
            }
                break;
            case Gender:
            {
                
                registerTextField.enabled = NO;
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
                
                if (self.typeUser == edit_infor) {
                    NSInteger genderN = [[[NSUserDefaults standardUserDefaults] objectForKey:@"gender"] integerValue];
                    if (genderN == 0) {
                        [self setButton:maleButton andBackground:Button_bg_Selected andTitleColor:White_Color];
                    } else{
                        [self setButton:femaleButton andBackground:Button_bg_Selected andTitleColor:White_Color];
                    }
                    gender = genderN;

                }
                
            }
                break;
            
            case Password:
            case Re_Password:
            {
                registerTextField.secureTextEntry = YES;
                
            }
                break;
                
            default:
                break;
        }
        cell.textLabel.text = [self.registerArray objectAtIndex:indexPath.row];
    }

    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == Birthday) {
        registerTextField.enabled = NO;
        long long birthdayNumber =[[[NSUserDefaults standardUserDefaults] objectForKey:@"birthday"] longLongValue];
        UILabel *birthdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 7, 160, 30)];
        
        if (self.typeUser == edit_infor) {
            if (birthdayString == nil) {
                birthdayString = [SWUtil convert:birthdayNumber toDateStringWithFormat:DATE_FORMAT];
            }
        }
        birthdayLabel.text = birthdayString;
        birthdayLabel.textAlignment = NSTextAlignmentRight;
        cell.accessoryView = birthdayLabel;
        
    }
    


    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3) {
        [self.view endEditing:YES];

        if (self.datePickerView.hidden) {
            
            self.datePickerView.hidden = NO;
            [UIView animateWithDuration:.3 animations:^{
                
                self.datePickerView.alpha = 1;
            } completion:^(BOOL finished) {}];
        }
        else {
            
            [UIView animateWithDuration:.3 animations:^{
                
                self.datePickerView.alpha = 0;
            } completion:^(BOOL finished) {
                
                self.datePickerView.hidden = YES;
            }];
        }

    } else{
        [self.view endEditing:YES];
    }
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
    
    switch (textField.tag) {
        case First_Name:
            firstname = textField.text;
            break;
        case Last_Name:
            lastname = textField.text;
            break;
        case Telephone:
            telephone = textField.text;
            break;
        case Email:
            email = textField.text;
            break;
        case Height:
            height = textField.text;
            break;
        case Weight:
            weight = textField.text;
            break;
        case Password:
            password = textField.text;
            break;
        default:
            break;
    }

}

- (void)keyboardWillShow:(NSNotification *)notifi {
    
}

- (void)keyboardWillHide:(NSNotification *)notifi {
    self.registerTableView.contentInset =  UIEdgeInsetsMake(0, 0, 0, 0);
}

@end
