//
//  OrderFinishedTableViewCell.h
//  nurseService
//
//  Created by 梅阳阳 on 16/12/31.
//  Copyright © 2016年 iMac. All rights reserved.
//

#import "HeBaseTableViewCell.h"

@interface OrderFinishedTableViewCell : HeBaseTableViewCell
@property (nonatomic,strong)UILabel *serviceContentL;
@property (nonatomic,strong)UILabel *orderStateL;
@property (nonatomic,strong)UILabel *orderIdNum;
@property (nonatomic,strong)UILabel *orderReceiveTime;
@property (nonatomic,strong)UILabel *orderFinshTime;
@property (nonatomic,strong)UILabel *orderMoney;
@property (nonatomic,strong) void(^reportBlock)();
@property (nonatomic,strong) void(^evaluateBlock)();

@end
