//
//  Left
//
//  Created by apple on 15/12/15.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "HomeTabbarController.h"
#import "HomeViewController.h"
#import "RankViewController.h"
#import "OrderViewController.h"
#import "MineViewController.h"
@interface HomeTabbarController ()<UITabBarControllerDelegate>

@property(nonatomic, strong) UIButton *openDrawerButton;
@end

@implementation HomeTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.selectedIndex = 0;
   
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    [self addChildVc:homeVC title:@"学术圈" image:@"main_home_unselector" selectedImage:@"main_home_selector"];
//    RankViewController *rankVC = [[RankViewController alloc] init];
//    [self addChildVc:rankVC title:@"排行榜" image:@"main_rank_unselector" selectedImage:@"main_rank_selector"];
    OrderViewController *orderVC = [[OrderViewController alloc] init];
    [self addChildVc:orderVC title:@"订单" image:@"main_order_unselector" selectedImage:@"main_order_selector"];
    MineViewController *mineVC = [[MineViewController alloc] init];
    [self addChildVc:mineVC title:@"我的" image:@"main_mine_unselector" selectedImage:@"main_mine_selector"];

    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.selectedIndex = self.selectVCIndex;
}

/**
 *  添加一个子控制器
 *
 *  @param childVc       子控制器
 *  @param title         标题
 *  @param image         图片
 *  @param selectedImage 选中的图片
 */
- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    childVc.title = title;
//    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:28],NSFontAttributeName, nil];
//    
//    [childVc.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
   
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = [UIColor purpleColor];
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    
    [self addChildViewController:childVc];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:childVc];
//    [nav.navigationBar setBarTintColor:[UIColor purpleColor]];
//    [self addChildViewController:nav];
}


#pragma mark - Configuring the view’s layout behavior

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
