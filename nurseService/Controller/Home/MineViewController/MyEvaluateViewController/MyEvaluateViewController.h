//
//  MyEvaluateViewController.h
//  nurseService
//
//  Created by 梅阳阳 on 16/12/22.
//  Copyright © 2016年 iMac. All rights reserved.
//

#import "HeBaseViewController.h"

@interface MyEvaluateViewController : HeBaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@end
