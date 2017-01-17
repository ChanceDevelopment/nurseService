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

@interface HeOrderDetailVC ()<UITableViewDelegate,UITableViewDataSource>
{
    CGFloat imageScrollViewHeigh;
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
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initializaiton];
    [self initView];
    [self getOrderDetailData];
}

- (void)initializaiton
{
    [super initializaiton];
    statusArray = @[@"已接单",@"已沟通",@"已出发",@"开始服务",@"已完成"];
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
    
    CGFloat scrollX = 5;
    CGFloat scrollY = 5;
    CGFloat scrollW = SCREENWIDTH - 2 * scrollX;
    CGFloat scrollH = imageScrollViewHeigh;
    photoScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(scrollX, scrollY, scrollW, scrollH)];
    [paperArray addObject:@"123"];

    [self addPhotoScrollView];
    
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
                [tableview reloadData];
            }
            NSLog(@"success");
        }else if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"400"]){
            [self performSelector:@selector(backToRootView) withObject:nil afterDelay:1.2];
            NSLog(@"faile");
        }
        [self.view makeToast:[NSString stringWithFormat:@"%@",[respondDict valueForKey:@"data"]] duration:1.2 position:@"center"];
    } failure:^(NSError* err){
        NSLog(@"err:%@",err);
        [self.view makeToast:ERRORREQUESTTIP duration:2.0 position:@"center"];
    }];
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
        }
        else{
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
        [self sendCancleOrderWithOrderId:orderId];
    }else{
        
        NSInteger orderIndex = [[infoDic valueForKey:@"orderReceivestate"] integerValue];
        if(orderIndex == 0 || orderIndex == 1 || orderIndex == 2){
            [self updateOrderStateWithOrderState:orderIndex];
        }else if(orderIndex == 3){
            // "执行下一步：填写报告";
            NurseReportVC *nurseReportVC = [[NurseReportVC alloc] init];
            nurseReportVC.hidesBottomBarWhenPushed = YES;
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
            return 2;
            break;
        }
        case 2:
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
    return 3;
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
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    
                    NSString *content = [NSString stringWithFormat:@"%@",[dict valueForKey:@"orderSendServicecontent"]];
                    NSArray *contentArr = [content componentsSeparatedByString:@":"];
                    
                    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, cellSize.height)];
                    titleLabel.backgroundColor = [UIColor clearColor];
                    @try {
                        titleLabel.text = contentArr[1];
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
                    NSString *stopTimeStr = [Tool convertTimespToString:[zoneCreatetime longLongValue] dateFormate:@"MM/dd HH:MM"];
                    
                    CGFloat timeLabelX = 10;
                    CGFloat timeLabelW = SCREENWIDTH - 2 * timeLabelX;
                    CGFloat timeLabelH = cellSize.height / 2.0;
                    CGFloat timeLabelY = 0;
                    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(timeLabelX, timeLabelY, timeLabelW, timeLabelH)];
                    timeLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
                    timeLabel.text = stopTimeStr;
                    [cell addSubview:timeLabel];
                    
                    CGFloat locationIconH = 20;
                    CGFloat locationIconW = 20;
                    CGFloat locationIconX = SCREENWIDTH - locationIconW - 20;
                    CGFloat locationIconY = cellSize.height / 2.0 + (cellSize.height / 2.0 - locationIconH) / 2.0;
                    
                    UIImageView *locationIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_address"]];
                    locationIcon.frame = CGRectMake(locationIconX, locationIconY, locationIconW, locationIconH);
                    [cell addSubview:locationIcon];
                    
                    NSString *address = [NSString stringWithFormat:@"%@",[dict valueForKey:@"orderSendAddree"]];
                    NSArray *addArr = [address componentsSeparatedByString:@","];
                    
                    CGFloat addressLabelX = 10;
                    CGFloat addressLabelW = CGRectGetMinX(locationIcon.frame) - addressLabelX - 10;
                    CGFloat addressLabelH = cellSize.height / 2.0;
                    CGFloat addressLabelY = CGRectGetMaxY(timeLabel.frame);
                    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(addressLabelX, addressLabelY, addressLabelW, addressLabelH)];
                    addressLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
                    @try {
                        addressLabel.text = addArr[2];
                    } @catch (NSException *exception) {
                        
                    } @finally {
                        
                    }
                    [cell addSubview:addressLabel];
                    
                    break;
                }
                case 2:
                {
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, cellSize.height)];
                    titleLabel.backgroundColor = [UIColor clearColor];
                    titleLabel.text = @"患者信息";
                    titleLabel.font = [UIFont systemFontOfSize:15.0];
                    titleLabel.textColor = [UIColor blackColor];
                    [cell addSubview:titleLabel];
                    
                    NSString *sex = [[dict valueForKey:@"orderSendSex"] integerValue] == 1 ? @"男" : @"女";
                    
                    CGFloat subTitleLabelX = CGRectGetMaxX(titleLabel.frame) + 5;
                    CGFloat subTitleLabelY = 0;
                    CGFloat subTitleLabelH = cellSize.height;
                    CGFloat subTitleLabelW = SCREENWIDTH - subTitleLabelX - 40;
                    UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(subTitleLabelX, subTitleLabelY, subTitleLabelW, subTitleLabelH)];
                    subTitleLabel.backgroundColor = [UIColor clearColor];
                    subTitleLabel.text = [NSString stringWithFormat:@"%@ %@ %@岁",[dict valueForKey:@"orderSendUsername"],sex,[dict valueForKey:@"orderSendAge"]];
                    subTitleLabel.textAlignment = NSTextAlignmentRight;
                    subTitleLabel.font = [UIFont systemFontOfSize:15.0];
                    subTitleLabel.textColor = [UIColor blackColor];
                    [cell addSubview:subTitleLabel];
                    
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
                    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, cellSize.height)];
                    titleLabel.backgroundColor = [UIColor clearColor];
                    titleLabel.text = @"备注信息";
                    titleLabel.font = [UIFont systemFontOfSize:15.0];
                    titleLabel.textColor = [UIColor blackColor];
                    [cell addSubview:titleLabel];
                    
                    CGFloat subTitleLabelX = CGRectGetMaxX(titleLabel.frame) + 5;
                    CGFloat subTitleLabelY = 0;
                    CGFloat subTitleLabelH = cellSize.height;
                    CGFloat subTitleLabelW = SCREENWIDTH - subTitleLabelX - 10;
                    UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(subTitleLabelX, subTitleLabelY, subTitleLabelW, subTitleLabelH)];
                    subTitleLabel.backgroundColor = [UIColor clearColor];
                    subTitleLabel.text = [dict valueForKey:@"orderSendNote"];
                    subTitleLabel.textAlignment = NSTextAlignmentRight;
                    subTitleLabel.font = [UIFont systemFontOfSize:15.0];
                    subTitleLabel.textColor = [UIColor blackColor];
                    [cell addSubview:subTitleLabel];
                    
                    break;
                }
                case 1:
                {
                    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 44)];
                    titleLabel.backgroundColor = [UIColor clearColor];
                    titleLabel.text = @"图片资料";
                    titleLabel.font = [UIFont systemFontOfSize:15.0];
                    titleLabel.textColor = [UIColor blackColor];
                    [cell addSubview:titleLabel];
                    
                    CGRect photoFrame = photoScrollView.frame;
                    photoFrame.origin.y = CGRectGetMaxY(titleLabel.frame);
                    photoScrollView.frame = photoFrame;
                    [cell addSubview:photoScrollView];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 2:
        {
            switch (row) {
                case 0:
                {
                    CGFloat orderNoLabelX = 10;
                    CGFloat orderNoLabelW = SCREENWIDTH - 2 * orderNoLabelX;
                    CGFloat orderNoLabelH = cellSize.height / 2.0;
                    CGFloat orderNoLabelY = 0;
                    UILabel *orderNoLabel = [[UILabel alloc] initWithFrame:CGRectMake(orderNoLabelX, orderNoLabelY, orderNoLabelW, orderNoLabelH)];
                    orderNoLabel.font = [UIFont fontWithName:@"Helvetica" size:13.0];
                    orderNoLabel.text = [NSString stringWithFormat:@"订单编号: %@",[dict valueForKey:@"orderSendId"]];
                    
                    [cell addSubview:orderNoLabel];
                    
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
                    NSString *stopTimeStr = [Tool convertTimespToString:[zoneCreatetime longLongValue] dateFormate:@"MM/dd HH:MM"];
                    
                    CGFloat timeLabelX = 10;
                    CGFloat timeLabelW = SCREENWIDTH - 2 * timeLabelX;
                    CGFloat timeLabelH = cellSize.height / 2.0;
                    CGFloat timeLabelY = CGRectGetMaxY(orderNoLabel.frame);
                    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(timeLabelX, timeLabelY, timeLabelW, timeLabelH)];
                    timeLabel.font = [UIFont fontWithName:@"Helvetica" size:13.0];
                    timeLabel.text = [NSString stringWithFormat:@"接单时间: %@",stopTimeStr];
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
                    [cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                    [cancelButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                    cancelButton.tag = 0;
                    [cell addSubview:cancelButton];
                    
                    NSArray  *orderStateStr = @[@"联系客户",@"出发",@"开始服务",@"填写报告"];
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
                    [nextButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    nextButton.backgroundColor = [UIColor clearColor];
                    [nextButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                    nextButton.tag = 1;
                    [cell addSubview:nextButton];
                    
                    CGFloat sepLineX = buttonX;
                    CGFloat sepLineY = 3;
                    CGFloat sepLineH = 44 - 2 * sepLineY;
                    CGFloat sepLineW = 1;
                    
                    UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(sepLineX, sepLineY, sepLineW, sepLineH)];
                    sepLine.backgroundColor = [UIColor colorWithWhite:237.0 / 255.0 alpha:1.0];
                    [cell addSubview:sepLine];
                    
                    NSArray *tipArr = @[@"1.仔细查看订单内容；\n2.仔细查看服务内容、备注内容；\n注：要求接单后尽快与病人确认。",@"1、电话联系用户，核对\n 1)服务时间、地点\n 2)病人信息、服务内容，备注：如需要请病人补充；\n 3）过敏史，传染病史；\n 4）病人自备材料及要求采购材料。",@"1、电话联系用户，确定是否在家。告知预计到达时间，及病人自备材料；\n2、核对所带设备、材料",@"1、自我介绍；\n2、说明服务内容及流程；\n3、开始服务"];
                    UITextView *tipTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, buttonY+buttonH, SCREENWIDTH-20, 90)];
                    tipTextView.font = [UIFont systemFontOfSize:10.0];
                    tipTextView.text = tipArr[orderIndex];
                    tipTextView.textColor = [UIColor grayColor];
                    tipTextView.backgroundColor = [UIColor clearColor];
                    [cell addSubview:tipTextView];
                    
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
                    return 60;
                    break;
                case 2:
                    return 44;
                    break;
                    
                default:
                    break;
            }
            break;
        }
        case 1:{
            switch (row) {
                case 0:
                    return 44;
                    break;
                case 1:
                    return 44 + imageScrollViewHeigh;
                    break;
                default:
                    break;
            }
        }
        case 2:{
            switch (row) {
                case 0:
                    return 50;
                    break;
                case 1:
                    return 44+94;
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
    if (section == 0 && row == 1) {
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
    if (section == 0 && row == 2) {
        //患者信息
        [self showPaitentInfoWith:infoDic];
    }
}


//取消订单
- (void)sendCancleOrderWithOrderId:(NSString *)orderId{
    NSString *userAccount = [[NSUserDefaults standardUserDefaults] objectForKey:USERIDKEY];
    //订单ID
    NSDictionary * params  = @{@"orderSendId" : orderId,
                               @"userId" : userAccount,
                               @"identity" : [NSNumber numberWithInteger:1]};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:CANCLEORDER params:params success:^(AFHTTPRequestOperation* operation,id response){
        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSLog(@"respondString:%@",respondString);
        NSMutableDictionary *respondDict = [NSMutableDictionary dictionaryWithDictionary:[respondString objectFromJSONString]];
        [self.view makeToast:[NSString stringWithFormat:@"%@",[respondDict valueForKey:@"data"]] duration:1.2 position:@"center"];
        if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"200"]) {
            NSLog(@"success");
//            [self getOrderDetailData];
        }else if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"400"]){
            NSLog(@"faile");
        }
        
        
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
        
        [self.view makeToast:[NSString stringWithFormat:@"%@",[respondDict valueForKey:@"data"]] duration:1.2 position:@"center"];
        if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"200"]) {
            NSLog(@"success");
            
            [self getOrderDetailData];
            
        }else if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"400"]){
            NSLog(@"faile");
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
    [self.navigationController pushViewController:paitentInfoVC animated:YES];
}

- (void)goLocationWithLocation:(NSDictionary *)locationDict
{
    HeUserLocatiVC *userLocationVC = [[HeUserLocatiVC alloc] init];
    userLocationVC.userLocationDict = [[NSDictionary alloc] initWithDictionary:locationDict];
    userLocationVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:userLocationVC animated:YES];
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
