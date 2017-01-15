//
//  RankTableViewCell.h
//  nurseService
//
//  Created by 梅阳阳 on 16/12/21.
//  Copyright © 2016年 iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeBaseTableViewCell.h"
@interface RankTableViewCell : HeBaseTableViewCell


@property (nonatomic,strong)UILabel *rankNum;
@property (nonatomic,strong)UIImageView *rankImageView;
@property (nonatomic,strong)UIImageView *headImageView;
@property (nonatomic,strong)UILabel *pickName;
@property (nonatomic,strong)UILabel *coinNum;
@property (nonatomic,strong) void(^followBlock)();
@end
