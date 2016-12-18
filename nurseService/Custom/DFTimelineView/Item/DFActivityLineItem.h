//
//  DFActivityLineItem.h
//  huayoutong
//
//  Created by Tony on 16/3/8.
//  Copyright © 2016年 HeDongMing. All rights reserved.
//

#import "DFBaseLineItem.h"

@interface DFActivityLineItem : DFBaseLineItem

@property (nonatomic, strong) NSString *activityIconText;  //活动图标的标题
@property (nonatomic, strong) NSString *text; //活动的简要
@property (nonatomic, strong) NSString *activityDate;  //活动时间
@property (nonatomic, strong) NSString *activityAddress;  //活动地点
@property (nonatomic, strong) NSString *activityContactPhone;  //活动的联系人电话
@property (nonatomic, strong) NSMutableArray *thumbImages;
@property (nonatomic, strong) NSMutableArray *srcImages;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

@property (nonatomic, strong) NSAttributedString *attrText;

@end
