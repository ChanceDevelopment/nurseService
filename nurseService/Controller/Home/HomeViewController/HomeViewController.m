//
//  HomeViewController.m
//  nurseService
//
//  Created by Tony on 2016/12/14.
//  Copyright © 2016年 iMac. All rights reserved.
//

#import "HomeViewController.h"
#import "DLNavigationTabBar.h"
#import "LBBanner.h"
#import "MJRefreshNormalHeader.h"
#import "MJRefreshAutoNormalFooter.h"
#import "HeStudyTableCell.h"
#import "DFTextImageLineItem.h"
#import "DFLineLikeItem.h"
#import "DFLineCommentItem.h"
#import "DFActivityLineItem.h"
//#import "HeDistributeVC.h"
//#import "HeActivityDetailVC.h"
#import "TagViewController.h"
#import "HomeWebViewController.h"
#import "DFLineJoinItem.h"
#import "ActivityLogModel.h"
#include <string.h>
#import "HeSysbsModel.h"
#import "DFBaseLineCell.h"
#import "HomeTableViewCell.h"
#import "MLLabel+Size.h"

@interface HomeViewController ()<LBBannerDelegate,UITableViewDelegate,UITableViewDataSource,ViewControllerDelegate>
{
    NSInteger currentPage;
    NSInteger currentType;
    NSMutableArray *dataArr;
    NSDictionary *currentDic;
    UIImageView *noDataView;


}
@property(nonatomic,strong)DLNavigationTabBar *navigationTabBar;
@property(strong,nonatomic)IBOutlet UIView *tabBarBG;
@property(strong,nonatomic)IBOutlet UITableView *tableview;
@property(strong,nonatomic)IBOutlet UIView *footerView;
@property (nonatomic, strong) LBBanner * banner;
@property (nonatomic, strong) NSArray *nurseFocusArr;
@property (nonatomic, strong) NSArray *barTitleArr;
@property (nonatomic, strong) NSArray *allPostTag;
@property(nonatomic,strong)NSCache *imageCache;

@end

@implementation HomeViewController
@synthesize tabBarBG;
@synthesize tableview;

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
        label.text = @"学术圈";
        [label sizeToFit];
        self.title = @"首页";
        self.navigationItem.titleView.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}
