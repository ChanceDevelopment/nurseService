//
//  MineViewController.m
//  nurseService
//
//  Created by Tony on 2016/12/14.
//  Copyright © 2016年 iMac. All rights reserved.
//

#import "MineViewController.h"
#import "Tool.h"
#import "SettingViewController.h"
#import "MainInfoViewController.h"
#import "MyEvaluateViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>
#import "MyCapitalViewController.h"
#import "MyFansVC.h"

@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>
{
    NSArray *iconArr;
    NSArray *tableItemArr;
    UIImageView *portrait;        //头像
    UILabel *userNameL;       //用户名
    UIButton *signBtn;
    
    UIImageView *healthImageView;
    UILabel *healthL;
    UIImageView *nameImageView;
    UILabel *nameL;
}

@property(strong,nonatomic)IBOutlet UITableView *myTableView;

@end

@implementation MineViewController
@synthesize myTableView;

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
        label.text = @"我的";
        [label sizeToFit];
        self.title = @"我的";
        self.navigationItem.titleView.hidden = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initializaiton];
    [self initView];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNurseData) name:KNOTIFICATION_NURSEINFOCHANGE object:nil];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
    [self getSignInState];
//    [self getNurseData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBarHidden = NO;
}


- (void)initializaiton
{
    [[UINavigationBar appearance] setTintColor:APPDEFAULTORANGE];
    [super initializaiton];
//    iconArr = @[@[@"icon_mycollection",@"icon_publish",@"icon_mycomment"],@[@"icon_patient",@"icon_follow",@"icon_fans"],@[@"icon_schedule",@"icon_service",@"icon_myadd"],@[@"icon_invite",@"icon_set",@"icon_set"]];
    iconArr = @[@"icon_mycomment",@"icon_fans",@"icon_schedule",@"icon_invite",@"icon_set"];
//    tableItemArr = @[@[@"        我的收藏",@"        我的发表",@"        我的评论"],@[@"        我的患者",@"        我的关注",@"        我的粉丝"],@[@"        我的排班表",@"        我的服务",@"        我的常用地址"],@[@"        邀请好友",@"        我的二维码",@"        设置"]];
    tableItemArr =@[@"        我的评论",@"        我的粉丝",@"        我的排班表",@"        邀好友",@"        设置"];
}

- (void)reloadViewData{
    NSString *userHeader = [NSString stringWithFormat:@"%@%@",PIC_URL,[[[NSUserDefaults standardUserDefaults] objectForKey:USERACCOUNTKEY] valueForKey:@"nurseHeader"]];
    [portrait sd_setImageWithURL:[NSURL URLWithString:userHeader] placeholderImage:[UIImage imageNamed:@"defalut_icon"]];
    
    userNameL.text = [NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults] objectForKey:USERACCOUNTKEY] valueForKey:@"nurseNick"]];
    NSString *nurseDistrict = [[[NSUserDefaults standardUserDefaults] objectForKey:USERACCOUNTKEY] valueForKey:@"nurseDistrict"];
    
    if ([nurseDistrict isEqualToString:@"0"]) {
        healthImageView.hidden = NO;
        healthL.hidden = NO;
        nameImageView.hidden = NO;
        nameL.hidden = NO;
    }else{
        healthImageView.hidden = YES;
        healthL.hidden = YES;
        nameImageView.hidden = YES;
        nameL.hidden = YES;
    }
}

- (void)initView
{
    self.view.backgroundColor = [UIColor colorWithWhite:237.0 /255.0 alpha:1.0];
    
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    myTableView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGH-50);
    myTableView.backgroundView = nil;
    myTableView.backgroundColor = [UIColor clearColor];
    [Tool setExtraCellLineHidden:myTableView];

    CGFloat viewHeight = 200;
    
    UIView *headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, SCREENWIDTH, viewHeight);
    headerView.backgroundColor = [UIColor purpleColor];
    
    myTableView.tableHeaderView = headerView;

    
    //签到按钮
