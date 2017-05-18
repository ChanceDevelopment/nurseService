//
//  DrawCashViewController.m
//  nurseService
//
//  Created by 梅阳阳 on 16/12/30.
//  Copyright © 2016年 iMac. All rights reserved.
//

#import "DrawCashViewController.h"

@interface DrawCashViewController ()
{
    UITextField *addTextField;
    UIView *windowView;
}
@property (strong, nonatomic) IBOutlet UITextField *crashTextField;

@end

@implementation DrawCashViewController
@synthesize crashTextField;
@synthesize totalCapital;
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
        label.text = @"提现";
        [label sizeToFit];
        self.title = @"提现";
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
    
    NSString *capitalStr = [[NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults] objectForKey:THREEINFOKEY] valueForKey:@"nurseBalance"]] isEqualToString:@""] ? @"0" : [NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults] objectForKey:THREEINFOKEY] valueForKey:@"nurseBalance"]];
    crashTextField.placeholder = [NSString stringWithFormat:@"本次最多可提现%@元",capitalStr];
}
//确定
- (IBAction)okAction:(id)sender {
    if ([crashTextField.text isEqualToString:@""]) {
        [self.view makeToast:@"请输入提现金额" duration:1.2 position:@"center"];
        return;
    }else if ([crashTextField.text integerValue] < 200){
        [self.view makeToast:@"提现金额过小，无法提现" duration:1.2 position:@"center"];
    }else if ([crashTextField.text integerValue] > 2000){
        [self.view makeToast:@"提现金额过大，无法提现" duration:1.2 position:@"center"];
    }else if([crashTextField.text integerValue] > totalCapital){
        [self.view makeToast:@"余额不足，无法提现" duration:1.2 position:@"center"];
    }else{
        [self showPasswordView];
    }
}
//输入支付密码弹窗
- (void)showPasswordView{
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
    titleL.text = @"支付密码";

    
    NSInteger addTextField_H = 44;
    NSInteger addTextField_Y = 50;
    NSInteger addTextField_W =SCREENWIDTH-40;
    
    addTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, addTextField_Y, addTextField_W, addTextField_H)];//高度--44
    addTextField.placeholder = @"请输入支付密码";
    addTextField.font = [UIFont systemFontOfSize:15.0];
    addTextField.backgroundColor = [UIColor clearColor];
    addTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //    addTextField.keyboardType = UIKeyboardTypeNamePhonePad;
    addTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    addTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    addTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [addBgView addSubview:addTextField];
    
    //边线
    UILabel *borderLine = [[UILabel alloc] initWithFrame:CGRectMake(10, addTextField_Y+44, addTextField_W, 0.5)];
    [addBgView addSubview:borderLine];
    borderLine.backgroundColor = [UIColor blueColor];
    
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
    okBt.tag = 1;
    [okBt addTarget:self action:@selector(clickBtAction:) forControlEvents:UIControlEventTouchUpInside];
    [addBgView addSubview:okBt];
    
}
//确定提现，提交数据
- (void)clickBtAction:(UIButton *)sender{
    NSLog(@"tag:%ld",sender.tag);
    if (sender.tag == 1) {
        if ([addTextField.text isEqualToString:@""]) {
            [self.view makeToast:@"请输入支付密码" duration:1.2 position:@"center"];
            return;
        }
        if ([addTextField.text isEqualToString:@""]) {
            [self.view makeToast:@"请输入支付密码" duration:1.2 position:@"center"];
            return;
        }
        NSString *nurseId = [[NSUserDefaults standardUserDefaults] objectForKey:USERIDKEY];
        NSDictionary * params  = @{@"userId" : nurseId,
                                   @"identity" : @"1",
                                   @"money" : crashTextField.text};
        [AFHttpTool requestWihtMethod:RequestMethodTypePost url:NURSEDRAWMONEY params:params success:^(AFHTTPRequestOperation* operation,id response){
            NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
            NSMutableDictionary *respondDict = [NSMutableDictionary dictionaryWithDictionary:[respondString objectFromJSONString]];
            [self.view makeToast:[NSString stringWithFormat:@"%@",[respondDict valueForKey:@"data"]] duration:1.2 position:@"center"];
            if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"200"]) {
                NSLog(@"success");
                [self performSelector:@selector(backToRoot) withObject:nil afterDelay:1.2];
            }else if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"400"]){
                NSLog(@"faile");
            }
        } failure:^(NSError* err){
            NSLog(@"err:%@",err);
            [self.view makeToast:ERRORREQUESTTIP duration:2.0 position:@"center"];
        }];
    }
    if (windowView) {
        [windowView removeFromSuperview];
    }
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
