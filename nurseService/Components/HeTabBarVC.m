//
//  HeTabBarVC.m
//  huayoutong
//
//  Created by HeDongMing on 16/3/2.
//  Copyright © 2016年 HeDongMing. All rights reserved.
//

#import "HeTabBarVC.h"
#import "RDVTabBarItem.h"
#import "RDVTabBar.h"
#import "RDVTabBarController.h"
#import "HeSysbsModel.h"
#import "HomeViewController.h"


@interface HeTabBarVC ()

@end

@implementation HeTabBarVC
@synthesize homeVC;
@synthesize rankVC;
@synthesize orderVC;
@synthesize userVC;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self getUserInfo];
    [self autoLogin];
    [self setupSubviews];
    
}

//后台自动登录
- (void)autoLogin
{
    
}

- (void)clearInfo
{
    
}

//获取用户的信息
- (void)getUserInfo
{
   
    
}

- (void)getUserAlbum
{
    
}

- (void)getActivityTypeAddress
{
    
}

//设置根控制器的四个子控制器
- (void)setupSubviews
{
    homeVC = [[HomeViewController alloc] init];
    CustomNavigationController *homeNav = [[CustomNavigationController alloc] initWithRootViewController:homeVC];
    
    rankVC = [[RankViewController alloc] init];
    CustomNavigationController *rankNav = [[CustomNavigationController alloc] initWithRootViewController:rankVC];
    
    orderVC = [[OrderViewController alloc] init];
    CustomNavigationController *orderNav = [[CustomNavigationController alloc] initWithRootViewController:orderVC];
    
    userVC = [[MineViewController alloc] init];
    CustomNavigationController *userNav = [[CustomNavigationController alloc]
                                           initWithRootViewController:userVC];
    
    [self setViewControllers:@[homeNav,rankNav,orderNav,userNav]];
    [self customizeTabBarForController];
}

//设置底部的tabbar
- (void)customizeTabBarForController{
    //    tabbar_normal_background   tabbar_selected_background
    UIImage *finishedImage = [UIImage imageNamed:@"tabbar_normal_background"];
    UIImage *unfinishedImage = [UIImage imageNamed:@"tabbar_normal_background"];
    NSArray *tabBarItemImages = @[@"tabar_home_icon", @"tabar_rank_icon", @"tabar_order_icon", @"tabar_user_icon"];
    
    NSInteger index = 0;
    for (RDVTabBarItem *item in [[self tabBar] items]) {
        [item setBackgroundSelectedImage:finishedImage withUnselectedImage:unfinishedImage];
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_active",
                                                      [tabBarItemImages objectAtIndex:index]]];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_normal",
                                                        [tabBarItemImages objectAtIndex:index]]];
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        
        index++;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100) {
        //后台自动登录失败，退出登录
        [self clearInfo];
    }
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
