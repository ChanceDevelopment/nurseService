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
#import "OrderNowTableViewCell.h"
#import "OrderRecTableViewCell.h"
#import "ZJSwitch.h"
#import "Masonry.h"
#import "MJRefreshNormalHeader.h"
#import "MJRefresh.h"
#import "HeOrderDetailVC.h"
#import "MZTimerLabel.h"

@interface OrderViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSInteger currentPage;
    NSInteger currentType;
    NSMutableArray *dataArr;
    UIView *receiveOrderView;
}
@property(nonatomic,strong)DLNavigationTabBar *navigationTabBar;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
/**
 *  占位Label
 */
@property(nonatomic,strong)UILabel *placeholderLabel;
@property(strong,nonatomic)IBOutlet UIView *footerView;

@end

@implementation OrderViewController
@synthesize myTableView;
@synthesize footerView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSMutableArray *buttons = [[NSMutableArray alloc] init];
        UIButton *searchBt = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 35)];
        [searchBt setTitleColor:APPDEFAULTTITLECOLOR forState:UIControlStateNormal];
        [searchBt setTitle:@"排班表" forState:UIControlStateNormal];
        [searchBt addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
        searchBt.backgroundColor = [UIColor clearColor];
        
        UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithCustomView:searchBt];
        [buttons addObject:searchItem];
        self.navigationItem.leftBarButtonItems = buttons;
        
        self.title = @"订单";
        
    }
    return self;
}

