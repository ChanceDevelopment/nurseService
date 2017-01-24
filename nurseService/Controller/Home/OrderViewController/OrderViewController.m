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
#import "HeUserLocatiVC.h"
#import "HePaitentInfoVC.h"
#import "NurseReportVC.h"
#import "CheckDetailVC.h"
#import "HeCommentNurseVC.h"
#import "WZLBadgeImport.h"


@interface OrderViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSInteger currentPage;
    NSInteger currentType;
    NSMutableArray *dataArr;

    UIView *receiveOrderView;
    UIView *windowView;
    NSDictionary *currentDic;
    UIImageView *noDataView;
    UIButton *switchBt;
    UILabel *titleLabel;
    
    UILabel *badge;
    NSMutableArray *badgeDataArr;
    
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
        
        //设置红点
        badge = [[UILabel alloc] init];
        badge.backgroundColor = APPDEFAULTTITLECOLOR;
        [self.navigationTabBar addSubview:badge];
        badge.frame = CGRectMake(0, 0, 12, 12);
        badge.textAlignment = NSTextAlignmentCenter;
        badge.center = CGPointMake(SCREENWIDTH/2.0+35, 12);
        badge.layer.cornerRadius = CGRectGetWidth(badge.frame) / 2;
        badge.layer.masksToBounds = YES;//very important
        badge.font = [UIFont systemFontOfSize:10.0];
        badge.hidden = NO;
        badge.textColor = [UIColor whiteColor];
        badge.adjustsFontSizeToFitWidth = YES;
        [self setBadgeTextWith:0];

        __weak typeof(self) weakSelf = self;
        [self.navigationTabBar setDidClickAtIndex:^(NSInteger index){
            [weakSelf navigationDidSelectedControllerIndex:index];
        }];
    }
    return _navigationTabBar;
}

- (void)setBadgeTextWith:(NSInteger)value{
    badge.text = (value >= 99 ?
                  [NSString stringWithFormat:@"%@+", @(99)] :
                  [NSString stringWithFormat:@"%@", @(value)]);
    badge.hidden = NO;
    if (value <= 0) {
        badge.hidden = YES;
    }
}



- (void)viewWillAppear:(BOOL)animated{
    [self getReceiveOrderSwitchState];
    
//    [self getBadgeNums];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initializaiton];
    [self initView];
    [self getDataWithUrl:ORDERLOOKRECEIVER];
}

- (void)initializaiton
{
    [super initializaiton];
    currentPage = 0;
    currentType = 0;
    dataArr = [[NSMutableArray alloc] initWithCapacity:0];
    currentDic = [[NSDictionary alloc] init];
    badgeDataArr = [[NSMutableArray alloc] initWithCapacity:0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateOrder:) name:@"updateOrder" object:nil];

}

- (void)initView
{
    [super initView];
    [self.view addSubview:self.navigationTabBar];
    self.view.backgroundColor = [UIColor colorWithWhite:244.0 / 255.0 alpha:1.0];

    CGFloat tableViewY = 44;
    CGFloat tableViewH = self.view.frame.size.height-44-120-48+80;
    

    UIImage *image = [UIImage imageNamed:@"img_no_data"];
    CGFloat noDataViewW = 100;
    CGFloat noDataViewH = image.size.height / image.size.width * noDataViewW;
    CGFloat noDataViewY = (self.view.frame.size.height-44-48-noDataViewW)/2.0 - 30;
    CGFloat noDataViewX = (SCREENWIDTH-noDataViewW)/2.0;
    noDataView = [[UIImageView alloc] init];
    noDataView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:noDataView];
    noDataView.frame = CGRectMake(noDataViewX, noDataViewY, noDataViewW, noDataViewH);
    noDataView.image = image;
    noDataView.hidden = YES;
    
    myTableView = [[UITableView alloc] init];
    myTableView.frame = CGRectMake(0, tableViewY, SCREENWIDTH, tableViewH);
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [myTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [Tool setExtraCellLineHidden:myTableView];
    myTableView.backgroundView = nil;
    myTableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:myTableView];
    myTableView.hidden = YES;
    
    
    CGFloat receiveOrderViewX = 0;
    CGFloat receiveOrderViewY = 0;
    CGFloat receiveOrderViewW = 50;
    CGFloat receiveOrderViewH = 35;
    
    CGFloat receiveOrderX = 0;
    CGFloat receiveOrderY = 0;
    CGFloat receiveOrderH = 25;
    CGFloat receiveOrderW = receiveOrderViewW;
    
    receiveOrderView = [[UIView alloc] initWithFrame:CGRectMake(receiveOrderViewX, receiveOrderViewY, receiveOrderViewW, receiveOrderViewH)];
    receiveOrderView.backgroundColor = [UIColor clearColor];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, receiveOrderH, receiveOrderViewW, 15)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = APPDEFAULTORANGE;
    titleLabel.text = @"接单中";
    titleLabel.tag = 100;
    titleLabel.font = [UIFont systemFontOfSize:10.0];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [receiveOrderView addSubview:titleLabel];
    
    switchBt = [[UIButton alloc] initWithFrame:CGRectMake(receiveOrderX, receiveOrderY, receiveOrderW, receiveOrderH)];
    [switchBt setBackgroundImage:[UIImage imageNamed:@"icon_switch_close"] forState:UIControlStateNormal];
    [switchBt setBackgroundImage:[UIImage imageNamed:@"icon_switch_open"] forState:UIControlStateSelected];
    
    [switchBt addTarget:self action:@selector(receiveOrderSwitchChangeValue:) forControlEvents:UIControlEventTouchUpInside];
    [receiveOrderView addSubview:switchBt];
    
    UIBarButtonItem *receiveOrderItem = [[UIBarButtonItem alloc] initWithCustomView:receiveOrderView];
    self.navigationItem.rightBarButtonItem = receiveOrderItem;
    
    [self.myTableView addSubview:self.placeholderLabel];
    [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.myTableView);
    }];
    
    [self initHeadViewAndFootView];
    

    
}

- (void)initHeadViewAndFootView{
    self.myTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block,刷新
        [self.myTableView.header performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.5];
        [self reloadOrderData];
    }];
    
    self.myTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.myTableView.footer.automaticallyHidden = YES;
        self.myTableView.footer.hidden = NO;
        // 进入刷新状态后会自动调用这个block，加载更多
        [self performSelector:@selector(endRefreshing) withObject:nil afterDelay:1.0];
    }];
}

- (void)removeHeadViewAndFootView{
//    if (self.myTableView.footer) {
//        [self.myTableView.footer removeFromSuperview];
//    }
//    if (self.myTableView.header) {
//        [self.myTableView.header removeFromSuperview];
//    }
    
    self.myTableView.footer.hidden = YES;
    self.myTableView.header.hidden = YES;

}

