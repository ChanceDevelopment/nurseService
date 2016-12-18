//
//  DFUserActivityLineItem.m
//  huayoutong
//
//  Created by Tony on 16/4/27.
//  Copyright © 2016年 HeDongMing. All rights reserved.
//

#import "DFUserActivityLineItem.h"

@implementation DFUserActivityLineItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.itemType = LineItemTypeUserActivity;
        
        _text = @"";
        _thumbImages = [NSMutableArray array];
        _srcImages = [NSMutableArray array];
        
    }
    return self;
}

@end
