//
//  RankViewController.m
//  nurseService
//
//  Created by Tony on 2016/12/14.
//  Copyright © 2016年 iMac. All rights reserved.
//

#import "RankViewController.h"
#import "DLNavigationTabBar.h"
#import "HeStudyTableCell.h"
#import "RankTableViewCell.h"
@interface RankViewController ()
{
    NSMutableArray *dataArray;
    NSMutableArray *dataArr;
    NSInteger currentPage;
}
@property(nonatomic,strong)DLNavigationTabBar *navigationTabBar;
@end

@implementation RankViewController
@synthesize tabBarBg;
@synthesize tableView;
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
        label.text = @"排行榜";
        [label sizeToFit];
        self.title = @"排行榜";
    }
    return self;
}

-(DLNavigationTabBar *)navigationTabBar
{
    if (!_navigationTabBar) {
        self.navigationTabBar = [[DLNavigationTabBar alloc] initWithTitles:@[@"总榜",@"近一个月",@"当日"]];
        self.navigationTabBar.backgroundColor = [UIColor colorWithWhite:237.0 / 255.0 alpha:1.0];
        self.navigationTabBar.frame = CGRectMake(0, 0, SCREENWIDTH, 44);
        self.navigationTabBar.sliderBackgroundColor = APPDEFAULTORANGE;
        self.navigationTabBar.buttonNormalTitleColor = [UIColor grayColor];
        self.navigationTabBar.buttonSelectedTileColor = APPDEFAULTORANGE;
        __weak typeof(self) weakSelf = self;
        [self.navigationTabBar setDidClickAtIndex:^(NSInteger index){
            [weakSelf navigationDidSelectedControllerIndex:index];
        }];
    }
    return _navigationTabBar;
}

- (void)viewWillAppear:(BOOL)animated{
    currentPage = 1;
    if (dataArr) {
        [dataArr removeAllObjects];
    }else{
        dataArray = [[NSMutableArray alloc] init];
    }
    [self getNurseRankDataWithUrl:NURSEMARKRANKING];
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
    
    
    [self.view addSubview:self.navigationTabBar];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}


- (void)getNurseRankDataWithUrl:(NSString *)url{

    NSDictionary * params  = @{@"pageNum": [NSNumber numberWithInteger:currentPage]};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:url params:params success:^(AFHTTPRequestOperation* operation,id response){
        
        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSMutableDictionary *respondDict = [NSMutableDictionary dictionaryWithDictionary:[respondString objectFromJSONString]];
        if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"200"]) {
            NSLog(@"success");
            NSArray *tempArr = [NSArray arrayWithArray:[respondDict valueForKey:@"json"]];
            if (tempArr.count > 0) {
                currentPage++;
            }else{
                return ;
            }
            [dataArr addObjectsFromArray:tempArr];
            
            [tableView reloadData];
        }else if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"400"]){
            NSLog(@"faile");
            [self.view makeToast:[NSString stringWithFormat:@"%@",[respondDict valueForKey:@"data"]] duration:1.2 position:@"center"];
        }

    } failure:^(NSError* err){
        NSLog(@"err:%@",err);
        [self.view makeToast:ERRORREQUESTTIP duration:2.0 position:@"center"];
    }];
}

#pragma mark - PrivateMethod
- (void)navigationDidSelectedControllerIndex:(NSInteger)index {
    NSLog(@"index = %ld",index);
    currentPage = 1;
    if (dataArr.count > 0 ) {
        [dataArr removeAllObjects];
    }
    switch (index) {
        case 0:
        {
            [self getNurseRankDataWithUrl:NURSEMARKRANKING];
        }
            break;
        case 1:
        {
            [self getNurseRankDataWithUrl:NURSEMONTHRANKING];
        }
            break;
        case 2:
        {
            [self getNurseRankDataWithUrl:NURSESEVENDAYRANKING];
        }
            break;
            
        default:
            break;
    }
    [self.tableView reloadData];
    
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
     
     static NSString *cellIndentifier = @"RankTableViewCell";
     CGSize cellSize = [tableView rectForRowAtIndexPath:indexPath].size;
     NSDictionary *dict = [NSDictionary dictionaryWithDictionary:dataArr[row]];
     RankTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
     if (!cell) {
         cell = [[RankTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier cellSize:cellSize];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
     }

     if (row < 3) {
         cell.rankImageView.hidden = NO;
         cell.rankImageView.image = [UIImage imageNamed:@""];
         cell.rankNum.hidden = YES;
     }else{
         cell.rankNum.hidden = NO;
         cell.rankNum.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"ranks"]];
         cell.rankImageView.hidden = YES;
     }
     cell.headImageView.imageURL = [NSString stringWithFormat:@"%@%@",PIC_URL,[dict valueForKey:@"nurseHeader"]];
     cell.pickName.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"nurseNick"]];
     cell.coinNum.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"nurseMark"]];
     cell.followBlock=^(){
         NSLog(@"关注：%ld",row);
     };
     return cell;
 }
 
 
 - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
 {
     NSInteger section = indexPath.section;
     NSInteger row = indexPath.row;
     
     
     return 44;
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
