//
//  HomeTableViewCell.h
//  nurseService
//
//  Created by 梅阳阳 on 17/1/10.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "HeBaseTableViewCell.h"

@interface HomeTableViewCell : HeBaseTableViewCell
@property (nonatomic,strong)UIImageView *headImageView;
@property (nonatomic,strong)UILabel *nameL;
@property (nonatomic,strong)UILabel *titleL;
@property (nonatomic,strong)UILabel *timeL;
@property (nonatomic, strong) UILabel *zanLabel;
@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic,strong)UILabel *detailTextView;
@end
