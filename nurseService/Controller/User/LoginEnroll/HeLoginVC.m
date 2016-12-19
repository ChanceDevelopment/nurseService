//
//  HeLoginVC.m
//  nurseService
//
//  Created by Tony on 2016/12/14.
//  Copyright © 2016年 iMac. All rights reserved.
//

#import "HeLoginVC.h"
#import "HeEnrollVC.h"

@interface HeLoginVC ()<UITextFieldDelegate>
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
}

- (IBAction)loginButtonClick:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
    return;
//    stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]
    
    NSString *account = [accountField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *password = passwordField.text;
    if (account == nil || [account isEqualToString:@""]) {
        [self showHint:@"请输入手机号码"];
        return;
    }
    if (password == nil || [password isEqualToString:@""]) {
        [self showHint:@"请输入登录密码"];
        return;
    }
    if (![Tool isMobileNumber:account]) {
        [self showHint:@"请输入正确的手机号码"];
        return;
    }
    
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
