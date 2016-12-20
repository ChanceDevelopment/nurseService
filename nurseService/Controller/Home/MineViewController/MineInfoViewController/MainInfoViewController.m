//
//  MainInfoViewController.m
//  nurseService
//
//  Created by 梅阳阳 on 16/12/20.
//  Copyright © 2016年 iMac. All rights reserved.
//

#import "MainInfoViewController.h"

@interface MainInfoViewController ()

@end

@implementation MainInfoViewController

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
        label.text = @"个人资料";
        [label sizeToFit];
        self.title = @"个人资料";
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
- (IBAction)clickHeadImageAction:(UIButton *)sender {
}
- (IBAction)clickNickNameAction:(UIButton *)sender {
}
- (IBAction)clickTelephoneNumAction:(UIButton *)sender {
}
- (IBAction)clickIdCardAction:(UIButton *)sender {
}
- (IBAction)clickSexTypeAction:(UIButton *)sender {
}
- (IBAction)clickAdvantageInfoAction:(UIButton *)sender {
}
- (IBAction)clickNurseInfoAction:(UIButton *)sender {
}
- (IBAction)clickAddressInfoAction:(UIButton *)sender {
}
- (IBAction)clickServiceInfoAction:(UIButton *)sender {
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
