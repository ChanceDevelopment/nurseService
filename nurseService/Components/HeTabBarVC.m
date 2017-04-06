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
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>

#define MinLocationSucceedNum 1   //要求最少成功定位的次数

@interface HeTabBarVC ()<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,CLLocationManagerDelegate>
{
    BMKLocationService *_locService;
    BMKGeoCodeSearch *_geoSearch;
}
//定位
@property (nonatomic,assign)NSInteger locationSucceedNum; //定位成功的次数
@property (nonatomic,strong)NSMutableDictionary *userLocationDict;
@end

@implementation HeTabBarVC
@synthesize homeVC;
@synthesize rankVC;
@synthesize orderVC;
@synthesize userVC;
@synthesize locationSucceedNum;
@synthesize userLocationDict;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self getUserInfo];
    [self autoLogin];
    [self setupSubviews];
    [self initLocationService];
    //获取用户的地理位置
    [self getLocation];
    //获取接单按钮状态
    [self getReceiveOrderSwitchState];

    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [_locService stopUserLocationService];
    _geoSearch.delegate = nil;
}

- (void)initLocationService
{
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc] init];
    _locService.delegate = self;
    //启动LocationService
    _locService.desiredAccuracy = kCLLocationAccuracyBest;
    _locService.distanceFilter  = 1.5f;
    
    _geoSearch = [[BMKGeoCodeSearch alloc] init];
    _geoSearch.delegate = self;
    
    userLocationDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    locationSucceedNum = 0;
}

- (void)getLocation
{
    if([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"定位服务未开启" message:@"请在系统设置中开启定位服务设置->隐私->定位服务" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
        [alertView show];
    }else{
        [_locService startUserLocationService];
    }
}



//后台自动登录
- (void)autoLogin
{
    /*
    NSString *latitude = [[HeSysbsModel getSysModel].userLocationDict objectForKey:@"longitude"];
    if (!latitude) {
        latitude = @"";
    }
    NSString *longitude = [[HeSysbsModel getSysModel].userLocationDict objectForKey:@"latitude"];
    if (!longitude) {
        longitude = @"";
    }
    NSString *userAccount = [[NSUserDefaults standardUserDefaults] objectForKey:USERIDKEY];
    
    NSDictionary * params  = @{@"nurseid":userAccount,@"latitude": latitude,@"longitude":longitude};
    NSLog(@"%@",params);
    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:SELECTBURSEBYID params:params success:^(AFHTTPRequestOperation* operation,id response){
        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        
        NSDictionary *respondDict = [NSDictionary dictionaryWithDictionary:[respondString objectFromJSONString]];
        if ([[respondDict valueForKey:@"errorCode"] integerValue] == REQUESTCODE_SUCCEED){
            NSLog(@"update Location Succeed!");
            
        }
        
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
            [[NSUserDefaults standardUserDefaults] setObject:nurseDic forKey:@"nurseInfoKey"];//本地存储
//            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",[userInfoDic valueForKey:@"nurseId"]] forKey:USERIDKEY];
//            [[NSUserDefaults standardUserDefaults] synchronize];//强制写入,保存数据
            
        }else if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"400"]){
            NSLog(@"faile");
        }
        
        
        
    } failure:^(NSError* err){
        
    }];

    */
    
    

    
    
    NSString *account = [[NSUserDefaults standardUserDefaults] objectForKey:NURSEACCOUNTKEY];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:USERPASSWORDKEY];
    if (!password) {
        password = @"";
    }
    if (!account) {
        account = @"";
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

        }else if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"400"]){
            NSLog(@"faile");
            
        }
        
        
    } failure:^(NSError* err){
        NSLog(@"err:%@",err);
    }];
 
}

//获取是否接单状态
- (void)getReceiveOrderSwitchState{
    NSString *userAccount = [[NSUserDefaults standardUserDefaults] objectForKey:USERIDKEY];
    NSDictionary * params  = @{@"nurseId": userAccount};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:ORDERRECEIVESTATE params:params success:^(AFHTTPRequestOperation* operation,id response){
        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSLog(@"respondString:%@",respondString);
        NSMutableDictionary *respondDict = [NSMutableDictionary dictionaryWithDictionary:[respondString objectFromJSONString]];
        if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"200"]) {
            NSLog(@"success");
            if ([[NSString stringWithFormat:@"%@",[respondDict valueForKey:@"json"]] isEqualToString:@"0"]) {
                /*
                 0.接
                 1.不接
                 */
                [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:RECEIVEORDERSTATE];
            }else{
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:RECEIVEORDERSTATE];
            }
            
        }else if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"400"]){
            NSLog(@"faile");
        }
        
        
    } failure:^(NSError* err){
        NSLog(@"err:%@",err);
        [self.view makeToast:ERRORREQUESTTIP duration:2.0 position:@"center"];
    }];
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