- (void)initFooterView{
    
    CGFloat selectViewH = 44;
    CGFloat footerViewY = selectViewH + 240;
    CGFloat footerViewH = self.view.frame.size.height-footerViewY;//120;
    
    footerView = [[UIView alloc] init];
    footerView.frame = CGRectMake(0, footerViewY, SCREENWIDTH, footerViewH);
    [self.view addSubview:footerView];
    footerView.backgroundColor = self.view.backgroundColor;
    
    CGFloat buttonH = 50;
    CGFloat buttonW = 100;
    CGFloat buttonX = SCREENWIDTH/2.0-buttonW-1;
    CGFloat buttonY = footerViewH-100;//30;

    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
    cancelButton.backgroundColor = [UIColor redColor];
    //    [cancelButton setTitleColor: forState:UIControlStateNormal];
    cancelButton.tag = 0;
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [cancelButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:cancelButton];
    
    buttonX = SCREENWIDTH/2.0 + 1;
    UIButton *receiveButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
    receiveButton.backgroundColor = [UIColor greenColor];
    //    [receiveButton setTitleColor:APPDEFAULTORANGE forState:UIControlStateNormal];
    receiveButton.tag = 1;
    [receiveButton setTitle:@"接单" forState:UIControlStateNormal];
    [receiveButton.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [receiveButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:receiveButton];
    
    
    
    CGFloat timeLabelX = 0;
    CGFloat timeLabelY = CGRectGetMaxY(receiveButton.frame) + 5;
    CGFloat timeLabelH = 30;
    CGFloat timeLabelW = SCREENWIDTH;
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(timeLabelX, timeLabelY, timeLabelW, timeLabelH)];
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.font = [UIFont systemFontOfSize:18.0];
    timeLabel.textColor = [UIColor grayColor];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    [footerView addSubview:timeLabel];
    
    MZTimerLabel *timer3 = [[MZTimerLabel alloc] initWithLabel:timeLabel andTimerType:MZTimerLabelTypeTimer];
    timer3.timeFormat = @"mm:ss";
    [timer3 setCountDownTime:60 * 5];
    [timer3 start];

    
    
    /*
    CGFloat receiveIconW = 60;
    CGFloat receiveIconH = 60;
    CGFloat receiveIconX = (SCREENWIDTH - receiveIconW) / 2.0;
    CGFloat receiveIconY = 20;
    
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
//    UIImageView *rightArrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_leftarrow_violet"]];
//    rightArrowImage.frame = CGRectMake(leftArrowImageX, leftArrowImageY, leftArrowImageW, leftArrowImageH);
//    [footerView addSubview:rightArrowImage];
    
    CGFloat buttonH = receiveIconH;
    CGFloat buttonW = 50;
    CGFloat buttonX = CGRectGetMinX(leftArrowImage.frame) - buttonW - 5;
    CGFloat buttonY = receiveIconY;
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
    cancelButton.backgroundColor = APPDEFAULTORANGE;
//    [cancelButton setTitleColor: forState:UIControlStateNormal];
    cancelButton.tag = 0;
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [cancelButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:cancelButton];
    
    buttonX = CGRectGetMaxX(rightArrowImage.frame) + 5;
    UIButton *receiveButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
    receiveButton.backgroundColor = APPDEFAULTORANGE;
//    [receiveButton setTitleColor:APPDEFAULTORANGE forState:UIControlStateNormal];
    receiveButton.tag = 1;
    [receiveButton setTitle:@"接单" forState:UIControlStateNormal];
    [receiveButton.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [receiveButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:receiveButton];
    
    
    
    CGFloat timeLabelX = 0;
    CGFloat timeLabelY = CGRectGetMaxY(receiveButton.frame) + 5;
    CGFloat timeLabelH = 30;
    CGFloat timeLabelW = SCREENWIDTH;
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(timeLabelX, timeLabelY, timeLabelW, timeLabelH)];
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.font = [UIFont systemFontOfSize:18.0];
    timeLabel.textColor = [UIColor grayColor];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    [footerView addSubview:timeLabel];
    
    MZTimerLabel *timer3 = [[MZTimerLabel alloc] initWithLabel:timeLabel andTimerType:MZTimerLabelTypeTimer];
    timer3.timeFormat = @"mm:ss";
    [timer3 setCountDownTime:60 * 5];
    [timer3 start];*/
}

- (void)updateOrder:(NSNotification *)notification
{
    [self navigationDidSelectedControllerIndex:currentType];
}

- (void)buttonClick:(UIButton *)button
{
    if (button.tag == 0) {
        NSLog(@"取消");
        [self cancleOrderAction];
//        [self cancleExclusiveOrder]
    }
    else if (button.tag == 1){
        NSLog(@"接单");
//        [self updateOrderStateWithOrderState:0];
        [self receiveTheOrder];
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

- (void)receiveOrderSwitchChangeValue:(UIButton *)mySwitch
{

    mySwitch.selected = !mySwitch.selected;
    UILabel *titleLabel = [receiveOrderView viewWithTag:100];
    if (mySwitch.isSelected) {
        titleLabel.text = @"接单中";
        NSLog(@"接单中");
    }
    else{
        titleLabel.text = @"关闭接单";
        NSLog(@"关闭接单");
    }
    
    [self reloadOrderData];
    
    NSString *userAccount = [[NSUserDefaults standardUserDefaults] objectForKey:USERIDKEY];
    NSString *receiveState = mySwitch.isSelected ? @"0" : @"1";    //0可接1不可接
    NSDictionary * params  = @{@"nurseId": userAccount,
                               @"nurseReceiverState": receiveState};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:UPDATEORDERRECEIVERSTATE params:params success:^(AFHTTPRequestOperation* operation,id response){
        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSLog(@"respondString:%@",respondString);
        NSMutableDictionary *respondDict = [NSMutableDictionary dictionaryWithDictionary:[respondString objectFromJSONString]];

        if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"200"]) {
            NSLog(@"success");
            
            if (mySwitch.isSelected) {
                [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:RECEIVEORDERSTATE];
            }else{
                [[NSUserDefaults standardUserDefaults] setObject:@NO forKey:RECEIVEORDERSTATE];
            }
        }else if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"400"]){
            NSLog(@"faile");
        }
    } failure:^(NSError* err){
        NSLog(@"err:%@",err);
        [self.view makeToast:ERRORREQUESTTIP duration:2.0 position:@"center"];
    }];

}

- (void)resetSetSwitchBtState{
    titleLabel .text = [[NSUserDefaults standardUserDefaults] objectForKey:RECEIVEORDERSTATE] ? @"接单中" : @"关闭接单";
    switchBt.selected = [[NSUserDefaults standardUserDefaults] objectForKey:RECEIVEORDERSTATE];
}

