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
    UIView *windowView;
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
        NSString *urlString = [NSString stringWithFormat:@"%@selectReportdetails.action?orderSendId=%@&protectedPersonId=%@",API_URL,[infoData valueForKey:@"orderSendId"],[infoData valueForKey:@"personId"]];
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    }else{
        NSString *urlString = [NSString stringWithFormat:@"%@selectReportdetailsStay.action?orderSendId=%@&protectedPersonId=%@",API_URL,[infoData valueForKey:@"orderSendId"],[infoData valueForKey:@"personId"]];
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];

    }
//    NSString *urlString = [NSString stringWithFormat:@"http://118.178.186.59:8080/nurseDoor/selectReportdetailsStay.action?orderSendId=%@&protectedPersonId=%@",[infoData valueForKey:@"orderSendId"],[infoData valueForKey:@"orderSendUserid"]];
//    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];


}
- (void)backItemClick:(id)sender{
    if (!isDetail) {
//        [self showAlertView];
        NSLog(@"%ld",[[self.navigationController viewControllers] count]);
        if ([[self.navigationController viewControllers] count] == 2) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateOrder" object:nil];
        }
        
        if ([[self.navigationController viewControllers] count] == 3) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshOrderDetailNotification" object:nil];
        }

    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showAlertView{
    windowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGH)];
    windowView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5];;
    [[[UIApplication sharedApplication] keyWindow] addSubview:windowView];
    
    NSInteger addBgView_W = SCREENWIDTH -20;
    NSInteger addBgView_H = 150;
    NSInteger addBgView_Y = SCREENHEIGH/2.0-addBgView_H/2.0-40;
    UIView *addBgView = [[UIView alloc] initWithFrame:CGRectMake(10, addBgView_Y, addBgView_W, addBgView_H)];
    addBgView.backgroundColor = [UIColor whiteColor];
    [addBgView.layer setMasksToBounds:YES];
    [addBgView.layer setCornerRadius:4];
    addBgView.alpha = 1.0;
    [windowView addSubview:addBgView];
    
    NSInteger pointY = 10;
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(10, pointY, 100, 40)];
    titleL.textColor = [UIColor blackColor];
    titleL.textAlignment = NSTextAlignmentLeft;
    titleL.font = [UIFont systemFontOfSize:18.0];
    titleL.backgroundColor = [UIColor clearColor];
    [addBgView addSubview:titleL];
    titleL.text = @"提示";
    
    NSInteger addTextField_H = 44;
    NSInteger addTextField_Y = CGRectGetMaxY(titleL.frame);
    NSInteger addTextField_W =SCREENWIDTH-40;
    
    UILabel *tipLable = [[UILabel alloc] initWithFrame:CGRectMake(10, addTextField_Y, addTextField_W, addTextField_H)];//高度--44
    tipLable.font = [UIFont systemFontOfSize:15.0];
    tipLable.backgroundColor = [UIColor clearColor];
    tipLable.numberOfLines = 0;
    tipLable.text = @"确认退出护理报告编辑？";
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
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (windowView) {
        [windowView removeFromSuperview];
    }
    NSLog(@"tag:%ld",sender.tag);
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