//    CGFloat buttonW = 50;
//    CGFloat buttonH = 20;
//    CGFloat buttonX = SCREENWIDTH-60;
//    CGFloat buttonY = 20;
//    signBtn = [[UIButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
//    signBtn.backgroundColor = [UIColor clearColor];
//    signBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
//    signBtn.layer.cornerRadius = 4.0;//2.0是圆角的弧度，根据需求自己更改
//    signBtn.layer.borderWidth = 1.0f;//设置边框颜色
//    signBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
//    [signBtn setTitle:@"签到" forState:UIControlStateNormal];
//    [signBtn addTarget:self action:@selector(toSignInView) forControlEvents:UIControlEventTouchUpInside];
//    [headerView addSubview:signBtn];
    
    //头像
    CGFloat imageDia = 70;              //直径
    CGFloat imageX = (SCREENWIDTH-imageDia)/2.0;
    CGFloat imageY = 40;
    portrait = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, imageY, imageDia, imageDia)];
    portrait.userInteractionEnabled = YES;
    portrait.layer.masksToBounds = YES;
    portrait.contentMode = UIViewContentModeScaleAspectFill;
    portrait.image = [UIImage imageNamed:@"defalut_icon"];
    portrait.layer.borderWidth = 0.0;
    portrait.layer.cornerRadius = imageDia / 2.0;
    portrait.layer.masksToBounds = YES;
    [headerView addSubview:portrait];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToMineInfoView)];
    [portrait addGestureRecognizer:tap];
    
    NSString *userHeader = [NSString stringWithFormat:@"%@%@",PIC_URL,[[[NSUserDefaults standardUserDefaults] objectForKey:USERACCOUNTKEY] valueForKey:@"nurseHeader"]];
    [portrait sd_setImageWithURL:[NSURL URLWithString:userHeader] placeholderImage:[UIImage imageNamed:@"defalut_icon"]];
    
    //用户名
    CGFloat labelX = SCREENWIDTH/2.0-150;
    CGFloat labelY = imageY+imageDia+5;
    CGFloat labelH = 25;
    CGFloat labelW = 150;
    
    userNameL = [[UILabel alloc] init];
    userNameL.textAlignment = NSTextAlignmentRight;
    userNameL.backgroundColor = [UIColor clearColor];
    userNameL.font = [UIFont systemFontOfSize:15.0];
    userNameL.textColor = [UIColor whiteColor];
    userNameL.frame = CGRectMake(labelX, labelY, labelW, labelH);
    [headerView addSubview:userNameL];
    userNameL.text = [NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults] objectForKey:USERACCOUNTKEY] valueForKey:@"nurseNick"]];
    
    CGFloat sexX = SCREENWIDTH/2.0+10;
    CGFloat sexY = labelY;
    CGFloat sexW = 50;
    UILabel *sexL = [[UILabel alloc] init];
    sexL.textAlignment = NSTextAlignmentLeft;
    sexL.backgroundColor = [UIColor clearColor];
    sexL.font = [UIFont systemFontOfSize:15.0];
    sexL.textColor = [UIColor whiteColor];
    sexL.frame = CGRectMake(sexX, sexY, sexW, labelH);
    [headerView addSubview:sexL];
    sexL.text = [[NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults] objectForKey:USERACCOUNTKEY] valueForKey:@"nurseSex"]] isEqualToString:@"1"] ? @"男" : @"女";
    
    CGFloat healthX = 30;
    CGFloat healthY = labelY +30;
    CGFloat healthW = 15;
    healthImageView = [[UIImageView alloc] initWithFrame:CGRectMake(healthX, healthY, healthW, healthW)];
    healthImageView.backgroundColor = [UIColor clearColor];
    healthImageView.image = [UIImage imageNamed:@"icon_health_authent"];
    [headerView addSubview:healthImageView];

    CGFloat healthL_X = healthX+20;
    CGFloat healthL_Y = healthY-5;
    CGFloat healthL_W = 120;
    healthL = [[UILabel alloc] init];
    healthL.textAlignment = NSTextAlignmentLeft;
    healthL.backgroundColor = [UIColor clearColor];
    healthL.font = [UIFont systemFontOfSize:15.0];
    healthL.textColor = [UIColor whiteColor];
    healthL.frame = CGRectMake(healthL_X, healthL_Y, healthL_W, labelH);
    [headerView addSubview:healthL];
    healthL.text = @"国家卫计委认证";
    
    nameImageView = [[UIImageView alloc] initWithFrame:CGRectMake(healthL_X+healthL_W+10, healthY, healthW, healthW)];
    nameImageView.backgroundColor = [UIColor clearColor];
    nameImageView.image = [UIImage imageNamed:@"icon_name_authent"];
    [headerView addSubview:nameImageView];
    
    CGFloat nameL_X = healthL_X+healthL_W+healthW+15;
    CGFloat nameL_Y = healthL_Y;
    CGFloat nameL_W = 90;
    nameL = [[UILabel alloc] init];
    nameL.textAlignment = NSTextAlignmentLeft;
    nameL.backgroundColor = [UIColor clearColor];
    nameL.font = [UIFont systemFontOfSize:15.0];
    nameL.textColor = [UIColor whiteColor];
    nameL.frame = CGRectMake(nameL_X, nameL_Y, nameL_W, labelH);
    [headerView addSubview:nameL];
    nameL.text = @"实名认证";
    
    NSString *nurseDistrict = [[[NSUserDefaults standardUserDefaults] objectForKey:USERACCOUNTKEY] valueForKey:@"nurseDistrict"];
    
    if ([nurseDistrict isEqualToString:@"0"]) {
        healthImageView.hidden = NO;
        healthL.hidden = NO;
        nameImageView.hidden = NO;
        nameL.hidden = NO;
    }else{
        healthImageView.hidden = YES;
        healthL.hidden = YES;
        nameImageView.hidden = YES;
        nameL.hidden = YES;
    }
    
