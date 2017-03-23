//
//  RedPacketVC.m
//  nurseService
//
//  Created by 梅阳阳 on 17/3/22.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "RedPacketVC.h"
#import "MJRefreshAutoNormalFooter.h"
#import "HeBaseTableViewCell.h"

@interface RedPacketVC ()
{
    UIImageView *noDataView;
    NSMutableArray *dataArr;
}
@property (strong, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation RedPacketVC

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
        label.text = @"我的红包";
        [label sizeToFit];
        self.title = @"我的红包";
        
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
    NSDictionary * params  = @{@"nuserId": userId};
    [self showHudInView:self.view hint:@"正在获取..."];
    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:@"nurseAnduser/selectAllNurseRedPackert.action" params:params success:^(AFHTTPRequestOperation* operation,id response){
        [self hideHud];

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
                if (dataArr.count >0) {
                    [dataArr removeAllObjects];
                }
                if (tempArr.count > 0) {
                    [dataArr addObjectsFromArray:tempArr];
                    [tableview reloadData];
                    noDataView.hidden = YES;
                    tableview.hidden = NO;
                }else{
                    noDataView.hidden = NO;
                    tableview.hidden = YES;
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
            if (dataArr.count >0) {
                [dataArr removeAllObjects];
                [tableview reloadData];
                noDataView.hidden = NO;
                tableview.hidden = YES;
            }
        }
    } failure:^(NSError* err){
        NSLog(@"err:%@",err);
        [self hideHud];
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
    
    UIImageView *bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, SCREENWIDTH-20, 80)];
    bgImage.backgroundColor = [UIColor clearColor];
    [cell addSubview:bgImage];
    [bgImage setImage:[UIImage imageNamed:@"icon_coupon_bg"]];
    
    
    CGFloat itemX = 10;
    CGFloat itemY = 15;
    CGFloat itemW = 50;
    UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(itemX, itemY, itemW, itemW)];
    headImageView.backgroundColor = [UIColor clearColor];
    headImageView.layer.masksToBounds = YES;
    headImageView.image = [UIImage imageNamed:@"icon_coupon"];
    headImageView.contentMode = UIViewContentModeScaleAspectFill;
    headImageView.layer.borderWidth = 0.0;
    headImageView.layer.cornerRadius = 40 / 2.0;
    headImageView.layer.masksToBounds = YES;
    [bgImage addSubview:headImageView];
    NSString *userHeader = [NSString stringWithFormat:@"%@%@",PIC_URL,[dict valueForKey:@"redPacketsNursePic"]];
    [headImageView sd_setImageWithURL:[NSURL URLWithString:userHeader] placeholderImage:[UIImage imageNamed:@"icon_coupon"]];
    
    itemX = CGRectGetMaxX(headImageView.frame);
    itemY = 10;
    itemW = 200;
    CGFloat itemH = 25;
    UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(itemX, itemY, itemW, itemH)];
    nameL.textColor = [UIColor redColor];
    nameL.font = [UIFont systemFontOfSize:16.0];
    nameL.backgroundColor = [UIColor clearColor];
    nameL.adjustsFontSizeToFitWidth = YES;
    nameL.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"redPacketsNurseSpeak"]];
    [bgImage addSubview:nameL];
    
    itemW = 100;
    itemX = SCREENWIDTH-40-itemW;
    itemY = 10;
    itemH = 25;
    UILabel *moneyL = [[UILabel alloc] initWithFrame:CGRectMake(itemX, itemY, itemW, itemH)];
    moneyL.textColor = [UIColor redColor];
    moneyL.textAlignment = NSTextAlignmentRight;
    moneyL.font = [UIFont systemFontOfSize:16.0];
    moneyL.backgroundColor = [UIColor clearColor];
//    moneyL.adjustsFontSizeToFitWidth = YES;
    moneyL.text = [NSString stringWithFormat:@"￥%@",[dict valueForKey:@"redPacketsNurseMoney"]];
    [bgImage addSubview:moneyL];
    
    
    id zoneCreatetimeObj = [dict objectForKey:@"redPacketsNurseCreatetime"];
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
    
    itemX = CGRectGetMaxX(headImageView.frame);
    itemW = SCREENWIDTH-25-itemX;
    itemY = CGRectGetMaxY(nameL.frame)+5;
    itemH = 1;
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(itemX, itemY, itemW, itemH)];
    line.backgroundColor = [UIColor lightGrayColor];
    [bgImage addSubview:line];
    NSLog(@"%@",dict);
    
    itemH = 50;
    UILabel *noteL = [[UILabel alloc] initWithFrame:CGRectMake(itemX, itemY-5, itemW, itemH)];
    noteL.textColor = [UIColor grayColor];
    noteL.numberOfLines = 2;
    noteL.font = [UIFont systemFontOfSize:13.0];
    noteL.backgroundColor = [UIColor clearColor];
    //    moneyL.adjustsFontSizeToFitWidth = YES;
    noteL.text = [NSString stringWithFormat:@"%@\n%@",[dict valueForKey:@"redPacketsNurseNote"],time];
    [bgImage addSubview:noteL];
    
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
//        NurseReportVC *nurseReportVC = [[NurseReportVC alloc] init];
//        nurseReportVC.hidesBottomBarWhenPushed = YES;
//        nurseReportVC.infoData = tempDict;
//        //        nurseReportVC.isDetail = YES;
//        nurseReportVC.reportType = 1;
//        [self.navigationController pushViewController:nurseReportVC animated:YES];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
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
