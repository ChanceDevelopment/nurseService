//
//  HeMessageVC.m
//  nurseService
//
//  Created by Tony on 2017/1/11.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "HeMessageVC.h"
#import "HeBaseTableViewCell.h"
#import "MJRefreshAutoNormalFooter.h"
#import "MJRefreshNormalHeader.h"
#import "DLNavigationTabBar.h"

@interface HeMessageVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger pageNum;
    NSInteger currentType;
}
@property(strong,nonatomic)IBOutlet UITableView *tableview;
@property(strong,nonatomic)NSMutableArray *dataSource;
@property(nonatomic,strong)DLNavigationTabBar *navigationTabBar;

@end

@implementation HeMessageVC
@synthesize tableview;
@synthesize dataSource;

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
        label.text = @"站内信";
        [label sizeToFit];
        self.title = @"站内信";
        
        NSMutableArray *buttons = [[NSMutableArray alloc] init];
        UIButton *saveBt = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 25)];
        [saveBt setTitleColor:APPDEFAULTTITLECOLOR forState:UIControlStateNormal];
        [saveBt setTitle:@"清空" forState:UIControlStateNormal];
        saveBt.titleLabel.adjustsFontSizeToFitWidth = YES;
        saveBt.titleLabel.font = [UIFont systemFontOfSize:13.0];
        [saveBt addTarget:self action:@selector(cleanAction) forControlEvents:UIControlEventTouchUpInside];
        saveBt.backgroundColor = [UIColor clearColor];
        
        UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithCustomView:saveBt];
        [buttons addObject:searchItem];
        self.navigationItem.rightBarButtonItems = buttons;
    }
    return self;
}