- (void)getDataWithUrl:(NSString *)url{
    BOOL isOn = [[[NSUserDefaults standardUserDefaults] objectForKey:RECEIVEORDERSTATE] boolValue];
    if (!isOn && currentType == 0) {
        
        if (footerView) {
            [footerView removeFromSuperview];
            footerView = nil;
        }
        noDataView.hidden = NO;
        myTableView.hidden = YES;
        return;
    }
    
    if (currentType == 0) {
//        [self removeHeadViewAndFootView];
    }else{
//        [self initHeadViewAndFootView];
    }
    
    NSString *userAccount = [[NSUserDefaults standardUserDefaults] objectForKey:USERIDKEY];
    NSDictionary * params;
    if (currentType == 0) {
        params= @{@"nurseId" : userAccount,@"pageNum" : [NSString stringWithFormat:@"%ld",currentPage]};
    }else{
        params= @{@"nurseId" : userAccount,@"pageNow" : [NSString stringWithFormat:@"%ld",currentPage]};
    }
    NSLog(@"params:%@",params);
    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:url params:params success:^(AFHTTPRequestOperation* operation,id response){
        
        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSMutableDictionary *respondDict = [NSMutableDictionary dictionaryWithDictionary:[respondString objectFromJSONString]];
        NSLog(@"respondDict:%@",respondDict);

        if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"200"]) {
            NSLog(@"success");
            
            if (currentType == 0 || currentType == 1) {
                //每次刷新正接单 进行中 刷新数量
                [self getBadgeNums];
            }
            
            if ([[respondDict valueForKey:@"json"] isMemberOfClass:[NSNull class]] || [respondDict valueForKey:@"json"] == nil) {
//                [self.view makeToast:[NSString stringWithFormat:@"%@",[respondDict valueForKey:@"data"]] duration:1.2 position:@"center"];
                if (footerView) {
                    [footerView removeFromSuperview];
                    footerView = nil;
                }
                if (currentType != 2) {
                    noDataView.hidden = NO;
                    myTableView.hidden = YES;
                }
                return ;
            }else{
                id jsonArray = [respondDict valueForKey:@"json"];
                if ([jsonArray isMemberOfClass:[NSNull class]] || jsonArray == nil) {
                    jsonArray = [NSArray array];
                }
                NSArray *tempArr = [NSArray arrayWithArray:jsonArray];
                switch (currentType) {
                    case 0:
                    {
                        CGFloat tableViewY = 44;
                        CGFloat tableViewH = self.view.frame.size.height-44-120-48+80;
                        myTableView.frame = CGRectMake(0, tableViewY, SCREENWIDTH, tableViewH);
                        if (tempArr.count >0){
                            if (footerView == nil) {
                                [self initFooterView];
                            }
                            noDataView.hidden = YES;
                            myTableView.hidden = NO;
                        }
                    }
                        break;
                    case 1:
                    {
                        
                        CGFloat tableViewY = 44;
                        CGFloat tableViewH = self.view.frame.size.height-44-48+80;
                        myTableView.frame = CGRectMake(0, tableViewY, SCREENWIDTH, tableViewH);
                        if (footerView) {
                            [footerView removeFromSuperview];
                            footerView = nil;
                        }
                        if (tempArr.count > 0){
                            noDataView.hidden = YES;
                            myTableView.hidden = NO;
                        }
                    }
                        break;
                    case 2:
                    {
                        if (footerView) {
                            [footerView removeFromSuperview];
                            footerView = nil;
                        }
                        CGFloat tableViewY = 44;
                        CGFloat tableViewH = self.view.frame.size.height-44-48+50;
                        myTableView.frame = CGRectMake(0, tableViewY, SCREENWIDTH, tableViewH);
                        if (tempArr.count >0){
                            noDataView.hidden = YES;
                            myTableView.hidden = NO;
                        }
                    }
                        break;
                    default:
                        break;
                }
                
                if (tempArr.count > 0) {
                    if (currentType != 1) {
                        currentPage++;
                    }

                    [dataArr addObjectsFromArray:tempArr];
                    [myTableView reloadData];
                }else{
                    if (currentPage == 0 && tempArr.count == 0) {
                        noDataView.hidden = NO;
                        myTableView.hidden = YES;
                    }
                    [myTableView reloadData];
                    return;
                }
                
            }
        }else if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"400"]){
            myTableView.hidden = YES;
            noDataView .hidden = NO;
            NSLog(@"faile");
            [self.view makeToast:[NSString stringWithFormat:@"%@",[respondDict valueForKey:@"data"]] duration:1.2 position:@"center"];
        }
    } failure:^(NSError* err){
        myTableView.hidden = YES;
        noDataView .hidden = NO;
        NSLog(@"err:%@",err);
        [self.view makeToast:ERRORREQUESTTIP duration:2.0 position:@"center"];
    }];
}
//取消订单
- (void)sendCancleOrderWithOrderId:(NSString *)orderId{
    NSString *userAccount = [[NSUserDefaults standardUserDefaults] objectForKey:USERIDKEY];
    //订单ID
    NSDictionary * params  = @{@"orderSendId" : orderId,
                               @"userId" : userAccount,
                               @"identity" : @"1"};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:CANCLEORDER params:params success:^(AFHTTPRequestOperation* operation,id response){
        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSLog(@"respondString:%@",respondString);
        NSMutableDictionary *respondDict = [NSMutableDictionary dictionaryWithDictionary:[respondString objectFromJSONString]];
//        [self.view makeToast:[NSString stringWithFormat:@"%@",[respondDict valueForKey:@"data"]] duration:1.2 position:@"center"];
        if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"200"]) {
            NSLog(@"success");
            [self reloadOrderData];
        }else if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"400"]){
            NSLog(@"faile");
        }
    } failure:^(NSError* err){
        NSLog(@"err:%@",err);
        [self.view makeToast:ERRORREQUESTTIP duration:2.0 position:@"center"];
    }];
}

//取消专属订单
- (void)cancleExclusiveOrder{
    
    NSString *userAccount = [[NSUserDefaults standardUserDefaults] objectForKey:USERIDKEY];
    NSDictionary * params  = @{@"orderSendId" : [dataArr[0] valueForKey:@"orderSendId"],
                               @"userId" : userAccount};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:CANCLEEXCLUSIVEORDER params:params success:^(AFHTTPRequestOperation* operation,id response){
        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSLog(@"respondString:%@",respondString);
        NSMutableDictionary *respondDict = [NSMutableDictionary dictionaryWithDictionary:[respondString objectFromJSONString]];
        
        [self.view makeToast:[NSString stringWithFormat:@"%@",[respondDict valueForKey:@"data"]] duration:2.0 position:@"center"];
        
        if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"200"]) {
//            [self reloadOrderData];
            [dataArr removeObjectAtIndex:0];
            [myTableView reloadData];
            if (dataArr.count == 0) {
                if (footerView) {
                    [footerView removeFromSuperview];
                    footerView = nil;
                }
                noDataView.hidden = NO;
                myTableView.hidden = YES;
            }
            NSLog(@"success");
        }else if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"400"]){
            NSLog(@"faile");
        }
    } failure:^(NSError* err){
        NSLog(@"err:%@",err);
        [self.view makeToast:ERRORREQUESTTIP duration:2.0 position:@"center"];
    }];
}

