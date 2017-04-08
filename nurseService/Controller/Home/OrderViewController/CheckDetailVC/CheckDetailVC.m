//
//  CheckDetailVC.m
//  nurseService
//
//  Created by 梅阳阳 on 17/1/16.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "CheckDetailVC.h"
#import "HeBaseTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "PNChart.h"

@interface CheckDetailVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSDictionary *dataSourceDic;
    NSMutableArray *ordersArr;
}
@property (strong, nonatomic) UITableView *tableview;
@property (strong, nonatomic) UILabel *labelTitleNum;
@property (strong, nonatomic) UILabel *orderTitleNum;
@property (strong, nonatomic) PNLineChart *lineChart;
@property (nonatomic, assign) int orderNum;
@property (nonatomic, copy) NSString *checkNum;

@end

@implementation CheckDetailVC
@synthesize tableview;
@synthesize labelTitleNum;
@synthesize orderTitleNum;

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
        label.text = @"账单";
        [label sizeToFit];
        self.title = @"账单";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initializaiton];
    [self initView];
    [self getDataSource];
}

- (void)initializaiton
{
    [super initializaiton];
    ordersArr = [[NSMutableArray alloc] initWithCapacity:0];
    dataSourceDic = [[NSDictionary alloc] init];
    
}

- (void)initView
{
    [super initView];
    tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGH) style:UITableViewStyleGrouped];
    tableview.backgroundView = nil;
    tableview.backgroundColor = [UIColor colorWithWhite:237.0 /255.0 alpha:1.0];
    [Tool setExtraCellLineHidden:tableview];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *weekTitle = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 44)];
    weekTitle.backgroundColor = [UIColor clearColor];
    UILabel *weekLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 150, 44)];
    weekLabel.text = [self getWeekTime];
    weekLabel.textColor = [UIColor grayColor];
    weekLabel.font = [UIFont systemFontOfSize:14];
    [weekTitle addSubview:weekLabel];
    UIImageView *calendarView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-35, 11, 20, 20)];
    calendarView.image = [UIImage imageNamed:@"icon_calendar.png"];
    [weekTitle addSubview:calendarView];
    tableview.tableHeaderView = weekTitle;
    [self.view addSubview:tableview];
    
}

- (PNLineChart *)lineChart
{
    if (!_lineChart) {
        _lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150.0)];
        _lineChart.yLabelFormat = @"%1.1f";
        _lineChart.backgroundColor = [UIColor clearColor];
        [_lineChart setXLabels:@[@"07/31-08/06",@"07/31-08/06",@"07/31-08/06",@"本周"]];
        _lineChart.showCoordinateAxis = NO;
        _lineChart.chartCavanWidth = SCREENWIDTH;

            // added an examle to show how yGridLines can be enabled
            // the color is set to clearColor so that the demo remains the same
        _lineChart.yGridLinesColor = [UIColor clearColor];
        _lineChart.showYGridLines = NO;
        _lineChart.showGenYLabels = NO;
        _lineChart.chartMarginRight = 0;
        _lineChart.chartMarginLeft = 0;
        _lineChart.xLabelWidth = SCREENWIDTH/4;

            //Use yFixedValueMax and yFixedValueMin to Fix the Max and Min Y Value
            //Only if you needed
        _lineChart.yFixedValueMax = 300.0;
        _lineChart.yFixedValueMin = 0.0;
        [_lineChart strokeChart];

    }
    return _lineChart;
}

