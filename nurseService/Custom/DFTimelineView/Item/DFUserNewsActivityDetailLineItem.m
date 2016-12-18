//
//  DFUserNewsActivityDetailLineItem.m
//  huayoutong
//
//  Created by Tony on 16/4/28.
//  Copyright © 2016年 HeDongMing. All rights reserved.
//

#import "DFUserNewsActivityDetailLineItem.h"

@implementation DFUserNewsActivityDetailLineItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.itemType = LineItemTypeUserNewsActivityDetail;
        
        _activityIconText = @"";  //活动图标的标题
        _text = @"";
        _activityDate = @"";
        _activityAddress = @"";
        _activityContactPhone = @"";
        
        _thumbImages = [NSMutableArray array];
        _srcImages = [NSMutableArray array];
        
    }
    return self;
}

@end
