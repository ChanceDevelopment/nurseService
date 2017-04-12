//
//  AddPaswordVC.m
//  nurseService
//
//  Created by 梅阳阳 on 17/1/17.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "AddPaswordVC.h"
#import "MyCapitalViewController.h"

@interface AddPaswordVC ()
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation AddPaswordVC
@synthesize passwordTextField;
@synthesize codeStr;
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
    
}



- (IBAction)okAction:(id)sender {
    if ([passwordTextField.text isEqualToString:@""] || (passwordTextField.text.length < 6) || (passwordTextField.text.length > 16)) {
        [self showHint:@"请输入正确密码"];
        return;
    }
    
    NSString *nurseId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:USERIDKEY]];
    NSDictionary * params  = @{@"nurseId": nurseId,@"pwd":passwordTextField.text,@"account":@"",@"drawcode":codeStr};
    
    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:BINDACCOUNTANDPAW params:params success:^(AFHTTPRequestOperation* operation,id response){
        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSLog(@"respondString:%@",respondString);
        NSMutableDictionary *respondDict = [NSMutableDictionary dictionaryWithDictionary:[respondString objectFromJSONString]];
        
        [self.view makeToast:[NSString stringWithFormat:@"%@",[respondDict valueForKey:@"data"]] duration:1.2 position:@"center"];
        if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"200"]) {
            NSLog(@"success");
            [[NSUserDefaults standardUserDefaults] setObject:passwordTextField.text forKey:THREEINFOKEY];
            [self performSelector:@selector(backToRoot) withObject:nil afterDelay:1.2];
            
        }else if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"400"]){
            NSLog(@"faile");
        }
        
        
    } failure:^(NSError* err){
        NSLog(@"err:%@",err);
        [self.view makeToast:ERRORREQUESTTIP duration:2.0 position:@"center"];
    }];

}

- (void)backToRoot{
    [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:[[self.navigationController viewControllers] count] -3] animated:YES];

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
