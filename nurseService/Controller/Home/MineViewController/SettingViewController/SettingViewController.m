//
//  SettingViewController.m
//  nurseService
//
//  Created by 梅阳阳 on 16/12/20.
//  Copyright © 2016年 iMac. All rights reserved.
//

#import "SettingViewController.h"
#import "FeedbackViewController.h"
@interface SettingViewController ()

@end

@implementation SettingViewController

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
        label.text = @"设置";
        [label sizeToFit];
        self.title = @"设置";
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)logOffAction:(UIButton *)sender {

    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERIDKEY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERACCOUNTKEY];
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
}
- (IBAction)updateVersionAction:(UIButton *)sender {
}
- (IBAction)feedBackAction:(UIButton *)sender {
    FeedbackViewController *feedbackViewController = [[FeedbackViewController alloc] init];
    feedbackViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:feedbackViewController animated:YES];
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
