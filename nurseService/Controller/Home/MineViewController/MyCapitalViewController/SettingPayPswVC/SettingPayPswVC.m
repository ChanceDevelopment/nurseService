//
//  SettingPayPswVC.m
//  nurseService
//
//  Created by 梅阳阳 on 17/1/11.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "SettingPayPswVC.h"

@interface SettingPayPswVC ()

@property (strong, nonatomic) IBOutlet UIButton *codeBt;
@property (strong, nonatomic) IBOutlet UITextField *codeTextField;
@end

@implementation SettingPayPswVC
@synthesize codeBt;
@synthesize codeTextField;

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
    
    codeBt.layer.borderWidth = 1.0;
    codeBt.layer.cornerRadius = 5.0;
    codeBt.layer.backgroundColor = APPDEFAULTORANGE.CGColor;
    codeBt.layer.masksToBounds = YES;
    
}

- (IBAction)getCodeClick:(id)sender {
    //获取注册手机号的验证码
    NSString *phoneNumber = [[[NSUserDefaults standardUserDefaults] objectForKey:USERACCOUNTKEY] valueForKey:@"nursePhone"];
    NSDictionary * params  = @{@"Phone": phoneNumber};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:SMSCODE params:params success:^(AFHTTPRequestOperation* operation,id response){
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