//    rankVC = [[RankViewController alloc] init];
//    CustomNavigationController *rankNav = [[CustomNavigationController alloc] initWithRootViewController:rankVC];
    
    orderVC = [[OrderViewController alloc] init];
    CustomNavigationController *orderNav = [[CustomNavigationController alloc] initWithRootViewController:orderVC];
    
    userVC = [[MineViewController alloc] init];
    CustomNavigationController *userNav = [[CustomNavigationController alloc]
                                           initWithRootViewController:userVC];
    
    [self setViewControllers:@[homeNav,orderNav,userNav]];//@[homeNav,rankNav,orderNav,userNav]
    [self customizeTabBarForController];
}

//设置底部的tabbar
- (void)customizeTabBarForController{
    //    tabbar_normal_background   tabbar_selected_background
    UIImage *finishedImage = [UIImage imageNamed:@"tabbar_normal_background"];
    UIImage *unfinishedImage = [UIImage imageNamed:@"tabbar_normal_background"];
    NSArray *tabBarItemImages = @[@"tabar_home_icon", @"tabar_order_icon", @"tabar_user_icon"];//@[@"tabar_home_icon", @"tabar_rank_icon", @"tabar_order_icon", @"tabar_user_icon"]
    
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

//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    CLLocation *newLocation = userLocation.location;
    CLLocationCoordinate2D coordinate = newLocation.coordinate;
    
    NSString *latitudeStr = [NSString stringWithFormat:@"%.6f",coordinate.latitude];
    NSString *longitudeStr = [NSString stringWithFormat:@"%.6f",coordinate.longitude];
    
    [self udpateUserLocationWithLocation:@{@"latitude":latitudeStr,@"longitude":longitudeStr}];
    
    if (newLocation && ![userLocationDict objectForKey:@"latitude"]) {
        locationSucceedNum = locationSucceedNum + 1;
        if (locationSucceedNum >= MinLocationSucceedNum) {
            [self hideHud];
            locationSucceedNum = 0;
            [userLocationDict setObject:latitudeStr forKey:@"latitude"];
            [userLocationDict setObject:longitudeStr forKey:@"longitude"];
            [_locService stopUserLocationService];
            
            BMKReverseGeoCodeOption *reverseGeoCodeOption = [[BMKReverseGeoCodeOption alloc] init];
            reverseGeoCodeOption.reverseGeoPoint = coordinate;
            _geoSearch.delegate = self;
            //进行反地理编码
            [_geoSearch reverseGeoCode:reverseGeoCodeOption];
            
            //更新用户坐标
            NSString *latitudeStr = [userLocationDict objectForKey:@"latitude"];
            if (latitudeStr == nil) {
                latitudeStr = @"";
            }
            NSString *longitudeStr = [userLocationDict objectForKey:@"longitude"];
            if (longitudeStr == nil) {
                longitudeStr = @"";
            }
            [HeSysbsModel getSysModel].userLocationDict = [[NSDictionary alloc] initWithDictionary:userLocationDict];
        }
    }
}


- (void)didFailToLocateUserWithError:(NSError *)error
{
    [self hideHud];
    [self showHint:@"定位失败!"];
}

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    NSLog(@"地址是：%@,%@",result.address,result.addressDetail);
    NSString *cityString = result.addressDetail.city;
    //记录当前的定位城市
//    [[NSUserDefaults standardUserDefaults] setObject:cityString forKey:kPreLocationCityKey];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSLog(@"当前城市是：%@",cityString);
    [HeSysbsModel getSysModel].addressResult = result;
//    if (![[HeSysbsModel getSysModel].userCity isEqualToString:cityString]) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:kGetCitySucceedNotification object:cityString];
//    }
    
    
}

- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    NSLog(@"%@",result.address);
}


- (void)udpateUserLocationWithLocation:(NSDictionary *)locationDict
{
    NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:USERIDKEY];
    if (!userid) {
        userid = @"";
    }
    NSString *latitude = locationDict[@"latitude"];
    if (!latitude) {
        latitude = @"";
    }
    NSString *longitude = locationDict[@"longitude"];
    if (!longitude) {
        longitude = @"";
    }
    //经度latitude   维度 longitude
    
    NSDictionary * params  = @{@"nurseid":userid,@"latitude":longitude ,@"longitude":latitude};
    
    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:NURSELATIUDE params:params success:^(AFHTTPRequestOperation* operation,id response){
        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        
        NSDictionary *respondDict = [NSDictionary dictionaryWithDictionary:[respondString objectFromJSONString]];
        if ([[respondDict valueForKey:@"errorCode"] integerValue] == REQUESTCODE_SUCCEED){
            NSLog(@"update Location Succeed!");
            
        }
    } failure:^(NSError* err){
        
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
