//
//  MyReportListVC.m
//  nurseService
//
//  Created by 梅阳阳 on 17/2/15.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "MyReportListVC.h"
#import "HeBaseTableViewCell.h"
#import "MJRefreshAutoNormalFooter.h"
#import "NurseReportVC.h"

@interface MyReportListVC ()
{
    UIImageView *noDataView;
    NSMutableArray *dataArr;
    NSInteger currentPage;

}
@property (strong, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation MyReportListVC
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
        label.text = @"护理报告";
        [label sizeToFit];
        self.title = @"护理报告";
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initializaiton];
    [self initView];
    [self getData];

}

- (void)initializaiton
{
    [super initializaiton];
    dataArr = [[NSMutableArray alloc] initWithCapacity:0];
    currentPage = 0;
}

- (void)initView
{
    [super initView];
    self.view.backgroundColor = [UIColor colorWithWhite:237.0 /255.0 alpha:1.0];
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
    
    [tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    self.tableview.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.tableview.footer.automaticallyHidden = YES;
        self.tableview.footer.hidden = NO;
        // 进入刷新状态后会自动调用这个block，加载更多
        //处理上拉后的逻辑
        [self getData];
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
    
}

- (void)getData{
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:USERIDKEY];
    NSDictionary * params  = @{@"nurseId": userId,@"pageNum" : [NSString stringWithFormat:@"%ld",currentPage]};
    
    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:ALLREPORTBYNURSE params:params success:^(AFHTTPRequestOperation* operation,id response){
        
        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSMutableDictionary *respondDict = [NSMutableDictionary dictionaryWithDictionary:[respondString objectFromJSONString]];
        if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"200"]||[[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"300"]) {
            NSLog(@"success");
            
            if ([[respondDict valueForKey:@"json"] isMemberOfClass:[NSNull class]] || [respondDict valueForKey:@"json"] == nil) {
                
                noDataView.hidden = NO;
                tableview.hidden = YES;
                return ;
            }else{
                NSArray *tempArr = [NSArray arrayWithArray:[respondDict valueForKey:@"json"]];
                if (tempArr.count > 0) {
                    currentPage++;
                    
                    [dataArr addObjectsFromArray:tempArr];
                    [tableview reloadData];
                    noDataView.hidden = YES;
                    tableview.hidden = NO;
                }else{
                    if (currentPage == 0 && tempArr.count == 0) {
                        noDataView.hidden = NO;
                        tableview.hidden = YES;
                    }
                    return ;
                }
            }
        }else if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"400"]){
            NSLog(@"faile");
            NSString *data = [NSString stringWithFormat:@"%@",[respondDict valueForKey:@"data"]];
            if ([data isMemberOfClass:[NSNull class]] || data == nil) {
                data = ERRORREQUESTTIP;
            }
            [self.view makeToast:data duration:1.2 position:@"center"];
        }
    } failure:^(NSError* err){
        NSLog(@"err:%@",err);
        [self.view makeToast:ERRORREQUESTTIP duration:2.0 position:@"center"];
    }];
    
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
    NSDictionary *dict;
    @try {
        dict = [NSDictionary dictionaryWithDictionary:dataArr[row]];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    HeBaseTableViewCell *cell  = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[HeBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier cellSize:cellSize];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    CGFloat itemX = 10;
    CGFloat itemY = 10;
    CGFloat itemW = SCREENWIDTH-20;
    CGFloat itemH = 80/3.0;
    
    NSString *sex = [[dict valueForKey:@"protectedPersonSex"] integerValue] == 1 ? @"男" : @"女";
    NSString *nameStr = [NSString stringWithFormat:@"%@",[dict valueForKey:@"protectedPersonName"]];
    //        NSArray *nameArr = [nameStr componentsSeparatedByString:@","];
    @try {
        //            nameStr = nameArr[1];
    } @catch (NSException *exception) {
    } @finally {
        
    }

    UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(itemX, itemY, itemW, itemH)];
    nameL.textColor = [UIColor blackColor];
    nameL.font = [UIFont systemFontOfSize:13.0];
    nameL.backgroundColor = [UIColor clearColor];
    nameL.adjustsFontSizeToFitWidth = YES;
    nameL.text = [NSString stringWithFormat:@"%@ %@ %@岁",nameStr,sex,[dict valueForKey:@"protectedPersonAge"]];
    [cell addSubview:nameL];
    
    itemY = CGRectGetMaxY(nameL.frame)-5;
    UILabel *contentL = [[UILabel alloc] initWithFrame:CGRectMake(itemX, itemY, itemW, itemH)];
    contentL.textColor = [UIColor grayColor];
    contentL.font = [UIFont systemFontOfSize:13.0];
    contentL.backgroundColor = [UIColor clearColor];
    contentL.adjustsFontSizeToFitWidth = YES;
    contentL.text = [dict valueForKey:@"orderSendServicecontent"];
    [cell addSubview:contentL];
    
    itemY = CGRectGetMaxY(contentL.frame)-5;
    UILabel *timeL = [[UILabel alloc] initWithFrame:CGRectMake(itemX, itemY, itemW, itemH)];
    timeL.textColor = [UIColor grayColor];
    timeL.font = [UIFont systemFontOfSize:13.0];
    timeL.backgroundColor = [UIColor clearColor];
    timeL.adjustsFontSizeToFitWidth = YES;
    timeL.text = [NSString stringWithFormat:@"创建时间%@",[self getSenderTimeStrWith:[dict objectForKey:@"nursingReportCreatetime"]]];
    [cell addSubview:timeL];
    
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    
    return 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;

    NSDictionary *dict;
    @try {
        dict = [NSDictionary dictionaryWithDictionary:dataArr[row]];
        
        NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithDictionary:[Tool deleteNullFromDic:dict]];
        NurseReportVC *nurseReportVC = [[NurseReportVC alloc] init];
        nurseReportVC.hidesBottomBarWhenPushed = YES;
        nurseReportVC.infoData = tempDict;
//        nurseReportVC.isDetail = YES;
        nurseReportVC.reportType = 1;
        [self.navigationController pushViewController:nurseReportVC animated:YES];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}

- (NSString *)getSenderTimeStrWith:(id)info{
    NSString *stopTimeStr = @"";
    id zoneCreatetimeObj = info;
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
    stopTimeStr = [Tool convertTimespToString:[zoneCreatetime longLongValue] dateFormate:@"yyyy-MM-dd HH:mm"];
    return stopTimeStr;
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