- (NSString *)getWeekTime
{
    NSDate *nowDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSDayCalendarUnit fromDate:nowDate];
        // 获取今天是周几
    NSInteger weekDay = [comp weekday];
        // 获取几天是几号
    NSInteger day = [comp day];

        // 计算当前日期和本周的星期一和星期天相差天数
    long firstDiff,lastDiff;
        //    weekDay = 1;
    if (weekDay == 1)
    {
        firstDiff = -6;
        lastDiff = 0;
    }
    else
    {
        firstDiff = [calendar firstWeekday] - weekDay + 1;
        lastDiff = 8 - weekDay;
    }
    NSLog(@"firstDiff: %ld   lastDiff: %ld",firstDiff,lastDiff);

        // 在当前日期(去掉时分秒)基础上加上差的天数
    NSDateComponents *firstDayComp = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit  fromDate:nowDate];
    [firstDayComp setDay:day + firstDiff];
    NSDate *firstDayOfWeek = [calendar dateFromComponents:firstDayComp];

    NSDateComponents *lastDayComp = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit   fromDate:nowDate];
    [lastDayComp setDay:day + lastDiff];
    NSDate *lastDayOfWeek = [calendar dateFromComponents:lastDayComp];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd"];
    NSString *firstDay = [formatter stringFromDate:firstDayOfWeek];
    NSString *lastDay = [formatter stringFromDate:lastDayOfWeek];
    NSLog(@"%@=======%@",firstDay,lastDay);

    NSString *dateStr = [NSString stringWithFormat:@"%@-%@",firstDay,lastDay];

    return dateStr;
    
}

- (void)getDataSource{
    NSString *userAccount = [[NSUserDefaults standardUserDefaults] objectForKey:USERIDKEY];
    
    NSDictionary * params  = @{@"nurseId" : userAccount};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:SELECTNURSEBILL params:params success:^(AFHTTPRequestOperation* operation,id response){
        
        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSMutableDictionary *respondDict = [NSMutableDictionary dictionaryWithDictionary:[respondString objectFromJSONString]];
        if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"200"]) {
            if ([[respondDict valueForKey:@"json"] isMemberOfClass:[NSNull class]] || [respondDict valueForKey:@"json"] == nil) {
                
                
            }else{
                NSDictionary *tempDic = [[NSDictionary alloc] initWithDictionary:[respondDict valueForKey:@"json"]];
                dataSourceDic = tempDic;

                if ([[dataSourceDic valueForKey:@"nurseOrders"] count] > 0) {
                    NSArray *tempArr = [NSArray arrayWithArray:[dataSourceDic valueForKey:@"nurseOrders"]];
                    [ordersArr addObjectsFromArray:tempArr];
                }
                self.orderNum = (int)ordersArr.count;
                self.checkNum = [tempDic objectForKey:@"totalPrice"];
                NSMutableArray *xData = @[].mutableCopy;
                for (int i = 1; i<5; i++) {
                    [xData addObject:[NSString stringWithFormat:@"%@",[dataSourceDic valueForKey:[NSString stringWithFormat:@"weekRange%d",i]]]];
                }
                [self.lineChart setXLabels:xData];
                NSMutableArray *yData = @[].mutableCopy;
                for (int i = 1; i<5; i++) {
                    [yData addObject:[NSString stringWithFormat:@"%@",[dataSourceDic valueForKey:[NSString stringWithFormat:@"totalPriceWeek%d",i]]]];
                }
                NSString *max = @"0";
                for (NSString *num in yData) {
                    if ([num floatValue]>[max floatValue]) {
                        max = num;
                    }
                }
                _lineChart.yFixedValueMax = [max floatValue]+20;
                PNLineChartData *data01 = [PNLineChartData new];
                _lineChart.chartData = @[data01];
                data01.itemCount = yData.count;
                data01.inflexionPointColor = APPDEFAULTORANGE;
                data01.showPointLabel = YES;
                data01.inflexionPointWidth = 2.5;
                data01.pointLabelFont = [UIFont systemFontOfSize:14];
                data01.color = APPDEFAULTORANGE;
                data01.inflexionPointStyle = PNLineChartPointStyleCircle;
                data01.getData = ^(NSUInteger index) {
                    CGFloat yValue = [yData[index] floatValue];
                    return [PNLineChartDataItem dataItemWithY:yValue];
                };
                [_lineChart strokeChart];

            }
            
            [tableview reloadData];
            NSLog(@"success");
        }else if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"400"]){
            NSLog(@"faile");
        }
//        [self.view makeToast:[NSString stringWithFormat:@"%@",[respondDict valueForKey:@"data"]] duration:1.2 position:@"center"];
    } failure:^(NSError* err){
        NSLog(@"err:%@",err);
        [self.view makeToast:ERRORREQUESTTIP duration:2.0 position:@"center"];
    }];
}


