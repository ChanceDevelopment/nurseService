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
#import "HomeWebViewController.h"
#import "DFLineJoinItem.h"
#import "ActivityLogModel.h"
#include <string.h>
#import "HeSysbsModel.h"
#import "DFBaseLineCell.h"
#import "HomeTableViewCell.h"

@interface HomeViewController ()<LBBannerDelegate,UITableViewDelegate,UITableViewDataSource>
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
    [self.tableview.header beginRefreshing];
    [self getRollPic];
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

- (void)getRollPic
{
    NSDictionary * params;
    NSString *url = @"post/selectPostRollPicInfo.action";
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

    NSString *userAccount = [[NSUserDefaults standardUserDefaults] objectForKey:USERIDKEY];
    NSDictionary * params;
    if (currentType == 0) {
        params= @{@"pageNum" : [NSString stringWithFormat:@"%ld",currentPage]};
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
//                if (currentType != 2) {
//                    noDataView.hidden = NO;
//                    myTableView.hidden = YES;
//                }

                return ;
            }else{
                NSArray *tempArr = [NSArray arrayWithArray:[respondDict valueForKey:@"json"]];
                switch (currentType) {
                    case 0:
                    {
//                        CGFloat tableViewY = 44;
//                        CGFloat tableViewH = self.view.frame.size.height-44-120-48+80;
//                        tableview.frame = CGRectMake(0, tableViewY, SCREENWIDTH, tableViewH);
                        if (tempArr.count >0){
//                            if (_footerView == nil) {
//                                [self initFooterView];
//                            }
                            noDataView.hidden = YES;
                            tableview.hidden = NO;
                        }else{
                            noDataView.hidden = NO;
                            tableview.hidden = YES;
                        }
                    }
                        break;
                    case 1:
                    {

                        CGFloat tableViewY = 44;
                        CGFloat tableViewH = self.view.frame.size.height-44-48+80;
//                        myTableView.frame = CGRectMake(0, tableViewY, SCREENWIDTH, tableViewH);
//                        if (footerView) {
//                            [footerView removeFromSuperview];
//                            footerView = nil;
//                        }
//                        if (tempArr.count >0){
//                            noDataView.hidden = YES;
//                            myTableView.hidden = NO;
//                        }else{
//                            noDataView.hidden = NO;
//                            myTableView.hidden = YES;
//                        }
                    }
                        break;
                    case 2:
                    {
//                        if (footerView) {
//                            [footerView removeFromSuperview];
//                            footerView = nil;
//                        }
//                        CGFloat tableViewY = 44;
//                        CGFloat tableViewH = self.view.frame.size.height-44-48+50;
//                        myTableView.frame = CGRectMake(0, tableViewY, SCREENWIDTH, tableViewH);
//                        if (tempArr.count >0){
//                            noDataView.hidden = YES;
//                            myTableView.hidden = NO;
//                        }else{
//                            noDataView.hidden = NO;
//                            myTableView.hidden = YES;
//                        }
                    }
                        break;
                    default:
                        break;
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
    
    NSArray * imageNames = @[@"index1", @"index2"];
    self.banner = [[LBBanner alloc] initWithImageNames:imageNames andFrame:CGRectMake(0, 0, SCREENWIDTH, 180)];
    _banner.delegate = self;
    self.banner.pageControlCenter = CGPointMake(SCREENWIDTH-50, 160);
    UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"index1"]];
    imageview.frame = CGRectMake(0, 0, SCREENWIDTH, 180);
    UIView * tableviewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 180)];
    [tableviewHeader addSubview:_banner];
    self.tableview.tableHeaderView = _banner;
    
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
    NSInteger row = indexPath.row;
    
    static NSString *cellIndentifier = @"HomeTableViewCell";
    CGSize cellSize = [tableView rectForRowAtIndexPath:indexPath].size;
    NSDictionary *dict = nil;
    
    HomeTableViewCell *cell  = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[HomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier cellSize:cellSize];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *dic = [dataArr objectAtIndex:indexPath.row];
    NSLog(@"信息是%@",dic);
    cell.detailTextView.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"postThreeLevelDetailsSpeak"]];
    NSString *timeString = [self changeTimeToString:[dic objectForKey:@"postThreeLevelDetailsCreatetime"]];
    NSRange range = [timeString rangeOfString:@"-"];

    cell.timeL.text = [NSString stringWithFormat:@"发布于%@",[timeString substringWithRange:NSMakeRange(range.location+1, 11)]];
    cell.nameL.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"postThreeLevelDetailsCreateter"]];
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

- (NSString *)changeTimeToString:(NSString *)miloTime
{
    NSTimeInterval time=[miloTime doubleValue]+28800;//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSLog(@"date:%@",[detaildate description]);
        //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    return currentDateStr;
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
