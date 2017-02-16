//
//  MyServiceListVC.m
//  nurseService
//
//  Created by 梅阳阳 on 17/2/16.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "MyServiceListVC.h"

@interface MyServiceListVC ()

@end

@implementation MyServiceListVC

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
        label.text = @"我的服务";
        [label sizeToFit];
        self.title = @"我的服务";
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
    
//
    UIButton *changeServiceBt = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 25)];
    changeServiceBt.backgroundColor = [UIColor clearColor];
    [changeServiceBt setTitle:@"变更服务" forState:UIControlStateNormal];
    [changeServiceBt setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    changeServiceBt.titleLabel.font = [UIFont systemFontOfSize:13.0];
    changeServiceBt.titleLabel.adjustsFontSizeToFitWidth = YES;
    [changeServiceBt addTarget:self action:@selector(changeServiceAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *changeBtItem = [[UIBarButtonItem alloc] initWithCustomView:changeServiceBt];
    self.navigationItem.rightBarButtonItem = changeBtItem;
    
}

- (void)changeServiceAction{
    NSLog(@"changeServiceAction");
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
