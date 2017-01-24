//
//  SettingPayPswVC.m
//  nurseService
//
//  Created by 梅阳阳 on 17/1/11.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "SettingPayPswVC.h"
#import "UIButton+countDown.h"
#import <SMS_SDK/SMSSDK.h>
#import "AddPaswordVC.h"
@interface SettingPayPswVC ()

@property (strong, nonatomic) IBOutlet UIButton *codeBt;
@property (strong, nonatomic) IBOutlet UILabel *tipLable;
@property (strong, nonatomic) IBOutlet UITextField *codeTextField;
@end

@implementation SettingPayPswVC
@synthesize codeBt;
@synthesize codeTextField;
@synthesize tipLable;

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
    label.text = @"设置支付密码";
    [label sizeToFit];
    self.title = @"设置支付密码";
}
return self;
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
    
    
    self.view.backgroundColor = [UIColor colorWithWhite:237.0 /255.0 alpha:1.0];
    
//    codeBt.layer.borderWidth = 1.0;
//    codeBt.layer.cornerRadius = 5.0;
////    codeBt.layer.backgroundColor = APPDEFAULTORANGE.CGColor;
//    codeBt.layer.masksToBounds = YES;
//    [codeBt setBackgroundImage:[Tool buttonImageFromColor:APPDEFAULTORANGE withImageSize:codeBt.frame.size] forState:UIControlStateNormal];
//    codeBt.layer.borderColor = [UIColor clearColor].CGColor;
//    
    codeBt.layer.masksToBounds = YES;
    codeBt.layer.cornerRadius = 5.0;
    codeBt.layer.borderWidth = 0.5;
    codeBt.layer.borderColor = APPDEFAULTORANGE.CGColor;
    
    NSDictionary *userInfoDic = [NSDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:USERACCOUNTKEY]];

    NSString *tipStr = [NSString stringWithFormat:@"请将手机号%@，收到的验证码填到下面的输入框中",[userInfoDic valueForKey:@"account"]];
    
    [tipLable setText:tipStr];
    
}

- (IBAction)getCodeClick:(id)sender {

    
    [sender startWithTime:60 title:@"获取验证码" countDownTitle:@"s" mainColor:[UIColor whiteColor] countColor:[UIColor whiteColor]];
    
    //获取注册手机号的验证码
    NSString *nurseId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:USERIDKEY]];
    NSDictionary * params  = @{@"nurseId": nurseId};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:@"nurseAnduser/sendSmsByNurseBindPassword.action" params:params success:^(AFHTTPRequestOperation* operation,id response){
        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSLog(@"respondString:%@",respondString);
        NSMutableDictionary *respondDict = [NSMutableDictionary dictionaryWithDictionary:[respondString objectFromJSONString]];
        
        [self.view makeToast:[NSString stringWithFormat:@"%@",[respondDict valueForKey:@"data"]] duration:1.2 position:@"center"];
        if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"200"]) {
            NSLog(@"success");
            
            
        }else if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"400"]){
            NSLog(@"faile");
        }
        
        
    } failure:^(NSError* err){
        NSLog(@"err:%@",err);
        [self.view makeToast:ERRORREQUESTTIP duration:2.0 position:@"center"];
    }];

}
- (IBAction)finishedClick:(id)sender {
    if ([codeTextField.text isEqualToString:@""]) {
        [self showHint:@"请输入验证码"];
        return;
    }
    
    NSString *pwd = [NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults] objectForKey:THREEINFOKEY] valueForKey:@"nursePaymentSettingsPwd"]];
    NSString *account = [NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults] objectForKey:THREEINFOKEY] valueForKey:@"nursePaymentSettingsAccount"]];
    NSString *nurseId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:USERIDKEY]];
    NSDictionary * params  = @{@"nurseId": nurseId,@"pwd":pwd,@"account":account,@"drawcode":codeTextField.text};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:BINDACCOUNTANDPAW params:params success:^(AFHTTPRequestOperation* operation,id response){
        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSLog(@"respondString:%@",respondString);
        NSMutableDictionary *respondDict = [NSMutableDictionary dictionaryWithDictionary:[respondString objectFromJSONString]];
        
        [self.view makeToast:[NSString stringWithFormat:@"%@",[respondDict valueForKey:@"data"]] duration:1.2 position:@"center"];
        if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"200"]) {
            NSLog(@"success");
            AddPaswordVC *addPaswordVC = [[AddPaswordVC alloc] init];
            addPaswordVC.hidesBottomBarWhenPushed = YES;
            addPaswordVC.codeStr = codeTextField.text;
            [self.navigationController pushViewController:addPaswordVC animated:YES];

        }else if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"400"]){
            NSLog(@"faile");
        }
        
        
    } failure:^(NSError* err){
        NSLog(@"err:%@",err);
        [self.view makeToast:ERRORREQUESTTIP duration:2.0 position:@"center"];
    }];
    
}

- (void)backToRoot{
    [self.navigationController popViewControllerAnimated:YES];
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
