//
//  MyEvaluateViewController.m
//  nurseService
//
//  Created by 梅阳阳 on 16/12/22.
//  Copyright © 2016年 iMac. All rights reserved.
//

#import "MyEvaluateViewController.h"
#import "DLNavigationTabBar.h"
#import "MyEvaluateTableViewCell.h"
#import "MJRefreshAutoNormalFooter.h"
@interface MyEvaluateViewController (){
    NSInteger currentPage;
    NSInteger currentType;
    NSMutableArray *dataArr;
    UIImageView *noDataView;
}
@property(nonatomic,strong)DLNavigationTabBar *navigationTabBar;
@end

@implementation MyEvaluateViewController
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
        label.text = @"我的评价";
        [label sizeToFit];
        self.title = @"我的评价";
    
    }
    return self;
}

-(DLNavigationTabBar *)navigationTabBar
{
    if (!_navigationTabBar) {
        self.navigationTabBar = [[DLNavigationTabBar alloc] initWithTitles:@[@"全部",@"好评",@"一般",@"不满意"]];
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
    
    currentPage = 0;
    currentType = 0;
    [self getDataWithType:currentType];
    dataArr = [[NSMutableArray alloc] initWithCapacity:0];
    
    self.view.backgroundColor = [UIColor colorWithWhite:244.0 / 255.0 alpha:1.0];
    
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
    
    [self.view addSubview:self.navigationTabBar];
    
    [myTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    myTableView.backgroundView = nil;
    myTableView.backgroundColor = self.view.backgroundColor;
    
    self.myTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.myTableView.footer.automaticallyHidden = YES;
        self.myTableView.footer.hidden = NO;
        // 进入刷新状态后会自动调用这个block，加载更多
        
        //处理上拉后的逻辑
        NSLog(@"endRefreshing");
        [self getDataWithType:currentType];
        [self performSelector:@selector(endRefreshing) withObject:nil afterDelay:1.0];
    }];
    
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
- (void)getDataWithType:(NSInteger)type{
    NSString *userAccount = [[NSUserDefaults standardUserDefaults] objectForKey:USERIDKEY];

    NSDictionary * params  = @{@"nurseid": userAccount,@"type" : [NSString stringWithFormat:@"%ld",type],@"pageNum" : [NSString stringWithFormat:@"%ld",currentPage]};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:EVALUATEURL params:params success:^(AFHTTPRequestOperation* operation,id response){
        
        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSMutableDictionary *respondDict = [NSMutableDictionary dictionaryWithDictionary:[respondString objectFromJSONString]];
        if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"200"]) {
            NSLog(@"success");
            NSArray *tempArr = [NSArray arrayWithArray:[respondDict valueForKey:@"json"]];
            if (tempArr.count > 0) {
                [dataArr addObjectsFromArray:tempArr];
                [myTableView reloadData];
                noDataView.hidden = YES;
                myTableView.hidden = NO;
                
                currentPage++;
                [myTableView reloadData];
            }else{
                
                if(currentPage == 0 && tempArr.count == 0){
                    myTableView.hidden = YES;
                    noDataView.hidden = NO;
                    return ;
                }
            }
            


        }else if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"400"]){
            NSLog(@"faile");
            myTableView.hidden = YES;
            noDataView.hidden = NO;
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
    currentPage = 0;
    if (dataArr) {
        [dataArr removeAllObjects];
    }
    [self getDataWithType:currentType];
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
    
    static NSString *cellIndentifier = @"MyEvaluateTableViewCell";
    CGSize cellSize = [tableView rectForRowAtIndexPath:indexPath].size;
    NSDictionary *tempDict = [NSDictionary dictionaryWithDictionary:[dataArr objectAtIndex:row]];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    for (NSString *key in [tempDict allKeys]) {
        if ([[NSString stringWithFormat:@"%@",[tempDict valueForKey:key]] isEqualToString:@"<null>"]) {
            NSLog(@"key:%@",key);
            [dict setValue:@"" forKey:key];
        }else{
            [dict setValue:[NSString stringWithFormat:@"%@",[tempDict valueForKey:key]] forKey:key];
        }
    }
    
    MyEvaluateTableViewCell *cell  = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[MyEvaluateTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier cellSize:cellSize];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSString *userHeader = [NSString stringWithFormat:@"%@%@",PIC_URL,[dict valueForKey:@"userHeader"]];
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:userHeader] placeholderImage:[UIImage imageNamed:@"defalut_icon"]];
    cell.telephoneNum.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"userNike"]];
    cell.serviceType.text = [NSString stringWithFormat:@"护理项:%@",[dict valueForKey:@"manageNursingContenName"]];
    cell.evaluateInfo.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"evaluateContent"]];

    id zoneCreatetimeObj = [dict objectForKey:@"evaluateCreatetime"];
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
    NSString *dateString = [Tool convertTimespToString:[zoneCreatetime longLongValue] dateFormate:@"yyyy/MM/dd HH:mm"];
    cell.time.text = dateString;
    
    NSInteger starNum = [[dict valueForKey:@"evaluateMark"] integerValue];
    CGFloat starX = SCREENWIDTH-85;
    CGFloat starW = 15;
    for (int i = 0; i<starNum; i++) {
        UIImageView *starImageView = [[UIImageView alloc] initWithFrame:CGRectMake(starX+starW*i, 10, starW, starW)];
        starImageView.backgroundColor = [UIColor clearColor];
        if (i < starNum) {
            starImageView.image = [UIImage imageNamed:@"icon_star_yellow"];
        }else{
            starImageView.image = [UIImage imageNamed:@"icon_star_normal"];
        }
        [cell addSubview:starImageView];
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    
    return 100;
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
