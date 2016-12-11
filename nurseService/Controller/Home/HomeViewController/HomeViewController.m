//
//  HomeViewController.m
//  nurseService
//
//  Created by 梅阳阳 on 16/12/11.
//  Copyright © 2016年 iMac. All rights reserved.
//

#import "HomeViewController.h"
#import "LBBanner.h"
@interface HomeViewController ()<LBBannerDelegate>
{
    NSInteger addStatusBarHeight;
}
@end

@implementation HomeViewController

- (void)viewDidLoad {
    addStatusBarHeight = STATUSBAR_HEIGHT;
    //--ios7 or later  添加 bar
    if (iOS7) {
        
    }else{
        UILabel *addStatusBar = [[UILabel alloc] initWithFrame:CGRectMake(0, -20, SCREENWIDTH, 20)];
        addStatusBar.backgroundColor = TOPNAVIBGCOLOR;
        [self.view addSubview:addStatusBar];
    }
    [super viewDidLoad];
    [self initView];
}

- (void)initView{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //top
    UIView *topNaviView_topClass = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, TOPNAVIHEIGHT + addStatusBarHeight)];
    [self.view addSubview:topNaviView_topClass];
    topNaviView_topClass.userInteractionEnabled = YES;//这样才可以点击
    topNaviView_topClass.backgroundColor = [UIColor whiteColor];
    
    //
//    UIButton *goBack = [[UIButton alloc] initWithFrame:CGRectMake(10, (TOPNAVIHEIGHT-19)/2+ addStatusBarHeight, 24, 19)];
//    [topNaviView_topClass addSubview:goBack];
//    [goBack setBackgroundImage:[UIImage imageNamed:@"icon_list"] forState:UIControlStateNormal];
//    [goBack addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
//    
    //文字
    UILabel *topNaviText = [[UILabel alloc] initWithFrame:CGRectMake(10, 0+ addStatusBarHeight, SCREENWIDTH-120, TOPNAVIHEIGHT)];
    topNaviText.textAlignment = NSTextAlignmentLeft;
    topNaviText.text = @"学术圈"; //60, 0, 250, TOPNAVIHEIGHT
    topNaviText.font = [UIFont systemFontOfSize:18];
    topNaviText.textColor = [UIColor purpleColor];
    topNaviText.userInteractionEnabled = YES;//这样才可以点击
    topNaviText.backgroundColor = [UIColor clearColor];
    [topNaviView_topClass addSubview:topNaviText];
    
    
    UIScrollView *mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, TOPNAVIHEIGHT+addStatusBarHeight, SCREENWIDTH, SCREENHEIGH-TOPNAVIHEIGHT-addStatusBarHeight-49)];
    mainScrollView.showsVerticalScrollIndicator = YES;
    mainScrollView.userInteractionEnabled = YES;
    mainScrollView.scrollEnabled = YES;
    mainScrollView.contentSize = CGSizeMake(SCREENWIDTH, SCREENHEIGH+100);
    mainScrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:mainScrollView];
    
    NSArray * imageNames = @[@"index1", @"index2"];
    LBBanner * banner = [[LBBanner alloc] initWithImageNames:imageNames andFrame:CGRectMake(0, 30, SCREENWIDTH, 180)];
    banner.delegate = self;
    [mainScrollView addSubview:banner];
}

#pragma mark LBBannerDelegate
- (void)banner:(LBBanner *)banner didClickViewWithIndex:(NSInteger)index {
    NSLog(@"didClickViewWithIndex:%ld", index);
}

- (void)banner:(LBBanner *)banner didChangeViewWithIndex:(NSInteger)index {
    NSLog(@"didChangeViewWithIndex:%ld", index);
}
#pragma mark - Configuring the view’s layout behavior

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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
