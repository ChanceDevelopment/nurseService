//
//  RankViewController.h
//  nurseService
//
//  Created by Tony on 2016/12/14.
//  Copyright © 2016年 iMac. All rights reserved.
//

#import "HeBaseViewController.h"

@interface RankViewController : HeBaseViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIView *tabBarBg;
@property (strong, nonatomic) IBOutlet UITableView *tableView;


@end
