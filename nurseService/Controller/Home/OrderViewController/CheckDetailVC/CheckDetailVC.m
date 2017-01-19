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

@interface CheckDetailVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSDictionary *dataSourceDic;
    NSMutableArray *ordersArr;
}
@property (strong, nonatomic) UITableView *tableview;
@property (strong, nonatomic) UILabel *labelTitleNum;
@property (strong, nonatomic) UILabel *orderTitleNum;

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
                self.labelTitleNum.text = [NSString stringWithFormat:@"%@",[dataSourceDic objectForKey:@"totalPrice"]];
                if ([[dataSourceDic valueForKey:@"nurseOrders"] count] > 0) {
                    NSArray *tempArr = [NSArray arrayWithArray:[dataSourceDic valueForKey:@"nurseOrders"]];
                    [ordersArr addObjectsFromArray:tempArr];
                }
                self.orderTitleNum.text = [NSString stringWithFormat:@"%d",(int)ordersArr.count];
            }
            
            [tableview reloadData];
            NSLog(@"success");
        }else if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"400"]){
            NSLog(@"faile");
        }
        [self.view makeToast:[NSString stringWithFormat:@"%@",[respondDict valueForKey:@"data"]] duration:1.2 position:@"center"];
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
        }
            break;
        case 1:
        {
            NSDictionary *dicInfo = ordersArr[indexPath.row];
            CGFloat point_X = 10;
            UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(point_X, 0, 100, cellSize.height)];
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
            NSString *stopTimeStr = [Tool convertTimespToString:[zoneCreatetime longLongValue] dateFormate:@"MM/dd HH:MM"];
            NSDate *date = [Tool convertTimespToDate:[zoneCreatetime longLongValue]];
            NSString *dateSt = [NSString stringWithFormat:@"%@\n%@",[self weekdayStringFromDate:date],[stopTimeStr substringToIndex:5]];
            dateLabel.text = dateSt;
            dateLabel.font = [UIFont systemFontOfSize:15.0];
            dateLabel.textColor = [UIColor blackColor];
            [cell addSubview:dateLabel];


            point_X = CGRectGetMaxX(dateLabel.frame)+5;
            
            CGFloat imageDia = 50;              //直径
            CGFloat imageY =  20;
            
            UIImageView *portrait = [[UIImageView alloc] initWithFrame:CGRectMake(60, imageY, imageDia, imageDia)];
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
            
            point_X = CGRectGetMaxX(portrait.frame)+15;
            
            UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(point_X, 15, 150, 30)];
            phoneLabel.backgroundColor = [UIColor clearColor];
            NSMutableString *aString = [[NSMutableString alloc] initWithFormat:@"%@",[dicInfo objectForKey:@"userPhone"]];
            [aString replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
            phoneLabel.text = [NSString stringWithFormat:@"%@",aString];
            phoneLabel.font = [UIFont systemFontOfSize:15.0];
            phoneLabel.textColor = [UIColor blackColor];
            [cell addSubview:phoneLabel];
            
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(point_X, 45, 150, 30)];
            nameLabel.backgroundColor = [UIColor clearColor];
            nameLabel.text = [dicInfo objectForKey:@"userNick"];
            nameLabel.font = [UIFont systemFontOfSize:15.0];
            nameLabel.textColor = [UIColor blackColor];
            [cell addSubview:nameLabel];

            UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(point_X+80, 45, 180, 30)];
            priceLabel.backgroundColor = [UIColor clearColor];
            priceLabel.font = [UIFont systemFontOfSize:14.0];

            NSString *priceString = [NSString stringWithFormat:@"+%@(其中包括平台奖励15元)",[dicInfo objectForKey:@"price"]];
            NSMutableAttributedString *textColor = [[NSMutableAttributedString alloc]initWithString:priceString];
            NSRange rangel = [priceString rangeOfString:@"("];
            [textColor addAttribute:NSForegroundColorAttributeName value:APPDEFAULTORANGE range:NSMakeRange(rangel.location, 13)];
            [textColor addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(rangel.location, 13)];
            priceLabel.attributedText = textColor;
            [cell addSubview:priceLabel];
            
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
            return 90;
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
            labelTitleNum.text = @"520";
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
            orderTitleNum.text = @"30";
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
