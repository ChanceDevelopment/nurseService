//
//  HomeWebViewController.h
//  nurseService
//
//  Created by HaviLee on 2017/1/18.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "HeBaseViewController.h"

@interface HomeWebViewController : HeBaseViewController

@property (nonatomic, strong) NSString* urlString;

@property (nonatomic)UIColor* progressViewColor;
@property (strong, nonatomic) UIProgressView *progressView;
@property (strong, nonatomic) NSDictionary *dataDic;

@end
