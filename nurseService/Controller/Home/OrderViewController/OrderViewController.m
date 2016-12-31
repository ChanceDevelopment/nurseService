//
//  OrderViewController.m
//  nurseService
//
//  Created by Tony on 2016/12/14.
//  Copyright © 2016年 iMac. All rights reserved.
//

#import "OrderViewController.h"
#import "DLNavigationTabBar.h"
#import "OrderFinishedTableViewCell.h"

@interface OrderViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSInteger currentPage;
    NSInteger currentType;
    NSMutableArray *dataArr;
}
@property(nonatomic,strong)DLNavigationTabBar *navigationTabBar;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation OrderViewController
@synthesize myTableView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        label.font = APPDEFAULTTITLETEXTFONT;
        label.textColor = APPDEFAULTTITLECOLOR;
        label.textAlignment = NSTextAlignmentCenter;
        self.navigationItem.titleView = label;
        label.text = @"订单";
        [label sizeToFit];
        self.title = @"订单";
    }
    return self;
}

-(DLNavigationTabBar *)navigationTabBar
{
    if (!_navigationTabBar) {
        self.navigationTabBar = [[DLNavigationTabBar alloc] initWithTitles:@[@"正接单",@"进行中",@"已完成"]];
        self.navigationTabBar.backgroundColor = [UIColor colorWithWhite:237.0 / 255.0 alpha:1.0];
        self.navigationTabBar.frame = CGRectMake(0, 0, SCREENWIDTH, 44);
        self.navigationTabBar.sliderBackgroundColor = APPDEFAULTORANGE;
        self.navigationTabBar.buttonNormalTitleColor = [UIColor grayColor];
        self.navigationTabBar.buttonSelectedTileColor = APPDEFAULTORANGE;
        __weak typeof(self) weakSelf = self;
        [self.navigationTabBar setDidClickAtIndex:^(NSInteger index){
            [weakSelf navigationDidSelectedControllerIndex:index];
        }];
    }
    return _navigationTabBar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initializaiton];
    [self initView];
}

- (void)initializaiton
{
    [super initializaiton];
}

- (void)initView
{
    [super initView];
    [self.view addSubview:self.navigationTabBar];
    
    currentPage = 0;
    currentType = 2;
    [self getDataWithUrl:ORDERSTATESUCCESS];
    dataArr = [[NSMutableArray alloc] initWithCapacity:0];

    self.view.backgroundColor = [UIColor colorWithWhite:237.0 /255.0 alpha:1.0];
    [myTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    
}

- (void)getDataWithUrl:(NSString *)url{
    NSString *userAccount = [[NSUserDefaults standardUserDefaults] objectForKey:USERIDKEY];
    NSDictionary * params  = @{@"nurseid" : userAccount,@"pageNow" : [NSString stringWithFormat:@"%ld",currentPage]};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:url params:params success:^(AFHTTPRequestOperation* operation,id response){
        
        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSMutableDictionary *respondDict = [NSMutableDictionary dictionaryWithDictionary:[respondString objectFromJSONString]];
        if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"200"]) {
            NSLog(@"success");
            NSArray *tempArr = [NSArray arrayWithArray:[respondDict valueForKey:@"json"]];
            if (tempArr.count > 0) {
                currentPage++;
                
                [dataArr addObjectsFromArray:tempArr];
                [myTableView reloadData];
            }else{
                return ;
            }
        }else if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"400"]){
            NSLog(@"faile");
            [self.view makeToast:[NSString stringWithFormat:@"%@",[respondDict valueForKey:@"data"]] duration:1.2 position:@"center"];
        }
    } failure:^(NSError* err){
        NSLog(@"err:%@",err);
        [self.view makeToast:ERRORREQUESTTIP duration:2.0 position:@"center"];
    }];
}


#pragma mark - PrivateMethod
- (void)navigationDidSelectedControllerIndex:(NSInteger)index {
    NSLog(@"index = %ld",index);
    currentType = index;
    if (dataArr && dataArr.count > 0) {
        [dataArr removeAllObjects];
    }
    switch (currentPage) {
        case 0:
        {
            [self getDataWithUrl:ORDERLOOKRECEIVER];
        }
            break;
        case 1:
        {
            [self getDataWithUrl:ORDERSTATENOW];
        }
            break;
        case 2:
        {
            [self getDataWithUrl:ORDERSTATESUCCESS];
        }
            break;
        default:
            break;
    }
    
}


#pragma mark - TableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArr.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    static NSString *cellIndentifier = @"OrderFinishedTableViewCell";
    CGSize cellSize = [tableView rectForRowAtIndexPath:indexPath].size;
    NSDictionary *dict = [NSDictionary dictionaryWithDictionary:[dataArr objectAtIndex:row]];
    
    OrderFinishedTableViewCell *cell  = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[OrderFinishedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier cellSize:cellSize];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.backgroundColor = [UIColor colorWithWhite:237.0 / 255.0 alpha:1.0];
    cell.serviceContentL.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"orderSendServicecontent"]];
    cell.orderIdNum.text = [NSString stringWithFormat:@"订单编号：%@",[dict valueForKey:@"orderSendId"]];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy/MM/dd HH:MM:SS"];
    
    NSDate *receiveTimeData = [NSDate dateWithTimeIntervalSince1970:[[dict valueForKey:@"orderSendGetOrderTime"] longValue]];
    NSString *receiveTimeStr = [formatter stringFromDate:receiveTimeData];
    
    NSDate *finishData = [NSDate dateWithTimeIntervalSince1970:[[dict valueForKey:@"orderSendFinishOrderTime"] longValue]];
    NSString *finishDataTimeStr = [formatter stringFromDate:finishData];
    
    cell.orderReceiveTime.text = receiveTimeStr;
    cell.orderFinshTime.text = finishDataTimeStr;
    cell.orderMoney.text = [NSString stringWithFormat:@"￥%@",[dict valueForKey:@"orderSendTotalmoney"]];
    cell.reportBlock = ^(){
        NSLog(@"报告");
    };
    cell.evaluateBlock = ^(){
        NSLog(@"评价");
    };
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    
    return 160;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (currentType == 2) {
        return 30;
    }else{
        return 0;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
