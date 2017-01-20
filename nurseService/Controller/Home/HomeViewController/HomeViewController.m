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
        
        
//        NSMutableArray *buttons = [[NSMutableArray alloc] init];
//        UIButton *scanBt = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
//        [scanBt setBackgroundImage:[UIImage imageNamed:@"icon_scan"] forState:UIControlStateNormal];
//        [scanBt addTarget:self action:@selector(scanAction) forControlEvents:UIControlEventTouchUpInside];
//        scanBt.backgroundColor = [UIColor clearColor];
//        UIBarButtonItem *scanItem = [[UIBarButtonItem alloc] initWithCustomView:scanBt];
//        [buttons addObject:scanItem];
//        UIButton *searchBt = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
//        [searchBt setBackgroundImage:[UIImage imageNamed:@"icon_search"] forState:UIControlStateNormal];
//        [searchBt addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
//        searchBt.backgroundColor = [UIColor clearColor];
//        UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithCustomView:searchBt];
//        [buttons addObject:searchItem];
//        self.navigationItem.rightBarButtonItems = buttons;
        
    }
    return self;
}

-(DLNavigationTabBar *)navigationTabBar
{
    if (!_navigationTabBar) {
        self.navigationTabBar = [[DLNavigationTabBar alloc] initWithTitles:@[@"精华",@"问题",@"神经内科",@"心血管"]];
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
    currentPage = 0;
    currentType = 0;
    dataArr = [[NSMutableArray alloc] initWithCapacity:0];
    currentDic = [[NSDictionary alloc] init];
    [super initializaiton];
}

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
        }
            break;
        default:
            [self getDataWithUrl:kThreeLevelDetails];
            break;
    }

}

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
                    [arrName addObject:[dic objectForKey:@"postTwoLevelName"]];
                }
                self.barTitleArr = arrName;
                [self.navigationTabBar setSubViewWithTitles:arrName];
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

- (void)getDataWithUrl:(NSString *)url{

//    NSString *userAccount = [[NSUserDefaults standardUserDefaults] objectForKey:USERIDKEY];


    NSDictionary * params;
    if (currentType == 0) {
        params= @{@"pageNum" : [NSString stringWithFormat:@"%d",(int)currentPage]};
    }else{
        NSString *postTwoLevelId = [[self.nurseFocusArr objectAtIndex:currentType-1] objectForKey:@"postTwoLevelId"];
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
    [self.view addSubview:self.navigationTabBar];
    UIButton *tagButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tagButton.frame = CGRectMake(SCREENWIDTH-44, 0, 44, 44);
    tagButton.backgroundColor = [UIColor colorWithWhite:237.0 / 255.0 alpha:1.0];
    [tagButton setImage:[UIImage imageNamed:@"icon_arrow_down.png"] forState:UIControlStateNormal];
    [tagButton addTarget:self action:@selector(showTag:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tagButton];
    
    NSArray * imageNames = @[@"index1", @"index2"];
    self.banner = [[LBBanner alloc] initWithImageNames:imageNames andFrame:CGRectMake(0, 0, SCREENWIDTH, 180)];
    _banner.delegate = self;
    self.banner.pageControlCenter = CGPointMake(SCREENWIDTH-50, 160);
    UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"index1"]];
    imageview.frame = CGRectMake(0, 0, SCREENWIDTH, 180);
    UIView * tableviewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 180)];
    [tableviewHeader addSubview:_banner];
    self.tableview.tableHeaderView = _banner;

    CGFloat noDataViewW = 50;
    CGFloat noDataViewY = (self.view.frame.size.height-44-48-noDataViewW)/2.0;
    CGFloat noDataViewX = (SCREENWIDTH-noDataViewW)/2.0;
    noDataView = [[UIImageView alloc] init];
    noDataView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:noDataView];
    noDataView.frame = CGRectMake(noDataViewX, noDataViewY, noDataViewW, noDataViewW);
    noDataView.image = [UIImage imageNamed:@"img_no_data"];
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
    NSDictionary *dic = [dataArr objectAtIndex:indexPath.row];
    NSLog(@"信息是%@",dic);
    cell.detailTextView.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"postThreeLevelDetailsSpeak"]];
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
    NSString *stopTimeStr = [Tool convertTimespToString:[zoneCreatetime longLongValue] dateFormate:@"MM-dd HH:MM"];

    cell.timeL.text = [NSString stringWithFormat:@"发布于%@",[stopTimeStr substringToIndex:5]];
    cell.nameL.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"postThreeLevelDetailsCreateter"]?@"小护健康":[dic objectForKey:@"postThreeLevelDetailsCreateter"]];
    cell.titleL.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"postThreeLevelDetailsTitle"]];
    cell.zanLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"postThreeLevelDetailsThingNumber"]];
    cell.backgroundColor = [UIColor colorWithWhite:244.0 / 255.0 alpha:1.0];

    return cell;
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;

    
    return 260;
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

    NSString *postTwoLevelId = @"";
    for (NSInteger i = 0; i < tagArr.count; i++) {
        for (int j = 0; j < self.allPostTag.count; j++) {
            NSDictionary *postDic = [NSDictionary dictionaryWithDictionary:self.allPostTag[j]];
            if ([tagArr[i] isEqualToString:[postDic valueForKey:@"postOneLevelName"]]) {
                
                postTwoLevelId = [postTwoLevelId stringByAppendingFormat:@",%@",[postDic valueForKey:@"postOneLevelId"]];
            }
        }
    }
    
    if (postTwoLevelId.length > 0) {
        postTwoLevelId = [postTwoLevelId substringFromIndex:1];
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
