//
//  HomeWebViewController.m
//  nurseService
//
//  Created by HaviLee on 2017/1/18.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "HomeWebViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>


@interface HomeWebViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView* webView;
@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic) BOOL loading;

@end

@implementation HomeWebViewController
@synthesize dataDic;

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
        label.text = @"";
        [label sizeToFit];
        self.title = @"";
        
        
        NSMutableArray *buttons = [[NSMutableArray alloc] init];
        UIButton *shareBt = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        [shareBt setBackgroundImage:[UIImage imageNamed:@"icon_share"] forState:UIControlStateNormal];
        [shareBt addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
        shareBt.backgroundColor = [UIColor clearColor];
        UIBarButtonItem *scanItem = [[UIBarButtonItem alloc] initWithCustomView:shareBt];
        [buttons addObject:scanItem];
        
        self.navigationItem.rightBarButtonItems = buttons;

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
    [self.view addSubview:self.webView];
    self.webView.delegate = self;
    _progressViewColor = [UIColor colorWithRed:0.000 green:0.482 blue:0.976 alpha:1.00];
    [self.view addSubview:self.progressView];

}

- (UIProgressView *)progressView {
    if (!_progressView) {
        CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, 2.0);
        _progressView = [[UIProgressView alloc] initWithFrame:frame];
        _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth ;
        _progressView.tintColor = self.progressViewColor;
        _progressView.trackTintColor = [UIColor clearColor];
    }

    return _progressView;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    self.progressView.progress = 0;
    self.progressView.hidden = false;
    self.loading = YES;

    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timerCallback) userInfo:nil repeats:YES];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.loading = NO;
}
- (void)timerCallback {
    if (!self.loading) {
        if (self.progressView.progress >= 1) {
            self.progressView.hidden = true;
            [self.timer invalidate];
        }
        else {
            self.progressView.progress += 0.5;
        }
    }
    else {
        self.progressView.progress += 0.05;
        if (self.progressView.progress >= 0.9) {
            self.progressView.progress = 0.9;
        }
    }
}

-(UIWebView*)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:(CGRect){0,0,self.view.frame.size.width,self.view.frame.size.height-64}];
//        _webView.delegate = (id)self;
        _webView.contentMode = UIViewContentModeScaleAspectFit;
        _webView.dataDetectorTypes = 0;
    }
    return _webView;
}

- (void)viewDidAppear:(BOOL)animated
{
//    NSString * htmlstr = [[NSString alloc]initWithContentsOfURL:[NSURL URLWithString:self.urlString] encoding:NSUTF8StringEncoding error:nil];
    NSURL *url = [NSURL URLWithString:self.urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:htmlstr]]];
//    [self.webView loadHTMLString:htmlstr baseURL:[NSURL URLWithString:self.urlString]];
}
//初始化分享内容
- (void)shareAction{
    //商品的分享
    NSString *titleStr = @"专业护士上门";
    NSString *imagePath = [NSString stringWithFormat:@"%@nurseDoor/img/index2.png",PIC_URL]; //图片的链接地址
    NSString *url = [NSString stringWithFormat:@"%@/nurseDoor/sendPostThreeInfoByThreeId.action?postThreeLevelDetailsId=%@",PIC_URL,[dataDic valueForKey:@"postThreeLevelDetailsId"]];
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
