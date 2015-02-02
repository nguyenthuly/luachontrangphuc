//
//  SWAddClotheViewController.m
//  SwiftArchitecture
//
//  Created by Mac on 1/20/15.
//  Copyright (c) 2015 Nguyen Thu Ly. All rights reserved.
//

#import "SWAddClotheViewController.h"

@interface SWAddClotheViewController (){
    NSMutableArray *tableViewArr;
}
@property (weak, nonatomic) IBOutlet UILabel *colorLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UITableView *addClotheTableView;
@property (weak, nonatomic) IBOutlet UIImageView *colorImageView;
@property (weak, nonatomic) IBOutlet UIImageView *categoryImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sizeImageView;

- (IBAction)addButton:(id)sender;
- (IBAction)colorButton:(id)sender;
- (IBAction)categoryButton:(id)sender;
- (IBAction)sizeButton:(id)sender;

@end

@implementation SWAddClotheViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
    //[self initData];
}

- (void)initUI{
    self.title = AddClothe_Title;
    [self setBackButtonWithImage:Back_Button highlightedImage:nil target:self action:@selector(backButtonTapped:)];
    [self setRightButtonWithImage:Check_Mark highlightedImage:nil target:self action:@selector(checkButtonTapped:)];
    self.addClotheTableView.hidden = YES;
    self.addClotheTableView.alpha = 0;
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
            tableViewArr = [[NSMutableArray alloc] initWithArray:Size_Clothes_Arr];
            break;
        default:
            break;
    }
}

- (void)backButtonTapped:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Action

- (void)checkButtonTapped:(id)sender{
}
- (IBAction)addButton:(id)sender {
}

- (IBAction)colorButton:(id)sender {
    UIButton *button = (UIButton*)sender;
    CGRect frame = self.addClotheTableView.frame;
    frame.origin.y = button.frame.origin.y + button.frame.size.height;
    self.addClotheTableView.frame = frame;
    
    self.typeTableView = color;
    [self initData];
    [self.addClotheTableView reloadData];
    if (self.addClotheTableView.hidden) {
        
        self.addClotheTableView.hidden = NO;
        self.colorImageView.image = [UIImage imageNamed:Up];
        [UIView animateWithDuration:.3 animations:^{
            
            self.addClotheTableView.alpha = 1;
        } completion:^(BOOL finished) {
        }];
    }
    else {
        
        [UIView animateWithDuration:.3 animations:^{
            
            self.addClotheTableView.alpha = 0;
        } completion:^(BOOL finished) {
            self.colorImageView.image = [UIImage imageNamed:Down];
            self.addClotheTableView.hidden = YES;
        }];
    }
}

- (IBAction)categoryButton:(id)sender {
    
    UIButton *button = (UIButton*)sender;
    CGRect frame = self.addClotheTableView.frame;
    frame.origin.y = button.frame.origin.y + button.frame.size.height;
    self.addClotheTableView.frame = frame;
    
    self.typeTableView = category;
    [self initData];
    [self.addClotheTableView reloadData];
    if (self.addClotheTableView.hidden) {
        
        self.addClotheTableView.hidden = NO;
        [UIView animateWithDuration:.3 animations:^{
            
            self.addClotheTableView.alpha = 1;
        } completion:^(BOOL finished) {}];
    }
    else {
        
        [UIView animateWithDuration:.3 animations:^{
            
            self.addClotheTableView.alpha = 0;
        } completion:^(BOOL finished) {
            
            self.addClotheTableView.hidden = YES;
        }];
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

    if (self.addClotheTableView.hidden) {
        
        self.addClotheTableView.hidden = NO;
        [UIView animateWithDuration:.3 animations:^{
            
            self.addClotheTableView.alpha = 1;
        } completion:^(BOOL finished) {}];
    }
    else {
        
        [UIView animateWithDuration:.3 animations:^{
            
            self.addClotheTableView.alpha = 0;
        } completion:^(BOOL finished) {
            
            self.addClotheTableView.hidden = YES;
        }];
    }
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
@end
