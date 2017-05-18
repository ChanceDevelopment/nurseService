//
//  MyServiceListVC.m
//  nurseService
//
//  Created by 梅阳阳 on 17/2/16.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "MyServiceListVC.h"
#import "HeBaseTableViewCell.h"
#import "ServiceDetailVC.h"

@interface MyServiceListVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UIImageView *noDataView;
    NSMutableArray *dataArr;
    UIView *windowView;
    
    NSMutableArray *serviceArr;
    NSMutableArray *serviceSelectArr;
    NSMutableDictionary *serviceIdDic;

}
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@end

@implementation MyServiceListVC
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
        label.text = @"我的服务";
        [label sizeToFit];
        self.title = @"我的服务";
    }
    return self;
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
    
    dataArr = [[NSMutableArray alloc] initWithCapacity:0];
    serviceArr = [[NSMutableArray alloc] initWithCapacity:0];  //可提供服务
    serviceSelectArr = [[NSMutableArray alloc] initWithCapacity:0];
    serviceIdDic = [[NSMutableDictionary alloc] initWithCapacity:0];  //可提供服务

    NSDictionary *userInfoDic = [NSDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:USERACCOUNTKEY]];
    NSString* temp = [NSString stringWithFormat:@"%@",[userInfoDic valueForKey:@"nurseGoodservice"]];
    NSArray *nameArr = [temp componentsSeparatedByString:@","];
    if (nameArr > 0) {
        [self getDataWithNameArr:nameArr];
    }
}
/*
 @brief 获取服务项目详情
 @prama nameArr:服务项目
 @return
 */