#pragma mark - TableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return ordersArr.count;//ordersArr.count;
            break;
        default:
            break;
    }
    return 5;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    
    static NSString *cellIndentifier = @"OrderFinishedTableViewCell";
    CGSize cellSize = [tableView rectForRowAtIndexPath:indexPath].size;
    //    NSDictionary *dict = [NSDictionary dictionaryWithDictionary:infoDic];
    
    HeBaseTableViewCell *cell  = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[HeBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier cellSize:cellSize];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    switch (section) {
        case 0:
        {
            [cell addSubview:self.lineChart];
        }
            break;
        case 1:
        {
            NSDictionary *dicInfo = ordersArr[indexPath.row];

            CGFloat point_X = 10;
            CGFloat imageDia = 50;              //直径
            CGFloat imageY =  10;
            
            UIImageView *portrait = [[UIImageView alloc] initWithFrame:CGRectMake(point_X, imageY, imageDia, imageDia)];
            portrait.userInteractionEnabled = YES;
            portrait.image = [UIImage imageNamed:@"defalut_icon"];
            NSString *logoString = [dicInfo objectForKey:@"userHeader"];
            NSString *iconUrl = [NSString stringWithFormat:@"%@%@",BASEURL,[logoString substringFromIndex:10]];
            [portrait setImageWithURL:[NSURL URLWithString:iconUrl] placeholderImage:[UIImage imageNamed:@"defalut_icon"]];
            portrait.layer.borderWidth = 0.0;
            portrait.contentMode = UIViewContentModeScaleAspectFill;
            portrait.layer.cornerRadius = imageDia / 2.0;
            portrait.layer.masksToBounds = YES;
            [cell addSubview:portrait];
            
            NSString *userHeader = [NSString stringWithFormat:@"%@/%@",HYTIMAGEURL,@""];
            [portrait sd_setImageWithURL:[NSURL URLWithString:userHeader] placeholderImage:[UIImage imageNamed:@"defalut_icon"]];

            point_X = CGRectGetMaxX(portrait.frame);
            CGFloat label_w = SCREENWIDTH - point_X - 70;
            CGFloat label_y = 10;
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(point_X, label_y, label_w, 25)];
            nameLabel.backgroundColor = [UIColor clearColor];
            nameLabel.text = [dicInfo objectForKey:@"userNick"];
            nameLabel.font = [UIFont systemFontOfSize:13.0];
            nameLabel.textColor = [UIColor grayColor];
            [cell addSubview:nameLabel];
            
            label_y = CGRectGetMaxY(nameLabel.frame);
            UILabel *contectLabel = [[UILabel alloc] initWithFrame:CGRectMake(point_X, label_y, label_w, 25)];
            contectLabel.backgroundColor = [UIColor clearColor];
            contectLabel.text = [dicInfo objectForKey:@"orderSendServicecontent"];
            contectLabel.font = [UIFont systemFontOfSize:13.0];
            contectLabel.textColor = [UIColor grayColor];
            [cell addSubview:contectLabel];
            
            point_X = CGRectGetMaxX(nameLabel.frame);
            label_y = 10;
            UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(point_X, label_y, 65, 25)];
            priceLabel.backgroundColor = [UIColor clearColor];
            priceLabel.font = [UIFont systemFontOfSize:13.0];
            NSString *priceString = [NSString stringWithFormat:@"￥%.2f",[[dicInfo objectForKey:@"price"] floatValue]];
            priceLabel.text = priceString;
            priceLabel.textColor = [UIColor redColor];
            [cell addSubview:priceLabel];

            label_y = CGRectGetMaxY(nameLabel.frame);
            UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(point_X, label_y, 65, 25)];
            dateLabel.backgroundColor = [UIColor clearColor];
            dateLabel.numberOfLines = 0;
            id zoneCreatetimeObj = [dicInfo objectForKey:@"orderSendBegintime"];
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
            NSString *stopTimeStr = [Tool convertTimespToString:[zoneCreatetime longLongValue] dateFormate:@"MM/dd"];
