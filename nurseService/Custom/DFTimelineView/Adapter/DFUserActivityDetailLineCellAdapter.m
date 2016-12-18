//
//  DFUserActivityDetailLineCellAdapter.m
//  huayoutong
//
//  Created by Tony on 16/4/27.
//  Copyright © 2016年 HeDongMing. All rights reserved.
//

#import "DFUserActivityDetailLineCellAdapter.h"
#import "DFUserActivityDetailLineCell.h"

#define UserActivityDetailCell @"timeline_cell_useractivityDetail"

@implementation DFUserActivityDetailLineCellAdapter

-(CGFloat) getCellHeightByCount:(DFBaseLineItem *)item
{
    return [DFUserActivityDetailLineCell getCellHeight:item];
}

-(UITableViewCell *)getCell:(UITableView *)tableView
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UserActivityDetailCell];
    if (cell == nil ) {
        cell = [[DFUserActivityDetailLineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:UserActivityDetailCell];
    }
    
    return cell;
}

-(void)updateCell:(DFBaseLineCell *)cell message:(DFBaseLineItem *)item
{
    [cell updateWithItem:item];
}

@end
