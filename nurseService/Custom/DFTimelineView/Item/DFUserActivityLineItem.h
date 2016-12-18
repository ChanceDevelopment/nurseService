//
//  DFUserActivityLineItem.h
//  huayoutong
//
//  Created by Tony on 16/4/27.
//  Copyright © 2016年 HeDongMing. All rights reserved.
//

#import "DFBaseLineItem.h"

@interface DFUserActivityLineItem : DFBaseLineItem

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSMutableArray *thumbImages;
@property (nonatomic, strong) NSMutableArray *srcImages;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

@property (nonatomic, strong) NSAttributedString *attrText;

@end