//            NSDate *date = [Tool convertTimespToDate:[zoneCreatetime longLongValue]];
//            NSString *dateSt = [NSString stringWithFormat:@"%@\n%@",[self weekdayStringFromDate:date],[stopTimeStr substringToIndex:5]];
            dateLabel.text = stopTimeStr;
            dateLabel.font = [UIFont systemFontOfSize:13.0];
            dateLabel.textColor = [UIColor grayColor];
            [cell addSubview:dateLabel];
        }
            break;
            
        default:
            break;
    }
    
    return cell;
    return nil;
}

- (NSString*)weekdayStringFromDate:(NSDate*)inputDate {

    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"Sunday", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];

    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];

    [calendar setTimeZone: timeZone];

    NSCalendarUnit calendarUnit = NSWeekdayCalendarUnit;

    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];

    return [weekdays objectAtIndex:theComponents.weekday];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    switch (section) {
        case 0:
            return 150;
            break;
        case 1:
            return 70;
            break;
        default:
            break;
    }
    
    return 160;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *v = nil;
    switch (section) {
        case 0:
        {
            v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
            v.userInteractionEnabled = YES;
            [v setBackgroundColor:[UIColor colorWithWhite:244.0 / 255.0 alpha:1.0]];
            
            UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0.0f, 200.0f, 44.0f)];
            [labelTitle setBackgroundColor:[UIColor clearColor]];
            labelTitle.text = @"本周收入情况";
            labelTitle.userInteractionEnabled = YES;
            labelTitle.font = [UIFont systemFontOfSize:15.0];
            UIImageView *calendarView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-35, 11, 25, 20)];
            calendarView.image = [UIImage imageNamed:@"icon_look.png"];
            [v addSubview:calendarView];
            [v addSubview:labelTitle];
            
            break;
        }
        case 1:
        {
            v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
            v.userInteractionEnabled = YES;
            [v setBackgroundColor:[UIColor colorWithWhite:244.0 / 255.0 alpha:1.0]];
            
            UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0.0f, 100.0f, 44.0f)];
            [labelTitle setBackgroundColor:[UIColor clearColor]];
            labelTitle.text = @"总收入";
            labelTitle.userInteractionEnabled = YES;
            labelTitle.font = [UIFont systemFontOfSize:15.0];
            labelTitle.textColor = [UIColor blackColor];
            [v addSubview:labelTitle];

            labelTitleNum = [[UILabel alloc] initWithFrame:CGRectMake(70.0f, 0.0f, 100.0f, 44.0f)];
            [labelTitleNum setBackgroundColor:[UIColor clearColor]];
            labelTitleNum.text = [NSString stringWithFormat:@"%.2f",[self.checkNum floatValue]];
            labelTitleNum.userInteractionEnabled = YES;
            labelTitleNum.font = [UIFont systemFontOfSize:14.0];
            labelTitleNum.textColor = APPDEFAULTORANGE;
            [v addSubview:labelTitleNum];

            UILabel *orderTitle = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH-120, 0.0f, 100.0f, 44.0f)];
            [orderTitle setBackgroundColor:[UIColor clearColor]];
            orderTitle.text = @"总单数";
            orderTitle.userInteractionEnabled = YES;
            orderTitle.font = [UIFont systemFontOfSize:15.0];
            orderTitle.textColor = [UIColor blackColor];
            [v addSubview:orderTitle];

            orderTitleNum = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH-50, 0.0f, 100.0f, 44.0f)];
            [orderTitleNum setBackgroundColor:[UIColor clearColor]];
            orderTitleNum.text = [NSString stringWithFormat:@"%d",self.orderNum];
            orderTitleNum.userInteractionEnabled = YES;
            orderTitleNum.font = [UIFont systemFontOfSize:14.0];
            orderTitleNum.textColor = APPDEFAULTORANGE;
            [v addSubview:orderTitleNum];
            
            break;
        }
            
        default:
            break;
    }

    return v;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    NSLog(@"row = %ld, section = %ld",row,section);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
