//
//  ServiceListVC.m
//  nurseService
//
//  Created by 梅阳阳 on 17/2/15.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "ServiceListVC.h"
#import "HeBaseTableViewCell.h"
#import "ServiceDetailVC.h"
@interface ServiceListVC ()
{
    UIImageView *noDataView;
    NSMutableArray *dataArr;
}
@property (strong, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation ServiceListVC
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
        label.text = @"服务介绍";
        [label sizeToFit];
        self.title = @"服务介绍";
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initializaiton];
    [self initView];
    [self getData];
}

- (void)initializaiton
{
    [super initializaiton];
    dataArr = [[NSMutableArray alloc] initWithCapacity:0];

    
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
}

- (void)getData{
    
    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:ALLSERVICEINFO params:nil success:^(AFHTTPRequestOperation* operation,id response){
        
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
                    [dataArr addObjectsFromArray:tempArr];
                    [tableview reloadData];
                    noDataView.hidden = YES;
                    tableview.hidden = NO;
                }else{
                    tableview.hidden = YES;
                    noDataView.hidden = NO;
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
    CGFloat itemY = 10;
    CGFloat itemW = 60;
    UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(itemX, itemY, itemW, itemW)];
    headImageView.backgroundColor = [UIColor clearColor];
//    headImageView.layer.masksToBounds = YES;
//    headImageView.image = [UIImage imageNamed:@"defalut_icon"];
//    headImageView.contentMode = UIViewContentModeScaleAspectFill;
//    headImageView.layer.borderWidth = 0.0;
//    headImageView.layer.cornerRadius = 40 / 2.0;
//    headImageView.layer.masksToBounds = YES;
    [cell addSubview:headImageView];
    
    NSString *imageStr = [NSString stringWithFormat:@"%@",[dict valueForKey:@"contentImgurl"]];
    NSArray *imageArr = [imageStr componentsSeparatedByString:@","];
    NSString *userHeader = @"";
    if (imageArr.count > 0 ) {
        userHeader = [NSString stringWithFormat:@"%@%@",PIC_URL,[imageArr objectAtIndex:0]];
    }
    
    [headImageView sd_setImageWithURL:[NSURL URLWithString:userHeader] placeholderImage:[UIImage imageNamed:@"defalut_icon"]];
    
    itemX = CGRectGetMaxX(headImageView.frame)+10;
    itemY = 5;
    itemW = SCREENWIDTH-itemX-10;
    UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(itemX, itemY, itemW, 30)];
    nameL.textColor = [UIColor blackColor];
    nameL.font = [UIFont systemFontOfSize:15.0];
    nameL.backgroundColor = [UIColor clearColor];
    nameL.adjustsFontSizeToFitWidth = YES;
    nameL.text = [dict valueForKey:@"manageNursingContentName"];
    [cell addSubview:nameL];
    
    itemY = CGRectGetMaxY(nameL.frame)-5;
    UILabel *contentL = [[UILabel alloc] initWithFrame:CGRectMake(itemX, itemY, itemW, 50)];
    contentL.textColor = [UIColor blackColor];
    contentL.numberOfLines = 0;
    contentL.font = [UIFont systemFontOfSize:12.0];
    contentL.backgroundColor = [UIColor clearColor];
//    contentL.adjustsFontSizeToFitWidth = YES;
    contentL.text = [dict valueForKey:@"manageNursingContentContent"];
    [cell addSubview:contentL];
    
    
    
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    
    return 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    //
    NSDictionary *dict;
    @try {
        dict = [NSDictionary dictionaryWithDictionary:dataArr[row]];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }

    ServiceDetailVC* serviceDetailVC = [[ServiceDetailVC alloc] init];
    serviceDetailVC.hidesBottomBarWhenPushed = YES;
    NSDictionary *tempDic = [NSDictionary dictionaryWithObjectsAndKeys:[dict valueForKey:@"manageNursingContentName"],@"contentName",[dict valueForKey:@"manageNursingContentId"],@"contentid", nil];
    serviceDetailVC.infoData = tempDic;
    [self.navigationController pushViewController:serviceDetailVC animated:YES];
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