- (void)receiveTheOrder{
    NSString *userAccount = [[NSUserDefaults standardUserDefaults] objectForKey:USERIDKEY];
    NSString *orderSendId = [currentDic valueForKey:@"orderSendId"];
    
    NSDictionary * params  = @{@"nurseId": userAccount,
                               @"orderSendId" : orderSendId};
    
    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:ORDERRECEIVER params:params success:^(AFHTTPRequestOperation* operation,id response){
        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSLog(@"respondString:%@",respondString);
        NSMutableDictionary *respondDict = [NSMutableDictionary dictionaryWithDictionary:[respondString objectFromJSONString]];
        
        [self.view makeToast:[NSString stringWithFormat:@"%@",[respondDict valueForKey:@"data"]] duration:1.2 position:@"center"];
        if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"200"]) {
            NSLog(@"success");
            [self reloadOrderData];

        }else if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"400"]){
            NSLog(@"faile");
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
    currentPage = 0;
    if (dataArr && dataArr.count > 0) {
        [dataArr removeAllObjects];
    }
    switch (currentType) {
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
    orderDetailVC.orderId = [orderDict valueForKey:@"orderSendId"];
    [self.navigationController pushViewController:orderDetailVC animated:YES];
}

- (void)goLocationWithLocation:(NSDictionary *)locationDict
{
    HeUserLocatiVC *userLocationVC = [[HeUserLocatiVC alloc] init];
    userLocationVC.userLocationDict = [[NSDictionary alloc] initWithDictionary:locationDict];
    userLocationVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:userLocationVC animated:YES];
}

