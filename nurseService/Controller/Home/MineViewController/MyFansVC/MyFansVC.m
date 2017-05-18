//
//  MyFansVC.m
//  nurseService
//
//  Created by 梅阳阳 on 17/1/15.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "MyFansVC.h"
#import "HeBaseTableViewCell.h"
#import "MJRefreshAutoNormalFooter.h"

@interface MyFansVC ()
{
    UIImageView *noDataView;
    NSMutableArray *dataArr;
    NSInteger currentPage;
}
@property (strong, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation MyFansVC
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
        label.text = @"我的粉丝";
        [label sizeToFit];
        self.title = @"我的粉丝";
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initializaiton];
    [self initView];
    [self getFansData];
}

- (void)initializaiton
{
    [super initializaiton];
    dataArr = [[NSMutableArray alloc] initWithCapacity:0];
    currentPage = 0;

}

- (void)initView
{
    [super initView];
    self.view.backgroundColor = [UIColor colorWithWhite:237.0 /255.0 alpha:1.0];

    UIImage *image = [UIImage imageNamed:@"img_no_data"];
    CGFloat noDataViewW = 100;
    CGFloat noDataViewH = image.size.height / image.size.width * noDataViewW;
    CGFloat noDataViewY = (self.view.frame.size.height-44-48-noDataViewW)/2.0 - 30;
    CGFloat noDataViewX = (SCREENWIDTH-noDataViewW)/2.0;
    noDataView = [[UIImageView alloc] init];
    noDataView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:noDataView];
    noDataView.frame = CGRectMake(noDataViewX, noDataViewY, noDataViewW, noDataViewH);
    noDataView.image = image;
    noDataView.hidden = YES;
    
    [tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    self.tableview.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.tableview.footer.automaticallyHidden = YES;
        self.tableview.footer.hidden = NO;
        // 进入刷新状态后会自动调用这个block，加载更多
        [self performSelector:@selector(endRefreshing) withObject:nil afterDelay:1.0];
    }];
}

- (void)endRefreshing
{
    [self.tableview.footer endRefreshing];
    self.tableview.footer.hidden = YES;
    self.tableview.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.tableview.footer.automaticallyHidden = YES;
        self.tableview.footer.hidden = NO;
        // 进入刷新状态后会自动调用这个block，加载更多
        [self performSelector:@selector(endRefreshing) withObject:nil afterDelay:1.0];
    }];
    
    
    //处理上拉后的逻辑
    NSLog(@"endRefreshing");
    [self getFansData];

}
//获取我的粉丝数据
- (void)getFansData{

    NSString *userAccount = [[NSUserDefaults standardUserDefaults] objectForKey:USERIDKEY];
    NSDictionary * params  = @{@"befollowId": userAccount,@"pageNum" : [NSString stringWithFormat:@"%ld",currentPage]};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:SELECTFOLLOWBYID params:params success:^(AFHTTPRequestOperation* operation,id response){
        
        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSMutableDictionary *respondDict = [NSMutableDictionary dictionaryWithDictionary:[respondString objectFromJSONString]];
        if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"200"]||[[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"300"]) {
            NSLog(@"success");
            if ([[respondDict valueForKey:@"json"] isMemberOfClass:[NSNull class]] || [respondDict valueForKey:@"json"] == nil) {
                [self.view makeToast:[NSString stringWithFormat:@"%@",[respondDict valueForKey:@"data"]] duration:1.2 position:@"center"];
                
                noDataView.hidden = NO;
                tableview.hidden = YES;
                return ;
            }else{
                NSArray *tempArr = [NSArray arrayWithArray:[respondDict valueForKey:@"json"]];
                if (tempArr.count > 0) {
                    currentPage++;
                    
                    [dataArr addObjectsFromArray:tempArr];
                    [tableview reloadData];
                    noDataView.hidden = YES;
                    tableview.hidden = NO;
                }else{
                    if (currentPage == 0) {
                        tableview.hidden = YES;
                        noDataView.hidden = NO;
                    }
                    return ;
                }
            }
        }else if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"400"]){
            NSLog(@"faile");
            [self.view makeToast:[NSString stringWithFormat:@"%@",[respondDict valueForKey:@"data"]] duration:1.2 position:@"center"];
        }
    } failure:^(NSError* err){
        NSLog(@"err:%@",err);
        [self.view makeToast:ERRORREQUESTTIP duration:2.0 position:@"center"];
    }];
}

