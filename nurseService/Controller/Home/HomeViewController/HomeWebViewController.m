//
//  HomeWebViewController.m
//  nurseService
//
//  Created by HaviLee on 2017/1/18.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "HomeWebViewController.h"

@interface HomeWebViewController ()<UIWebViewDelegate>

@property (nonatomic)UIWebView* webView;
@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic) BOOL loading;

@end

@implementation HomeWebViewController

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
        _webView.delegate = (id)self;
        _webView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _webView;
}

- (void)viewDidAppear:(BOOL)animated
{
    NSString * htmlstr = [[NSString alloc]initWithContentsOfURL:[NSURL URLWithString:self.urlString] encoding:NSUTF8StringEncoding error:nil];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:htmlstr]]];
    [self.webView loadHTMLString:htmlstr baseURL:[NSURL URLWithString:self.urlString]];
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
