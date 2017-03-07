//
//  HeOrderDetailVC.m
//  nurseService
//
//  Created by Tony on 2017/1/3.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "HeOrderDetailVC.h"
#import "HeBaseTableViewCell.h"
#import "MLLabel.h"
#import "MLLabel+Size.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "NurseReportVC.h"
#import "HePaitentInfoVC.h"
#import "HeUserLocatiVC.h"
#import "HandleIntroductionVC.h"

@interface HeOrderDetailVC ()<UITableViewDelegate,UITableViewDataSource>
{
    CGFloat imageScrollViewHeigh;
    UIView *windowView;
    
    UIImageView *tipImageView;
    NSInteger currentTipImageTag;
}
@property(strong,nonatomic)IBOutlet UITableView *tableview;
@property(strong,nonatomic)IBOutlet UIView *statusView;
@property(strong,nonatomic)NSArray *statusArray;
@property(strong,nonatomic)UIScrollView *photoScrollView;
@property(strong,nonatomic)NSMutableArray *paperArray;

@end

@implementation HeOrderDetailVC
@synthesize tableview;
@synthesize statusArray;
@synthesize statusView;
@synthesize photoScrollView;
@synthesize paperArray;
@synthesize infoDic;
@synthesize orderId;

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
        label.text = @"订单详情";
        [label sizeToFit];
        self.title = @"订单详情";
        
        NSMutableArray *buttons = [[NSMutableArray alloc] init];
        UIButton *saveBt = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 25)];
        [saveBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [saveBt setTitle:@"操作提示" forState:UIControlStateNormal];
        saveBt.titleLabel.adjustsFontSizeToFitWidth = YES;
        saveBt.titleLabel.font = [UIFont systemFontOfSize:13.0];
        [saveBt addTarget:self action:@selector(introductionAction) forControlEvents:UIControlEventTouchUpInside];
        saveBt.backgroundColor = [UIColor clearColor];
        
        UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithCustomView:saveBt];
        [buttons addObject:searchItem];
        self.navigationItem.rightBarButtonItems = buttons;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initializaiton];
    [self initView];
    [self getOrderDetailData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getOrderDetailData) name:@"refreshOrderDetailNotification" object:nil];  //refreshOrderDetail
    if (![[NSUserDefaults standardUserDefaults] valueForKey:@"isFirst"]) {
        [self showFirstTipView];
    }
}

- (void)initializaiton
{
    [super initializaiton];
    statusArray = @[@"已接单",@"开始沟通",@"开始出发",@"开始服务",@"完成"];
    imageScrollViewHeigh = 100;
    paperArray = [[NSMutableArray alloc] initWithCapacity:0];
    infoDic = [[NSDictionary alloc] init];
}

- (void)initView
{
    [super initView];

    self.view.backgroundColor = [UIColor colorWithWhite:237.0 / 255.0 alpha:1.0];
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.backgroundView = nil;
    tableview.backgroundColor = [UIColor colorWithWhite:237.0 / 255.0 alpha:1.0];
    [Tool setExtraCellLineHidden:tableview];
    
//    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 50)];
//    footerView.backgroundColor = tableview.backgroundColor;
//    tableview.tableFooterView = footerView;
//    
//    UILabel *tipLabel = [[UILabel alloc] initWithFrame:footerView.bounds];
//    tipLabel.textAlignment = NSTextAlignmentCenter;
//    tipLabel.textColor = [UIColor grayColor];
//    tipLabel.backgroundColor = [UIColor clearColor];
//    tipLabel.font = [UIFont systemFontOfSize:12.0];
//    tipLabel.text = @"服务完成后，请填写护理报告";
//    [footerView addSubview:tipLabel];
    

//    [paperArray addObject:@"123"];

//    [self addPhotoScrollView];
    
}

- (void)getOrderDetailData{
    
    NSDictionary * params  = @{@"orderSendId" : orderId};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:ORDERDESCRIPTION params:params success:^(AFHTTPRequestOperation* operation,id response){
        
        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSMutableDictionary *respondDict = [NSMutableDictionary dictionaryWithDictionary:[respondString objectFromJSONString]];
        if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"200"]) {
            if ([[respondDict valueForKey:@"json"] isMemberOfClass:[NSNull class]] || [respondDict valueForKey:@"json"] == nil) {
                [self performSelector:@selector(backToRootView) withObject:nil afterDelay:1.2];
            }else{
                infoDic = [[NSDictionary alloc] initWithDictionary:[respondDict valueForKey:@"json"]];
                [self addStatueViewWithStatus:[[infoDic valueForKey:@"orderReceivestate"] integerValue]];

                NSString *picStr = [NSString stringWithFormat:@"%@",[infoDic valueForKey:@"orderSendUserpic"]];

                CGFloat scrollX = 5;
                CGFloat scrollY = 5;
                CGFloat scrollW = SCREENWIDTH - 2 * scrollX;
                CGFloat scrollH = imageScrollViewHeigh;
                
                if ([picStr isEqualToString:@"<null>"]) {
                    imageScrollViewHeigh = 0;
                }else{
                    if (paperArray.count > 0) {
                        [paperArray removeAllObjects];
                    }
                    NSArray *tempArr = [picStr componentsSeparatedByString:@","];
                    [paperArray addObjectsFromArray:tempArr];
                }
                photoScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(scrollX, scrollY, scrollW, scrollH)];
                
                [self addPhotoScrollView];
                [tableview reloadData];
            }
            NSLog(@"success");
        }else if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"400"]){
            [self performSelector:@selector(backToRootView) withObject:nil afterDelay:1.2];
            NSLog(@"faile");
            [self.view makeToast:[NSString stringWithFormat:@"%@",[respondDict valueForKey:@"data"]] duration:1.2 position:@"center"];
        }
    } failure:^(NSError* err){
        NSLog(@"err:%@",err);
        [self.view makeToast:ERRORREQUESTTIP duration:2.0 position:@"center"];
    }];
}