//初始化导航条
-(DLNavigationTabBar *)navigationTabBar
{
    if (!_navigationTabBar) {
        NSArray *focus = [[NSUserDefaults standardUserDefaults] objectForKey:kUserFoucus];
        if ([focus count] == 0) {
            focus = @[@"精华"];//,@"问题"
        }
        self.navigationTabBar = [[DLNavigationTabBar alloc] initWithTitles:focus];
        self.navigationTabBar.backgroundColor = [UIColor colorWithWhite:237.0 / 255.0 alpha:1.0];
        self.navigationTabBar.frame = CGRectMake(0, 0, SCREENWIDTH-44, 44);
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
    [self getAllTag];
    [self.tableview.header beginRefreshing];
    [self getRollPic];
    [self getNurseFoucesPostInfo];
    
}

- (void)initializaiton
{
    _imageCache = [[NSCache alloc] init];
    currentPage = 0;
    currentType = 0;
    dataArr = [[NSMutableArray alloc] initWithCapacity:0];
    currentDic = [[NSDictionary alloc] init];
    [super initializaiton];
}
//根据当前选中的导航条类型请求数据
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
            [self getDataWithUrl:ESSENCEARTICLE];
            break;
        }
        default:
            [self getDataWithUrl:kThreeLevelDetails];
            break;
    }

}
//根绝url类型请求数据
- (void)reloadData{
    currentPage = 0;
    if (dataArr && dataArr.count > 0) {
        [dataArr removeAllObjects];
    }
    switch (currentType) {
        case 0:
        {
            [self getDataWithUrl:ESSENCEARTICLE];
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
//所有的导航条类型
- (void)getAllTag
{

    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:ALLPOSTINFODETAIL params:nil success:^(AFHTTPRequestOperation* operation,id response){

        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSMutableDictionary *respondDict = [NSMutableDictionary dictionaryWithDictionary:[respondString objectFromJSONString]];
        if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"200"]) {
            NSLog(@"success");
            if ([[respondDict valueForKey:@"json"] isMemberOfClass:[NSNull class]] || [respondDict valueForKey:@"json"] == nil) {
                [self.view makeToast:[NSString stringWithFormat:@"%@",[respondDict valueForKey:@"data"]] duration:1.2 position:@"center"];
                return ;
            }else{
                NSArray *tempArr = [NSArray arrayWithArray:[respondDict valueForKey:@"json"]];
                NSLog(@"所有的tag%@",tempArr);
                self.allPostTag = tempArr;
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

- (void)getNurseFoucesPostInfo
{
    NSString *userAccount = [[NSUserDefaults standardUserDefaults] objectForKey:USERIDKEY];
    NSDictionary * params=@{@"nurseId" : userAccount};

    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:NURSESELECTPOST params:params success:^(AFHTTPRequestOperation* operation,id response){

        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSMutableDictionary *respondDict = [NSMutableDictionary dictionaryWithDictionary:[respondString objectFromJSONString]];
        if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"200"]) {
            NSLog(@"success");
            if ([[respondDict valueForKey:@"json"] isMemberOfClass:[NSNull class]] || [respondDict valueForKey:@"json"] == nil) {
                [self.view makeToast:[NSString stringWithFormat:@"%@",[respondDict valueForKey:@"data"]] duration:1.2 position:@"center"];
                return ;
            }else{
                NSArray *tempArr = [NSArray arrayWithArray:[respondDict valueForKey:@"json"]];
                NSMutableArray *arrName = @[].mutableCopy;
                [arrName addObject:@"精华"];
                self.nurseFocusArr = tempArr;
                for (NSDictionary *dic in tempArr) {
                    NSString *postTwoLevelName = dic[@"postTwoLevelName"];
                    if ([postTwoLevelName isMemberOfClass:[NSNull class]] || postTwoLevelName == nil) {
                        postTwoLevelName = @"";
                    }
                    [arrName addObject:postTwoLevelName];
                }
                [[NSUserDefaults standardUserDefaults] setObject:arrName forKey:kUserFoucus];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                self.barTitleArr = [[NSArray alloc] initWithArray:arrName];
                [self.navigationTabBar setSubViewWithTitles:arrName];
            }
        }
        else if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"300"]){
            NSArray *tempArr = [NSArray array];
            NSMutableArray *arrName = @[].mutableCopy;
            [arrName addObject:@"精华"];
            self.nurseFocusArr = tempArr;
            for (NSDictionary *dic in tempArr) {
                NSString *postTwoLevelName = dic[@"postTwoLevelName"];
                if ([postTwoLevelName isMemberOfClass:[NSNull class]] || postTwoLevelName == nil) {
                    postTwoLevelName = @"";
                }
                [arrName addObject:postTwoLevelName];
            }
            [[NSUserDefaults standardUserDefaults] setObject:arrName forKey:kUserFoucus];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            self.barTitleArr = [[NSArray alloc] initWithArray:arrName];
            [self.navigationTabBar setSubViewWithTitles:arrName];
        }
        else if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"400"]){
            NSLog(@"faile");
            [self.view makeToast:[NSString stringWithFormat:@"%@",[respondDict valueForKey:@"data"]] duration:1.2 position:@"center"];
        }
    } failure:^(NSError* err){
        NSLog(@"err:%@",err);
        [self.view makeToast:ERRORREQUESTTIP duration:2.0 position:@"center"];
    }];
}

