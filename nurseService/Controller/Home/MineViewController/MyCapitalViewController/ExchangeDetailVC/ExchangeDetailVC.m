//
//  ExchangeDetailVC.m
//  nurseService
//
//  Created by 梅阳阳 on 17/1/11.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "ExchangeDetailVC.h"
#import "MJRefreshAutoNormalFooter.h"
#import "HeBaseTableViewCell.h"

@interface ExchangeDetailVC (){
    
    UIImageView *noDataView;
    NSMutableArray *dataArr;
    NSInteger currentPage;

}
@property (strong, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation ExchangeDetailVC
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
        label.text = @"交易明细";
        [label sizeToFit];
        self.title = @"交易明细";
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
    tableview.backgroundColor = self.view.backgroundColor;
    tableview.backgroundView = nil;
    [Tool setExtraCellLineHidden:tableview];
    [tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    
    CGFloat noDataViewW = 50;
    CGFloat noDataViewY = (self.view.frame.size.height-44-48-noDataViewW)/2.0;
    CGFloat noDataViewX = (SCREENWIDTH-noDataViewW)/2.0;
    
    noDataView = [[UIImageView alloc] init];
    noDataView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:noDataView];
    noDataView.frame = CGRectMake(noDataViewX, noDataViewY, noDataViewW, noDataViewW);
    noDataView.image = [UIImage imageNamed:@"img_no_data"];
    noDataView.hidden = YES;
    
    
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
    NSDictionary * params  = @{@"userId": userId,@"pageNum" : [NSString stringWithFormat:@"%ld",currentPage]};
    
    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:@"nurseAnduser/selectCapitalUserPoolInfo.action" params:params success:^(AFHTTPRequestOperation* operation,id response){
        
        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSMutableDictionary *respondDict = [NSMutableDictionary dictionaryWithDictionary:[respondString objectFromJSONString]];
        if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"200"]||[[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"300"]) {
            NSLog(@"success");
            if ([[respondDict valueForKey:@"json"] isMemberOfClass:[NSNull class]] || [respondDict valueForKey:@"json"] == nil) {
                [self.view makeToast:[NSString stringWithFormat:@"%@",[respondDict valueForKey:@"data"]] duration:1.2 position:@"center"];
                
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
            [self.view makeToast:[NSString stringWithFormat:@"%@",[respondDict valueForKey:@"data"]] duration:1.2 position:@"center"];
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
    
    static NSString *cellIndentifier = @"HeBaseTableViewCell";
    CGSize cellSize = [tableView rectForRowAtIndexPath:indexPath].size;
    NSDictionary *dict = nil;//[NSDictionary dictionaryWithDictionary:dataArr[row]];
    
    HeBaseTableViewCell *cell  = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[HeBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier cellSize:cellSize];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    CGFloat bgView_W = SCREENWIDTH-10;
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(5, 10, bgView_W, 70)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.userInteractionEnabled = YES;
    [cell addSubview:bgView];
    [bgView.layer setMasksToBounds:YES];
    bgView.layer.cornerRadius = 4.0;
    
    CGFloat serviceContentLX = 10;
    CGFloat serviceContentLY = 0;
    CGFloat serviceContentLW = SCREENWIDTH - 160;
    CGFloat serviceContentLH = 70;
    
    UILabel *capitalUserPoolSpeakL = [[UILabel alloc] initWithFrame:CGRectMake(serviceContentLX, serviceContentLY, serviceContentLW, serviceContentLH)];
    capitalUserPoolSpeakL.userInteractionEnabled = YES;
    capitalUserPoolSpeakL.textColor = APPDEFAULTORANGE;
    capitalUserPoolSpeakL.font = [UIFont systemFontOfSize:15.0];
    capitalUserPoolSpeakL.backgroundColor = [UIColor clearColor];
    [bgView addSubview:capitalUserPoolSpeakL];
    capitalUserPoolSpeakL.textColor = [UIColor blackColor];
    capitalUserPoolSpeakL.numberOfLines = 0;
    capitalUserPoolSpeakL.text = [dict valueForKey:@"capitalUserPoolSpeak"];
    
    serviceContentLX = SCREENWIDTH - 165;
    serviceContentLW = 150;
    serviceContentLH = 40;
    UILabel *moneyL = [[UILabel alloc] initWithFrame:CGRectMake(serviceContentLX, serviceContentLY+5, serviceContentLW, serviceContentLH)];
    moneyL.userInteractionEnabled = YES;
    moneyL.textColor = APPDEFAULTORANGE;
    moneyL.font = [UIFont systemFontOfSize:15.0];
    moneyL.backgroundColor = [UIColor clearColor];
    [bgView addSubview:moneyL];
    moneyL.textColor = [UIColor redColor];
    moneyL.textAlignment = NSTextAlignmentRight;
    NSString *money = @"";
    if ([[dict valueForKey:@"capitalUserPoolMoney"] integerValue] > 0) {
        money = [NSString stringWithFormat:@"+%@元",[dict valueForKey:@"capitalUserPoolMoney"]];
    }else{
        money = [NSString stringWithFormat:@"-%@元",[dict valueForKey:@"capitalUserPoolMoney"]];
    }
    moneyL.text = money;
    
    serviceContentLY = 30;
    UILabel *timeL = [[UILabel alloc] initWithFrame:CGRectMake(serviceContentLX, serviceContentLY, serviceContentLW, serviceContentLH)];
    timeL.userInteractionEnabled = YES;
    timeL.textColor = APPDEFAULTORANGE;
    timeL.font = [UIFont systemFontOfSize:12.0];
    timeL.backgroundColor = [UIColor clearColor];
    [bgView addSubview:timeL];
    timeL.textAlignment = NSTextAlignmentRight;
    timeL.textColor = [UIColor grayColor];
    
    id zoneCreatetimeObj = [dict objectForKey:@"capitalUserPoolCreatetime"];
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
    NSString *time = [Tool convertTimespToString:[zoneCreatetime longLongValue] dateFormate:@"MM-dd"];
    
    timeL.text = time;
    
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
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