- (void)backItemClick:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateOrder" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backToRootView{

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addStatueViewWithStatus:(NSInteger)statusType
{
    CGFloat statusLabelX = 5;
    CGFloat statusLabelY = 10;
    CGFloat statusLabelH = 20;
    CGFloat statusLabelW = (SCREENWIDTH - 2 * statusLabelX) / [statusArray count];
    
    CGFloat circleIconX = 0;
    CGFloat circleIconY = 0;
    CGFloat circleIconW = 10;
    CGFloat circleIconH = 10;
    
    CGFloat sepLineX = 0;
    CGFloat sepLineY = 0;
    CGFloat sepLineW = 0;
    CGFloat sepLineH = 1;
    
    for (NSInteger index = 0; index < [statusArray count]; index++) {
        UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(statusLabelX, statusLabelY, statusLabelW, statusLabelH)];
        statusLabel.tag = 1;
        statusLabel.backgroundColor = [UIColor clearColor];
        statusLabel.textColor = APPDEFAULTORANGE;
        statusLabel.font = [UIFont systemFontOfSize:13.0];
        statusLabel.textAlignment = NSTextAlignmentCenter;
        statusLabel.text = statusArray[index];
        [statusView addSubview:statusLabel];
        
        circleIconX = CGRectGetMidX(statusLabel.frame) - circleIconW / 2.0;
        circleIconY = CGRectGetMaxY(statusLabel.frame) + 5;
        UIImageView *circleIcon = [[UIImageView alloc] initWithFrame:CGRectMake(circleIconX, circleIconY, circleIconW, circleIconH)];
        circleIcon.layer.masksToBounds = YES;
        circleIcon.layer.cornerRadius = circleIconH / 2.0;
        if (index <= statusType) {
            circleIcon.backgroundColor = APPDEFAULTORANGE;
            statusLabel.textColor = APPDEFAULTORANGE;
        }
        else{
            statusLabel.textColor = [UIColor grayColor];
            circleIcon.backgroundColor = [UIColor colorWithWhite:237.0 / 255.0 alpha:1.0];
        }
        [statusView addSubview:circleIcon];
        
        sepLineY = CGRectGetMidY(circleIcon.frame);
        sepLineW = CGRectGetMinX(circleIcon.frame) - sepLineX - 2;
        UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(sepLineX, sepLineY, sepLineW, sepLineH)];
        sepLine.backgroundColor = circleIcon.backgroundColor;
        [statusView addSubview:sepLine];
        
        statusLabelX = CGRectGetMaxX(statusLabel.frame);
        sepLineX = CGRectGetMaxX(circleIcon.frame) + 2;
    }
    
    sepLineW = SCREENWIDTH - sepLineX;
    UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(sepLineX, sepLineY, sepLineW, sepLineH)];
    sepLine.backgroundColor = [UIColor colorWithWhite:237.0 / 255.0 alpha:1.0];
    [statusView addSubview:sepLine];
    
}

- (void)addPhotoScrollView
{
    CGFloat imageX = 0;
    CGFloat imageY = 5;
    CGFloat imageH = photoScrollView.frame.size.height - 2 * imageY;
    CGFloat imageW = imageH;
    CGFloat imageDistance = 5;
    NSInteger index = 0;
    for (NSString *url in paperArray) {
        NSString *imageurl = [NSString stringWithFormat:@"%@/%@",HYTIMAGEURL,url];
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, imageY, imageW, imageH)];
        [imageview sd_setImageWithURL:[NSURL URLWithString:imageurl] placeholderImage:[UIImage imageNamed:@"comonDefaultImage"]];
        imageview.layer.masksToBounds = YES;
        imageview.layer.cornerRadius = 5.0;
        imageview.contentMode = UIViewContentModeScaleAspectFill;
        [photoScrollView addSubview:imageview];
        imageX = imageX + imageW + imageDistance;
        imageview.tag = index + 10000;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanlargeImage:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        imageview.userInteractionEnabled = YES;
        [imageview addGestureRecognizer:tap];
        index++;
        
    }
    if (imageX > photoScrollView.frame.size.width) {
        photoScrollView.contentSize = CGSizeMake(imageX, 0);
    }
}

- (void)scanlargeImage:(UITapGestureRecognizer *)tap
{
    NSInteger index = 0;
    NSMutableArray *photos = [NSMutableArray array];
    for (NSString *url in paperArray) {
        NSString *imageurl = [NSString stringWithFormat:@"%@/%@",HYTIMAGEURL,url];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:imageurl];
        
        UIImageView *srcImageView = [photoScrollView viewWithTag:index + 10000];
        photo.image = srcImageView.image;
        photo.srcImageView = srcImageView;
        [photos addObject:photo];
        index++;
    }
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = tap.view.tag - 10000;
    browser.photos = photos;
    [browser show];
}

- (void)enlargeImage:(UITapGestureRecognizer *)tap
{
    NSString *zoneCover = [NSString stringWithFormat:@"%@/%@",HYTIMAGEURL,paperArray[0]];
    
    UIImageView *srcImageView = (UIImageView *)tap.view;
    NSMutableArray *photos = [NSMutableArray array];
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    MJPhoto *photo = [[MJPhoto alloc] init];
    photo.url = [NSURL URLWithString:zoneCover];
    photo.image = srcImageView.image;
    photo.srcImageView = srcImageView;
    [photos addObject:photo];
    browser.photos = photos;
    [browser show];
}

- (void)buttonClick:(UIButton *)button
{
    if (button.tag == 0) {
        NSLog(@"请求取消");
        //若取消订单，
        [self showCancleAlertView];
    }else{
        
        NSInteger orderIndex = [[infoDic valueForKey:@"orderReceivestate"] integerValue];
        if(orderIndex == 0 || orderIndex == 1 || orderIndex == 2){
            [self updateOrderStateWithOrderState:orderIndex];
        }else if(orderIndex == 3){
            // "执行下一步：填写报告";
            NurseReportVC *nurseReportVC = [[NurseReportVC alloc] init];
            nurseReportVC.hidesBottomBarWhenPushed = YES;
            nurseReportVC.infoData = infoDic;
//            nurseReportVC.isDetail = NO;
            nurseReportVC.reportType = 2;
            [self.navigationController pushViewController:nurseReportVC animated:YES];
        }
    }
}