//    viewHeight
    NSArray *titleArr = @[@"我的资金",@"我的积分",@"我的信息"];
    CGFloat titleX = 0;
    CGFloat titleY = viewHeight-30;
    CGFloat titleW = SCREENWIDTH/3.0;
    CGFloat titleH = 30;
    for (int i = 0; i<[titleArr count];i++) {
        
        UIButton *titleBt = [[UIButton alloc] initWithFrame:CGRectMake(titleX+i*titleW, titleY, titleW, titleH)];
        [titleBt setTitle:titleArr[i] forState:UIControlStateNormal];
        titleBt.titleLabel.font = [UIFont systemFontOfSize:18.0];
        titleBt.backgroundColor = [UIColor clearColor];
        titleBt.tag = 100+i;
        [titleBt addTarget:self action:@selector(clickTitleBtAction:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:titleBt];
        
        if (i>0) {
            UILabel *lineL = [[UILabel alloc] initWithFrame:CGRectMake(titleX+i*titleW, titleY, 1, titleH)];
            [lineL setBackgroundColor:[UIColor whiteColor]];
            [headerView addSubview:lineL];
        }
    }
    
}

- (void)clickTitleBtAction:(UIButton*)sender{
    NSLog(@"tag:%ld",sender.tag);
    if (sender.tag == 100) {
        MyCapitalViewController *myCapitalViewController = [[MyCapitalViewController alloc] init];
        myCapitalViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myCapitalViewController animated:YES];
    }else if (sender.tag == 101){
        
    }else if (sender.tag == 102){
        [self goToMineInfoView];
    }
}

- (void)toSignInView{
    NSLog(@"toSignInView");
    NSString *userAccount = [[NSUserDefaults standardUserDefaults] objectForKey:USERIDKEY];

    NSDictionary * params  = @{@"nurseId": userAccount};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:TOSIGNIN params:params success:^(AFHTTPRequestOperation* operation,id response){
        
        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSMutableDictionary *respondDict = [NSMutableDictionary dictionaryWithDictionary:[respondString objectFromJSONString]];
        if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"200"]) {
            NSLog(@"success");
            if ([[respondDict valueForKey:@"json"] boolValue]) {
                [signBtn setTitle:@"已签" forState:UIControlStateNormal];
                [signBtn setEnabled:NO];
            }
        }else if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"400"]){
            NSLog(@"faile");
        }
        [self.view makeToast:[NSString stringWithFormat:@"%@",[respondDict valueForKey:@"data"]] duration:1.2 position:@"center"];
    } failure:^(NSError* err){
        NSLog(@"err:%@",err);
        [self.view makeToast:ERRORREQUESTTIP duration:2.0 position:@"center"];
    }];
}

- (void)getSignInState{
    NSLog(@"toSignInView");
    NSString *userAccount = [[NSUserDefaults standardUserDefaults] objectForKey:USERIDKEY];

    NSDictionary * params  = @{@"nurseId": userAccount};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:SIGNINSTATE params:params success:^(AFHTTPRequestOperation* operation,id response){
        
        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSMutableDictionary *respondDict = [NSMutableDictionary dictionaryWithDictionary:[respondString objectFromJSONString]];
        if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"200"]) {
            NSLog(@"success");
            if ([[NSString stringWithFormat:@"%@",[respondDict valueForKey:@"json"]] isEqualToString:@"no"]) {
                if (signBtn) {
                    [signBtn setTitle:@"签到" forState:UIControlStateNormal];
                    [signBtn setEnabled:YES];
                }
            }else{
                if (signBtn) {
                    [signBtn setTitle:@"已签" forState:UIControlStateNormal];
                    [signBtn setEnabled:NO];
                }
            }
        }else if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"400"]){
            NSLog(@"faile");
            [self.view makeToast:[NSString stringWithFormat:@"%@",[respondDict valueForKey:@"data"]] duration:1.2 position:@"center"];
        }
        
    } failure:^(NSError* err){
        NSLog(@"err:%@",err);
        [self.view makeToast:ERRORREQUESTTIP duration:2.0 position:@"center"];
    }];
}

