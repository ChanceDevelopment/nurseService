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
#import "HeMineTableCell.h"
#import "HeBaseTableViewCell.h"

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
    UIView *windowView;
    
    NSMutableArray *serviceArr;
    NSMutableArray *serviceSelectArr;
    NSMutableDictionary *serviceIdDic;


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
    tableItemArr =@[@"        我的评论",@"        我的粉丝",@"        我的服务",@"        邀好友",@"        设置"];
    serviceArr = [[NSMutableArray alloc] initWithCapacity:0];  //可提供服务
    serviceSelectArr = [[NSMutableArray alloc] initWithCapacity:0];
    serviceIdDic = [[NSMutableDictionary alloc] initWithCapacity:0];  //可提供服务
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
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    CGFloat labelX = 0;
    CGFloat labelY = imageY+imageDia+5;
    CGFloat labelH = 25;
    CGFloat labelW = SCREENWIDTH;
    
    userNameL = [[UILabel alloc] init];
    userNameL.textAlignment = NSTextAlignmentCenter;
    userNameL.backgroundColor = [UIColor clearColor];
    userNameL.font = [UIFont systemFontOfSize:15.0];
    userNameL.textColor = [UIColor whiteColor];
    userNameL.frame = CGRectMake(labelX, labelY, labelW, labelH);
    [headerView addSubview:userNameL];
    
    NSString *nurseNick = [[[NSUserDefaults standardUserDefaults] objectForKey:USERACCOUNTKEY] valueForKey:@"nurseNick"];
    if ([nurseNick isMemberOfClass:[NSNull class]] || nurseNick == nil) {
        nurseNick = @"";
    }
    id nurseSex = [[[NSUserDefaults standardUserDefaults] objectForKey:USERACCOUNTKEY] valueForKey:@"nurseSex"];
    NSString *nurseSexStr = @"女";
    if ([nurseSex integerValue] == ENUM_SEX_Boy) {
        nurseSexStr = @"男";
    }
    userNameL.text = [NSString stringWithFormat:@"%@    %@",nurseNick,nurseSexStr];
    
    CGFloat sexX = SCREENWIDTH/2.0+10;
    CGFloat sexY = labelY;
    CGFloat sexW = 50;
    UILabel *sexL = [[UILabel alloc] init];
    sexL.textAlignment = NSTextAlignmentLeft;
    sexL.backgroundColor = [UIColor clearColor];
    sexL.font = [UIFont systemFontOfSize:15.0];
    sexL.textColor = [UIColor whiteColor];
    sexL.frame = CGRectMake(sexX, sexY, sexW, labelH);