//获取滚动图片数据
- (void)getRollPic
{
    NSDictionary * params;
    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:ROLLPICTURE params:params success:^(AFHTTPRequestOperation* operation,id response){

        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSMutableDictionary *respondDict = [NSMutableDictionary dictionaryWithDictionary:[respondString objectFromJSONString]];
        if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"200"]) {
            NSLog(@"success");
            if ([[respondDict valueForKey:@"json"] isMemberOfClass:[NSNull class]] || [respondDict valueForKey:@"json"] == nil) {
                [self.view makeToast:[NSString stringWithFormat:@"%@",[respondDict valueForKey:@"data"]] duration:1.2 position:@"center"];
                return ;
            }else{
                NSArray *tempArr = [NSArray arrayWithArray:[respondDict valueForKey:@"json"]];
                NSMutableArray *imageUrl = @[].mutableCopy;
                for (NSDictionary *dic in tempArr) {
                    NSString *url = [NSString stringWithFormat:@"%@%@",BASEURL,[dic objectForKey:@"postRollPicUrl"]];
                    [imageUrl addObject:url];
                }
                self.banner.imageURLArray = imageUrl;
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
//获取滚动图片下方数据
- (void)getDataWithUrl:(NSString *)url{
    NSDictionary * params;
    if (currentType == 0) {
        params= @{@"pageNum" : [NSString stringWithFormat:@"%d",(int)currentPage]};
    }else{
        NSDictionary *dict = nil;
        @try {
            dict = [self.nurseFocusArr objectAtIndex:currentType - 1];
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
        NSString *postTwoLevelId = dict[@"postTwoLevelId"];
        if ([postTwoLevelId isMemberOfClass:[NSNull class]] || postTwoLevelId == nil) {
            postTwoLevelId = @"";
        }
        params= @{@"postTwoLevelId" : postTwoLevelId,@"pageNum" : [NSString stringWithFormat:@"%d",(int)currentPage]};
    }

    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:url params:params success:^(AFHTTPRequestOperation* operation,id response){

        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSMutableDictionary *respondDict = [NSMutableDictionary dictionaryWithDictionary:[respondString objectFromJSONString]];
        if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"200"]) {
            NSLog(@"success");
            if ([[respondDict valueForKey:@"json"] isMemberOfClass:[NSNull class]] || [respondDict valueForKey:@"json"] == nil) {
                [self.view makeToast:[NSString stringWithFormat:@"%@",[respondDict valueForKey:@"data"]] duration:1.2 position:@"center"];
                noDataView.hidden = NO;
                tableview.hidden = YES;
                return ;
            }else{
                NSArray *tempArr = [NSArray arrayWithArray:[respondDict valueForKey:@"json"]];
                if (tempArr.count >0){
                    noDataView.hidden = YES;
                    tableview.hidden = NO;
                }else{
                    noDataView.hidden = NO;
                    tableview.hidden = YES;
                }

                if (tempArr.count >0) {
                    currentPage++;
                    [dataArr addObjectsFromArray:tempArr];
                    [tableview reloadData];
                }else{
                    [tableview reloadData];
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



- (void)initView
{
    [super initView];
    
    tableview.backgroundView = nil;
    tableview.backgroundColor = [UIColor colorWithWhite:237.0 / 255.0 alpha:1.0];
    [Tool setExtraCellLineHidden:tableview];
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.navigationTabBar];
    
    UIView *btView = [[UIView alloc] initWithFrame:CGRectMake(SCREENWIDTH - 44, 0, 44, 44)];
    btView .backgroundColor = [UIColor colorWithWhite:237.0 / 255.0 alpha:1.0];
    [self.view addSubview:btView];
    
    UIButton *tagButton = [[UIButton alloc] init];
    
    CGFloat buttonH = 25;
    CGFloat buttonW = 25;
    CGFloat buttonX = (44 - buttonW) / 2.0;
    CGFloat buttonY = (44 - buttonH) / 2.0;
    
    tagButton.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
    tagButton.backgroundColor = [UIColor colorWithWhite:237.0 / 255.0 alpha:1.0];
    [tagButton setImage:[UIImage imageNamed:@"icon_arrow_down.png"] forState:UIControlStateNormal];
    [tagButton addTarget:self action:@selector(showTag:) forControlEvents:UIControlEventTouchUpInside];
    [btView addSubview:tagButton];
    
    NSArray * imageNames = @[@"index1", @"index2"];
    self.banner = [[LBBanner alloc] initWithImageNames:imageNames andFrame:CGRectMake(0, 0, SCREENWIDTH, 180)];
    _banner.delegate = self;
    self.banner.pageControlCenter = CGPointMake(SCREENWIDTH-50, 160);
    UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"index1"]];
    imageview.frame = CGRectMake(0, 0, SCREENWIDTH, 180);
    UIView * tableviewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 180)];
    [tableviewHeader addSubview:_banner];
    self.tableview.tableHeaderView = _banner;

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
    
    self.tableview.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block,刷新
        [self.tableview.header performSelector:@selector(endRefreshing) withObject:nil afterDelay:1.0];
        [self reloadData];
    }];
    
    self.tableview.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.tableview.footer.automaticallyHidden = YES;
        self.tableview.footer.hidden = NO;
        // 进入刷新状态后会自动调用这个block，加载更多
        [self performSelector:@selector(endRefreshing) withObject:nil afterDelay:1.0];
    }];
}

