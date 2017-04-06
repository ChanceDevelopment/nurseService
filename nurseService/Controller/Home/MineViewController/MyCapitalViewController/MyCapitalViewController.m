//
//  MyCapitalViewController.m
//  nurseService
//
//  Created by 梅阳阳 on 16/12/28.
//  Copyright © 2016年 iMac. All rights reserved.
//

#import "MyCapitalViewController.h"
#import "DrawCashViewController.h"
#import "SettingPayPswVC.h"
#import "ExchangeDetailVC.h"

@interface MyCapitalViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *iconArr;
    NSArray * tableItemArr;
    UILabel *capitalL;
    UIView *windowView;
    UITextField *addTextField;
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

    [self getData];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getData) name:THREEINFONOCATIFITION object:nil];
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
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    [headerView addSubview:capitalL];
    capitalL.text = @"0.00元";
    
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
    NSString *nurseId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:USERIDKEY]];

    NSDictionary * params  = @{@"nurseId": nurseId};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:SELECTNURSETHREEINFO params:params success:^(AFHTTPRequestOperation* operation,id response){
        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        
        NSMutableDictionary *respondDict = [NSMutableDictionary dictionaryWithDictionary:[respondString objectFromJSONString]];
//        [self.view makeToast:[NSString stringWithFormat:@"%@",[respondDict objectForKey:@"data"]] duration:1.2 position:@"center"];
        if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"200"]) {
            NSLog(@"success");
            
            NSDictionary *userInfoDic = [NSDictionary dictionaryWithDictionary:[respondDict valueForKey:@"json"]];
            NSMutableDictionary *nurseDic = [NSMutableDictionary dictionaryWithCapacity:0];
            
            for (NSString *key in [userInfoDic allKeys]) {
                if ([[NSString stringWithFormat:@"%@",[userInfoDic valueForKey:key]] isEqualToString:@"<null>"]) {
                    NSLog(@"key:%@",key);
                    [nurseDic setValue:@"" forKey:key];
                }else{
                    [nurseDic setValue:[NSString stringWithFormat:@"%@",[userInfoDic valueForKey:key]] forKey:key];
                }
            }
            
            NSString *capitalStr = [[NSString stringWithFormat:@"%@",[nurseDic valueForKey:@"nurseBalance"]] isEqualToString:@""] ? @"0.00元" : [NSString stringWithFormat:@"%@元",[nurseDic valueForKey:@"nurseBalance"]];
            capitalL.text = capitalStr;
            [[NSUserDefaults standardUserDefaults] setObject:nurseDic forKey:THREEINFOKEY];
        }else if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"400"]){
            NSLog(@"faile");
        }
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
    NSInteger index = indexPath.row;
    NSInteger sectionNum = indexPath.section;
    NSLog(@"section:%ld,index:%ld",sectionNum,index);
    switch (index) {
        case 0:
        {
            NSString *account = [NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults] objectForKey:THREEINFOKEY] valueForKey:@"nursePaymentSettingsAccount"]];
            
            NSString *pwd = [NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults] objectForKey:THREEINFOKEY] valueForKey:@"nursePaymentSettingsPwd"]];
            if ([account isEqualToString:@""]) {
                [self showAddView];
            }else if([pwd isEqualToString:@""]){
                SettingPayPswVC *settingPayPswVC =[[SettingPayPswVC alloc] init];
                settingPayPswVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:settingPayPswVC animated:YES];
            }else {
                DrawCashViewController *drawCashViewController = [[DrawCashViewController alloc] init];
                drawCashViewController.totalCapital = [capitalL.text floatValue];
                drawCashViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:drawCashViewController animated:YES];
            }

        }
            break;
        case 1:
        {
            [self showAddView];
        }
            break;
        case 2:
        {
            SettingPayPswVC *settingPayPswVC =[[SettingPayPswVC alloc] init];
            settingPayPswVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:settingPayPswVC animated:YES];
        }
            break;
        case 3:
        {
            ExchangeDetailVC *exchangeDetailVC = [[ExchangeDetailVC alloc] init];
            exchangeDetailVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:exchangeDetailVC animated:YES];
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