#pragma mark UITableViewdDataSource UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return iconArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier = @"cellIndentifier";
    UITableViewCell *userCell = [tableView cellForRowAtIndexPath:indexPath];
    if (!userCell) {
        userCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    CGSize cellSize = [tableView rectForRowAtIndexPath:indexPath].size;
    CGFloat iconY = 10;
    CGFloat iconH = cellSize.height - 2 * iconY;
    CGFloat iconX = 10;
    CGFloat iconW = iconH;
    switch (section) {
        case 0:
        {
            UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[iconArr objectAtIndex:row]]];
            icon.frame = CGRectMake(iconX, iconY, iconW, iconH);
            [userCell addSubview:icon];
            userCell.textLabel.text = [tableItemArr objectAtIndex:row];
            userCell.textLabel.textColor = [UIColor grayColor];
            userCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        }
        case 1:
        {
            UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[iconArr[section] objectAtIndex:row]]];
            icon.frame = CGRectMake(iconX, iconY, iconW, iconH);
            [userCell addSubview:icon];
            userCell.textLabel.text = [tableItemArr objectAtIndex:row];
            userCell.textLabel.textColor = [UIColor grayColor];
            userCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        }
        case 2:
        {
            UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[iconArr[section] objectAtIndex:row]]];
            icon.frame = CGRectMake(iconX, iconY, iconW, iconH);
            [userCell addSubview:icon];
            userCell.textLabel.text = [tableItemArr objectAtIndex:row];
            userCell.textLabel.textColor = [UIColor grayColor];
            userCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        }
        case 3:
        {
            UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[iconArr[section] objectAtIndex:row]]];
            icon.frame = CGRectMake(iconX, iconY, iconW, iconH);
            [userCell addSubview:icon];
            userCell.textLabel.text = [tableItemArr[section] objectAtIndex:row];
            userCell.textLabel.textColor = [UIColor grayColor];
            userCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        }
        default:
            break;
    }
    return userCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSInteger index = indexPath.row;
    NSInteger sectionNum = indexPath.section;
    NSLog(@"section:%ld,index:%ld",sectionNum,index);
    switch (sectionNum) {
        case 0:
        {
            switch (index) {
                case 0:
                {//我的评论
                    MyEvaluateViewController *myEvaluateViewController = [[MyEvaluateViewController alloc] init];
                    myEvaluateViewController.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:myEvaluateViewController animated:YES];
                }
                    break;
                case 1:
                {//我的粉丝
                    MyFansVC *myFansVC = [[MyFansVC alloc] init];
                    myFansVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:myFansVC animated:YES];
                }
                    break;
                case 2:
                {//我的排班表
                    [self.view makeToast:@"功能未完善" duration:1.2 position:@"center"];
                }
                    break;
                case 3:
                {//邀请好友
                    [self inviteFriend];
                }
                    break;
                case 4:
                {//设置
                    SettingViewController *settingViewController = [[SettingViewController alloc] init];
                    settingViewController.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:settingViewController animated:YES];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            switch (index) {
                case 0:
                {//我的患者
                }
                    break;
                case 1:
                {//我的关注
                }
                    break;
                case 2:
                {//我的粉丝
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 2:
        {
            switch (index) {
                case 0:
                {//我的排班表
                }
                    break;
                case 1:
                {//我的服务
                }
                    break;
                case 2:
                {//我的常用地址
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 3:
        {
            switch (index) {
                case 0:
                {//邀请好友
                    [self inviteFriend];
                }
                    break;
                case 1:
                {//我的二维码
                }
                    break;
                case 2:
                {//设置
                    SettingViewController *settingViewController = [[SettingViewController alloc] init];
                    settingViewController.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:settingViewController animated:YES];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 10;
}


- (void)goToMineInfoView{
    MainInfoViewController *mainInfoViewController = [[MainInfoViewController alloc] init];
    mainInfoViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:mainInfoViewController animated:YES];
}

- (void)inviteFriend
{
    //商品的分享
    NSString *titleStr = @"专业护士上门";
    NSString *imagePath = [NSString stringWithFormat:@"%@nurseDoor/img/index2.png",PIC_URL]; //图片的链接地址
    NSString *url = [NSString stringWithFormat:@"%@nurseDoor/fenxiang.jsp",PIC_URL];
    NSString *content = @"我在这里邀请你的加入";
    //构造分享内容
    /***新版分享***/
    //1、创建分享参数（必要）2/6/22/23/24/37
//    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSArray* imageArray = @[[NSURL URLWithString:imagePath]];
    if (imageArray) {
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:content
                                         images:imageArray
                                            url:[NSURL URLWithString:url]
                                          title:titleStr
                                           type:SSDKContentTypeAuto];
        
        [ShareSDK showShareActionSheet:nil
                                 items:@[
                                         @(SSDKPlatformSubTypeQZone),
                                         @(SSDKPlatformSubTypeWechatSession),
                                         @(SSDKPlatformSubTypeWechatTimeline),
                                         @(SSDKPlatformSubTypeQQFriend),
                                         @(SSDKPlatformSubTypeWechatFav)]
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       NSLog(@"error:%@",error.userInfo);
                       switch (state) {
                               
                           case SSDKResponseStateSuccess:
                           {
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateCancel:
                           {
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           default:
                               break;
                       }
                       
                       if (state != SSDKResponseStateBegin)
                       {
                           
                       }
                       
                   }];
    }
}



- (void)getNurseData{
    NSString *account = [[NSUserDefaults standardUserDefaults] objectForKey:NURSEACCOUNTKEY];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:USERPASSWORDKEY];
    if (!password) {
        password = @"";
    }
    NSDictionary * params  = @{@"NurseName": account,@"NursePwd" : password};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:LOGINURL params:params success:^(AFHTTPRequestOperation* operation,id response){
        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSLog(@"护士信息：%@",respondString);
        NSMutableDictionary *respondDict = [NSMutableDictionary dictionaryWithDictionary:[respondString objectFromJSONString]];
        if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"200"]) {
            NSLog(@"success");
            
            NSDictionary *userInfoDic = [NSDictionary dictionaryWithDictionary:[respondDict valueForKey:@"json"]];
            NSMutableDictionary *nurseDic = [NSMutableDictionary dictionaryWithCapacity:0];
            
            for (NSString *key in [userInfoDic allKeys]) {
                
                if ([[NSString stringWithFormat:@"%@",[userInfoDic valueForKey:key]] isEqualToString:@"<null>"]) {
                    NSLog(@"key:%@",key);
                    [nurseDic setValue:@"" forKey:key];
                }else{
                    [nurseDic setValue:[NSString stringWithFormat:@"%@",[userInfoDic valueForKey:key]] forKey:key];
                }
            }
            NSLog(@"%@",nurseDic);
            
            
            [[NSUserDefaults standardUserDefaults] setObject:nurseDic forKey:USERACCOUNTKEY];//本地存储
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",[userInfoDic valueForKey:@"nurseId"]] forKey:USERIDKEY];
            [[NSUserDefaults standardUserDefaults] synchronize];//强制写入,保存数据
            
            [self reloadViewData];
            
        }else if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"400"]){
            NSLog(@"faile");
        }
        
        
    } failure:^(NSError* err){
        NSLog(@"err:%@",err);
    }];

//    NSString *latitude = [[HeSysbsModel getSysModel].userLocationDict objectForKey:@"longitude"];
//    if (!latitude) {
//        latitude = @"";
//    }
//    NSString *longitude = [[HeSysbsModel getSysModel].userLocationDict objectForKey:@"latitude"];
//    if (!longitude) {
//        longitude = @"";
//    }
//    NSString *userAccount = [[NSUserDefaults standardUserDefaults] objectForKey:USERIDKEY];
//
//    NSDictionary * params  = @{@"nurseid":userAccount,@"latitude": latitude,@"longitude":longitude};
//    
//    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:SELECTBURSEBYID params:params success:^(AFHTTPRequestOperation* operation,id response){
//        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
//        
//        NSDictionary *respondDict = [NSDictionary dictionaryWithDictionary:[respondString objectFromJSONString]];
//        if ([[respondDict valueForKey:@"errorCode"] integerValue] == REQUESTCODE_SUCCEED){
//            NSLog(@"update Location Succeed!");
//            
//        }
//    } failure:^(NSError* err){
//        
//    }];

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