#pragma mark - TableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (currentType == 0 && dataArr.count > 0) {
        tableView.scrollEnabled = NO;
        return 1;
    }
    tableView.scrollEnabled = YES;
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
    NSDictionary *userInfoDic = nil;
    NSMutableDictionary *dict = nil;
    if (dataArr.count > 0) {
        userInfoDic = [NSDictionary dictionaryWithDictionary:[dataArr objectAtIndex:row]];
        dict = [NSMutableDictionary dictionaryWithDictionary:[Tool deleteNullFromDic:userInfoDic]];
    }
    if (currentType == 0) {
        OrderRecTableViewCell *cell  = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[OrderRecTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier cellSize:cellSize];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.backgroundColor = [UIColor colorWithWhite:244.0 / 255.0 alpha:1.0];
        
        NSString *content = [NSString stringWithFormat:@"%@",[dict valueForKey:@"orderSendServicecontent"]];
        NSArray *contentArr = [content componentsSeparatedByString:@":"];
        
        @try {
            cell.serviceContentL.text = contentArr[1];
        } @catch (NSException *exception) {
            
        } @finally {
            
        }

        if ([[dict valueForKey:@"orderSendType"] isEqualToString:@"1"]) {
            cell.exclusiveImageView.hidden = NO;//专属
        }else{
            cell.exclusiveImageView.hidden = YES;

        }
        
        id zoneCreatetimeObj = [dict objectForKey:@"orderSendBegintime"];
        if ([zoneCreatetimeObj isMemberOfClass:[NSNull class]] || zoneCreatetimeObj == nil) {
            NSTimeInterval  timeInterval = [[NSDate date] timeIntervalSince1970];
            zoneCreatetimeObj = [NSString stringWithFormat:@"%.0f000",timeInterval];
        }
        long long timestamp = [zoneCreatetimeObj longLongValue];
        NSString *zoneCreatetime = [NSString stringWithFormat:@"%lld",timestamp];
        if ([zoneCreatetime length] > 3) {
            //时间戳
            zoneCreatetime = [zoneCreatetime substringToIndex:[zoneCreatetime length] - 3];
        }
        NSString *stopTimeStr = [Tool convertTimespToString:[zoneCreatetime longLongValue] dateFormate:@"MM/dd HH:MM"];
        
        cell.stopTimeL.text = stopTimeStr;
        cell.orderMoney.text = [NSString stringWithFormat:@"￥%@",[dict valueForKey:@"orderSendTotalmoney"]];
        NSString *address = [NSString stringWithFormat:@"%@",[dict valueForKey:@"orderSendAddree"]];
        NSArray *addArr = [address componentsSeparatedByString:@","];
        NSString *addressStr = nil;
        //经度
        NSString *zoneLocationX = nil;
        //纬度
        NSString *zoneLocationY = nil;
        @try {
            zoneLocationX = addArr[0];
            zoneLocationY = addArr[1];
            addressStr = [addArr objectAtIndex:2];
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
        cell.addressL.text = [NSString stringWithFormat:@"%@",addressStr];
        NSString *sex = [[dict valueForKey:@"orderSendSex"] integerValue]==1 ? @"男" : @"女";

        NSString *nameStr = [dict valueForKey:@"orderSendUsername"];
        NSArray *nameArr = [nameStr componentsSeparatedByString:@","];
        @try {
            nameStr = nameArr[1];
        } @catch (NSException *exception) {
        } @finally {
            
        }
        cell.userInfoL.text = [NSString stringWithFormat:@"%@ %@ %@岁",nameStr,sex,[dict valueForKey:@"orderSendAge"]];
        cell.remarkInfoL.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"orderSendNote"]];
        
        __weak typeof(self) weakSelf = self;
        
        cell.showOrderDetailBlock = ^(){
            NSLog(@"showOrderDetail");
            [weakSelf showOrderDetailWithOrder:dict];
        };
        cell.locationBlock = ^(){
            NSLog(@"locationBlock");
            NSDictionary *userLocationDic = @{@"zoneLocationY":zoneLocationY,@"zoneLocationX":zoneLocationX};
            [weakSelf goLocationWithLocation:userLocationDic];
        };
        cell.showUserInfoBlock = ^(){
            NSLog(@"showUserInfoBlock");
            HePaitentInfoVC *paitentInfoVC = [[HePaitentInfoVC alloc] init];
            paitentInfoVC.userInfoDict = [[NSDictionary alloc] initWithDictionary:dict];
            paitentInfoVC.isFromNowOrder = NO;
            paitentInfoVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:paitentInfoVC animated:YES];
        };

        return  cell;
    }else if (currentType == 1){
        OrderNowTableViewCell *cell  = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[OrderNowTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier cellSize:cellSize];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.backgroundColor = [UIColor colorWithWhite:244.0 / 255.0 alpha:1.0];
        NSString *content = [NSString stringWithFormat:@"%@",[dict valueForKey:@"orderSendServicecontent"]];
        NSArray *contentArr = [content componentsSeparatedByString:@":"];
        
        cell.serviceContentL.text = contentArr[1];
        
        id zoneCreatetimeObj = [dict objectForKey:@"orderSendBegintime"];
        if ([zoneCreatetimeObj isMemberOfClass:[NSNull class]] || zoneCreatetimeObj == nil) {
            NSTimeInterval  timeInterval = [[NSDate date] timeIntervalSince1970];
            zoneCreatetimeObj = [NSString stringWithFormat:@"%.0f000",timeInterval];
        }
        long long timestamp = [zoneCreatetimeObj longLongValue];
        NSString *zoneCreatetime = [NSString stringWithFormat:@"%lld",timestamp];
        if ([zoneCreatetime length] > 3) {
            //时间戳
            zoneCreatetime = [zoneCreatetime substringToIndex:[zoneCreatetime length] - 3];
        }
        NSString *stopTimeStr = [Tool convertTimespToString:[zoneCreatetime longLongValue] dateFormate:@"MM/dd HH:MM"];
        
        cell.stopTimeL.text = stopTimeStr;
        cell.orderMoney.text = [NSString stringWithFormat:@"￥%@",[dict valueForKey:@"orderSendTotalmoney"]];
        NSString *address = [NSString stringWithFormat:@"%@",[dict valueForKey:@"orderSendAddree"]];
        NSArray *addArr = [address componentsSeparatedByString:@","];
        NSString *addressStr = nil;
        //经度
        NSString *zoneLocationX = nil;
        //纬度
        NSString *zoneLocationY = nil;
        @try {
            zoneLocationX = addArr[0];
            zoneLocationY = addArr[1];
            addressStr = [addArr objectAtIndex:2];
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
        cell.addressL.text = [NSString stringWithFormat:@"%@",addressStr];
        NSString *sex = [[dict valueForKey:@"orderSendSex"] integerValue] == 1 ? @"男" : @"女";
        
        NSString *nameStr = [dict valueForKey:@"orderSendUsername"];
        NSArray *nameArr = [nameStr componentsSeparatedByString:@","];
        @try {
            nameStr = nameArr[1];
        } @catch (NSException *exception) {
        } @finally {
            
        }
        cell.userInfoL.text = [NSString stringWithFormat:@"%@ %@ %@岁",nameStr,sex,[dict valueForKey:@"orderSendAge"]];
        
        NSArray  *orderStateStr = @[@"联系客户",@"出发",@"开始服务",@"填写报告"];
        NSInteger orderIndex = [[dict valueForKey:@"orderReceivestate"] integerValue];
        cell.oderStateL.text = [NSString stringWithFormat:@"(%@)",orderStateStr[orderIndex]];
    
        __weak typeof(self) weakSelf = self;
        
        cell.showOrderDetailBlock = ^(){
            NSLog(@"showOrderDetail");
            [weakSelf showOrderDetailWithOrder:dict];
        };
        cell.cancleRequstBlock = ^(){
            NSLog(@"cancleRequstBlock");
            currentDic = dict;
            [weakSelf showCancleAlertView:row];
        };
        cell.nextStepBlock = ^(){
            NSLog(@"nextStepBlock");
            currentDic = dict;
            [weakSelf showAlertViewWithTag:orderIndex];
        };
        cell.locationBlock = ^(){
            NSLog(@"locationBlock");
            NSDictionary *userLocationDic = @{@"zoneLocationY":zoneLocationY,@"zoneLocationX":zoneLocationX};
            [weakSelf goLocationWithLocation:userLocationDic];
        };
        cell.showUserInfoBlock = ^(){
            NSLog(@"showUserInfoBlock");
            HePaitentInfoVC *paitentInfoVC = [[HePaitentInfoVC alloc] init];
            paitentInfoVC.userInfoDict = [[NSDictionary alloc] initWithDictionary:dict];
            paitentInfoVC.isFromNowOrder = YES;
            paitentInfoVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:paitentInfoVC animated:YES];
        };
        
        return  cell;
    }else if(currentType == 2){
        
        HeBaseTableViewCell *cell  = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[HeBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier cellSize:cellSize];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.backgroundColor = [UIColor colorWithWhite:244.0 / 255.0 alpha:1.0];
        
        BOOL isCancleOrder = [[dict valueForKey:@"orderSendState"] integerValue] == 4 ? YES : NO;
        CGFloat bgViewH = isCancleOrder ? 120 : 150;
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(5, 0, SCREENWIDTH-10, bgViewH)];
        bgView.backgroundColor = [UIColor whiteColor];
        [cell addSubview:bgView];
        [bgView.layer setMasksToBounds:YES];
        bgView.layer.cornerRadius = 4.0;
        
        
        UILabel *serviceContentL = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 200, 44)];
        serviceContentL.textColor = APPDEFAULTORANGE;
        serviceContentL.font = [UIFont systemFontOfSize:15.0];
        serviceContentL.backgroundColor = [UIColor clearColor];
        serviceContentL.adjustsFontSizeToFitWidth = YES;
        [bgView addSubview:serviceContentL];
        
        NSString *content = [NSString stringWithFormat:@"%@",[dict valueForKey:@"orderSendServicecontent"]];
        NSArray *contentArr = [content componentsSeparatedByString:@":"];
        serviceContentL.text = contentArr[1];
        
        UILabel *orderStateL = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH-20-40, 0, 40, 50)];
        orderStateL.textColor = [UIColor grayColor];
        orderStateL.font = [UIFont systemFontOfSize:12.0];
        orderStateL.backgroundColor = [UIColor clearColor];
        [bgView addSubview:orderStateL];
        
        NSString *state = @"";
        if (isCancleOrder) {
            state = @"已取消";
        }else{
            state = @"已完成";
        }
        orderStateL.text = state;
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(10, 44, SCREENWIDTH-20, 1)];
        [bgView addSubview:line];
        line.backgroundColor = [UIColor colorWithWhite:237.0 / 255.0 alpha:1.0];
        
        UILabel *orderIdNum = [[UILabel alloc] initWithFrame:CGRectMake(10, 45, SCREENWIDTH-30, 20)];
        orderIdNum.textColor = [UIColor blackColor];
        orderIdNum.font = [UIFont systemFontOfSize:12.0];
        orderIdNum.backgroundColor = [UIColor clearColor];
        [bgView addSubview:orderIdNum];
        orderIdNum.text = [NSString stringWithFormat:@"订单编号：%@",[dict valueForKey:@"orderSendNumbers"]];

        UILabel *orderReceiveTime = [[UILabel alloc] initWithFrame:CGRectMake(10, 65, 200, 20)];
        orderReceiveTime.textColor = [UIColor blackColor];
        orderReceiveTime.font = [UIFont systemFontOfSize:12.0];
        orderReceiveTime.backgroundColor = [UIColor clearColor];
        [bgView addSubview:orderReceiveTime];
        orderReceiveTime.text = [NSString stringWithFormat:@"接单时间：%@",[self getTimeWith:[dict objectForKey:@"orderSendGetOrderTime"]]];
        
        UILabel *orderFinshTime = [[UILabel alloc] initWithFrame:CGRectMake(10, 85, 200, 20)];
        orderFinshTime.textColor = [UIColor blackColor];
        orderFinshTime.font = [UIFont systemFontOfSize:12.0];
        orderFinshTime.backgroundColor = [UIColor clearColor];
        [bgView addSubview:orderFinshTime];
        if (isCancleOrder) {
            orderFinshTime.text = [NSString stringWithFormat:@"取消时间：%@",[self getTimeWith:[dict valueForKey:@"orderSendFinishOrderTime"]]];
        }else{
            orderFinshTime.text = [NSString stringWithFormat:@"完成时间：%@",[self getTimeWith:[dict valueForKey:@"orderSendFinishOrderTime"]]];
            
        }
        
        UILabel *orderMoney = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH-150, 65, 130, 30)];
        orderMoney.textColor = [UIColor orangeColor];
        orderMoney.textAlignment = NSTextAlignmentRight;
        orderMoney.font = [UIFont systemFontOfSize:15.0];
        orderMoney.backgroundColor = [UIColor clearColor];
        orderMoney.adjustsFontSizeToFitWidth = YES;
        [bgView addSubview:orderMoney];
        orderMoney.text = [NSString stringWithFormat:@"￥%@",[dict valueForKey:@"orderSendTotalmoney"]];

    
        BOOL isEvaluate = [[dict valueForKey:@"isEvaluate"] isEqualToString:@"1"] ? YES : NO;
        if (!isCancleOrder) {
            
            UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 111, SCREENWIDTH-20, 1)];
            [bgView addSubview:line1];
            line1.backgroundColor = [UIColor colorWithWhite:237.0 / 255.0 alpha:1.0];
            
            UIButton *reportBt = [[UIButton alloc] initWithFrame:CGRectMake(0, 111, SCREENWIDTH/2.0-5, 35)];
            [reportBt setTitle:@"护理报告" forState:UIControlStateNormal];
            [reportBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            reportBt.titleLabel.font = [UIFont systemFontOfSize:15.0];
            reportBt.backgroundColor = [UIColor clearColor];
            reportBt.tag = row;
            [reportBt addTarget:self action:@selector(reportAction:) forControlEvents:UIControlEventTouchUpInside];
            [bgView addSubview:reportBt];
            
            UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH/2.0-5, 113, 1, 30)];
            [bgView addSubview:line2];
            line2.backgroundColor = [UIColor colorWithWhite:237.0 / 255.0 alpha:1.0];
            
            UIButton *evaluateBt = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH/2.0-5, 111, SCREENWIDTH/2.0-5, 35)];
            [evaluateBt setTitle:@"去评价" forState:UIControlStateNormal];
            [evaluateBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            evaluateBt.titleLabel.font = [UIFont systemFontOfSize:15.0];
            evaluateBt.backgroundColor = [UIColor clearColor];
            evaluateBt.tag = row;
            [evaluateBt addTarget:self action:@selector(evaluateAction:) forControlEvents:UIControlEventTouchUpInside];
            [bgView addSubview:evaluateBt];
            
            if (isEvaluate) {
                [evaluateBt setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                evaluateBt.enabled = NO;
            }
        }
        return cell;
    }
    return nil;
}
- (void)reportAction:(UIButton *)sender{
    NSLog(@"报告");
    NSInteger index = sender.tag;
    NSDictionary *tempDict = [NSDictionary dictionaryWithDictionary:[dataArr objectAtIndex:index]];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[Tool deleteNullFromDic:tempDict]];
        
    NurseReportVC *nurseReportVC = [[NurseReportVC alloc] init];
    nurseReportVC.hidesBottomBarWhenPushed = YES;
    nurseReportVC.infoData = dict;
    nurseReportVC.isDetail = YES;
    [self.navigationController pushViewController:nurseReportVC animated:YES];
}