- (UILabel *)placeholderLabel {
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc]init];
        _placeholderLabel.hidden = YES;
        //        NSString *judge = [[Tool judge] isEqualToString:@"0"] ? @"车主" : @"用户";
        _placeholderLabel.text = @"暂无新动态";
        _placeholderLabel.font = [UIFont systemFontOfSize:28];
        _placeholderLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1];
        _placeholderLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _placeholderLabel;
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
    
    currentPage = 1;
    currentType = 0;
    [self getDataWithUrl:ORDERLOOKRECEIVER];
    dataArr = [[NSMutableArray alloc] initWithCapacity:0];

    self.view.backgroundColor = [UIColor colorWithWhite:237.0 /255.0 alpha:1.0];
    [myTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [Tool setExtraCellLineHidden:myTableView];
    myTableView.backgroundView = nil;
    myTableView.backgroundColor = self.view.backgroundColor;
    
    footerView.backgroundColor = self.view.backgroundColor;
    
    CGFloat footerHeigth = 100;
    CGFloat receiveIconW = 60;
    CGFloat receiveIconH = 60;
    CGFloat receiveIconX = (SCREENWIDTH - receiveIconW) / 2.0;
    CGFloat receiveIconY = (footerHeigth - receiveIconH) / 2.0;
    
    UIImageView *receiveIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_takeorder_violet"]];
    receiveIcon.frame = CGRectMake(receiveIconX, receiveIconY, receiveIconW, receiveIconH);
    [footerView addSubview:receiveIcon];
    
    UIImageView *leftArrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_rightarrow_violet"]];
    
    CGFloat leftArrowImageW = 60;
    CGFloat leftArrowImageH = leftArrowImage.image.size.height / leftArrowImage.image.size.width * leftArrowImageW;
    CGFloat leftArrowImageX = CGRectGetMinX(receiveIcon.frame) - leftArrowImageW - 5;
    CGFloat leftArrowImageY = 0;
    leftArrowImage.frame = CGRectMake(leftArrowImageX, leftArrowImageY, leftArrowImageW, leftArrowImageH);
    CGPoint centerPoint = receiveIcon.center;
    centerPoint.x = leftArrowImage.center.x;
    leftArrowImage.center = centerPoint;
    [footerView addSubview:leftArrowImage];
    
    leftArrowImageY = CGRectGetMinY(leftArrowImage.frame);
    leftArrowImageX = CGRectGetMaxX(receiveIcon.frame) + 5;
    UIImageView *rightArrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_leftarrow_violet"]];
    rightArrowImage.frame = CGRectMake(leftArrowImageX, leftArrowImageY, leftArrowImageW, leftArrowImageH);
    [footerView addSubview:rightArrowImage];
    
    CGFloat buttonH = receiveIconH;
    CGFloat buttonW = 50;
    CGFloat buttonX = CGRectGetMinX(leftArrowImage.frame) - buttonW - 5;
    CGFloat buttonY = receiveIconY;
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
    [cancelButton setTitleColor:APPDEFAULTORANGE forState:UIControlStateNormal];
    cancelButton.tag = 0;
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [cancelButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:cancelButton];
    
    buttonX = CGRectGetMaxX(rightArrowImage.frame) + 5;
    UIButton *receiveButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
    [receiveButton setTitleColor:APPDEFAULTORANGE forState:UIControlStateNormal];
    receiveButton.tag = 1;
    [receiveButton setTitle:@"接单" forState:UIControlStateNormal];
    [receiveButton.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [receiveButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:receiveButton];
    
    
    UILabel *timeLabel = [[UILabel alloc] init];
    
    MZTimerLabel *timer3 = [[MZTimerLabel alloc] initWithLabel:timeLabel andTimerType:MZTimerLabelTypeTimer];
    timer3.timeFormat = @"mm:ss";
    [timer3 setCountDownTime:60 * 5];
    [timer3 start];
    
    
    CGFloat receiveOrderViewX = 0;
    CGFloat receiveOrderViewY = 0;
    CGFloat receiveOrderViewW = 50;
    CGFloat receiveOrderViewH = 35;
    
    CGFloat receiveOrderX = 0;
    CGFloat receiveOrderY = 0;
    CGFloat receiveOrderH = 20;
    CGFloat receiveOrderW = receiveOrderViewW;
    
    receiveOrderView = [[UIView alloc] initWithFrame:CGRectMake(receiveOrderViewX, receiveOrderViewY, receiveOrderViewW, receiveOrderViewH)];
    receiveOrderView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, receiveOrderH, receiveOrderViewW, 15)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = APPDEFAULTORANGE;
    titleLabel.text = @"接单中";
    titleLabel.tag = 100;
    titleLabel.font = [UIFont systemFontOfSize:10.0];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [receiveOrderView addSubview:titleLabel];
    
    ZJSwitch *receiveOrderSwitch = [[ZJSwitch alloc] initWithFrame:CGRectMake(receiveOrderX, receiveOrderY, receiveOrderW, receiveOrderH)];
    receiveOrderSwitch.on = YES;
    [receiveOrderSwitch addTarget:self action:@selector(receiveOrderSwitchChangeValue:) forControlEvents:UIControlEventValueChanged];
    receiveOrderSwitch.tintColor = APPDEFAULTORANGE;
    receiveOrderSwitch.onTintColor = APPDEFAULTORANGE;
    receiveOrderSwitch.thumbTintColor = [UIColor whiteColor];
//    receiveOrderSwitch.layer.borderWidth = 0.5;
//    receiveOrderSwitch.layer.borderColor = APPDEFAULTORANGE.CGColor;
    [receiveOrderView addSubview:receiveOrderSwitch];
    
    UIBarButtonItem *receiveOrderItem = [[UIBarButtonItem alloc] initWithCustomView:receiveOrderView];
    self.navigationItem.rightBarButtonItem = receiveOrderItem;
    
    [self.myTableView addSubview:self.placeholderLabel];
    [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.myTableView);
    }];
    
    self.myTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block,刷新
        [self.myTableView.header performSelector:@selector(endRefreshing) withObject:nil afterDelay:1.0];
    }];
    
    self.myTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.myTableView.footer.automaticallyHidden = YES;
        self.myTableView.footer.hidden = NO;
        // 进入刷新状态后会自动调用这个block，加载更多
        [self performSelector:@selector(endRefreshing) withObject:nil afterDelay:1.0];
    }];
}

- (void)buttonClick:(UIButton *)button
{
    if (button.tag == 0) {
        NSLog(@"取消");
    }
    else if (button.tag == 1){
        NSLog(@"接单");
    }
}
- (void)endRefreshing
{
    [self.myTableView.footer endRefreshing];
    self.myTableView.footer.hidden = YES;
    self.myTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.myTableView.footer.automaticallyHidden = YES;
        self.myTableView.footer.hidden = NO;
        // 进入刷新状态后会自动调用这个block，加载更多
        [self performSelector:@selector(endRefreshing) withObject:nil afterDelay:1.0];
    }];
    
    
}

- (void)receiveOrderSwitchChangeValue:(UISwitch *)mySwitch
{
    UILabel *titleLabel = [receiveOrderView viewWithTag:100];
    if (mySwitch.on) {
        titleLabel.text = @"接单中";
        NSLog(@"接单中");
    }
    else{
        titleLabel.text = @"关闭接单";
        NSLog(@"关闭接单");
    }
}