- (void)endRefreshing
{
    [self.tableview.footer endRefreshing];
    self.tableview.footer.hidden = YES;
    self.tableview.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.tableview.footer.automaticallyHidden = YES;
        self.tableview.footer.hidden = NO;
        // 进入刷新状态后会自动调用这个block，加载更多
        [self performSelector:@selector(endRefreshing) withObject:nil afterDelay:1.0];
    }];
    NSLog(@"endRefreshing");
}


#pragma mark LBBannerDelegate
- (void)banner:(LBBanner *)banner didClickViewWithIndex:(NSInteger)index {
    NSLog(@"didClickViewWithIndex:%ld", index);
}

- (void)banner:(LBBanner *)banner didChangeViewWithIndex:(NSInteger)index {
    NSLog(@"didChangeViewWithIndex:%ld", index);
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
    static NSString *cellIndentifier = @"HomeTableViewCell";
    CGSize cellSize = [tableView rectForRowAtIndexPath:indexPath].size;
    HomeTableViewCell *cell  = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[HomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier cellSize:cellSize];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *dic = nil;
    @try {
        dic = [dataArr objectAtIndex:indexPath.row];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    NSLog(@"信息是%@",dic);
    
    NSString *postThreeLevelDetailsTitle = dic[@"postThreeLevelDetailsTitle"];
    if ([postThreeLevelDetailsTitle isMemberOfClass:[NSNull class]] || postThreeLevelDetailsTitle == nil) {
        postThreeLevelDetailsTitle = @"";
    }
    CGSize titleSize = [MLLabel getViewSizeByString:postThreeLevelDetailsTitle maxWidth:SCREENWIDTH - 20 font:cell.titleL.font lineHeight:1.2f lines:0];
    if (titleSize.height < 30) {
        titleSize.height = 30;
    }
    CGRect titleFrame = cell.titleL.frame;
    titleFrame.size.width = titleSize.width;
    titleFrame.size.height = titleSize.height;
    cell.titleL.frame = titleFrame;
    
    cell.titleL.text = [NSString stringWithFormat:@"%@",postThreeLevelDetailsTitle];
    
    NSString *postThreeLevelDetailsSpeak = [dic objectForKey:@"postThreeLevelDetailsSpeak"];
    if ([postThreeLevelDetailsSpeak isMemberOfClass:[NSNull class]]) {
        postThreeLevelDetailsSpeak = @"";
    }
    CGRect detailFrame = cell.detailTextView.frame;
    CGSize mySize = [MLLabel getViewSizeByString:postThreeLevelDetailsSpeak maxWidth:cell.detailTextView.frame.size.width font:cell.detailTextView.font lineHeight:1.2f lines:0];
    if (mySize.height < 30) {
        mySize.height = 30;
    }
    detailFrame.origin.y = CGRectGetMaxY(cell.titleL.frame) + 5;
    detailFrame.size.width = mySize.width;
    detailFrame.size.height = mySize.height;
    cell.detailTextView.frame = detailFrame;
    cell.detailTextView.text = [NSString stringWithFormat:@"%@",postThreeLevelDetailsSpeak];
    

    id zoneCreatetimeObj = [dic objectForKey:@"postThreeLevelDetailsCreatetime"];
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
    NSString *stopTimeStr = [Tool convertTimespToString:[zoneCreatetime longLongValue] dateFormate:@"MM-dd HH:mm"];

    cell.timeL.text = [NSString stringWithFormat:@"发布于%@",[stopTimeStr substringToIndex:5]];
    cell.nameL.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"postThreeLevelDetailsCreateter"]?@"小护健康":[dic objectForKey:@"postThreeLevelDetailsCreateter"]];
    
    