#pragma mark - TableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            return 3;
            break;
        }
        case 1:
        {
            return 1;
            break;
        }
        case 2:
        {
            return 1;
            break;
        }
        case 3:
        {
            return 2;
            break;
        }
            
        default:
            break;
    }
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    static NSString *cellIndentifier = @"OrderFinishedTableViewCell";
    CGSize cellSize = [tableView rectForRowAtIndexPath:indexPath].size;
    NSDictionary *dict = [NSDictionary dictionaryWithDictionary:infoDic];
    
    HeBaseTableViewCell *cell  = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[HeBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier cellSize:cellSize];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    switch (section) {
        case 0:
        {
            switch (row) {
                case 0:
                {
//                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    
                    NSString *content = [NSString stringWithFormat:@"%@",[dict valueForKey:@"orderSendServicecontent"]];
                    NSArray *contentArr = [content componentsSeparatedByString:@":"];
                    
                    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, cellSize.height)];
                    titleLabel.backgroundColor = [UIColor clearColor];
                    @try {
                        titleLabel.text = contentArr[0];
                    } @catch (NSException *exception) {
                        
                    } @finally {
                        
                    }
                    titleLabel.font = [UIFont systemFontOfSize:15.0];
                    titleLabel.textColor = [UIColor blackColor];
                    [cell addSubview:titleLabel];
                    
                    NSString *priceString = [NSString stringWithFormat:@"￥%@",[dict valueForKey:@"orderSendTotalmoney"]];
                    UIFont *priceFont = [UIFont systemFontOfSize:14.0];
                    CGSize priceSize = [MLLabel getViewSizeByString:priceString maxWidth:200 font:priceFont lineHeight:1.2f lines:0];
                    CGFloat priceLabelW = priceSize.width;
                    CGFloat priceLabelY = 0;
                    CGFloat priceLabelH = cellSize.height;
                    CGFloat priceLabelX = cellSize.width - priceLabelW - 40;
                    
                    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(priceLabelX, priceLabelY, priceLabelW, priceLabelH)];
                    priceLabel.text = priceString;
                    priceLabel.backgroundColor = [UIColor clearColor];
                    priceLabel.textColor = [UIColor redColor];
                    priceLabel.font = priceFont;
                    [cell addSubview:priceLabel];
                    
                    UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(priceLabel.frame) - 80, 0, 80, cellSize.height)];
                    subTitleLabel.backgroundColor = [UIColor clearColor];
                    subTitleLabel.text = @"预计收入";
                    subTitleLabel.textAlignment = NSTextAlignmentRight;
                    subTitleLabel.font = priceFont;
                    subTitleLabel.textColor = [UIColor grayColor];
                    [cell addSubview:subTitleLabel];
                    
                    break;
                }
                case 1:
                {
                    NSString *content = [NSString stringWithFormat:@"%@",[dict valueForKey:@"orderSendServicecontent"]];
                    NSString *serviceStr = @"";
                    NSArray *contentArr = [content componentsSeparatedByString:@":"];
                    @try {
                        serviceStr = contentArr[1];
                    } @catch (NSException *exception) {
                    } @finally {
                        
                    }
                    if (serviceStr.length > 0) {
                        CGFloat scroll_W = cellSize.width;
                        UIScrollView *serviceBG = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, scroll_W, 44)];
                        serviceBG.showsVerticalScrollIndicator = NO;
                        serviceBG.showsHorizontalScrollIndicator = NO;
                        serviceBG.userInteractionEnabled = YES;
                        //默认设置可以滑动
                        serviceBG.contentSize =  CGSizeMake(scroll_W, 44);
                        [cell addSubview:serviceBG];
                        
                        NSArray *serviceArr = [serviceStr componentsSeparatedByString:@","];
                        
                        CGFloat endLabelY = 5;
                        CGFloat endLabelW = 10;
                        CGFloat endLabelH = 30;
                        CGFloat endLabelX = 10;
                        CGFloat endLabelHDistance = 10;
                        
                        UIFont *textFont = [UIFont systemFontOfSize:14.0];
                        
                        for (NSInteger index = 0; index < [serviceArr count]; index ++ ) {
                            
                            NSString *title = serviceArr[index];
                            
                            CGSize size = [MLLabel getViewSizeByString:title maxWidth:1000 font:textFont lineHeight:1.2f lines:0];
                            
                            endLabelW = size.width+10;
                            
                            UILabel *endLabel = [[UILabel alloc] initWithFrame:CGRectMake(endLabelX, endLabelY, endLabelW, endLabelH)];
                            endLabel.font = [UIFont systemFontOfSize:14.0];
                            endLabel.text = title;
                            endLabel.textColor = APPDEFAULTORANGE;
                            endLabel.textAlignment = NSTextAlignmentCenter;
                            endLabel.backgroundColor = [UIColor clearColor];
                            endLabel.layer.cornerRadius = 5.0;
                            endLabel.layer.masksToBounds = YES;
                            endLabel.layer.borderWidth = 0.5;
                            endLabel.layer.borderColor = APPDEFAULTORANGE.CGColor;
                            endLabel.textColor = APPDEFAULTORANGE;
                            [serviceBG addSubview:endLabel];
                            
                            endLabelX = endLabelX + endLabelHDistance + endLabelW;
                            NSLog(@"endLabelX:%f",endLabelX);
                            
                        }

                        if (scroll_W > endLabelX) {
                            endLabelX = scroll_W;
                        }
                        serviceBG.contentSize =  CGSizeMake(endLabelX, 44);
                    }
                    break;
                }
                case 2:
                {
                    
                    id zoneCreatetimeObj = [dict objectForKey:@"orderSendBegintime"];
                    if ([zoneCreatetimeObj isMemberOfClass:[NSNull class]] || zoneCreatetimeObj == nil) {
                        NSTimeInterval  timeInterval = [[NSDate date] timeIntervalSince1970];
                        zoneCreatetimeObj = [NSString stringWithFormat:@"%.0f000",timeInterval];
                    }
                    long long timestamp = [zoneCreatetimeObj longLongValue];
                    NSString *zoneCreatetime = [NSString stringWithFormat:@"%lld",timestamp];
                    if ([zoneCreatetime length] > 3) {
                        //时间戳
                        zoneCreatetime = [zoneCreatetime substringToIndex:[zoneCreatetime length] - 3];
                    }
                    NSString *stopTimeStr = [Tool convertTimespToString:[zoneCreatetime longLongValue] dateFormate:@"MM/dd/ EEE HH:mm"];
                    
                    CGFloat timeLabelX = 10;
                    CGFloat timeLabelW = SCREENWIDTH - 50;
                    CGFloat timeLabelH = cellSize.height / 2.0;
                    CGFloat timeLabelY = 0;
                    
                    UILabel *timeTip = [[UILabel alloc] initWithFrame:CGRectMake(timeLabelX, timeLabelY, 30, timeLabelH)];
                    timeTip.font = [UIFont systemFontOfSize:13.0];
                    timeTip.text = @"时间";
                    timeTip.textColor = [UIColor grayColor];
                    timeTip.backgroundColor = [UIColor clearColor];
                    [cell addSubview:timeTip];
                    
                    timeLabelX = CGRectGetMaxX(timeTip.frame)+5;
                    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(timeLabelX, timeLabelY, timeLabelW, timeLabelH)];
                    timeLabel.font = [UIFont systemFontOfSize:13.0];
                    timeLabel.text = stopTimeStr;
                    timeLabel.backgroundColor =[UIColor clearColor];
                    [cell addSubview:timeLabel];
                    
                    NSString *address = [NSString stringWithFormat:@"%@",[dict valueForKey:@"orderSendAddree"]];
                    NSArray *addArr = [address componentsSeparatedByString:@","];
                    
                    CGFloat addressLabelX = 10;
                    CGFloat addressLabelW = SCREENWIDTH-110;
                    CGFloat addressLabelH = cellSize.height / 2.0;
                    CGFloat addressLabelY = CGRectGetMaxY(timeLabel.frame);
                    
                    UILabel *addressTip = [[UILabel alloc] initWithFrame:CGRectMake(addressLabelX, addressLabelY, 30, addressLabelH)];
                    addressTip.font = [UIFont systemFontOfSize:13.0];
                    addressTip.text = @"地址";
                    addressTip.textColor = [UIColor grayColor];
                    addressTip.backgroundColor = [UIColor clearColor];
                    [cell addSubview:addressTip];
                    
                    addressLabelX = CGRectGetMaxX(addressTip.frame);
                    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(addressLabelX, addressLabelY, addressLabelW, addressLabelH)];
                    addressLabel.font = [UIFont systemFontOfSize:13.0];
                    @try {
                        addressLabel.text = addArr[2];
                    } @catch (NSException *exception) {
                        
                    } @finally {
                        
                    }
                    [cell addSubview:addressLabel];

                    UIButton *locationButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH-75, addressLabelY-3, 65, 25)];
                    locationButton.backgroundColor = APPDEFAULTTITLECOLOR;
                    [locationButton setTitle:@"查看地图" forState:UIControlStateNormal];
                    locationButton.layer.cornerRadius = 4.0;
                    [locationButton.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
                    [locationButton addTarget:self action:@selector(goToLocationView) forControlEvents:UIControlEventTouchUpInside];
                    [cell addSubview:locationButton];
                    
//                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//                    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, cellSize.height)];
//                    titleLabel.backgroundColor = [UIColor clearColor];
//                    titleLabel.text = @"患者信息";
//                    titleLabel.font = [UIFont systemFontOfSize:15.0];
//                    titleLabel.textColor = [UIColor blackColor];
//                    [cell addSubview:titleLabel];
//                    
//                    NSString *sex = [[dict valueForKey:@"orderSendSex"] integerValue] == 1 ? @"男" : @"女";
//                    
//                    CGFloat subTitleLabelX = CGRectGetMaxX(titleLabel.frame) + 5;
//                    CGFloat subTitleLabelY = 0;
//                    CGFloat subTitleLabelH = cellSize.height;
//                    CGFloat subTitleLabelW = SCREENWIDTH - subTitleLabelX - 40;
//                    UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(subTitleLabelX, subTitleLabelY, subTitleLabelW, subTitleLabelH)];
//                    subTitleLabel.backgroundColor = [UIColor clearColor];
//                    
//                    NSString *nameStr = [dict valueForKey:@"orderSendUsername"];
//                    NSArray *nameArr = [nameStr componentsSeparatedByString:@","];
//                    @try {
//                        nameStr = nameArr[0];
//                    } @catch (NSException *exception) {
//                    } @finally {
//                        
//                    }
//                    subTitleLabel.text = [NSString stringWithFormat:@"%@ %@ %@岁",nameStr,sex,[dict valueForKey:@"orderSendAge"]];
//                    subTitleLabel.textAlignment = NSTextAlignmentRight;
//                    subTitleLabel.font = [UIFont systemFontOfSize:15.0];
//                    subTitleLabel.textColor = [UIColor blackColor];
//                    [cell addSubview:subTitleLabel];
                    
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 1:
        {
            switch (row) {
                case 0:
                {
//                    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, cellSize.height)];
//                    titleLabel.backgroundColor = [UIColor clearColor];
//                    titleLabel.text = @"备注信息";
//                    titleLabel.font = [UIFont systemFontOfSize:15.0];
//                    titleLabel.textColor = [UIColor blackColor];
//                    [cell addSubview:titleLabel];
//                    
//                    CGFloat subTitleLabelX = CGRectGetMaxX(titleLabel.frame) + 5;
//                    CGFloat subTitleLabelY = 0;
//                    CGFloat subTitleLabelH = cellSize.height;
//                    CGFloat subTitleLabelW = SCREENWIDTH - subTitleLabelX - 10;
//                    UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(subTitleLabelX, subTitleLabelY, subTitleLabelW, subTitleLabelH)];
//                    subTitleLabel.backgroundColor = [UIColor clearColor];
//                    subTitleLabel.text = [dict valueForKey:@"orderSendNote"];
//                    subTitleLabel.textAlignment = NSTextAlignmentRight;
//                    subTitleLabel.font = [UIFont systemFontOfSize:15.0];
//                    subTitleLabel.textColor = [UIColor blackColor];
//                    [cell addSubview:subTitleLabel];
//                    
                    CGFloat lableH = cellSize.height/3.0;
                    CGFloat tipX = 10;
                    CGFloat tipY = 0;
                    CGFloat tipW = 30;
                    UILabel *userTip = [[UILabel alloc] initWithFrame:CGRectMake(tipX, tipY, tipW, lableH)];
                    userTip.textColor = [UIColor grayColor];
                    userTip.text = @"姓名";
                    userTip.font = [UIFont systemFontOfSize:13.0];
                    userTip.backgroundColor = [UIColor clearColor];
                    [cell addSubview:userTip];
                    
                    CGFloat userInfoX = CGRectGetMaxX(userTip.frame);
                    CGFloat userInfoW = SCREENWIDTH-userInfoX-80;
                    
                    UILabel *userInfoL = [[UILabel alloc] initWithFrame:CGRectMake(userInfoX, tipY, userInfoW, lableH)];
                    userInfoL.textColor = [UIColor blackColor];
                    userInfoL.userInteractionEnabled = YES;
                    userInfoL.font = [UIFont systemFontOfSize:13.0];
                    userInfoL.backgroundColor = [UIColor clearColor];
                    [cell addSubview:userInfoL];
                    userInfoL.text = [NSString stringWithFormat:@"%@ %@",[dict valueForKey:@"userNickNew"],[dict valueForKey:@"userNameNew"]];

                    
                    NSString *sex = [[dict valueForKey:@"orderSendSex"] integerValue]==1 ? @"男" : @"女";
                    
                    NSString *nameStr = [dict valueForKey:@"orderSendUsername"];
                    NSArray *nameArr = [nameStr componentsSeparatedByString:@","];
                    @try {
                        nameStr = nameArr[1];
                    } @catch (NSException *exception) {
                    } @finally {
                        
                    }
                    ;
                    
                    UILabel *userInfoL1 = [[UILabel alloc] initWithFrame:CGRectMake(userInfoX, lableH, userInfoW, lableH)];
                    userInfoL1.textColor = [UIColor blackColor];
                    userInfoL1.userInteractionEnabled = YES;
                    userInfoL1.font = [UIFont systemFontOfSize:13.0];
                    userInfoL1.backgroundColor = [UIColor clearColor];
                    [cell addSubview:userInfoL1];
                    userInfoL1.text = [NSString stringWithFormat:@"为%@(%@,%@,%@岁)预约",[dict valueForKey:@"protectedPersonNexus"],nameStr,sex,[dict valueForKey:@"orderSendAge"]];

                    UIImageView *telephone = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH-40, 3, 20, 20)];
                    telephone.backgroundColor = [UIColor clearColor];
                    telephone.image = [UIImage imageNamed:@"icon_phone"];
                    telephone.userInteractionEnabled = YES;
                    [cell addSubview:telephone];
                    
                    UITapGestureRecognizer *userInfoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callCustomer)];
                    [telephone addGestureRecognizer:userInfoTap];
                    
                    UILabel *remarkTip = [[UILabel alloc] initWithFrame:CGRectMake(tipX, lableH*2, tipW, lableH)];
                    remarkTip.textColor = [UIColor grayColor];
                    remarkTip.text = @"备注";
                    remarkTip.font = [UIFont systemFontOfSize:13.0];
                    remarkTip.backgroundColor = [UIColor clearColor];
                    [cell addSubview:remarkTip];
                    
                    CGFloat remarkInfoX = CGRectGetMaxX(remarkTip.frame);
                    CGFloat remarkInfoW = SCREENWIDTH-remarkInfoX-10;
                    
                    UILabel *remarkInfoL = [[UILabel alloc] initWithFrame:CGRectMake(remarkInfoX, lableH*2, remarkInfoW, lableH)];
                    remarkInfoL.textColor = [UIColor blackColor];
                    remarkInfoL.userInteractionEnabled = YES;
                    remarkInfoL.font = [UIFont systemFontOfSize:13.0];
                    remarkInfoL.backgroundColor = [UIColor clearColor];
                    [cell addSubview:remarkInfoL];
                    remarkInfoL.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"orderSendNote"]];

                    break;
                }
