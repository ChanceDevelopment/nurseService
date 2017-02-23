//
//  AppDelegate.m
//  nurseService
//
//  Created by Tony on 16/7/29.
//  Copyright © 2016年 iMac. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeTabbarController.h"
#import "RESideMenu.h"
#import "HeLoginVC.h"
#import "HeTabBarVC.h"
#import <SMS_SDK/SMSSDK.h>
#include <sys/xattr.h>
#import "HeTabBarVC.h"
#import <UMMobClick/MobClick.h>
#import "HeInstructionView.h"
#import "HeLoginVC.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import "BrowserView.h"
#import "TOWebViewController.h"
#import <SMS_SDK/SMSSDK.h>
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#import "BasicInfoVC.h"

@interface AppDelegate ()

@end

BMKMapManager* _mapManager;

@implementation AppDelegate
@synthesize queue;
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"注册APNs成功并上报DeviceToken");
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // Required
    //IOS6.0上面接收到推送的时候执行的方法
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"iOS6及以下系统，收到通知:%@", userInfo);
    //    [self performSelector:@selector(receiveNotification:) withObject:userInfo afterDelay:0.5];
}


//avoid compile error for sdk under 7.0
#ifdef __IPHONE_7_0
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    //IOS7收到推送执行的方法
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNoData);
    
    NSLog(@"iOS7及以上系统，收到通知:%@", userInfo);
    //[self performSelector:@selector(receiveNotification:) withObject:userInfo afterDelay:0.5];
}
#endif


#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 前台收到远程通知:%@", userInfo);
        
        //        [rootViewController addNotificationCount];
        
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 收到远程通知:%@", userInfo);
        //        [rootViewController addNotificationCount];
        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:body delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
//        [alert show];
        
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    completionHandler();  // 系统要求执行这个方法
}
#endif

//当接收到推送通知，并且设备激活后的处理事件
-(void)receiveNotification:(NSDictionary *)userInfo
{
    NSLog(@"receiveNotification = %@",userInfo);
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self initialization];
    [self launchBaiduMap];
    [self initAPServiceWithOptions:launchOptions];
    [self initshareSDK];
    [self umengTrack];
    self.window.rootViewController = self.viewController;
    //清除缓存
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(clearImg:) object:nil];
    
    [operation setQueuePriority:NSOperationQueuePriorityNormal];
    [operation setCompletionBlock:^{
        //不上传到iCloud
        [Tool canceliClouldBackup];
    }];
    queue = [[NSOperationQueue alloc]init];
    [queue addOperation:operation];
    [queue setMaxConcurrentOperationCount:1];
    //配置根控制器
    [self loginStateChange:nil];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

//初始化极光推送
- (void)initAPServiceWithOptions:(NSDictionary *)launchOptions
{
    //Required
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
        
    }
    else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    }
    else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    //Required
    // init Push(2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil  )
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
            
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    //    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
    //                                                   UIRemoteNotificationTypeSound |
    //                                                   UIRemoteNotificationTypeAlert)
    //                                       categories:nil];
    //    [APService setupWithOption:launchOptions];

    //    [APService setLogOFF];
}

- (void)launchBaiduMap
{
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:BAIDUMAPKEY generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    else{
        NSLog(@"manager start success!");
    }
}

#pragma mark - login changed

- (void)loginStateChange:(NSNotification *)notification
{
    NSString *userAccount = [[NSUserDefaults standardUserDefaults] objectForKey:USERIDKEY];
    BOOL haveLogin = (userAccount == nil) ? NO : YES;
    
    NSString *nurseDistrict = [[[NSUserDefaults standardUserDefaults] objectForKey:USERACCOUNTKEY] valueForKey:@"nurseDistrict"];
    BOOL isDistrict = [nurseDistrict isEqualToString:@"1"] ? NO : YES;
    
    if (haveLogin) {//登陆成功加载主窗口控制器
        
        [Tool initPush];
        
        if (isDistrict || [[NSString stringWithFormat:@"%@",notification.object] isEqualToString:@"1"]) {
            
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            
            [[UINavigationBar appearance] setTitleTextAttributes:
             [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont systemFontOfSize:20.0], NSFontAttributeName, nil]];
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
            
            HeTabBarVC *tabBarController = [[HeTabBarVC alloc] init];
            self.viewController = tabBarController;
            self.viewController = tabBarController;
            
        }else{
            BasicInfoVC *loginVC = [[BasicInfoVC alloc] init];
            CustomNavigationController *loginNav = [[CustomNavigationController alloc] initWithRootViewController:loginVC];
            self.viewController = loginNav;
        }
    }
    else{
        //BasicInfoVC
        HeLoginVC *loginVC = [[HeLoginVC alloc] init];
        CustomNavigationController *loginNav = [[CustomNavigationController alloc] initWithRootViewController:loginVC];
        self.viewController = loginNav;
    }
    self.window.rootViewController = self.viewController;
}

//登陆成功后 未实名验证
- (void)justToRootView:(NSNotification *)notification
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont systemFontOfSize:20.0], NSFontAttributeName, nil]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    HeTabBarVC *tabBarController = [[HeTabBarVC alloc] init];
    self.viewController = tabBarController;
    self.viewController = tabBarController;
    
    self.window.rootViewController = self.viewController;
}