- (void)getDataWithNameArr:(NSArray *)nameArr{
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
                tableview.hidden = YES;
                noDataView.hidden = NO;
                
                NSArray *tempArr = [NSArray arrayWithArray:[respondDict valueForKey:@"json"]];
                if (tempArr.count > 0) {
                    for (NSString *contentName in nameArr) {
                        for (int i = 0; i < tempArr.count; i++) {
                            if ([contentName isEqualToString:[tempArr[i] objectForKey:@"manageNursingContentId"]]) {
                                
                                [dataArr addObject:tempArr[i]];
                                [serviceSelectArr addObject:[tempArr[i] objectForKey:@"manageNursingContentName"]];
                            }
                        }
                    }
                    if (dataArr.count > 0) {
                        noDataView.hidden = YES;
                        tableview.hidden = NO;
                        [tableview reloadData];
                    }
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

- (void)initView
{
    [super initView];
    self.view.backgroundColor = [UIColor colorWithWhite:237.0 /255.0 alpha:1.0];
    

    UIButton *changeServiceBt = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 25)];
    changeServiceBt.backgroundColor = [UIColor clearColor];
    [changeServiceBt setTitle:@"变更服务" forState:UIControlStateNormal];
    [changeServiceBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    changeServiceBt.titleLabel.font = [UIFont systemFontOfSize:13.0];
    changeServiceBt.titleLabel.adjustsFontSizeToFitWidth = YES;
    [changeServiceBt addTarget:self action:@selector(changeServiceAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *changeBtItem = [[UIBarButtonItem alloc] initWithCustomView:changeServiceBt];
    self.navigationItem.rightBarButtonItem = changeBtItem;
    
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
    noDataView.hidden = NO;
    
    [tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
}
//选择服务项目
- (void)changeServiceAction{

    NSString *nurseDistrict = [[[NSUserDefaults standardUserDefaults] objectForKey:USERACCOUNTKEY] valueForKey:@"nurseDistrict"];
    BOOL isDistrict = [nurseDistrict isEqualToString:@"0"] ? YES : NO;
    if (isDistrict) {
        [self showAlertView];
    }else{
        [self.view makeToast:@"您还未通过认证，请耐心等候" duration:1.2 position:@"bottom"];
    }
}

//我的服务
- (void)showAlertView{
    
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
     titleL.text = @"提示";
     
     NSInteger addTextField_H = 44;
     NSInteger addTextField_Y = 50;
     NSInteger addTextField_W =SCREENWIDTH-40;
     
     UILabel *tipLable = [[UILabel alloc] initWithFrame:CGRectMake(10, addTextField_Y, addTextField_W, addTextField_H)];//高度--44
     tipLable.font = [UIFont systemFontOfSize:15.0];
     tipLable.backgroundColor = [UIColor clearColor];
     tipLable.numberOfLines = 0;
     tipLable.text = @"提交新的服务认证需要重新审核，未审核通过前无法接单，是否确认";
     [addBgView addSubview:tipLable];
     
     NSInteger cancleBt_X = SCREENWIDTH-20-10-90;
     NSInteger cancleBt_Y = addTextField_Y+44+30;
     NSInteger cancleBt_W = 40;
     NSInteger cancleBt_H = 20;
     
     UIButton *cancleBt = [[UIButton alloc] initWithFrame:CGRectMake(cancleBt_X, cancleBt_Y, cancleBt_W, cancleBt_H)];
     [cancleBt setTitle:@"取消" forState:UIControlStateNormal];
     cancleBt.backgroundColor = [UIColor clearColor];
     cancleBt.titleLabel.font = [UIFont systemFontOfSize:15.0];
     [cancleBt setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
     cancleBt.tag = 0;
     [cancleBt addTarget:self action:@selector(clickBtAction:) forControlEvents:UIControlEventTouchUpInside];
     [addBgView addSubview:cancleBt];
     
     UIButton *okBt = [[UIButton alloc] initWithFrame:CGRectMake(cancleBt_X+50, cancleBt_Y, cancleBt_W, cancleBt_H)];
     [okBt setTitle:@"确认" forState:UIControlStateNormal];
     okBt.backgroundColor = [UIColor clearColor];
     okBt.titleLabel.font = [UIFont systemFontOfSize:15.0];
     [okBt setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
     okBt.tag = 1;
     [okBt addTarget:self action:@selector(clickBtAction:) forControlEvents:UIControlEventTouchUpInside];
     [addBgView addSubview:okBt];
}
//提交选中的服务项目
- (void)clickBtAction:(UIButton *)sender{
    
    if (sender.tag == 1) {
        [self getAllServiceInfo];
    }
    if (sender.tag == 100) {
        if (windowView) {
            [windowView removeFromSuperview];
        }
        [self showRebackAlertView];
        return;
    }
    if (sender.tag == 101) {
        NSString *serviceStr = @"";
        for (NSString *value in serviceSelectArr) {
            NSString *serviceItem = [NSString stringWithFormat:@"%@",[serviceIdDic objectForKey:value]];
            serviceStr = [serviceStr stringByAppendingFormat:@",%@",serviceItem];;
        }
        
        if (serviceStr.length > 0) {
            serviceStr = [serviceStr substringFromIndex:1];
        }
        NSLog(@"%@",serviceStr);
        
        //        [dataSourceDic setValue:serviceStr forKey:@"nurseGoodservice"];
        NSString *userAccount = [[NSUserDefaults standardUserDefaults] objectForKey:USERIDKEY];
        NSDictionary * params  = @{@"nurseId" : [NSString stringWithFormat:@"%@",userAccount],
                                   @"contentId" : serviceStr};
        
        NSLog(@"%@",params);
        [self showHudInView:self.view hint:@"保存中..."];
        [AFHttpTool requestWihtMethod:RequestMethodTypePost url:@"content/SelectGoodServiceForNurse.action" params:params success:^(AFHTTPRequestOperation* operation,id response){
            [self hideHud];
            NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
            NSMutableDictionary *respondDict = [NSMutableDictionary dictionaryWithDictionary:[respondString objectFromJSONString]];
            
            [self.view makeToast:[NSString stringWithFormat:@"%@",[respondDict valueForKey:@"data"]] duration:1.2 position:@"center"];
            
            if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"200"]) {
                NSLog(@"success");
                
            }else if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"400"]){
                NSLog(@"faile");
            }
//            [self showRebackAlertView];
            //刷新
            
        } failure:^(NSError* err){
            NSLog(@"err:%@",err);
            [self hideHud];
            [self.view makeToast:ERRORREQUESTTIP duration:2.0 position:@"center"];
        }];
    }
    if (windowView) {
        [windowView removeFromSuperview];
    }
    NSLog(@"tag:%ld",sender.tag);
}

//获取所有的服务
- (void)getAllServiceInfo{
    
    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:@"content/SelectContentAllinfo.action" params:nil success:^(AFHTTPRequestOperation* operation,id response){
        
        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSMutableDictionary *respondDict = [NSMutableDictionary dictionaryWithDictionary:[respondString objectFromJSONString]];
        if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"200"]) {
            NSArray *temp = [NSArray arrayWithArray:[respondDict objectForKey:@"json"]];
            if (serviceArr.count > 0) {
                [serviceArr removeAllObjects];
            }
            if ([[serviceIdDic allKeys] count] > 0) {
                [serviceIdDic removeAllObjects];
            }
            for (int i = 0; i<temp.count; i++) {
                NSDictionary *tempDic = [NSDictionary dictionaryWithDictionary:temp[i]];
                [serviceArr addObject:[tempDic objectForKey:@"manageNursingContentName"]];
                [serviceIdDic setObject:[tempDic objectForKey:@"manageNursingContentId"] forKey:[tempDic objectForKey:@"manageNursingContentName"]];
                
            }
            NSLog(@"success");
            NSString *serviceStr = @"";
            for (NSString *value in serviceSelectArr) {
                NSString *serviceItem = [NSString stringWithFormat:@"%@",[serviceIdDic objectForKey:value]];
                serviceStr = [serviceStr stringByAppendingFormat:@",%@",serviceItem];;
            }
            
            if (serviceStr.length > 0) {
                serviceStr = [serviceStr substringFromIndex:1];
            }
            //            [dataSourceDic setValue:serviceStr forKey:@"nurseGoodservice"];
            [self showServiceAlertView];
            
            [tableview reloadData];
            
        }else if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"400"]){
            NSLog(@"faile");
        }
    } failure:^(NSError* err){
        NSLog(@"err:%@",err);
        [self.view makeToast:ERRORREQUESTTIP duration:2.0 position:@"center"];
    }];
}