- (void)getDataWithUrl:(NSString *)url{
    NSString *userAccount = [[NSUserDefaults standardUserDefaults] objectForKey:USERIDKEY];
    NSDictionary * params;
    if (currentType == 0) {
        params= @{@"nurseId" : userAccount,@"pageNum" : [NSString stringWithFormat:@"%ld",currentPage]};
    }else{
        params= @{@"nurseId" : userAccount,@"pageNow" : [NSString stringWithFormat:@"%ld",currentPage]};
    }
    
    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:url params:params success:^(AFHTTPRequestOperation* operation,id response){
        
        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSMutableDictionary *respondDict = [NSMutableDictionary dictionaryWithDictionary:[respondString objectFromJSONString]];
        if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"200"]) {
            NSLog(@"success");
            if ([[respondDict valueForKey:@"json"] isMemberOfClass:[NSNull class]] || [respondDict valueForKey:@"json"] == nil) {
                [self.view makeToast:[NSString stringWithFormat:@"%@",[respondDict valueForKey:@"data"]] duration:1.2 position:@"center"];

                return ;
            }else{
                NSArray *tempArr = [NSArray arrayWithArray:[respondDict valueForKey:@"json"]];
                if (tempArr.count >0) {
                    currentPage++;
                    [dataArr addObjectsFromArray:tempArr];
                    [myTableView reloadData];
                }else{
                    return;
                }
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
    currentPage = 1;
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

- (void)showOrderDetailWithOrder:(NSDictionary *)orderDict
{
    HeOrderDetailVC *orderDetailVC = [[HeOrderDetailVC alloc] init];
    orderDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:orderDetailVC animated:YES];
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
    
    NSDictionary *userInfoDic = [NSDictionary dictionaryWithDictionary:[dataArr objectAtIndex:row]];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[Tool deleteNullFromDic:userInfoDic]];
    
    if (currentType == 0) {
        OrderRecTableViewCell *cell  = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[OrderRecTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier cellSize:cellSize];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.backgroundColor = [UIColor colorWithWhite:244.0 / 255.0 alpha:1.0];
        
        cell.serviceContentL.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"orderSendServicecontent"]];
        
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"MM/dd HH:MM"];
        [NSString stringWithFormat:@"%@",[dict valueForKey:@"orderSendGetOrderTime"]];
        NSDate *stopTimeData = [NSDate dateWithTimeIntervalSince1970:[[dict valueForKey:@"orderSendGetOrderTime"] longLongValue]];
        NSString *stopTimeStr = [formatter stringFromDate:stopTimeData];
        cell.stopTimeL.text = stopTimeStr;
        cell.orderMoney.text = [NSString stringWithFormat:@"￥%@",[dict valueForKey:@"orderSendTotalmoney"]];
        NSString *address = [NSString stringWithFormat:@"%@",[dict valueForKey:@"orderSendAddree"]];
        NSArray *addArr = [address componentsSeparatedByString:@","];
        cell.addressL.text = [NSString stringWithFormat:@"%@",[addArr objectAtIndex:2]];
        NSString *sex = [[dict valueForKey:@"orderSendSex"] integerValue]==1 ? @"男" : @"女";
        cell.userInfoL.text = [NSString stringWithFormat:@"%@ %@ %@岁",[dict valueForKey:@"orderSendUsername"],sex,[dict valueForKey:@"orderSendAge"]];
        cell.remarkInfoL.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"orderSendNote"]];
        
        cell.showOrderDetailBlock = ^(){
            NSLog(@"showOrderDetail");
        };
        cell.locationBlock = ^(){
            NSLog(@"locationBlock");
        };
        cell.showUserInfoBlock = ^(){
            NSLog(@"showUserInfoBlock");
        };

        return  cell;
    }else if (currentType == 1){
        OrderNowTableViewCell *cell  = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[OrderNowTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier cellSize:cellSize];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.backgroundColor = [UIColor colorWithWhite:244.0 / 255.0 alpha:1.0];
        __weak typeof(self) weakSelf = self;
        cell.showOrderDetailBlock = ^{
            [weakSelf showOrderDetailWithOrder:nil];
        };
        cell.serviceContentL.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"orderSendServicecontent"]];
        
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"MM/dd HH:MM"];
        [NSString stringWithFormat:@"%@",[dict valueForKey:@"orderSendGetOrderTime"]];
        NSDate *stopTimeData = [NSDate dateWithTimeIntervalSince1970:[[dict valueForKey:@"orderSendGetOrderTime"] longLongValue]];
        NSString *stopTimeStr = [formatter stringFromDate:stopTimeData];
        cell.stopTimeL.text = stopTimeStr;
        cell.orderMoney.text = [NSString stringWithFormat:@"￥%@",[dict valueForKey:@"orderSendTotalmoney"]];
        NSString *address = [NSString stringWithFormat:@"%@",[dict valueForKey:@"orderSendAddree"]];
        NSArray *addArr = [address componentsSeparatedByString:@","];
        cell.addressL.text = [NSString stringWithFormat:@"%@",[addArr objectAtIndex:2]];
        NSString *sex = [[dict valueForKey:@"orderSendSex"] integerValue]==1 ? @"男" : @"女";
        cell.userInfoL.text = [NSString stringWithFormat:@"%@ %@ %@岁",[dict valueForKey:@"orderSendUsername"],sex,[dict valueForKey:@"orderSendAge"]];
        
        cell.showOrderDetailBlock = ^(){
            NSLog(@"showOrderDetail");
        };
        cell.cancleRequstBlock = ^(){
            NSLog(@"cancleRequstBlock");
        };
        cell.nextStepBlock = ^(){
            NSLog(@"nextStepBlock");
        };
        cell.locationBlock = ^(){
            NSLog(@"locationBlock");
        };
        cell.showUserInfoBlock = ^(){
            NSLog(@"showUserInfoBlock");
        };
        
        return  cell;
    }else if(currentType == 2){
        OrderFinishedTableViewCell *cell  = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[OrderFinishedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier cellSize:cellSize];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.backgroundColor = [UIColor colorWithWhite:244.0 / 255.0 alpha:1.0];
        
        
         cell.serviceContentL.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"orderSendServicecontent"]];
         cell.orderIdNum.text = [NSString stringWithFormat:@"订单编号：%@",[dict valueForKey:@"orderSendId"]];
         
         NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
         [formatter setDateStyle:NSDateFormatterMediumStyle];
         [formatter setTimeStyle:NSDateFormatterShortStyle];
         [formatter setDateFormat:@"yyyy/MM/dd HH:MM:SS"];
        [NSString stringWithFormat:@"%@",[dict valueForKey:@"orderSendGetOrderTime"]];
         NSDate *receiveTimeData = [NSDate dateWithTimeIntervalSince1970:[[dict valueForKey:@"orderSendGetOrderTime"] longLongValue]];
         NSString *receiveTimeStr = [formatter stringFromDate:receiveTimeData];
         
         NSDate *finishData = [NSDate dateWithTimeIntervalSince1970:[[dict valueForKey:@"orderSendFinishOrderTime"] longLongValue]];
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
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    
    return 160;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (currentType == 2 && section == 0) {
        return 30;
    }else{
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *v = nil;
    if (currentType == 2 && section == 0) {
        v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
        v.userInteractionEnabled = YES;
        [v setBackgroundColor:[UIColor colorWithWhite:244.0 / 255.0 alpha:1.0]];
        
        UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0.0f, 200.0f, 30.0f)];
        [labelTitle setBackgroundColor:[UIColor clearColor]];
        labelTitle.text = @"本周";
        labelTitle.userInteractionEnabled = YES;
        labelTitle.font = [UIFont systemFontOfSize:12.0];
        labelTitle.textColor = [UIColor lightGrayColor];
        [v addSubview:labelTitle];
        
        UILabel *checkTitle = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH-100, 0.0f, 80.0f, 30.0f)];
        checkTitle.userInteractionEnabled = YES;
        checkTitle.font = [UIFont systemFontOfSize:12.0];
        checkTitle.textAlignment = NSTextAlignmentRight;
        [checkTitle setBackgroundColor:[UIColor clearColor]];
        checkTitle.textColor = [UIColor lightGrayColor];
        checkTitle.text = @"查看账单";
        [v addSubview:checkTitle];
        
        UIImageView *rightV = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH-20, 10, 10, 10)];
        rightV.backgroundColor = [UIColor clearColor];
        rightV.image = [UIImage imageNamed:@"icon_into_right"];
        rightV.userInteractionEnabled = YES;
        [v addSubview:rightV];
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToCheck)];
        [v addGestureRecognizer:tapGes];
    }
    return v;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    NSLog(@"row = %ld, section = %ld",row,section);
}


- (void)goToCheck{
    NSLog(@"goToCheck");
}

- (void)searchAction{
    NSLog(@"searchAction");
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