//                case 1:
//                {
//                    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 44)];
//                    titleLabel.backgroundColor = [UIColor clearColor];
//                    titleLabel.text = @"图片资料";
//                    titleLabel.font = [UIFont systemFontOfSize:15.0];
//                    titleLabel.textColor = [UIColor blackColor];
//                    [cell addSubview:titleLabel];
//                    
//                    CGRect photoFrame = photoScrollView.frame;
//                    photoFrame.origin.y = CGRectGetMaxY(titleLabel.frame);
//                    photoScrollView.frame = photoFrame;
//                    [cell addSubview:photoScrollView];
//                    break;
//                }
                default:
                    break;
            }
            break;
        }
        case 2:{
            switch (row) {
                case 0:
                {
                    
                    UIImageView *piccImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 90, 40)];
                    [piccImageView setBackgroundColor:[UIColor clearColor]];
                    piccImageView.userInteractionEnabled = YES;
                    piccImageView.image = [UIImage imageNamed:@"icon_picc"];
                    [cell addSubview:piccImageView];
                    
                    UILabel *piccTipL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(piccImageView.frame), 5, SCREENWIDTH-CGRectGetMaxX(piccImageView.frame)-40, 50)];
                    piccTipL.textColor = [UIColor grayColor];
                    piccTipL.userInteractionEnabled = YES;
                    piccTipL.numberOfLines = 0;
                    piccTipL.text = @"【护士上门】将免费为患者和医护人员投保中国人寿意外险";
                    piccTipL.font = [UIFont systemFontOfSize:12.0];
                    piccTipL.backgroundColor = [UIColor clearColor];
                    [cell addSubview:piccTipL];
                    
                    
                    UIImageView *quessionImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(piccTipL.frame), 20, 20, 20)];
                    [quessionImageView setBackgroundColor:[UIColor clearColor]];
                    quessionImageView.userInteractionEnabled = YES;
                    quessionImageView.image = [UIImage imageNamed:@"icon_question"];
                    [cell addSubview:quessionImageView];
                    
                    break;
                }
                    
                default:
                    break;
            }
            break;
        }
        case 3:
        {
            switch (row) {
                case 0:
                {
                    id zoneCreatetimeObj = [dict objectForKey:@"orderSendGetOrderTime"];
                    if ([zoneCreatetimeObj isMemberOfClass:[NSNull class]] || zoneCreatetimeObj == nil) {
                        NSTimeInterval  timeInterval = [[NSDate date] timeIntervalSince1970];
                        zoneCreatetimeObj = [NSString stringWithFormat:@"%.0f000",timeInterval];
                    }
                    long long timestamp = [zoneCreatetimeObj longLongValue];
                    NSString *zoneCreatetime = [NSString stringWithFormat:@"%lld",timestamp];
                    if ([zoneCreatetime length] > 3) {
                        //时间戳
                        zoneCreatetime = [zoneCreatetime substringToIndex:[zoneCreatetime length] - 3];
                    }
                    NSString *stopTimeStr = [Tool convertTimespToString:[zoneCreatetime longLongValue] dateFormate:@"yyyy-MM-dd HH:mm"];
                    
                    CGFloat orderNoLabelX = 10;
                    CGFloat orderNoLabelW = SCREENWIDTH - 2 * orderNoLabelX;
                    CGFloat orderNoLabelH = cellSize.height / 2.0;
                    CGFloat orderNoLabelY = 0;
                    UILabel *orderNoLabel = [[UILabel alloc] initWithFrame:CGRectMake(orderNoLabelX, orderNoLabelY, orderNoLabelW, orderNoLabelH)];
                    orderNoLabel.font = [UIFont fontWithName:@"Helvetica" size:13.0];
                    orderNoLabel.text = [NSString stringWithFormat:@"接单时间: %@",stopTimeStr];
                    [cell addSubview:orderNoLabel];
                    
                    CGFloat timeLabelX = 10;
                    CGFloat timeLabelW = SCREENWIDTH - 2 * timeLabelX;
                    CGFloat timeLabelH = cellSize.height / 2.0;
                    CGFloat timeLabelY = CGRectGetMaxY(orderNoLabel.frame);
                    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(timeLabelX, timeLabelY, timeLabelW, timeLabelH)];
                    timeLabel.font = [UIFont fontWithName:@"Helvetica" size:13.0];
                    timeLabel.text = [NSString stringWithFormat:@"订单编号: %@",[dict valueForKey:@"orderSendNumbers"]];
                    [cell addSubview:timeLabel];
                    
                    break;
                }
                case 1:
                {
                    CGFloat buttonX = 0;
                    CGFloat buttonY = 0;
                    CGFloat buttonW = 100;
                    CGFloat buttonH = 44;
                    
                    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
                    [cancelButton setTitle:@"请求取消" forState:UIControlStateNormal];
                    [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
                    [cancelButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                    [cancelButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                    cancelButton.tag = 0;
                    [cell addSubview:cancelButton];
                    
                    NSArray  *orderStateStr = @[@"联系客户",@"出发",@"开始服务",@"填写报告",@"已完成"];
                    NSInteger orderIndex = [[dict valueForKey:@"orderReceivestate"] integerValue];
                    
                    buttonX = CGRectGetMaxX(cancelButton.frame);
                    buttonW = SCREENWIDTH - buttonX;

                    UILabel *stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(buttonX+buttonW/2.0+15, buttonY, 100, buttonH)];
                    stateLabel.font = [UIFont systemFontOfSize:15.0];
                    stateLabel.text = [NSString stringWithFormat:@"(%@)",orderStateStr[orderIndex]];
                    stateLabel.textColor = [UIColor grayColor];
                    stateLabel.textAlignment = NSTextAlignmentCenter;
                    stateLabel.backgroundColor = [UIColor clearColor];
                    [cell addSubview:stateLabel];
                    
                    UIButton *nextButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
                    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
                    [nextButton.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
                    [nextButton setTitleColor:APPDEFAULTORANGE forState:UIControlStateNormal];
                    nextButton.backgroundColor = [UIColor clearColor];
                    [nextButton addTarget:self action:@selector(showAlertViewWithTag:) forControlEvents:UIControlEventTouchUpInside];
                    nextButton.tag = orderIndex;
                    [cell addSubview:nextButton];
                    if (orderIndex >= 4) {
                        nextButton.enabled = NO;
                        [nextButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                        
                        cancelButton.enabled = NO;
                        [cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                        
                    }
                    
                    CGFloat sepLineX = buttonX;
                    CGFloat sepLineY = 3;
                    CGFloat sepLineH = 44 - 2 * sepLineY;
                    CGFloat sepLineW = 1;
                    
                    UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(sepLineX, sepLineY, sepLineW, sepLineH)];
                    sepLine.backgroundColor = [UIColor colorWithWhite:237.0 / 255.0 alpha:1.0];
                    [cell addSubview:sepLine];
                    
//                    NSArray *tipArr = @[@"1.仔细查看订单内容；\n2.仔细查看服务内容、备注内容；\n注：要求接单后尽快与病人确认。",@"1、电话联系用户，核对\n 1)服务时间、地点\n 2)病人信息、服务内容，备注：如需要请病人补充；\n 3）过敏史，传染病史；\n 4）病人自备材料及要求采购材料。",@"1、电话联系用户，确定是否在家。告知预计到达时间，及病人自备材料；\n2、核对所带设备、材料",@"1、自我介绍；\n2、说明服务内容及流程；\n3、开始服务",@""];
//                    UITextView *tipTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, buttonY+buttonH, SCREENWIDTH-20, 90)];
//                    tipTextView.font = [UIFont systemFontOfSize:10.0];
//                    @try {
//                        tipTextView.text = tipArr[orderIndex];
//                    } @catch (NSException *exception) {
//                        
//                    } @finally {
//                        
//                    }
//                    tipTextView.textColor = [UIColor grayColor];
//                    tipTextView.backgroundColor = [UIColor clearColor];
//                    [cell addSubview:tipTextView];
                    
                    break;
                }
                default:
                    break;
            }
            break;
        }
            
        default:
            break;
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    switch (section) {
        case 0:
        {
            switch (row) {
                case 0:
                    return 44;
                    break;
                case 1:
                    return 44;
                    break;
                case 2:
                    return 60;
                    break;
                    
                default:
                    break;
            }
            break;
        }
        case 1:{
            switch (row) {
                case 0:
                    return 80;
                    break;
//                case 1:
//                    return 44 + imageScrollViewHeigh;
//                    break;
                default:
                    break;
            }
        }
        case 2:{
            switch (row) {
                case 0:
                    return 50;
                    break;
                default:
                    break;
            }
        }
        case 3:{
            switch (row) {
                case 0:
                    return 50;
                    break;
                case 1:
                    return 44+90;
                    break;
                default:
                    break;
            }
        }
        default:
            break;
    }
    
    return 160;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 10)];
    headerView.backgroundColor = [UIColor colorWithWhite:237.0 /255.0 alpha:1.0];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    NSLog(@"row = %ld, section = %ld",row,section);
//    if (section == 0 && row == 1) {
//        //地图
//        NSString *address = [NSString stringWithFormat:@"%@",[infoDic valueForKey:@"orderSendAddree"]];
//        NSArray *addArr = [address componentsSeparatedByString:@","];
//        //经度
//        NSString *zoneLocationX = nil;
//        //纬度
//        NSString *zoneLocationY = nil;
//        @try {
//            zoneLocationX = addArr[0];
//            zoneLocationY = addArr[1];
//        } @catch (NSException *exception) {
//            
//        } @finally {
//            
//        }
//        NSDictionary *userLocationDic = @{@"zoneLocationY":zoneLocationY,@"zoneLocationX":zoneLocationX};
//        [self goLocationWithLocation:userLocationDic];
//    }
    if (section == 0 && row == 2) {
        //患者信息
//        [self showPaitentInfoWith:infoDic];
    }
}


