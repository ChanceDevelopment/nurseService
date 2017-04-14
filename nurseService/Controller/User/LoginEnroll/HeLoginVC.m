//
//  HeLoginVC.m
//  nurseService
//
//  Created by Tony on 2016/12/14.
//  Copyright © 2016年 iMac. All rights reserved.
//

#import "HeLoginVC.h"
#import "HeEnrollVC.h"
#import "BasicInfoVC.h"
#import "HeForGetPasswordVC.h"
@interface HeLoginVC ()<UITextFieldDelegate>
{
    UIView *windowView;
}
@property(strong,nonatomic)IBOutlet UITextField *accountField;
@property(strong,nonatomic)IBOutlet UITextField *passwordField;
@property(strong,nonatomic)IBOutlet UIButton *securirtyButton;
@property(strong,nonatomic)IBOutlet UIButton *loginButton;
@property(strong,nonatomic)IBOutlet UIButton *enrollButton;

@end

@implementation HeLoginVC
@synthesize accountField;
@synthesize passwordField;
@synthesize securirtyButton;
@synthesize enrollButton;

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
        label.text = @"登录";
        [label sizeToFit];
        self.title = @"登录";
        
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
    securirtyButton.selected = YES;
}

- (IBAction)loginButtonClick:(id)sender
{
    if ([accountField isFirstResponder]) {
        [accountField resignFirstResponder];
    }
    if ([passwordField isFirstResponder]) {
        [passwordField resignFirstResponder];
    }
    NSString *account = [accountField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *password = passwordField.text;
    if (account == nil || ![Tool isMobileNumber:account]) {
        [self showHint:@"请输入正确的手机号"];
        return;
    }
    if (password == nil || (password.length < 6) || (password.length > 16)) {
        [self showHint:@"请输入正确密码"];
        return;
    }
    
    [self showHudInView:self.view hint:@"登录中..."];
    NSDictionary * params  = @{@"NurseName": account,@"NursePwd" : password};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:LOGINURL params:params success:^(AFHTTPRequestOperation* operation,id response){
        [self hideHud];
        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSLog(@"护士信息：%@",respondString);
        NSMutableDictionary *respondDict = [NSMutableDictionary dictionaryWithDictionary:[respondString objectFromJSONString]];
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
            NSLog(@"%@",nurseDic);
            [[NSUserDefaults standardUserDefaults] setObject:nurseDic forKey:USERACCOUNTKEY];//本地存储
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",[userInfoDic valueForKey:@"nurseId"]] forKey:USERIDKEY];
            [[NSUserDefaults standardUserDefaults] setObject:password forKey:USERPASSWORDKEY];
            [[NSUserDefaults standardUserDefaults] setObject:account forKey:NURSEACCOUNTKEY];

            [[NSUserDefaults standardUserDefaults] synchronize];//强制写入,保存数据
            
            NSString *nurseDistrict = [NSString stringWithFormat:@"%@",[nurseDic valueForKey:@"nurseDistrict"]];
            //未认证时 弹出提示框
            BOOL isDistrict = [nurseDistrict isEqualToString:@"1"] ? NO : YES;
            if (isDistrict) {
                [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
            }else{
                [self showAlertView];
            }
        }else if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"400"]){
            NSLog(@"faile");
            [self.view makeToast:[NSString stringWithFormat:@"%@",[respondDict valueForKey:@"data"]] duration:1.2 position:@"center"];
        }
    } failure:^(NSError* err){
        [self hideHud];
        NSLog(@"err:%@",err);
        [self.view makeToast:ERRORREQUESTTIP duration:2.0 position:@"center"];
    }];
}

- (IBAction)enrollButtonClick:(id)sender
{
    HeEnrollVC *enrollVC = [[HeEnrollVC alloc] init];
    enrollVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:enrollVC animated:YES];
}

- (IBAction)securityButtonClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    passwordField.secureTextEntry = sender.selected;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
    }
    return YES;
}

//忘记密码
- (IBAction)forgetPassword:(id)sender {
    HeForGetPasswordVC *heForGetPasswordVC = [[HeForGetPasswordVC alloc] init];
    heForGetPasswordVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:heForGetPasswordVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)showAlertView{
    
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
    
    
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 40)];
    titleL.textColor = [UIColor blackColor];
    titleL.textAlignment = NSTextAlignmentLeft;
    titleL.font = [UIFont systemFontOfSize:18.0];
    titleL.backgroundColor = [UIColor clearColor];
    [addBgView addSubview:titleL];
    
    NSInteger addTextField_H = 44;
    NSInteger addTextField_Y = 50;
    NSInteger addTextField_W =SCREENWIDTH-40;
    
    UILabel *infoTip= [[UILabel alloc] initWithFrame:CGRectMake(10, addTextField_Y, addTextField_W, addTextField_H)];//高度--44
    infoTip.font = [UIFont systemFontOfSize:12.0];
    infoTip.numberOfLines = 0;
    infoTip.backgroundColor = [UIColor clearColor];
    [addBgView addSubview:infoTip];
    
    titleL.text = @"提示";
    infoTip.text = @"请先完善信息，通过审核方可提供相关服务，点击‘确认’进入完善信息";
    
    NSInteger wordNum_Y = addTextField_Y+44;
    
    NSInteger cancleBt_X = SCREENWIDTH-20-10-90;
    NSInteger cancleBt_Y = wordNum_Y+30;
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
    [okBt setTitle:@"确认" forState:UIControlStateNormal];
    okBt.backgroundColor = [UIColor clearColor];
    okBt.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [okBt setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    okBt.tag = 100;
    [okBt addTarget:self action:@selector(clickBtAction:) forControlEvents:UIControlEventTouchUpInside];
    [addBgView addSubview:okBt];
    
    
}

- (void)clickBtAction:(UIButton *)sender{
    NSLog(@"tag:%ld",sender.tag);
    if (sender.tag == 100) {
        BasicInfoVC *basicInfoVC = [[BasicInfoVC alloc] init];
        basicInfoVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:basicInfoVC animated:YES];
    }
    if (sender.tag == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@1];
    }
    if (windowView) {
        [windowView removeFromSuperview];
    }
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