- (void)evaluateAction:(UIButton *)sender{
    NSLog(@"评价");
    NSInteger index = sender.tag;
    NSDictionary *tempDict = [NSDictionary dictionaryWithDictionary:[dataArr objectAtIndex:index]];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[Tool deleteNullFromDic:tempDict]];
    
    HeCommentNurseVC *commentNurseVC = [[HeCommentNurseVC alloc] init];
    commentNurseVC.nurseDict = dict;
    commentNurseVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:commentNurseVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    NSDictionary *userInfoDic = nil;
    NSMutableDictionary *dict = nil;
    if (dataArr.count > 0) {
        userInfoDic = [NSDictionary dictionaryWithDictionary:[dataArr objectAtIndex:row]];
        dict = [NSMutableDictionary dictionaryWithDictionary:[Tool deleteNullFromDic:userInfoDic]];
        currentDic = dict;
    }
    
    if (currentType == 0) {
        return 240;
    }
    if (currentType == 1) {
        return 180;
    }
    
    if (currentType == 2) {
        if ([[dict valueForKey:@"orderSendState"] integerValue] == 4) {
            //已取消
            return 130;
        }
    }
    
    return 160;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (currentType == 2 && section == 0 && dataArr.count > 0) {
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
    CheckDetailVC *checkDetailVC = [[CheckDetailVC alloc] init];
    checkDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:checkDetailVC animated:YES];
}

- (void)searchAction{
    NSLog(@"searchAction");
}