-(DLNavigationTabBar *)navigationTabBar
{
    if (!_navigationTabBar) {
        self.navigationTabBar = [[DLNavigationTabBar alloc] initWithTitles:@[@"全部",@"系统消息",@"订单消息",@"资金消息"]];
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
    [self loadMessageWithType:currentType];
}

- (void)initializaiton
{
    [super initializaiton];
    pageNum = 0;
    currentType = 3;
    dataSource = [[NSMutableArray alloc] initWithCapacity:0];
}

- (void)initView
{
    [super initView];
    tableview.backgroundView = nil;
    tableview.backgroundColor = [UIColor colorWithWhite:237.0 /255.0 alpha:1.0];
    [Tool setExtraCellLineHidden:tableview];
    tableview.showsVerticalScrollIndicator = NO;
    tableview.showsHorizontalScrollIndicator = NO;

    [self.view addSubview:self.navigationTabBar];

    
//    __weak HeMessageVC *weakSelf = self;
//    self.tableview.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        // 进入刷新状态后会自动调用这个block,刷新
//        [weakSelf.tableview.header performSelector:@selector(endRefreshing) withObject:nil afterDelay:1.0];
//        pageNum = 0;
//        [weakSelf loadMessage];
//    }];
//    
//    self.tableview.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        self.tableview.footer.automaticallyHidden = YES;
//        self.tableview.footer.hidden = NO;
//        // 进入刷新状态后会自动调用这个block，加载更多
//        [weakSelf performSelector:@selector(endRefreshing) withObject:nil afterDelay:1.0];
//        pageNum++;
//        [weakSelf loadMessage];
//        
//    }];
//    
}

//- (void)endRefreshing
//{
//    [self.tableview.footer endRefreshing];
//    self.tableview.footer.hidden = YES;
//    self.tableview.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        self.tableview.footer.automaticallyHidden = YES;
//        self.tableview.footer.hidden = NO;
//        // 进入刷新状态后会自动调用这个block，加载更多
//        [self performSelector:@selector(endRefreshing) withObject:nil afterDelay:1.0];
//    }];
//    NSLog(@"endRefreshing");
//}

#pragma mark - PrivateMethod
- (void)navigationDidSelectedControllerIndex:(NSInteger)index {
    NSLog(@"index = %ld",index);
    switch (index) {
        case 0:
                currentType = 3;
            break;
        case 1:
                currentType = 2;
            break;
        case 2:
            currentType = 0;
            break;
        case 3:
            currentType = 1;
            break;
            
        default:
            break;
    }

    
    [self loadMessageWithType:currentType];
}
/*
 @brief 请求信息数据
 @prama type:信息类型
 @return
 */
- (void)loadMessageWithType:(NSInteger)type
{
    
    NSString *userId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:USERIDKEY]];
    
    NSDictionary *params = @{@"roleId":userId,
                             @"identity":@"1",
                             @"type":[NSString stringWithFormat:@"%ld",type]};
    [self showHudInView:self.view hint:@"正在获取..."];
    
    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:@"nurseAnduser/selectStandInnerLetterInfo.action" params:params success:^(AFHTTPRequestOperation* operation,id response){
        
        [self hideHud];
        if (dataSource) {
            [dataSource removeAllObjects];
        }
        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSDictionary *respondDict = [respondString objectFromJSONString];
        NSInteger statueCode = [[respondDict objectForKey:@"errorCode"] integerValue];
        
        if (statueCode == REQUESTCODE_SUCCEED){
            
            NSArray *resultArray = [respondDict objectForKey:@"json"];
            if ([resultArray isMemberOfClass:[NSNull class]]) {
                resultArray = [NSArray array];
            }
            
            [dataSource addObjectsFromArray:resultArray];
        }
        else{
            NSString *data = respondDict[@"data"];
            if ([data isMemberOfClass:[NSNull class]] || data == nil) {
                data = @"";
            }
            [self showHint:data];
        }
        if ([dataSource count] == 0) {
            UIView *bgView = [[UIView alloc] initWithFrame:self.view.bounds];
            UIImage *noImage = [UIImage imageNamed:@"img_no_data_refresh"];
            CGFloat scale = noImage.size.height / noImage.size.width;
            CGFloat imageW = 120;
            CGFloat imageH = imageW * scale;
            UIImageView *imageview = [[UIImageView alloc] initWithImage:noImage];
            imageview.frame = CGRectMake(100, 100, imageW, imageH);
            imageview.center = bgView.center;
            [bgView addSubview:imageview];
            tableview.backgroundView = bgView;
        }
        else{
            tableview.backgroundView = nil;
        }
        [self.tableview reloadData];
    } failure:^(NSError* err){
        NSLog(@"err:%@",err);
        [self hideHud];
        [self showHint:ERRORREQUESTTIP];
    }];

    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataSource count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    static NSString *cellIndentifier = @"HeUserCellIndentifier";
    CGSize cellSize = [tableView rectForRowAtIndexPath:indexPath].size;
    
    
    HeBaseTableViewCell *cell  = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[HeBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSDictionary *dict = nil;
    @try {
        dict = dataSource[row];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    CGFloat contentLabelX = 10;
    CGFloat contentLabelW = SCREENWIDTH - 2 * contentLabelX;
    UIFont *textFont = [UIFont systemFontOfSize:16.0];
    NSString *standInnerLetterContent = dict[@"standInnerLetterContent"];
    if ([standInnerLetterContent isMemberOfClass:[NSNull class]] || standInnerLetterContent == nil) {
        standInnerLetterContent = @"";
    }
    CGSize size = [MLLabel getViewSizeByString:standInnerLetterContent maxWidth:contentLabelW font:textFont lineHeight:1.2f lines:0];
    CGFloat contentLabelY = 0;
    CGFloat contentLabelH = size.height;
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(contentLabelX, contentLabelY, contentLabelW, contentLabelH)];
    contentLabel.backgroundColor = [UIColor clearColor];
    contentLabel.font = [UIFont systemFontOfSize:15.0];
    contentLabel.textColor = [UIColor blackColor];
    contentLabel.numberOfLines = 0;
    [cell addSubview:contentLabel];
    
    contentLabel.text = standInnerLetterContent;
    
    
    CGFloat timeLabelX = 10;
    CGFloat timeLabelY = CGRectGetMaxY(contentLabel.frame)-5;
    CGFloat timeLabelH = 30;
    CGFloat timeLabelW = SCREENWIDTH - 2 * timeLabelX;
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(timeLabelX, timeLabelY, timeLabelW, timeLabelH)];
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.font = [UIFont systemFontOfSize:13.0];
    timeLabel.textAlignment = NSTextAlignmentRight;
    timeLabel.textColor = [UIColor grayColor];
    [cell addSubview:timeLabel];
    
    
    id zoneCreatetimeObj = [dict objectForKey:@"standInnerLetterCreatetime"];
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
    
    NSString *time = [Tool convertTimespToString:[zoneCreatetime longLongValue] dateFormate:@"YYYY-MM-dd HH:mm:ss"];
    timeLabel.text = time;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    NSDictionary *dict = nil;
    @try {
        dict = dataSource[row];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    CGFloat contentLabelX = 10;
    CGFloat contentLabelW = SCREENWIDTH - 2 * contentLabelX;
    UIFont *textFont = [UIFont systemFontOfSize:16.0];
    NSString *standInnerLetterContent = dict[@"standInnerLetterContent"];
    if ([standInnerLetterContent isMemberOfClass:[NSNull class]] || standInnerLetterContent == nil) {
        standInnerLetterContent = @"";
    }
    CGSize size = [MLLabel getViewSizeByString:standInnerLetterContent maxWidth:contentLabelW font:textFont lineHeight:1.2f lines:0];
    return 25.0+size.height;
}
//清空数据
- (void)cleanAction{
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:USERIDKEY];
    if (!userId) {
        userId = @"";
    }
    NSDictionary *requestMessageParams = @{@"roleId":userId,
                                           @"identity":@"1",
                                           @"type":[NSString stringWithFormat:@"%ld",currentType]};
    [self showHudInView:self.view hint:@"正在获取..."];
    
    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:@"nurseAnduser/deleteStandInnerLetterInfo.action" params:requestMessageParams success:^(AFHTTPRequestOperation* operation,id response){
        [self hideHud];
        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSDictionary *respondDict = [respondString objectFromJSONString];
        NSInteger statueCode = [[respondDict objectForKey:@"errorCode"] integerValue];
        
        if (statueCode == REQUESTCODE_SUCCEED){
            [self loadMessageWithType:currentType];
        }
        else{
            NSString *data = respondDict[@"data"];
            if ([data isMemberOfClass:[NSNull class]] || data == nil) {
                data = @"";
            }
            [self showHint:data];
        }
    } failure:^(NSError *error){
        [self hideHud];
        [self showHint:ERRORREQUESTTIP];
    }];
    
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