- (void)showAddView{
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
    titleL.text = @"绑定支付宝";
    
    NSInteger addTextField_H = 44;
    NSInteger addTextField_Y = 50;
    NSInteger addTextField_W =SCREENWIDTH-40;
    
    addTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, addTextField_Y, addTextField_W, addTextField_H)];//高度--44
    addTextField.font = [UIFont systemFontOfSize:15.0];
    addTextField.backgroundColor = [UIColor clearColor];
    addTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    addTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    addTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    addTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    addTextField.placeholder = @"请输入支付宝账号";
    [addBgView addSubview:addTextField];
    
    //边线
    UILabel *borderLine = [[UILabel alloc] initWithFrame:CGRectMake(10, addTextField_Y+40, addTextField_W, 0.5)];
    [addBgView addSubview:borderLine];
    borderLine.backgroundColor = [UIColor blueColor];
    
    
    NSInteger cancleBt_X = SCREENWIDTH-20-10-90;
    NSInteger cancleBt_Y = addTextField_Y+40+30;
    NSInteger cancleBt_W = 40;
    NSInteger cancleBt_H = 20;
    
    UIButton *cancleBt = [[UIButton alloc] initWithFrame:CGRectMake(cancleBt_X, cancleBt_Y, cancleBt_W, cancleBt_H)];
    [cancleBt setTitle:@"取消" forState:UIControlStateNormal];
    cancleBt.backgroundColor = [UIColor clearColor];
    cancleBt.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [cancleBt setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    cancleBt.tag = 0;
    [cancleBt addTarget:self action:@selector(clickBtAction:) forControlEvents:UIControlEventTouchUpInside];
    [addBgView addSubview:cancleBt];
    
    UIButton *okBt = [[UIButton alloc] initWithFrame:CGRectMake(cancleBt_X+50, cancleBt_Y, cancleBt_W, cancleBt_H)];
    [okBt setTitle:@"确定" forState:UIControlStateNormal];
    okBt.backgroundColor = [UIColor clearColor];
    okBt.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [okBt setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    okBt.tag = 1;
    [okBt addTarget:self action:@selector(clickBtAction:) forControlEvents:UIControlEventTouchUpInside];
    [addBgView addSubview:okBt];
    
    
}
- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}
- (void)clickBtAction:(UIButton *)sender{
    if (windowView) {
        [windowView removeFromSuperview];
    }
    if (sender.tag == 1) {
        if (addTextField.text.length == 0 || ![self isPureInt:addTextField.text]) {
            [self.view makeToast:@"请输入正确支付宝账号" duration:2.0 position:@"center"];
            return;
        }

        NSString *nurseId = [[NSUserDefaults standardUserDefaults] objectForKey:USERIDKEY];
        NSDictionary * params  = @{@"nurseId" : nurseId,
                                   @"pwd" : @"",
                                   @"account" : addTextField.text,
                                   @"drawcode" : @""};
        [AFHttpTool requestWihtMethod:RequestMethodTypePost url:BINDACCOUNTANDPAW params:params success:^(AFHTTPRequestOperation* operation,id response){
            NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
            NSLog(@"respondString:%@",respondString);
            NSMutableDictionary *respondDict = [NSMutableDictionary dictionaryWithDictionary:[respondString objectFromJSONString]];
            if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"200"]) {
                NSLog(@"success");
                [self getData];
            }else if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"400"]){
                NSLog(@"faile");
            }
            [self.view makeToast:[NSString stringWithFormat:@"%@",[respondDict valueForKey:@"data"]] duration:1.2 position:@"center"];
        } failure:^(NSError* err){
            NSLog(@"err:%@",err);
            [self.view makeToast:ERRORREQUESTTIP duration:2.0 position:@"center"];
        }];
    }
    
    
    NSLog(@"tag:%ld",sender.tag);
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
