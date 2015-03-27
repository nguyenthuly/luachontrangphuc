//
//  SWListLogViewController.m
//  SwiftArchitecture
//
//  Created by Mac on 2/11/15.
//  Copyright (c) 2015 Nguyen Thu Ly. All rights reserved.
//

#import "SWListLogViewController.h"
#import "SWLogViewController.h"

@interface SWListLogViewController ()
@property (weak, nonatomic) IBOutlet UITableView *listLogTableView;
@property (nonatomic, strong)NSMutableArray *listLogArr;

@end

@implementation SWListLogViewController{
    BOOL _endOfRespond;

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[SWUtil appDelegate] hideTabbar:NO];
    [self initData];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
    //[self initData];
}

- (void)initUI{
    self.title = Log_Title;
    _endOfRespond = NO;
}

- (void)initData{
    
    if (!self.listLogArr) {
        self.listLogArr = [[NSMutableArray alloc] initWithCapacity:10];
    }
    [[SWUtil sharedUtil] showLoadingView];
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, URL_LIST_HISTORY];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"image/jpeg", nil];

        
    NSDictionary *parameters = @{@"userid": [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],
                                  @"offset":[NSNumber numberWithInteger:self.listLogArr.count]};
    [manager GET:url
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"List Log JSON: %@", responseObject);
             if ([responseObject isKindOfClass:[NSArray class]]) {
                 NSArray *result = (NSArray *)responseObject;
                 for (int i = 0; i < result.count; i++) {
                     NSDictionary *dict = [result objectAtIndex:i];
                     if (![self.listLogArr containsObject:dict]) {
                         [self.listLogArr addObject:dict];
                     }
                 }
                 _endOfRespond = NO;
             }
             
             NSDictionary *dict;
             if ([responseObject isKindOfClass:[NSDictionary class]]) {
                 dict = (NSDictionary *)responseObject;
                 _endOfRespond = YES;
             }
             
             NSInteger code = [[dict objectForKey:@"code"] integerValue];
             
             if (code == 0 && self.listLogArr.count == 0) {
                 _endOfRespond = YES;
                 //self.listLogTableView.hidden = YES;
             } else {
                 //self.listLogTableView.hidden = NO;
                [self.listLogTableView reloadData];
             }
             
             [[SWUtil sharedUtil] hideLoadingView];
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             NSLog(@"Error: %@", error);
             //[SWUtil showConfirmAlert:Title_Alert_Validate message:@"Lỗi" delegate:nil];
             [[SWUtil sharedUtil] hideLoadingView];
         }];

}

#pragma mark - TableView
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.listLogArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = [NSString stringWithFormat:@"Cell-Index%ld",(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont fontHelveticaNeue_Medium:17.0f];
    cell.textLabel.textColor = [UIColor colorWithHex:Gray_Color alpha:1.0f];
    
    NSString *imageLink = [NSString stringWithFormat:@"%@%@",[[self.listLogArr objectAtIndex:indexPath.row] objectForKey:@"weatherImage"],Red_Weather];
    long long datetime = [[[self.listLogArr objectAtIndex:indexPath.row] objectForKey:@"datetime"] longLongValue];
    
    cell.imageView.image = [UIImage imageNamed:imageLink];
    cell.textLabel.text = [SWUtil convert:datetime toDateStringWithFormat:DateTime_Format];
  
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SWLogViewController *logVC = [[SWLogViewController alloc] init];
    logVC.historyId = [[self.listLogArr objectAtIndex:indexPath.row] objectForKey:@"historyid"];
    [self.navigationController pushViewController:logVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == self.listLogArr.count - 1  && !_endOfRespond){
        [self initData];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

@end