//取消订单
- (void)sendCancleOrder{
    NSString *userAccount = [[NSUserDefaults standardUserDefaults] objectForKey:USERIDKEY];
    //订单ID
    NSDictionary * params  = @{@"orderSendId" : orderId,
                               @"userId" : userAccount,
                               @"identity" : [NSNumber numberWithInteger:1]};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:CANCLEORDER params:params success:^(AFHTTPRequestOperation* operation,id response){
        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSLog(@"respondString:%@",respondString);
        NSMutableDictionary *respondDict = [NSMutableDictionary dictionaryWithDictionary:[respondString objectFromJSONString]];
        if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"200"]) {
            NSLog(@"success");
//            [self getOrderDetailData];
            
        }else{
            NSLog(@"faile");
//            [self.view makeToast:[NSString stringWithFormat:@"%@",[respondDict valueForKey:@"data"]] duration:1.2 position:@"center"];
        }

        [self performSelector:@selector(backItemClick:) withObject:nil afterDelay:1.2f];
    } failure:^(NSError* err){
        NSLog(@"err:%@",err);
        [self.view makeToast:ERRORREQUESTTIP duration:2.0 position:@"center"];
    }];
}


- (void)updateOrderStateWithOrderState:(NSInteger)orderState{
    NSString *userAccount = [[NSUserDefaults standardUserDefaults] objectForKey:USERIDKEY];
    NSString *orderSendId = [infoDic valueForKey:@"orderSendId"];
    NSString *orderReceiverState = [NSString stringWithFormat:@"%ld",orderState+1];
    
    NSDictionary * params  = @{@"nurseId": userAccount,
                               @"orderSendId" : orderSendId,
                               @"orderReceiverState" : orderReceiverState};
    
    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:UPDATEORDERSTATE params:params success:^(AFHTTPRequestOperation* operation,id response){
        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSLog(@"respondString:%@",respondString);
        NSMutableDictionary *respondDict = [NSMutableDictionary dictionaryWithDictionary:[respondString objectFromJSONString]];
        
        if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"200"]) {
            NSLog(@"success");
//            switch (orderState) {
//                case 0:
//                    [self.view makeToast:@"联系客户后，请出发" duration:1.2 position:@"center"];
//                    break;
//                case 1:
//                    [self.view makeToast:@"出发后，请开始服务" duration:1.2 position:@"center"];
//                    break;
//                case 2:
//                    [self.view makeToast:@"服务完成后，请填写护理报告" duration:1.2 position:@"center"];
//                    break;
//                    
//                default:
//                    break;
//            }
            
            [self getOrderDetailData];
            
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateOrder" object:nil];
            
        }else{
            NSLog(@"faile");
            
            [self.view makeToast:[NSString stringWithFormat:@"%@",[respondDict valueForKey:@"data"]] duration:1.2 position:@"center"];
            
            [self performSelector:@selector(backItemClick:) withObject:nil afterDelay:1.2f];

        }
    } failure:^(NSError* err){
        NSLog(@"err:%@",err);
        [self.view makeToast:ERRORREQUESTTIP duration:2.0 position:@"center"];
    }];
}

