//
//  NurseReportVC.m
//  nurseService
//
//  Created by 梅阳阳 on 17/1/11.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "NurseReportVC.h"

@interface NurseReportVC ()
{
}

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation NurseReportVC
@synthesize webView;
@synthesize infoData;
@synthesize isDetail;
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
        label.text = @"护理报告";
        [label sizeToFit];
        self.title = @"护理报告";
        
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
    self.view.backgroundColor = [UIColor colorWithWhite:237.0 / 255.0 alpha:1.0];
//    [self getReportStayUrl];
//    [self getReportDetailUrl];
    [webView setScalesPageToFit:YES];
    webView.userInteractionEnabled = YES;
    webView.scrollView.bounces = NO;

    if (isDetail) {
        NSString *urlString = [NSString stringWithFormat:@"http://118.178.186.59:8080/nurseDoor/selectReportdetails.action?orderSendId=%@&protectedPersonId=%@",[infoData valueForKey:@"orderSendId"],[infoData valueForKey:@"orderSendUserid"]];
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    }else{
        NSString *urlString = [NSString stringWithFormat:@"http://118.178.186.59:8080/nurseDoor/selectReportdetailsStay.action?orderSendId=%@&protectedPersonId=%@",[infoData valueForKey:@"orderSendId"],[infoData valueForKey:@"orderSendUserid"]];
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];

    }
//    NSString *urlString = [NSString stringWithFormat:@"http://118.178.186.59:8080/nurseDoor/selectReportdetailsStay.action?orderSendId=%@&protectedPersonId=%@",[infoData valueForKey:@"orderSendId"],[infoData valueForKey:@"orderSendUserid"]];
//    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];


}

#pragma mark webViewdelegate

-(void)webViewDidFinishLoad:(UIWebView *)webViewTmp{
    
}

- (BOOL)webView:(UIWebView *)webViewTmp shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    static BOOL isRequestWeb = YES;
    
    if (isRequestWeb) {
        NSHTTPURLResponse *response = nil;
        NSError *error = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        if (response.statusCode == 404 || response.statusCode == 403 || error) {
            // code for 404 or 403
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"noData"]];
            imageView.frame = CGRectMake((SCREENWIDTH - 100)/2.0, 200, 100, 100);
            imageView.center = self.view.center;
            [self.view addSubview:imageView];
            [webView stopLoading];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"亲，目前页面有点问题，请稍后再试" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            alert.tag = 404;
            [alert show];
            return NO;
        }
        
        [webView loadData:data MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:[request URL]];
        isRequestWeb = NO;
        return NO;
    }
    
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