//    [headerView addSubview:sexL];
    sexL.text = [[NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults] objectForKey:USERACCOUNTKEY] valueForKey:@"nurseSex"]] isEqualToString:@"1"] ? @"男" : @"女";
    
    CGFloat healthX = 5;
    CGFloat healthW = 15;
    CGFloat healthY = (labelH - 15) / 2.0;
    
    healthImageView = [[UIImageView alloc] initWithFrame:CGRectMake(healthX, healthY, healthW, healthW)];
    healthImageView.backgroundColor = [UIColor clearColor];
    healthImageView.image = [UIImage imageNamed:@"icon_health_authent"];
    [headerView addSubview:healthImageView];

    CGFloat healthL_X = 25;
    CGFloat healthL_Y = 0;
    CGFloat healthL_W = 120;
    healthL = [[UILabel alloc] init];
    healthL.textAlignment = NSTextAlignmentLeft;
    healthL.backgroundColor = [UIColor clearColor];
    healthL.font = [UIFont systemFontOfSize:13.0];
    healthL.textColor = [UIColor whiteColor];
    healthL.text = @"国家卫计委认证";
    CGSize size = [MLLabel getViewSizeByString:healthL.text maxWidth:healthL_W font:healthL.font lineHeight:1.2f lines:0];
    healthL_W = size.width;
    healthL.frame = CGRectMake(healthL_X, healthL_Y, healthL_W, labelH);
    [headerView addSubview:healthL];
    
    CGFloat nameImageViewX = 5;
    CGFloat nameImageViewH = 15;
    CGFloat nameImageViewW = 15;
    CGFloat nameImageViewY = (labelH - nameImageViewH) / 2.0;
    
    nameImageView = [[UIImageView alloc] initWithFrame:CGRectMake(nameImageViewX, nameImageViewY, nameImageViewW, nameImageViewH)];
    nameImageView.backgroundColor = [UIColor clearColor];
    nameImageView.image = [UIImage imageNamed:@"icon_name_authent"];
    [headerView addSubview:nameImageView];
    
    
    CGFloat nameL_X = 25;
    CGFloat nameL_Y = healthL_Y;
    CGFloat nameL_W = 90;
    nameL = [[UILabel alloc] init];
    nameL.textAlignment = NSTextAlignmentLeft;
    nameL.backgroundColor = [UIColor clearColor];
    nameL.font = [UIFont systemFontOfSize:13.0];
    nameL.textColor = [UIColor whiteColor];
    nameL.text = @"实名认证";
    size = [MLLabel getViewSizeByString:nameL.text maxWidth:nameL_W font:nameL.font lineHeight:1.2f lines:0];
    nameL_W = size.width;
    nameL.frame = CGRectMake(nameL_X, nameL_Y, nameL_W, labelH);
    [headerView addSubview:nameL];
    
    CGFloat labelDistance = 10;
    CGFloat healViewX = 0;
    CGFloat healViewY = CGRectGetMaxY(userNameL.frame) + 5;
    CGFloat healViewW = healthL_W + 10 + healthW;
    CGFloat healViewH = 25;
    
    UIView *healBgView = [[UIView alloc] initWithFrame:CGRectMake(healViewX, healViewY, healViewW, healViewH)];
    [healBgView addSubview:healthL];
    [healBgView addSubview:healthImageView];
    
    CGFloat nameBgViewX = 0;
    CGFloat nameBgViewY = CGRectGetMaxY(userNameL.frame) + 5;
    CGFloat nameBgViewW = nameL_W + 10 + nameImageViewW;
    CGFloat nameBgViewH = 25;
    
    UIView *nameBgView = [[UIView alloc] initWithFrame:CGRectMake(nameBgViewX, nameBgViewY, nameBgViewW, nameBgViewH)];
    [nameBgView addSubview:nameL];
    [nameBgView addSubview:nameImageView];
    
    CGFloat bgViewX = (SCREENWIDTH - (nameBgViewW + healViewW + labelDistance)) / 2.0;
    CGRect healBgViewFrame = healBgView.frame;
    healBgViewFrame.origin.x = bgViewX;
    healBgView.frame = healBgViewFrame;
    
    CGRect nameBgViewFrame = nameBgView.frame;
    nameBgViewFrame.origin.x = CGRectGetMaxX(healBgView.frame) + labelDistance;
    nameBgView.frame = nameBgViewFrame;
    
    [headerView addSubview:healBgView];
    [headerView addSubview:nameBgView];
    
    
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
        titleBt.titleLabel.font = [UIFont systemFontOfSize:15.0];
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
    if (tableView.tag == 500) {
        return serviceArr.count;
    }
    return iconArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    static NSString *cellIndentifier = @"cellIndentifier";
    CGSize cellSize = [tableView rectForRowAtIndexPath:indexPath].size;
    NSInteger section = indexPath.section;
    
    if (tableView.tag == 500) {
        
        HeBaseTableViewCell *cell  = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[HeBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier cellSize:cellSize];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREENWIDTH-20, cellSize.height)];
        tipLabel.backgroundColor = [UIColor clearColor];
        tipLabel.text = serviceArr[row];
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.font = [UIFont systemFontOfSize:15.0];
        tipLabel.textColor = [UIColor grayColor];
        [cell addSubview:tipLabel];
        
        CGFloat imageW = 20;
        CGFloat imageX = SCREENWIDTH-100;
        
        UIImageView *selectImage = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, 12, imageW, imageW)];
        [cell addSubview:selectImage];
        selectImage.backgroundColor = [UIColor clearColor];
        selectImage.userInteractionEnabled = YES;
        selectImage.tag = row +50;
        
        for (NSString *serviceStr in serviceSelectArr) {
            if ([serviceStr isEqualToString:serviceArr[row]]) {
                selectImage.image = [UIImage imageNamed:@"icon_hook"];
            }
        }
        
        return cell;
    }
    
    HeMineTableCell *userCell = [tableView cellForRowAtIndexPath:indexPath];
    if (!userCell) {
        userCell = [[HeMineTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    
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
    if (tableView.tag == 500) {
        return 44;
    }
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
            if (tableView.tag == 500) {
                for (int i = 0; i < serviceSelectArr.count; i++) {
                    if ([serviceSelectArr[i] isEqualToString:serviceArr[index]]) {
                        //移除
                        [serviceSelectArr removeObjectAtIndex:i];
                        
                        [tableView reloadData];
                        return;
                    }
                }
                [serviceSelectArr addObject:serviceArr[index]];
                [tableView reloadData];
                
                return;
            }
            
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
                {//我的服务
                    [self showAlertView];
//                    [self.view makeToast:@"功能未完善" duration:1.2 position:@"center"];
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

- (void)showRebackAlertView{
    windowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGH)];
    windowView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5];;
    [[[UIApplication sharedApplication] keyWindow] addSubview:windowView];
    
    NSInteger addBgView_W = SCREENWIDTH -20;
    NSInteger addBgView_H = 160;
    NSInteger addBgView_Y = SCREENHEIGH/2.0-addBgView_H/2.0-40;
    UIView *addBgView = [[UIView alloc] initWithFrame:CGRectMake(10, addBgView_Y, addBgView_W, addBgView_H)];
    addBgView.backgroundColor = [UIColor whiteColor];
    [addBgView.layer setMasksToBounds:YES];
    [addBgView.layer setCornerRadius:4];
    addBgView.alpha = 1.0;
    [windowView addSubview:addBgView];
    
    
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 40)];
    titleL.textColor = [UIColor blackColor];
    titleL.textAlignment = NSTextAlignmentLeft;
    titleL.font = [UIFont systemFontOfSize:18.0];
    titleL.backgroundColor = [UIColor clearColor];
    [addBgView addSubview:titleL];
    titleL.text = @"提示";
    
    NSInteger addTextField_H = 44;
    NSInteger addTextField_Y = 50;
    NSInteger addTextField_W =SCREENWIDTH-40;
    
    UILabel *tipLable = [[UILabel alloc] initWithFrame:CGRectMake(10, addTextField_Y, addTextField_W, addTextField_H)];//高度--44
    tipLable.font = [UIFont systemFontOfSize:15.0];
    tipLable.backgroundColor = [UIColor clearColor];
    tipLable.numberOfLines = 0;
    tipLable.text = @"您提交的服务认证，平台将在1~2个工作日给你反馈";
    [addBgView addSubview:tipLable];
    
    NSInteger cancleBt_X = SCREENWIDTH-20-10-90;
    NSInteger cancleBt_Y = addTextField_Y+44+30;
    NSInteger cancleBt_W = 40;
    NSInteger cancleBt_H = 20;
    