//患者信息
- (void)showPaitentInfoWith:(NSDictionary *)paitentInfoDict
{
    HePaitentInfoVC *paitentInfoVC = [[HePaitentInfoVC alloc] init];
    paitentInfoVC.userInfoDict = [[NSDictionary alloc] initWithDictionary:paitentInfoDict];
    paitentInfoVC.hidesBottomBarWhenPushed = YES;
    paitentInfoVC.isFromNowOrder = YES;
    [self.navigationController pushViewController:paitentInfoVC animated:YES];
}

- (void)goLocationWithLocation:(NSDictionary *)locationDict
{
    HeUserLocatiVC *userLocationVC = [[HeUserLocatiVC alloc] init];
    userLocationVC.userLocationDict = [[NSDictionary alloc] initWithDictionary:locationDict];
    userLocationVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:userLocationVC animated:YES];
}


- (void)showAlertViewWithTag:(UIButton *)sender{
    NSInteger tag = sender.tag;
    windowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGH)];
    windowView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5];;
    [[[UIApplication sharedApplication] keyWindow] addSubview:windowView];
    
    NSInteger addBgView_W = SCREENWIDTH -20;
    NSInteger addBgView_H = 90;
    NSInteger addBgView_Y = SCREENHEIGH/2.0-addBgView_H/2.0-40;
    UIView *addBgView = [[UIView alloc] initWithFrame:CGRectMake(10, addBgView_Y, addBgView_W, addBgView_H)];
    addBgView.backgroundColor = [UIColor whiteColor];
    [addBgView.layer setMasksToBounds:YES];
    [addBgView.layer setCornerRadius:4];
    addBgView.alpha = 1.0;
    [windowView addSubview:addBgView];
    
    NSInteger addTextField_H = 44;
    NSInteger addTextField_Y = 10;
    NSInteger addTextField_W =SCREENWIDTH-40;
    
    UILabel *infoTip= [[UILabel alloc] initWithFrame:CGRectMake(10, addTextField_Y, addTextField_W, addTextField_H)];//高度--44
    infoTip.font = [UIFont systemFontOfSize:12.0];
    infoTip.numberOfLines = 0;
    infoTip.backgroundColor = [UIColor clearColor];
    [addBgView addSubview:infoTip];
    NSInteger orderSendState = tag;  //0已接单1已沟通2已出发3开始服务4已完成
    if(orderSendState == 0){
        infoTip.text = @"执行下一步：联系客户";
    }else if(orderSendState == 1){
        infoTip.text = @"执行下一步：出发";
    }else if(orderSendState == 2){
        infoTip.text = @"执行下一步：开始服务";
    }else if(orderSendState == 3){
        infoTip.text = @"执行下一步：填写报告";
    }
    
    NSInteger cancleBt_X = SCREENWIDTH-20-10-90;
    NSInteger cancleBt_Y = addTextField_Y+50;
    NSInteger cancleBt_W = 40;
    NSInteger cancleBt_H = 20;
    
    UIButton *cancleBt = [[UIButton alloc] initWithFrame:CGRectMake(cancleBt_X, cancleBt_Y, cancleBt_W, cancleBt_H)];
    [cancleBt setTitle:@"取消" forState:UIControlStateNormal];
    cancleBt.backgroundColor = [UIColor clearColor];
    cancleBt.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [cancleBt setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    cancleBt.tag = 1000;
    [cancleBt addTarget:self action:@selector(clickBtAction:) forControlEvents:UIControlEventTouchUpInside];
    [addBgView addSubview:cancleBt];
    
    UIButton *okBt = [[UIButton alloc] initWithFrame:CGRectMake(cancleBt_X+50, cancleBt_Y, cancleBt_W, cancleBt_H)];
    [okBt setTitle:@"确认" forState:UIControlStateNormal];
    okBt.backgroundColor = [UIColor clearColor];
    okBt.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [okBt setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    okBt.tag = orderSendState;
    [okBt addTarget:self action:@selector(clickBtAction:) forControlEvents:UIControlEventTouchUpInside];
    [addBgView addSubview:okBt];
}


- (void)clickBtAction:(UIButton *)sender{
    NSLog(@"tag:%ld",sender.tag);
    if(sender.tag == 0){
        [self updateOrderStateWithOrderState:sender.tag];
        // "执行下一步：联系客户";
    }else if(sender.tag == 1){
        [self updateOrderStateWithOrderState:sender.tag];
        // "执行下一步：出发";
    }else if(sender.tag == 2){
        [self updateOrderStateWithOrderState:sender.tag];
        // "执行下一步：开始服务";
    }else if(sender.tag == 3){
        // "执行下一步：填写报告";
        NurseReportVC *nurseReportVC = [[NurseReportVC alloc] init];
        nurseReportVC.hidesBottomBarWhenPushed = YES;
        nurseReportVC.infoData = infoDic;
//        nurseReportVC.isDetail = NO;
        nurseReportVC.reportType = 2;
        [self.navigationController pushViewController:nurseReportVC animated:YES];
    }
    
    if (windowView) {
        [windowView removeFromSuperview];
    }
    
}

- (void)refreshOrderDetail{
    [self updateOrderStateWithOrderState:4];
}

- (void)goToLocationView{
    //地图
    NSString *address = [NSString stringWithFormat:@"%@",[infoDic valueForKey:@"orderSendAddree"]];
    NSArray *addArr = [address componentsSeparatedByString:@","];
    //经度
    NSString *zoneLocationX = nil;
    //纬度
    NSString *zoneLocationY = nil;
    @try {
        zoneLocationX = addArr[0];
        zoneLocationY = addArr[1];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    NSDictionary *userLocationDic = @{@"zoneLocationY":zoneLocationY,@"zoneLocationX":zoneLocationX};
    [self goLocationWithLocation:userLocationDic];
}

- (void)callCustomer{
    NSDictionary *dict = [NSDictionary dictionaryWithDictionary:infoDic];

    [Tool callPhoneWithPhone:[dict valueForKey:@"userNameNew"]];
}

- (void)introductionAction{
    HandleIntroductionVC *handleIntroductionVC = [[HandleIntroductionVC alloc] init];
    handleIntroductionVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:handleIntroductionVC animated:YES];
}
- (void)showFirstTipView{
    
    
    [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:@"isFirst"];
    
    windowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGH)];
    windowView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5];;
    [[[UIApplication sharedApplication] keyWindow] addSubview:windowView];
    
    tipImageView = [[UIImageView alloc] initWithFrame:windowView.frame];
    tipImageView.backgroundColor = [UIColor clearColor];
    tipImageView.userInteractionEnabled = YES;
    [windowView addSubview:tipImageView];
    tipImageView.image = [UIImage imageNamed:@"bg_detail_one"];
    
    UITapGestureRecognizer *tipTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeTipImage)];
    tipTap.numberOfTapsRequired = 1;
    tipTap.numberOfTapsRequired = 1;
    [tipImageView addGestureRecognizer:tipTap];
    currentTipImageTag = 0;
}