#pragma mark - TableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArr.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    static NSString *cellIndentifier = @"OrderFinishedTableViewCell";
    CGSize cellSize = [tableView rectForRowAtIndexPath:indexPath].size;
    NSDictionary *dict;
    @try {
        dict = [NSDictionary dictionaryWithDictionary:dataArr[row]];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    HeBaseTableViewCell *cell  = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[HeBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier cellSize:cellSize];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    CGFloat itemX = 10;
    CGFloat itemY = 15;
    CGFloat itemW = 40;
    UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(itemX, itemY, itemW, itemW)];
    headImageView.backgroundColor = [UIColor clearColor];
    headImageView.layer.masksToBounds = YES;
    headImageView.image = [UIImage imageNamed:@"defalut_icon"];
    headImageView.contentMode = UIViewContentModeScaleAspectFill;
    headImageView.layer.borderWidth = 0.0;
    headImageView.layer.cornerRadius = 40 / 2.0;
    headImageView.layer.masksToBounds = YES;
    [cell addSubview:headImageView];
    NSString *userHeader = [NSString stringWithFormat:@"%@%@",PIC_URL,[dict valueForKey:@"userHeader"]];
    [headImageView sd_setImageWithURL:[NSURL URLWithString:userHeader] placeholderImage:[UIImage imageNamed:@"defalut_icon"]];

    itemX = CGRectGetMaxX(headImageView.frame)+10;
    itemY = 10;
    itemW = 180;
    UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(itemX, itemY, itemW, 30)];
    nameL.textColor = [UIColor blackColor];
    nameL.font = [UIFont systemFontOfSize:15.0];
    nameL.backgroundColor = [UIColor clearColor];
    nameL.adjustsFontSizeToFitWidth = YES;
    nameL.text = [dict valueForKey:@"userNick"];
    [cell addSubview:nameL];
    
    itemX = CGRectGetMaxX(nameL.frame);
    itemW = 100;
    UILabel *workL = [[UILabel alloc] initWithFrame:CGRectMake(itemX, itemY, itemW, 30)];
    workL.textColor = [UIColor blackColor];
    workL.font = [UIFont systemFontOfSize:15.0];
    workL.backgroundColor = [UIColor clearColor];
    workL.adjustsFontSizeToFitWidth = YES;
    workL.text = [dict valueForKey:@"workUnit"];
    [cell addSubview:workL];
    
    itemX = CGRectGetMaxX(headImageView.frame)+10;
    itemY = CGRectGetMaxY(nameL.frame)-5;
    itemW = 200;
    UILabel *stateL = [[UILabel alloc] initWithFrame:CGRectMake(itemX, itemY, itemW, 25)];
    stateL.textColor = [UIColor blackColor];
    stateL.font = [UIFont systemFontOfSize:12.0];
    stateL.backgroundColor = [UIColor clearColor];
//    stateL.text =@"国家卫委认证  已实名认证";
    [cell addSubview:stateL];
    
    NSString *noteStr = [NSString stringWithFormat:@"%@",[dict valueForKey:@"userName"]];
    if (noteStr.length == 11 && noteStr.length > 0) {
        noteStr = [NSString stringWithFormat:@"%@****%@",[noteStr substringToIndex:3],[noteStr substringFromIndex:7]];
    }else{
        noteStr = @"无";
    }
    itemY = CGRectGetMaxY(stateL.frame)-25;
    UILabel *noteL = [[UILabel alloc] initWithFrame:CGRectMake(itemX, itemY, itemW, 25)];
    noteL.textColor = [UIColor blackColor];
    noteL.font = [UIFont systemFontOfSize:12.0];
    noteL.backgroundColor = [UIColor clearColor];
    noteL.text = noteStr;
    noteL.lineBreakMode = NSLineBreakByTruncatingMiddle;
    [cell addSubview:noteL];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    
    return 70;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    
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