//    UIButton *cancleBt = [[UIButton alloc] initWithFrame:CGRectMake(cancleBt_X, cancleBt_Y, cancleBt_W, cancleBt_H)];
//    [cancleBt setTitle:@"取消" forState:UIControlStateNormal];
//    cancleBt.backgroundColor = [UIColor clearColor];
//    cancleBt.titleLabel.font = [UIFont systemFontOfSize:15.0];
//    [cancleBt setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    cancleBt.tag = 0;
//    [cancleBt addTarget:self action:@selector(clickBtAction:) forControlEvents:UIControlEventTouchUpInside];
//    [addBgView addSubview:cancleBt];
    
    UIButton *okBt = [[UIButton alloc] initWithFrame:CGRectMake(cancleBt_X+50, cancleBt_Y, cancleBt_W, cancleBt_H)];
    [okBt setTitle:@"确认" forState:UIControlStateNormal];
    okBt.backgroundColor = [UIColor clearColor];
    okBt.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [okBt setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    okBt.tag = 0;
    [okBt addTarget:self action:@selector(clickBtAction:) forControlEvents:UIControlEventTouchUpInside];
    [addBgView addSubview:okBt];
    
    
}

- (void)showAlertView{
    windowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGH)];
    windowView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5];;
    [[[UIApplication sharedApplication] keyWindow] addSubview:windowView];
    
    NSInteger addBgView_W = SCREENWIDTH -20;
    NSInteger addBgView_H = 160;
    NSInteger addBgView_Y = SCREENHEIGH/2.0-addBgView_H/2.0-40;
    UIView *addBgView = [[UIView alloc] initWithFrame:CGRectMake(10, addBgView_Y, addBgView_W, addBgView_H)];
    addBgView.backgroundColor = [UIColor whiteColor];
    [addBgView.layer setMasksToBounds:YES];
    [addBgView.layer setCornerRadius:4];
    addBgView.alpha = 1.0;
    [windowView addSubview:addBgView];
    
    
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 40)];
    titleL.textColor = [UIColor blackColor];
    titleL.textAlignment = NSTextAlignmentLeft;
    titleL.font = [UIFont systemFontOfSize:18.0];
    titleL.backgroundColor = [UIColor clearColor];
    [addBgView addSubview:titleL];
    titleL.text = @"提示";
    
    NSInteger addTextField_H = 44;
    NSInteger addTextField_Y = 50;
    NSInteger addTextField_W =SCREENWIDTH-40;
    
    UILabel *tipLable = [[UILabel alloc] initWithFrame:CGRectMake(10, addTextField_Y, addTextField_W, addTextField_H)];//高度--44
    tipLable.font = [UIFont systemFontOfSize:15.0];
    tipLable.backgroundColor = [UIColor clearColor];
    tipLable.numberOfLines = 0;
    tipLable.text = @"提交新的服务认证需要重新审核，未审核通过前无法接单，是否确认";
    [addBgView addSubview:tipLable];

    NSInteger cancleBt_X = SCREENWIDTH-20-10-90;
    NSInteger cancleBt_Y = addTextField_Y+44+30;
    NSInteger cancleBt_W = 40;
    NSInteger cancleBt_H = 20;
    
    UIButton *cancleBt = [[UIButton alloc] initWithFrame:CGRectMake(cancleBt_X, cancleBt_Y, cancleBt_W, cancleBt_H)];
    [cancleBt setTitle:@"取消" forState:UIControlStateNormal];
    cancleBt.backgroundColor = [UIColor clearColor];
    cancleBt.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [cancleBt setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    cancleBt.tag = 0;
    [cancleBt addTarget:self action:@selector(clickBtAction:) forControlEvents:UIControlEventTouchUpInside];
    [addBgView addSubview:cancleBt];
    
    UIButton *okBt = [[UIButton alloc] initWithFrame:CGRectMake(cancleBt_X+50, cancleBt_Y, cancleBt_W, cancleBt_H)];
    [okBt setTitle:@"确认" forState:UIControlStateNormal];
    okBt.backgroundColor = [UIColor clearColor];
    okBt.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [okBt setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    okBt.tag = 1;
    [okBt addTarget:self action:@selector(clickBtAction:) forControlEvents:UIControlEventTouchUpInside];
    [addBgView addSubview:okBt];
}

- (void)clickBtAction:(UIButton *)sender{
    
    if (sender.tag == 1) {
        [self getAllServiceInfo];
    }
    if (sender.tag == 100) {
        NSString *serviceStr = @"";
        for (NSString *value in serviceSelectArr) {
            NSString *serviceItem = [NSString stringWithFormat:@"%@",[serviceIdDic objectForKey:value]];
            serviceStr = [serviceStr stringByAppendingFormat:@",%@",serviceItem];;
        }
        
        if (serviceStr.length > 0) {
            serviceStr = [serviceStr substringFromIndex:1];
        }
        NSLog(@"%@",serviceStr);

        //        [dataSourceDic setValue:serviceStr forKey:@"nurseGoodservice"];
        NSString *userAccount = [[NSUserDefaults standardUserDefaults] objectForKey:USERIDKEY];
        NSDictionary * params  = @{@"nurseId" : [NSString stringWithFormat:@"%@",userAccount],
                                   @"contentId" : serviceStr};
        
        NSLog(@"%@",params);
        [self showHudInView:self.view hint:@"保存中..."];
        [AFHttpTool requestWihtMethod:RequestMethodTypePost url:@"content/SelectGoodServiceForNurse.action" params:params success:^(AFHTTPRequestOperation* operation,id response){
            [self hideHud];
            NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
            NSMutableDictionary *respondDict = [NSMutableDictionary dictionaryWithDictionary:[respondString objectFromJSONString]];
            if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"200"]) {
                NSLog(@"success");
                
            }else if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"400"]){
                NSLog(@"faile");
                [self.view makeToast:[NSString stringWithFormat:@"%@",[respondDict valueForKey:@"data"]] duration:1.2 position:@"center"];

            }
            [self showRebackAlertView];
        } failure:^(NSError* err){
            NSLog(@"err:%@",err);
            [self hideHud];
            [self.view makeToast:ERRORREQUESTTIP duration:2.0 position:@"center"];
        }];
    }
    if (windowView) {
        [windowView removeFromSuperview];
    }
    NSLog(@"tag:%ld",sender.tag);
}