- (void)changeTipImage{
    if (currentTipImageTag == 0) {
        tipImageView.image = [UIImage imageNamed:@"bg_detail_two"];
    }
    if (currentTipImageTag == 1){
        tipImageView.image = [UIImage imageNamed:@"bg_detail_three"];
    }
    if (currentTipImageTag == 2){
        if (windowView) {
            [windowView removeFromSuperview];
        }
    }
    
    currentTipImageTag++;
}

- (void)showCancleAlertView{
    
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
    
    NSInteger addTextField_H = 44;
    NSInteger addTextField_Y = 50;
    NSInteger addTextField_W =SCREENWIDTH-40;
    
    UILabel *infoTip= [[UILabel alloc] initWithFrame:CGRectMake(10, addTextField_Y, addTextField_W, addTextField_H)];//高度--44
    infoTip.font = [UIFont systemFontOfSize:14.0];
    infoTip.numberOfLines = 0;
    infoTip.backgroundColor = [UIColor clearColor];
    [addBgView addSubview:infoTip];
    
    titleL.text = @"请求取消";
    infoTip.text = @"若取消订单,你将无法获取酬劳,你确定要取消这笔订单吗？";
    
    
    NSInteger wordNum_Y = addTextField_Y+44;
    
    NSInteger cancleBt_X = SCREENWIDTH-20-10-90;
    NSInteger cancleBt_Y = wordNum_Y+30;
    NSInteger cancleBt_W = 40;
    NSInteger cancleBt_H = 20;
    
    UIButton *cancleBt = [[UIButton alloc] initWithFrame:CGRectMake(cancleBt_X, cancleBt_Y, cancleBt_W, cancleBt_H)];
    [cancleBt setTitle:@"取消" forState:UIControlStateNormal];
    cancleBt.backgroundColor = [UIColor clearColor];
    cancleBt.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [cancleBt setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    cancleBt.tag = 0;
    [cancleBt addTarget:self action:@selector(clickCancleBtAction:) forControlEvents:UIControlEventTouchUpInside];
    [addBgView addSubview:cancleBt];
    
    UIButton *okBt = [[UIButton alloc] initWithFrame:CGRectMake(cancleBt_X+50, cancleBt_Y, cancleBt_W, cancleBt_H)];
    [okBt setTitle:@"确定" forState:UIControlStateNormal];
    okBt.backgroundColor = [UIColor clearColor];
    okBt.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [okBt setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    okBt.tag = 1;
    [okBt addTarget:self action:@selector(clickCancleBtAction:) forControlEvents:UIControlEventTouchUpInside];
    [addBgView addSubview:okBt];
    
    
}

//取消进行中的订单
- (void)clickCancleBtAction:(UIButton *)sender{
    // "请求取消"

    if (sender.tag == 1) {
        [self sendCancleOrder];
    }
    if (windowView) {
        [windowView removeFromSuperview];
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