- (void)clearImg:(id)sender
{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *folderPath = [NSHomeDirectory() stringByAppendingString:@"/tmp"];
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    
    NSString *libraryfolderPath = [NSHomeDirectory() stringByAppendingString:@"/Library"];
    //    libraryfolderPath = [[NSString alloc] initWithFormat:@"libraryfolderPath = %@",libraryfolderPath];
    
    NSString* LibraryfileName = [libraryfolderPath stringByAppendingPathComponent:@"EaseMobLog"];
    childFilesEnumerator = [[manager subpathsAtPath:LibraryfileName] objectEnumerator];
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [LibraryfileName stringByAppendingPathComponent:fileName];
        
        BOOL result = [manager removeItemAtPath:fileAbsolutePath error:nil];
        if (result) {
            NSLog(@"remove EaseMobLog succeed");
        }
        else{
            NSLog(@"remove EaseMobLog faild");
        }
        
    }
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesPath = [path objectAtIndex:0];
    childFilesEnumerator = [[manager subpathsAtPath:cachesPath] objectEnumerator];
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [cachesPath stringByAppendingPathComponent:fileName];
        NSRange range = [fileAbsolutePath rangeOfString:@"umeng"];
        
        if (range.length == 0) {
            BOOL result = [manager removeItemAtPath:fileAbsolutePath error:nil];
            if (result) {
                NSLog(@"remove caches succeed");
            }
            else{
                NSLog(@"remove caches faild");
            }
        }
    }
}

- (void)initialization
{
    [[NSUserDefaults standardUserDefaults] setObject:@NO forKey:USERHAVELOGINKEY];
    //注册登录状态监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                                 name:KNOTIFICATION_LOGINCHANGE
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(justToRootView:)
                                                 name:KNOTIFICATION_JUSTTOROOTVIEW
                                               object:nil];
    
    
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    if (ISIOS7) {
        [[UINavigationBar appearance] setTintColor:NAVTINTCOLOR];
        UIImage *navBackgroundImage = [UIImage imageNamed:@"NavBarIOS7"];
        [[UINavigationBar appearance] setBackgroundImage:navBackgroundImage forBarMetrics:UIBarMetricsDefault];
        NSDictionary *attributeDict = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:20.0]};
        [[UINavigationBar appearance] setTitleTextAttributes:attributeDict];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }
    else{
        [[UINavigationBar appearance] setTintColor:APPDEFAULTORANGE];
        
        NSDictionary *attributeDict = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:20.0]};
        [[UINavigationBar appearance] setTitleTextAttributes:attributeDict];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
        
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
}

//初始化SMSSDK
- (void)initSMSSDK{
    //初始化应用，appKey和appSecret从后台申请得
    [SMSSDK registerApp:@"15eb8c9d7d534" withSecret:@"dacf079a7e60b30120a97690d154f113"];
}

//初始化友盟的SDK
- (void)umengTrack
{
    [MobClick setLogEnabled:NO];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        [MobClick setLogEnabled:YES];
        UMConfigInstance.appKey = UMANALYSISKEY;
        UMConfigInstance.secret = @"secretstringaldfkals";
        //    UMConfigInstance.eSType = E_UM_GAME;
        [MobClick startWithConfigure:UMConfigInstance];
        
        //        [MobClick startWithAppkey:UMANALYSISKEY reportPolicy:(ReportPolicy) SEND_INTERVAL channelId:nil];
    }
    else{
        [MobClick setLogEnabled:YES];
        UMConfigInstance.appKey = UMANALYSISKEY_HD;
        UMConfigInstance.secret = @"secretstringaldfkals";
        //    UMConfigInstance.eSType = E_UM_GAME;
        [MobClick startWithConfigure:UMConfigInstance];
        
        //        [MobClick startWithAppkey:UMANALYSISKEY_HD reportPolicy:(ReportPolicy) SEND_INTERVAL channelId:nil];
    }
    
    [MobClick setCrashReportEnabled:YES]; // 如果不需要捕捉异常，注释掉此行
    [MobClick setBackgroundTaskEnabled:YES];
    [MobClick setLogSendInterval:90];//每隔两小时上传一次
    //    [MobClick ];  //在线参数配置
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineConfigCallBack:) name:UMOnlineConfigDidFinishedNotification object:nil];
    
}


//初始化shareSDK
- (void)initshareSDK
{
    [ShareSDK registerApp:SHARESDKKEY
          activePlatforms:@[
                            @(SSDKPlatformSubTypeQZone),
                            @(SSDKPlatformTypeQQ),
                            @(SSDKPlatformTypeWechat)
                            ]
                 onImport:^(SSDKPlatformType platformType) {
                     
                     switch (platformType)
                     {
                         case SSDKPlatformTypeWechat:
                             [ShareSDKConnector connectWeChat:[WXApi class] delegate:self];
                             break;
                         case SSDKPlatformTypeQQ:
                             [ShareSDKConnector connectQQ:[QQApiInterface class]
                                        tencentOAuthClass:[TencentOAuth class]];
                             break;
                         default:
                             break;
                     }
                     
                 }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
              
              switch (platformType)
              {
                  case SSDKPlatformTypeWechat:
                      [appInfo SSDKSetupWeChatByAppId:@"wx59a24b22c97543ee"
                                            appSecret:@"e02faf49615c6c9208cd3510604e1599"];
                      break;
                  case SSDKPlatformTypeQQ:
                      [appInfo SSDKSetupQQByAppId:@"1105942752"
                                           appKey:@"V78mzcd0Hrwjrgxc"
                                         authType:SSDKAuthTypeBoth];
                      break;
                  default:
                      break;
              }
          }];
}

- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