//    cell.zanLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"postThreeLevelDetailsThingNumber"]];
    cell.backgroundColor = [UIColor colorWithWhite:244.0 / 255.0 alpha:1.0];

    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    NSDictionary *dict = nil;
    @try {
        dict = dataArr[row];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    NSString *postThreeLevelDetailsSpeak = [dict objectForKey:@"postThreeLevelDetailsSpeak"];
    if ([postThreeLevelDetailsSpeak isMemberOfClass:[NSNull class]]) {
        postThreeLevelDetailsSpeak = @"";
    }
    CGSize mySize = [MLLabel getViewSizeByString:postThreeLevelDetailsSpeak maxWidth:SCREENWIDTH - 20 font:[UIFont systemFontOfSize:14.0] lineHeight:1.2f lines:0];
    if (mySize.height < 30) {
        mySize.height = 30;
    }
    
    NSString *postThreeLevelDetailsTitle = dict[@"postThreeLevelDetailsTitle"];
    if ([postThreeLevelDetailsTitle isMemberOfClass:[NSNull class]] || postThreeLevelDetailsTitle == nil) {
        postThreeLevelDetailsTitle = @"";
    }
    CGSize titleSize = [MLLabel getViewSizeByString:postThreeLevelDetailsTitle maxWidth:SCREENWIDTH - 20 font:[UIFont systemFontOfSize:15.0] lineHeight:1.2f lines:0];
    if (titleSize.height < 30) {
        titleSize.height = 30;
    }
    
    
    return 135 + (mySize.height + 10) + (titleSize.height - 30);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    NSDictionary *dic = [dataArr objectAtIndex:indexPath.row];
    NSString *articleId = [dic objectForKey:@"postThreeLevelDetailsId"];
    NSString *userAccount = [[NSUserDefaults standardUserDefaults] objectForKey:USERIDKEY];
    NSString *url = [NSString stringWithFormat:@"%@sendPostThreeInfoByThreeId.action?postThreeLevelDetailsId=%@&nurseId=%@",BASEURL,articleId,userAccount];
    HomeWebViewController* webViewController = [[HomeWebViewController alloc] init];
    webViewController.hidesBottomBarWhenPushed = YES;
    webViewController.urlString = url;
    webViewController.dataDic = dic;
    [self.navigationController pushViewController:webViewController animated:YES];

}

- (void)searchAction{
    NSLog(@"searchAction");
}

