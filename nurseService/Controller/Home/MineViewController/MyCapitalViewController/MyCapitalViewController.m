//
//  MyCapitalViewController.m
//  nurseService
//
//  Created by 梅阳阳 on 16/12/28.
//  Copyright © 2016年 iMac. All rights reserved.
//

#import "MyCapitalViewController.h"
#import "DrawCashViewController.h"

@interface MyCapitalViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *iconArr;
    NSArray * tableItemArr;
    UILabel *capitalL;
}
@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation MyCapitalViewController
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
        label.text = @"我的资金";
        [label sizeToFit];
        self.title = @"我的资金";
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initializaiton];
    [self initView];
//    [self getData];
}

- (void)initializaiton
{
    [super initializaiton];
    iconArr = @[@"icon_withdrawals",@"icon_bind_alipay",@"icon_set_paypwd",@"icon_financial_details"];
    tableItemArr = @[@"        提现",@"        绑定支付宝",@"        设置支付密码",@"        交易明细"];
}

- (void)initView
{
    [super initView];
    self.view.backgroundColor = [UIColor colorWithWhite:237.0 /255.0 alpha:1.0];
    
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    myTableView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGH-50);
    myTableView.backgroundView = nil;
    myTableView.backgroundColor = [UIColor clearColor];
    [Tool setExtraCellLineHidden:myTableView];
    
    CGFloat viewHeight = 100;
    UIView *headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, SCREENWIDTH, viewHeight);
    headerView.backgroundColor = [UIColor whiteColor];
    myTableView.tableHeaderView = headerView;
    
    capitalL = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREENWIDTH, 40)];
    capitalL.backgroundColor = [UIColor clearColor];
    capitalL.font = [UIFont systemFontOfSize:25.0f];
    capitalL.textColor = APPDEFAULTTITLECOLOR;
    capitalL.textAlignment = NSTextAlignmentCenter;
    capitalL.text = @"2000.00元";
    [headerView addSubview:capitalL];
    
    CGFloat tipImageX = SCREENWIDTH/2.0 - 30;
    CGFloat tipImageY = 65;
    CGFloat tipImageW = 15;
    UIImageView *tipImageV = [[UIImageView alloc] initWithFrame:CGRectMake(tipImageX, tipImageY, tipImageW, tipImageW)];
    [headerView addSubview:tipImageV];
    [tipImageV setBackgroundColor:[UIColor clearColor]];
    tipImageV.image = [UIImage imageNamed:@"icon_money_volie"];
    
    
    UILabel *tipL = [[UILabel alloc] initWithFrame:CGRectMake(tipImageX+20, tipImageY-2, 120, 20)];
    tipL.backgroundColor = [UIColor clearColor];
    tipL.font = [UIFont systemFontOfSize:15.0f];
    tipL.textColor = APPDEFAULTTITLECOLOR;
    tipL.text = @"我的余额";
    [headerView addSubview:tipL];
    
}

- (void)getData{
    NSString *userAccount = [[NSUserDefaults standardUserDefaults] objectForKey:USERIDKEY];

    NSDictionary * params  = @{@"nurseid": [NSString stringWithFormat:@"%@",userAccount],@"latitude" : @"0",@"longitude" : @"0"};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:LOGINURL params:params success:^(AFHTTPRequestOperation* operation,id response){
        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        
        NSMutableDictionary *respondDict = [NSMutableDictionary dictionaryWithDictionary:[respondString objectFromJSONString]];
        if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"200"]) {
            NSLog(@"success");
            
            NSDictionary *userInfoDic = [NSDictionary dictionaryWithDictionary:[respondDict valueForKey:@"json"]];
            NSMutableDictionary *nurseDic = [NSMutableDictionary dictionaryWithCapacity:0];
            
            for (NSString *key in [userInfoDic allKeys]) {
                
                if ([[NSString stringWithFormat:@"%@",[userInfoDic valueForKey:key]] isEqualToString:@"<null>"]) {
                    NSLog(@"key:%@",key);
                    
                    //                    [userInfoDic setValue:@"" forKey:key];
                    [nurseDic setValue:@"" forKey:key];
                }else{
                    [nurseDic setValue:[NSString stringWithFormat:@"%@",[userInfoDic valueForKey:key]] forKey:key];
                }
            }
            NSLog(@"%@",nurseDic);
            
            NSString *capitalStr = [[NSString stringWithFormat:@"%@",[nurseDic valueForKey:@"nurseBalance"]] isEqualToString:@""] ? @"0元" : [NSString stringWithFormat:@"%@元",[nurseDic valueForKey:@"nurseBalance"]];
            capitalL.text = capitalStr;
            
        }else if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"400"]){
            NSLog(@"faile");
        }
        [self.view makeToast:[NSString stringWithFormat:@"%@",[respondDict valueForKey:@"data"]] duration:1.2 position:@"center"];
        
        
    } failure:^(NSError* err){
        NSLog(@"err:%@",err);
        [self.view makeToast:ERRORREQUESTTIP duration:2.0 position:@"center"];
    }];

}


#pragma mark UITableViewdDataSource UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return iconArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier = @"cellIndentifier";
    UITableViewCell *userCell = [tableView cellForRowAtIndexPath:indexPath];
    if (!userCell) {
        userCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    NSInteger row = indexPath.row;
    CGSize cellSize = [tableView rectForRowAtIndexPath:indexPath].size;
    CGFloat iconY = 10;
    CGFloat iconH = cellSize.height - 2 * iconY;
    CGFloat iconX = 10;
    CGFloat iconW = iconH;

    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[iconArr objectAtIndex:row]]];
    icon.frame = CGRectMake(iconX, iconY, iconW, iconH);
    [userCell addSubview:icon];
    userCell.textLabel.text = [tableItemArr objectAtIndex:row];
    userCell.textLabel.textColor = [UIColor grayColor];
    userCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return userCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view makeToast:@"功能未完善" duration:1.2 position:@"center"];
    
    NSInteger index = indexPath.row;
    NSInteger sectionNum = indexPath.section;
    NSLog(@"section:%ld,index:%ld",sectionNum,index);
    switch (index) {
        case 0:
        {
            DrawCashViewController *drawCashViewController = [[DrawCashViewController alloc] init];
            drawCashViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:drawCashViewController animated:YES];
        }
            break;
        case 1:
        {
        }
            break;
        case 2:
        {
        }
            break;
        case 3:
        {
        }
            break;
            
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    }
    return 10;
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
