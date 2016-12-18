//
//  DFActivityDetailLineItem.m
//  huayoutong
//
//  Created by HeDongMing on 16/4/12.
//  Copyright © 2016年 HeDongMing. All rights reserved.
//

#import "DFCollectActivityLineItem.h"

@implementation DFCollectActivityLineItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.itemType = LineItemTypeCollectActivity;
        
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