- (void)showCancleAlertView:(NSInteger)index{
    
    windowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGH)];
    windowView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5];;
    [[[UIApplication sharedApplication] keyWindow] addSubview:windowView];
    
    NSInteger addBgView_W = SCREENWIDTH -20;
    NSInteger addBgView_H = 160;
    NSInteger addBgView_Y = SCREENHEIGH/2.0-addBgView_H/2.0-40;
    UIView *addBgView = [[UIView alloc] initWithFrame:CGRectMake(10, addBgView_Y, addBgView_W, addBgView_H)];
    addBgView.backgroundColor = [UIColor whiteColor];
    [addBgView.layer setMasksToBounds:YES];
    [addBgView.layer setCornerRadius:4];
    addBgView.alpha = 1.0;
    [windowView addSubview:addBgView];
    
    
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 40)];
    titleL.textColor = [UIColor blackColor];
    titleL.textAlignment = NSTextAlignmentLeft;
    titleL.font = [UIFont systemFontOfSize:18.0];
    titleL.backgroundColor = [UIColor clearColor];
    [addBgView addSubview:titleL];
    
    NSInteger addTextField_H = 44;
    NSInteger addTextField_Y = 50;
    NSInteger addTextField_W =SCREENWIDTH-40;
    
    UILabel *infoTip= [[UILabel alloc] initWithFrame:CGRectMake(10, addTextField_Y, addTextField_W, addTextField_H)];//高度--44
    infoTip.font = [UIFont systemFontOfSize:14.0];
    infoTip.numberOfLines = 0;
    infoTip.backgroundColor = [UIColor clearColor];
    [addBgView addSubview:infoTip];
    
    titleL.text = @"请求取消";
    infoTip.text = @"若取消订单,你将无法获取酬劳,你确定要取消这笔订单吗？";
    
    
    NSInteger wordNum_Y = addTextField_Y+44;
    
    NSInteger cancleBt_X = SCREENWIDTH-20-10-90;
    NSInteger cancleBt_Y = wordNum_Y+30;
    NSInteger cancleBt_W = 40;
    NSInteger cancleBt_H = 20;
    
    UIButton *cancleBt = [[UIButton alloc] initWithFrame:CGRectMake(cancleBt_X, cancleBt_Y, cancleBt_W, cancleBt_H)];
    [cancleBt setTitle:@"取消" forState:UIControlStateNormal];
    cancleBt.backgroundColor = [UIColor clearColor];
    cancleBt.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [cancleBt setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    cancleBt.tag = 1000;
    [cancleBt addTarget:self action:@selector(clickCancleBtAction:) forControlEvents:UIControlEventTouchUpInside];
    [addBgView addSubview:cancleBt];
    
    UIButton *okBt = [[UIButton alloc] initWithFrame:CGRectMake(cancleBt_X+50, cancleBt_Y, cancleBt_W, cancleBt_H)];
    [okBt setTitle:@"确定" forState:UIControlStateNormal];
    okBt.backgroundColor = [UIColor clearColor];
    okBt.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [okBt setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    okBt.tag = 1000+index;
    [okBt addTarget:self action:@selector(clickCancleBtAction:) forControlEvents:UIControlEventTouchUpInside];
    [addBgView addSubview:okBt];
    
    
}

- (void)showAlertViewWithTag:(NSInteger)tag{
    
    windowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGH)];
    windowView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5];;
    [[[UIApplication sharedApplication] keyWindow] addSubview:windowView];
    
    NSInteger addBgView_W = SCREENWIDTH -20;
    NSInteger addBgView_H = 90;
    NSInteger addBgView_Y = SCREENHEIGH/2.0-addBgView_H/2.0-40;
    UIView *addBgView = [[UIView alloc] initWithFrame:CGRectMake(10, addBgView_Y, addBgView_W, addBgView_H)];
    addBgView.backgroundColor = [UIColor whiteColor];
    [addBgView.layer setMasksToBounds:YES];
    [addBgView.layer setCornerRadius:4];
    addBgView.alpha = 1.0;
    [windowView addSubview:addBgView];
    
    NSInteger addTextField_H = 44;
    NSInteger addTextField_Y = 10;
    NSInteger addTextField_W =SCREENWIDTH-40;
    
    UILabel *infoTip= [[UILabel alloc] initWithFrame:CGRectMake(10, addTextField_Y, addTextField_W, addTextField_H)];//高度--44
    infoTip.font = [UIFont systemFontOfSize:12.0];
    infoTip.numberOfLines = 0;
    infoTip.backgroundColor = [UIColor clearColor];
    [addBgView addSubview:infoTip];
    NSInteger orderSendState = tag;  //0已接单1已沟通2已出发3开始服务4已完成
    if(orderSendState == 0){
        infoTip.text = @"执行下一步：联系客户";
    }else if(orderSendState == 1){
        infoTip.text = @"执行下一步：出发";
    }else if(orderSendState == 2){
        infoTip.text = @"执行下一步：开始服务";
    }else if(orderSendState == 3){
        infoTip.text = @"执行下一步：填写报告";
    }
    
    NSInteger cancleBt_X = SCREENWIDTH-20-10-90;
    NSInteger cancleBt_Y = addTextField_Y+50;
    NSInteger cancleBt_W = 40;
    NSInteger cancleBt_H = 20;
    
    UIButton *cancleBt = [[UIButton alloc] initWithFrame:CGRectMake(cancleBt_X, cancleBt_Y, cancleBt_W, cancleBt_H)];
    [cancleBt setTitle:@"取消" forState:UIControlStateNormal];
    cancleBt.backgroundColor = [UIColor clearColor];
    cancleBt.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [cancleBt setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    cancleBt.tag = 1000;
    [cancleBt addTarget:self action:@selector(clickBtAction:) forControlEvents:UIControlEventTouchUpInside];
    [addBgView addSubview:cancleBt];
    
    UIButton *okBt = [[UIButton alloc] initWithFrame:CGRectMake(cancleBt_X+50, cancleBt_Y, cancleBt_W, cancleBt_H)];
    [okBt setTitle:@"确定" forState:UIControlStateNormal];
    okBt.backgroundColor = [UIColor clearColor];
    okBt.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [okBt setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    okBt.tag = orderSendState;
    [okBt addTarget:self action:@selector(clickBtAction:) forControlEvents:UIControlEventTouchUpInside];
    [addBgView addSubview:okBt];
}

//正接单取消订单
- (void)cancleOrderAction{
    
    if (dataArr.count > 0) {
        if ([[dataArr[0] valueForKey:@"orderSendType"] isEqualToString:@"1"]) {
            [self cancleExclusiveOrder];
        }else{
            [dataArr addObject:dataArr[0]];
            [dataArr removeObjectAtIndex:0];
            [myTableView reloadData];
            
//            [self sendCancleOrderWithOrderId:[dataArr[0] valueForKey:@"orderSendId"]];
        }
    }
}

//取消进行中的订单
- (void)clickCancleBtAction:(UIButton *)sender{
    // "请求取消"
    NSInteger rowNum = sender.tag-1000;
    [self sendCancleOrderWithOrderId:[dataArr[rowNum] valueForKey:@"orderSendId"]];
    if (windowView) {
        [windowView removeFromSuperview];
    }
}

- (void)clickBtAction:(UIButton *)sender{
    NSLog(@"tag:%ld",sender.tag);
//    if (sender.tag == 100) {
//
//        [self sendCancleOrderWithOrderId:[dataArr[0] valueForKey:@"orderSendId"]];
//
//        if (dataArr.count > 0) {
//            if ([[dataArr[0] valueForKey:@"orderSendType"] isEqualToString:@"1"]) {
//                [self cancleExclusiveOrder];
//            }else{
//                [self sendCancleOrderWithOrderId:[dataArr[0] valueForKey:@"orderSendId"]];
//            }
//        }
//    }else
    if(sender.tag == 0){
        [self updateOrderStateWithOrderState:sender.tag];
// "执行下一步：联系客户";
    }else if(sender.tag == 1){
        [self updateOrderStateWithOrderState:sender.tag];
// "执行下一步：出发";
    }else if(sender.tag == 2){
        [self updateOrderStateWithOrderState:sender.tag];
// "执行下一步：开始服务";
    }else if(sender.tag == 3){
// "执行下一步：填写报告";
        NurseReportVC *nurseReportVC = [[NurseReportVC alloc] init];
        nurseReportVC.hidesBottomBarWhenPushed = YES;
        nurseReportVC.infoData = currentDic;
        nurseReportVC.isDetail = NO;
        [self.navigationController pushViewController:nurseReportVC animated:YES];
    }
    if (windowView) {
        [windowView removeFromSuperview];
    }
}

//执行下一步
- (void)updateOrderStateWithOrderState:(NSInteger)orderState{
    NSString *userAccount = [[NSUserDefaults standardUserDefaults] objectForKey:USERIDKEY];
    NSString *orderSendId = [currentDic valueForKey:@"orderSendId"];
    NSString *orderReceiverState = [NSString stringWithFormat:@"%ld",orderState+1];

    NSDictionary * params  = @{@"nurseId": userAccount,
                               @"orderSendId" : orderSendId,
                               @"orderReceiverState" : orderReceiverState};
    
    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:UPDATEORDERSTATE params:params success:^(AFHTTPRequestOperation* operation,id response){
        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSLog(@"respondString:%@",respondString);
        NSMutableDictionary *respondDict = [NSMutableDictionary dictionaryWithDictionary:[respondString objectFromJSONString]];
        
        [self.view makeToast:[NSString stringWithFormat:@"%@",[respondDict valueForKey:@"data"]] duration:1.2 position:@"center"];
        if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"200"]) {
            NSLog(@"success");
            [self reloadOrderData];
        }else if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"400"]){
            NSLog(@"faile");
        }
    } failure:^(NSError* err){
        NSLog(@"err:%@",err);
        [self.view makeToast:ERRORREQUESTTIP duration:2.0 position:@"center"];
    }];
}