- (void)showServiceAlertView{
    
    //serviceArr
    windowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGH)];
    windowView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5];;
    [[[UIApplication sharedApplication] keyWindow] addSubview:windowView];
    
    
    NSInteger addBgView_W = SCREENWIDTH -20;
    NSInteger addBgView_H = 44*serviceArr.count;
    NSInteger addBgView_Y = (SCREENHEIGH-addBgView_H)/2.0;//SCREENHEIGH/2.0-addBgView_H/2.0-40;
    UIView *addBgView = [[UIView alloc] initWithFrame:CGRectMake(10, addBgView_Y, addBgView_W, addBgView_H)];
    addBgView.backgroundColor = [UIColor whiteColor];
    [addBgView.layer setMasksToBounds:YES];
    [addBgView.layer setCornerRadius:4];
    addBgView.alpha = 1.0;
    [windowView addSubview:addBgView];
    
    UITableView *tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, addBgView_W, addBgView_H-50) style:UITableViewStylePlain];
    tableview.tag = 500;
    tableview.delegate = self;
    tableview.dataSource = self;
    [addBgView addSubview:tableview];
    tableview.backgroundView = nil;
    tableview.backgroundColor = [UIColor whiteColor];
    [Tool setExtraCellLineHidden:tableview];
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    NSInteger cancleBt_X = SCREENWIDTH-50-90;
    NSInteger cancleBt_Y = CGRectGetMaxY(tableview.frame)+10;
    NSInteger cancleBt_W = 40;
    NSInteger cancleBt_H = 20;
    

    UIButton *cancleBt = [[UIButton alloc] initWithFrame:CGRectMake(cancleBt_X, cancleBt_Y, cancleBt_W, cancleBt_H)];
    [cancleBt setTitle:@"取消" forState:UIControlStateNormal];
    cancleBt.backgroundColor = [UIColor clearColor];
    cancleBt.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [cancleBt setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    cancleBt.tag = 0;
    [cancleBt addTarget:self action:@selector(clickBtAction:) forControlEvents:UIControlEventTouchUpInside];
    [addBgView addSubview:cancleBt];

    
    UIButton *okBt = [[UIButton alloc] initWithFrame:CGRectMake(cancleBt_X+50, cancleBt_Y, cancleBt_W, cancleBt_H)];
    [okBt setTitle:@"确定" forState:UIControlStateNormal];
    okBt.backgroundColor = [UIColor clearColor];
    okBt.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [okBt setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    okBt.tag = 100;
    [okBt addTarget:self action:@selector(clickBtAction:) forControlEvents:UIControlEventTouchUpInside];
    [addBgView addSubview:okBt];
    
}

//获取所有的服务
- (void)getAllServiceInfo{
    
    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:@"content/SelectContentAllinfo.action" params:nil success:^(AFHTTPRequestOperation* operation,id response){
        
        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSMutableDictionary *respondDict = [NSMutableDictionary dictionaryWithDictionary:[respondString objectFromJSONString]];
        if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"200"]) {
            NSArray *temp = [NSArray arrayWithArray:[respondDict objectForKey:@"json"]];
            if (serviceArr.count > 0) {
                [serviceArr removeAllObjects];
            }
            if ([[serviceIdDic allKeys] count] > 0) {
                [serviceIdDic removeAllObjects];
            }
            for (int i = 0; i<temp.count; i++) {
                NSDictionary *tempDic = [NSDictionary dictionaryWithDictionary:temp[i]];
                [serviceArr addObject:[tempDic objectForKey:@"manageNursingContentName"]];
                [serviceIdDic setObject:[tempDic objectForKey:@"manageNursingContentId"] forKey:[tempDic objectForKey:@"manageNursingContentName"]];
                
            }
            NSLog(@"success");
            NSString *serviceStr = @"";
            for (NSString *value in serviceSelectArr) {
                NSString *serviceItem = [NSString stringWithFormat:@"%@",[serviceIdDic objectForKey:value]];
                serviceStr = [serviceStr stringByAppendingFormat:@",%@",serviceItem];;
            }
            
            if (serviceStr.length > 0) {
                serviceStr = [serviceStr substringFromIndex:1];
            }
//            [dataSourceDic setValue:serviceStr forKey:@"nurseGoodservice"];
            [self showServiceAlertView];

            [myTableView reloadData];
            
        }else if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"400"]){
            NSLog(@"faile");
        }
    } failure:^(NSError* err){
        NSLog(@"err:%@",err);
        [self.view makeToast:ERRORREQUESTTIP duration:2.0 position:@"center"];
    }];
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
