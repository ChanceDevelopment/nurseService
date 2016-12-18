//
//  DFActivityLineItem.m
//  huayoutong
//
//  Created by Tony on 16/3/8.
//  Copyright © 2016年 HeDongMing. All rights reserved.
//

#import "DFActivityLineItem.h"

@implementation DFActivityLineItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.itemType = LineItemTypeActivity;
        
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