- (void)showServiceAlertView{
    
    //serviceArr
    windowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGH)];
    windowView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5];;
    [[[UIApplication sharedApplication] keyWindow] addSubview:windowView];
    
    
    NSInteger addBgView_W = SCREENWIDTH -20;
    NSInteger addBgView_H = 44*serviceArr.count;
    NSInteger addBgView_Y = (SCREENHEIGH-addBgView_H)/2.0;//SCREENHEIGH/2.0-addBgView_H/2.0-40;
    UIView *addBgView = [[UIView alloc] initWithFrame:CGRectMake(10, addBgView_Y, addBgView_W, addBgView_H)];
    addBgView.backgroundColor = [UIColor whiteColor];
    [addBgView.layer setMasksToBounds:YES];
    [addBgView.layer setCornerRadius:4];
    addBgView.alpha = 1.0;
    [windowView addSubview:addBgView];
    
    UITableView *myTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, addBgView_W, addBgView_H-50) style:UITableViewStylePlain];
    myTableview.tag = 500;
    myTableview.delegate = self;
    myTableview.dataSource = self;
    [addBgView addSubview:myTableview];
    myTableview.backgroundView = nil;
    myTableview.backgroundColor = [UIColor whiteColor];
    [Tool setExtraCellLineHidden:myTableview];
    myTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    NSInteger cancleBt_X = SCREENWIDTH-50-90;
    NSInteger cancleBt_Y = CGRectGetMaxY(myTableview.frame)+10;
    NSInteger cancleBt_W = 40;
    NSInteger cancleBt_H = 20;
    
    
    UIButton *cancleBt = [[UIButton alloc] initWithFrame:CGRectMake(cancleBt_X, cancleBt_Y, cancleBt_W, cancleBt_H)];
    [cancleBt setTitle:@"取消" forState:UIControlStateNormal];
    cancleBt.backgroundColor = [UIColor clearColor];
    cancleBt.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [cancleBt setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    cancleBt.tag = 0;
    [cancleBt addTarget:self action:@selector(clickBtAction:) forControlEvents:UIControlEventTouchUpInside];
    [addBgView addSubview:cancleBt];
    
    
    UIButton *okBt = [[UIButton alloc] initWithFrame:CGRectMake(cancleBt_X+50, cancleBt_Y, cancleBt_W, cancleBt_H)];
    [okBt setTitle:@"确定" forState:UIControlStateNormal];
    okBt.backgroundColor = [UIColor clearColor];
    okBt.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [okBt setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    okBt.tag = 100;
    [okBt addTarget:self action:@selector(clickBtAction:) forControlEvents:UIControlEventTouchUpInside];
    [addBgView addSubview:okBt];
    
}

- (void)showRebackAlertView{
    
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
    titleL.text = @"提示";
    
    NSInteger addTextField_H = 44;
    NSInteger addTextField_Y = 50;
    NSInteger addTextField_W =SCREENWIDTH-40;
    
    UILabel *tipLable = [[UILabel alloc] initWithFrame:CGRectMake(10, addTextField_Y, addTextField_W, addTextField_H)];//高度--44
    tipLable.font = [UIFont systemFontOfSize:15.0];
    tipLable.backgroundColor = [UIColor clearColor];
    tipLable.numberOfLines = 0;
    tipLable.text = @"您提交的服务认证，平台将在1~2个工作日给你反馈";
    [addBgView addSubview:tipLable];
    
    NSInteger cancleBt_X = SCREENWIDTH-20-10-90;
    NSInteger cancleBt_Y = addTextField_Y+44+30;
    NSInteger cancleBt_W = 40;
    NSInteger cancleBt_H = 20;
    
    UIButton *cancleBt = [[UIButton alloc] initWithFrame:CGRectMake(cancleBt_X, cancleBt_Y, cancleBt_W, cancleBt_H)];
    [cancleBt setTitle:@"取消" forState:UIControlStateNormal];
    cancleBt.backgroundColor = [UIColor clearColor];
    cancleBt.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [cancleBt setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    cancleBt.tag = 0;
    [cancleBt addTarget:self action:@selector(clickBtAction:) forControlEvents:UIControlEventTouchUpInside];
    [addBgView addSubview:cancleBt];
    
    UIButton *okBt = [[UIButton alloc] initWithFrame:CGRectMake(cancleBt_X+50, cancleBt_Y, cancleBt_W, cancleBt_H)];
    [okBt setTitle:@"确认" forState:UIControlStateNormal];
    okBt.backgroundColor = [UIColor clearColor];
    okBt.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [okBt setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    okBt.tag = 101;
    [okBt addTarget:self action:@selector(clickBtAction:) forControlEvents:UIControlEventTouchUpInside];
    [addBgView addSubview:okBt];
    
    
}
#pragma mark - TableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 500) {
        return serviceArr.count;
    }
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
    
    if (tableView.tag == 500) {
        
        HeBaseTableViewCell *cell  = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[HeBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier cellSize:cellSize];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREENWIDTH-20, cellSize.height)];
        tipLabel.backgroundColor = [UIColor clearColor];
        tipLabel.text = serviceArr[row];
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.font = [UIFont systemFontOfSize:15.0];
        tipLabel.textColor = [UIColor grayColor];
        [cell addSubview:tipLabel];
        
        CGFloat imageW = 20;
        CGFloat imageX = SCREENWIDTH-100;
        
        UIImageView *selectImage = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, 12, imageW, imageW)];
        [cell addSubview:selectImage];
        selectImage.backgroundColor = [UIColor clearColor];
        selectImage.userInteractionEnabled = YES;
        selectImage.tag = row +50;
        
        for (NSString *serviceStr in serviceSelectArr) {
            if ([serviceStr isEqualToString:serviceArr[row]]) {
                selectImage.image = [UIImage imageNamed:@"icon_hook"];
            }
        }
        
        return cell;
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
    
    if (tableView.tag == 500) {
        return 44;
    }
    return 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    if (tableView.tag == 500) {
        for (int i = 0; i < serviceSelectArr.count; i++) {
            if ([serviceSelectArr[i] isEqualToString:serviceArr[row]]) {
                //移除
                [serviceSelectArr removeObjectAtIndex:i];
                
                [tableView reloadData];
                return;
            }
        }
        [serviceSelectArr addObject:serviceArr[row]];
        [tableView reloadData];
        
        return;
    }
    
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
