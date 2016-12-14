//
//  HeTabBarVC.h
//  huayoutong
//
//  Created by HeDongMing on 16/3/2.
//  Copyright © 2016年 HeDongMing. All rights reserved.
//

#import "HeBaseViewController.h"
#import "RDVTabBarController.h"
#import "HomeViewController.h"
#import "RankViewController.h"
#import "MineViewController.h"
#import "OrderViewController.h"

@interface HeTabBarVC : RDVTabBarController<UIAlertViewDelegate>
@property(strong,nonatomic)HomeViewController *homeVC;
@property(strong,nonatomic)RankViewController *rankVC;
@property(strong,nonatomic)OrderViewController *orderVC;
@property(strong,nonatomic)MineViewController *userVC;

@end
