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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initializaiton];
    [self initData];
    [self initView];
}

- (void)initializaiton
{
    [super initializaiton];

}

- (void)initData{
    dataArray = [[NSMutableArray alloc] init];
}
- (void)initView
{
    [super initView];
    [self.view addSubview:self.navigationTabBar];
}

#pragma mark - PrivateMethod
- (void)navigationDidSelectedControllerIndex:(NSInteger)index {
    NSLog(@"index = %ld",index);
    [self.tableView reloadData];
    
}



 #pragma mark - TableView Delegate
 
 -(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
 {
     return 5;
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
     NSDictionary *dict = nil;
     
     RankTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
     if (!cell) {
         cell = [[RankTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier cellSize:cellSize];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
     }
     cell.rankNum.text = @"111";
     cell.rankImageView.image = [UIImage imageNamed:@""];
     cell.headImageView.image = [UIImage imageNamed:@""];
     cell.pickName.text = @"昵称";
     cell.coinNum.text = @"1233";
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
