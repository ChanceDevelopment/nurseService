//
//  OrderNowTableViewCell.h
//  nurseService
//
//  Created by 梅阳阳 on 17/1/1.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "HeBaseTableViewCell.h"

@interface OrderNowTableViewCell : HeBaseTableViewCell
@property (nonatomic,strong)UILabel *serviceContentL;
@property (nonatomic,strong)UILabel *stopTimeL;
@property (nonatomic,strong)UILabel *orderMoney;
@property (nonatomic,strong)UILabel *addressL;
@property (nonatomic,strong)UILabel *userInfoL;
@property (nonatomic,strong)UILabel *oderStateL;
@property (nonatomic,strong)void(^showOrderDetailBlock)();
@property (nonatomic,strong)void(^cancleRequstBlock)();
@property (nonatomic,strong)void(^nextStepBlock)();
@property (nonatomic,strong)void(^locationBlock)();
@property (nonatomic,strong)void(^showUserInfoBlock)();

@property(strong,nonatomic)NSDictionary *orderInfoDict;
@end