- (void)reloadOrderData{
    currentPage = 0;
    if (dataArr && dataArr.count > 0) {
        [dataArr removeAllObjects];
    }
    switch (currentType) {
        case 0:
        {
            [self getDataWithUrl:ORDERLOOKRECEIVER];
//            [self getBadgeNums];
        }
            break;
        case 1:
        {
            [self getDataWithUrl:ORDERSTATENOW];
//            [self getBadgeNums];
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


//获取是否接单状态
- (void)getReceiveOrderSwitchState{
    NSString *userAccount = [[NSUserDefaults standardUserDefaults] objectForKey:USERIDKEY];
    NSDictionary * params  = @{@"nurseId": userAccount};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:ORDERRECEIVESTATE params:params success:^(AFHTTPRequestOperation* operation,id response){
        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSLog(@"respondString:%@",respondString);
        NSMutableDictionary *respondDict = [NSMutableDictionary dictionaryWithDictionary:[respondString objectFromJSONString]];
        if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"200"]) {
            NSLog(@"success");
            if ([[NSString stringWithFormat:@"%@",[respondDict valueForKey:@"json"]] isEqualToString:@"0"]) {
                /*
                 0.接
                 1.不接
                 */
                [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:RECEIVEORDERSTATE];
            }else{
                [[NSUserDefaults standardUserDefaults] setObject:@NO forKey:RECEIVEORDERSTATE];
            }
            [self resetSetSwitchBtState];
//            [self reloadOrderData];
        }else if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"400"]){
            NSLog(@"faile");
        }
        
        
    } failure:^(NSError* err){
        NSLog(@"err:%@",err);
        [self.view makeToast:ERRORREQUESTTIP duration:2.0 position:@"center"];
    }];
}

- (NSString *)getTimeWith:(id)value{
    NSString *time = @"";
    
    id zoneCreatetimeObj = value;
    if ([zoneCreatetimeObj isMemberOfClass:[NSNull class]] || zoneCreatetimeObj == nil) {
        NSTimeInterval  timeInterval = [[NSDate date] timeIntervalSince1970];
        zoneCreatetimeObj = [NSString stringWithFormat:@"%.0f000",timeInterval];
    }
    long long timestamp = [zoneCreatetimeObj longLongValue];
    NSString *zoneCreatetime = [NSString stringWithFormat:@"%lld",timestamp];
    if ([zoneCreatetime length] > 3) {
        //时间戳
        zoneCreatetime = [zoneCreatetime substringToIndex:[zoneCreatetime length] - 3];
    }
    time = [Tool convertTimespToString:[zoneCreatetime longLongValue] dateFormate:@"yyyy/MM/dd HH:MM:SS"];
    return time;
}

- (void)getBadgeNums{
    NSString *userAccount = [[NSUserDefaults standardUserDefaults] objectForKey:USERIDKEY];
    NSDictionary *params= @{@"nurseId" : userAccount,@"pageNow" : @"0"};

    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:ORDERSTATENOW params:params success:^(AFHTTPRequestOperation* operation,id response){
        
        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSMutableDictionary *respondDict = [NSMutableDictionary dictionaryWithDictionary:[respondString objectFromJSONString]];
        if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"200"]) {
            NSLog(@"success");
            if (badgeDataArr.count > 0) {
                [badgeDataArr removeAllObjects];
            }
            if ([[respondDict valueForKey:@"json"] isMemberOfClass:[NSNull class]] || [respondDict valueForKey:@"json"] == nil) {
                [self setBadgeTextWith:badgeDataArr.count];
                return ;
            }else{
                id jsonArray = [respondDict valueForKey:@"json"];
                if ([jsonArray isMemberOfClass:[NSNull class]] || jsonArray == nil) {
                    jsonArray = [NSArray array];
                }
                NSArray *tempArr = [NSArray arrayWithArray:[respondDict valueForKey:@"json"]];
                if (tempArr.count >0) {
                    [badgeDataArr addObjectsFromArray:tempArr];
                }
                [self setBadgeTextWith:badgeDataArr.count];
            }

        }else if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"400"]){
            NSLog(@"faile");
            [self setBadgeTextWith:0];
        }
    } failure:^(NSError* err){
        NSLog(@"err:%@",err);
        [self.view makeToast:ERRORREQUESTTIP duration:2.0 position:@"center"];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateOrder" object:nil];
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
