//
//  CheckDetailVC.m
//  nurseService
//
//  Created by 梅阳阳 on 17/1/16.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "CheckDetailVC.h"
#import "HeBaseTableViewCell.h"

@interface CheckDetailVC ()
{
    NSDictionary *dataSourceDic;
    NSMutableArray *ordersArr;
}
@property (strong, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation CheckDetailVC
@synthesize tableview;

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
    
    tableview.backgroundView = nil;
    tableview.backgroundColor = [UIColor colorWithWhite:237.0 /255.0 alpha:1.0];
    [Tool setExtraCellLineHidden:tableview];
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
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
            return 3;//ordersArr.count;
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
            CGFloat point_X = 10;
            UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(point_X, 0, cellSize.height, cellSize.height)];
            dateLabel.backgroundColor = [UIColor clearColor];
            dateLabel.numberOfLines = 0;
            dateLabel.text = @"周一\n09/12";
            dateLabel.font = [UIFont systemFontOfSize:15.0];
            dateLabel.textColor = [UIColor blackColor];
            [cell addSubview:dateLabel];


            point_X = CGRectGetMaxX(dateLabel.frame)+5;
            
            CGFloat imageDia = 50;              //直径
            CGFloat imageY = (cellSize.height - imageDia) / 2.0 - 20;
            
            UIImageView *portrait = [[UIImageView alloc] initWithFrame:CGRectMake(point_X, imageY, imageDia, imageDia)];
            portrait.userInteractionEnabled = YES;
            portrait.image = [UIImage imageNamed:@"defalut_icon"];
            portrait.layer.borderWidth = 0.0;
            portrait.contentMode = UIViewContentModeScaleAspectFill;
            portrait.layer.cornerRadius = imageDia / 2.0;
            portrait.layer.masksToBounds = YES;
            [cell addSubview:portrait];
            
            NSString *userHeader = [NSString stringWithFormat:@"%@/%@",HYTIMAGEURL,@""];
            [portrait sd_setImageWithURL:[NSURL URLWithString:userHeader] placeholderImage:[UIImage imageNamed:@"defalut_icon"]];
            
            point_X = CGRectGetMaxX(portrait.frame);
            
            UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(point_X, 10, 150, 30)];
            phoneLabel.backgroundColor = [UIColor clearColor];
            phoneLabel.text = @"18675629187";
            phoneLabel.font = [UIFont systemFontOfSize:15.0];
            phoneLabel.textColor = [UIColor blackColor];
            [cell addSubview:phoneLabel];
            
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(point_X, 10, 150, 30)];
            nameLabel.backgroundColor = [UIColor clearColor];
            nameLabel.text = @"张三";
            nameLabel.font = [UIFont systemFontOfSize:15.0];
            nameLabel.textColor = [UIColor blackColor];
            [cell addSubview:nameLabel];
            
        }
            break;
            
        default:
            break;
    }
    
    return cell;
    return nil;
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
            
            UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0.0f, 200.0f, 30.0f)];
            [labelTitle setBackgroundColor:[UIColor clearColor]];
            labelTitle.text = @"本周收入情况";
            labelTitle.userInteractionEnabled = YES;
            labelTitle.font = [UIFont systemFontOfSize:12.0];
            labelTitle.textColor = [UIColor blackColor];
            [v addSubview:labelTitle];
            
            break;
        }
        case 1:
        {
            v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
            v.userInteractionEnabled = YES;
            [v setBackgroundColor:[UIColor colorWithWhite:244.0 / 255.0 alpha:1.0]];
            
            UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0.0f, 200.0f, 30.0f)];
            [labelTitle setBackgroundColor:[UIColor clearColor]];
            labelTitle.text = @"总收入  0.00";
            labelTitle.userInteractionEnabled = YES;
            labelTitle.font = [UIFont systemFontOfSize:12.0];
            labelTitle.textColor = [UIColor blackColor];
            [v addSubview:labelTitle];
            
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