- (void)scanAction{
    NSLog(@"scanAction");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)showTag:(UIButton *)sender
{
    TagViewController *VC = [[TagViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:VC];
    NSMutableString *string = [[NSMutableString alloc]initWithString:@""];
    for (int i = 0;i<self.barTitleArr.count;i++) {
        NSString *title = self.barTitleArr[i];
        if (i==0) {
            continue;
        }
        if (i == self.barTitleArr.count -1) {
            [string appendFormat:@"%@",title];
        }else{
            [string appendFormat:@"%@ ",title];
        }
    }
    VC.bqlabStr = string;
    VC.tagListArr = self.allPostTag;
    VC.delegate = self;
    [self presentViewController:navi animated:YES completion:nil];

}

#pragma mark - 实现标签页的代理方法(传回来的标签字符串)
- (void)updateTagsLabelWithTagsString:(NSString *)tags {

    NSLog(@"回掉tag %@",tags);
    
    
    if ([tags isEqualToString:@""]) {
        [self upladAllTagsWith:@""];
        return;
    }
    NSArray *tagArr = [tags componentsSeparatedByString:@" "];

    NSMutableString *postTwoLevelId = [[NSMutableString alloc] initWithCapacity:0];
    for (NSInteger i = 0; i < tagArr.count; i++) {
        for (int j = 0; j < self.allPostTag.count; j++) {
            NSDictionary *postDic = [NSDictionary dictionaryWithDictionary:self.allPostTag[j]];
            NSString *postTwoInfo = postDic[@"postTwoInfo"];
            if ([postTwoInfo isMemberOfClass:[NSNull class]] || postTwoInfo == nil) {
                postTwoInfo = @"";
            }
            NSArray *postTwoInfoArray = [postTwoInfo objectFromJSONString];
            for (NSDictionary *dict in postTwoInfoArray) {
                NSString *tagName = tagArr[i];
                NSString *PostTwoLevelName = [dict valueForKey:@"PostTwoLevelName"];
                if ([PostTwoLevelName isMemberOfClass:[NSNull class]] || PostTwoLevelName == nil) {
                    PostTwoLevelName = @"";
                }
                if ([tagName isEqualToString:PostTwoLevelName]) {
                    NSString *tempPostTwoLevelId = [dict valueForKey:@"PostTwoLevelId"];
                    if ([tempPostTwoLevelId isMemberOfClass:[NSNull class]] || tempPostTwoLevelId == nil) {
                        tempPostTwoLevelId = @"";
                    }
                    if (postTwoLevelId.length == 0) {
                        [postTwoLevelId appendString:tempPostTwoLevelId];
                    }
                    else{
                        [postTwoLevelId appendFormat:@",%@",tempPostTwoLevelId];
                    }
                    break;
                }
            }
            
        }
    }
    
//    if (postTwoLevelId.length > 0) {
//        postTwoLevelId = [postTwoLevelId substringFromIndex:1];
//    }
    if (postTwoLevelId.length == 0 || postTwoLevelId == nil) {
        postTwoLevelId = [[NSMutableString alloc] initWithString:@""];
    }
    [self upladAllTagsWith:postTwoLevelId];
}

//提交所选标签
- (void)upladAllTagsWith:(NSString *)postTwoLevelId{
    NSString *nurseId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:USERIDKEY]];
    
    NSDictionary * params = @{@"nurseId" : nurseId,@"postTwoLevelId" : postTwoLevelId};
    
    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:@"post/AddPostNursefFocus.action" params:params success:^(AFHTTPRequestOperation* operation,id response){
        
        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSMutableDictionary *respondDict = [NSMutableDictionary dictionaryWithDictionary:[respondString objectFromJSONString]];
        if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"200"]) {
            NSLog(@"success");
            
            [self getNurseFoucesPostInfo];
        
        }else if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"400"]){
            NSLog(@"faile");
            [self.view makeToast:[NSString stringWithFormat:@"%@",[respondDict valueForKey:@"data"]] duration:1.2 position:@"center"];
        }
    } failure:^(NSError* err){
        NSLog(@"err:%@",err);
        [self.view makeToast:ERRORREQUESTTIP duration:2.0 position:@"center"];
    }];
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
