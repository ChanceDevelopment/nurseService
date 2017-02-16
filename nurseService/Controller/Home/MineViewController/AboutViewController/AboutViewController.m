//
//  AboutViewController.m
//  nurseService
//
//  Created by 梅阳阳 on 17/2/15.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "AboutViewController.h"
#import "Tool.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

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
        label.text = @"关于";
        [label sizeToFit];
        self.title = @"关于";
        
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
    
    CGFloat iconW = 60;
    CGFloat iconX = (SCREENWIDTH-60)/2.0;
    CGFloat iconY = 100;

    UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(iconX, iconY, iconW, iconW)];
    iconImage.backgroundColor = [UIColor clearColor];
    iconImage.image = [UIImage imageNamed:@"icon"];
    [self.view addSubview:iconImage];

    CGFloat appNameW = 200;
    CGFloat appNameX = (SCREENWIDTH-200)/2.0;
    CGFloat appNameY = CGRectGetMaxY(iconImage.frame)+10;

    UILabel *appName = [[UILabel alloc] initWithFrame:CGRectMake(appNameX, appNameY, appNameW, 60)];
    appName.backgroundColor = [UIColor clearColor];
    appName.text = @"安心护";
    appName.textAlignment = NSTextAlignmentCenter;
    appName.font = [UIFont systemFontOfSize:40.0];
    appName.textColor = APPDEFAULTTITLECOLOR;
    [self.view addSubview:appName];

    CGFloat versionW = SCREENWIDTH-20;
    CGFloat versionX = 10;
    CGFloat versionY = CGRectGetMaxY(appName.frame)+10;
    
    UILabel *versionL = [[UILabel alloc] initWithFrame:CGRectMake(versionX, versionY, versionW, 20)];
    versionL.backgroundColor = [UIColor clearColor];
    versionL.adjustsFontSizeToFitWidth = YES;
    versionL.textAlignment = NSTextAlignmentCenter;
    versionL.text = [NSString stringWithFormat:@"版本号：%@",[Tool getAppVersion]];
    versionL.font = [UIFont systemFontOfSize:14.0];
    versionL.textColor = APPDEFAULTTITLECOLOR;
    [self.view addSubview:versionL];

    CGFloat tipW = SCREENWIDTH-20;
    CGFloat tipX = 10;
    CGFloat tipY = CGRectGetMaxY(versionL.frame)+10;
    
    UILabel *tipL = [[UILabel alloc] initWithFrame:CGRectMake(tipX, tipY, tipW, 20)];
    tipL.backgroundColor = [UIColor clearColor];
    tipL.adjustsFontSizeToFitWidth = YES;
    tipL.textAlignment = NSTextAlignmentCenter;
    tipL.text = @"本产品最终解释权归杭州小护健康科技有限公司所有";
    tipL.font = [UIFont systemFontOfSize:14.0];
    tipL.textColor = APPDEFAULTTITLECOLOR;
    [self.view addSubview:tipL];
    
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
