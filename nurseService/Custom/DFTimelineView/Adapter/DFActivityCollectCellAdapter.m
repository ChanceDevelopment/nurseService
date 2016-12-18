//
//  DFActivityDetailLineCellAdapter.m
//  huayoutong
//
//  Created by HeDongMing on 16/4/12.
//  Copyright © 2016年 HeDongMing. All rights reserved.
//

#import "DFActivityCollectCellAdapter.h"
#import "DFCollectActivityLineCell.h"

#define ActivityCollectCell @"timeline_cell_activityCollect"

@implementation DFActivityCollectCellAdapter

-(CGFloat) getCellHeightByCount:(DFBaseLineItem *)item
{
    return [DFCollectActivityLineCell getCellHeight:item];
}

-(UITableViewCell *)getCell:(UITableView *)tableView
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ActivityCollectCell];
    if (cell == nil ) {
        cell = [[DFCollectActivityLineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ActivityCollectCell];
    }
    
    return cell;
}

-(void)updateCell:(DFBaseLineCell *)cell message:(DFBaseLineItem *)item
{
    [cell updateWithItem:item];
}

@end
