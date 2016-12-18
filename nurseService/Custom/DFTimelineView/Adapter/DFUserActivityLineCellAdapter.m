//
//  DFUserActivityLineCellAdapter.m
//  huayoutong
//
//  Created by Tony on 16/4/27.
//  Copyright © 2016年 HeDongMing. All rights reserved.
//

#import "DFUserActivityLineCellAdapter.h"
#import "DFUserActivityLineCell.h"

#define ActivityUserCell @"timeline_cell_useractivity"

@implementation DFUserActivityLineCellAdapter

-(CGFloat) getCellHeightByCount:(DFBaseLineItem *)item
{
    return [DFUserActivityLineCell getCellHeight:item];
}

-(UITableViewCell *)getCell:(UITableView *)tableView
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ActivityUserCell];
    if (cell == nil ) {
        cell = [[DFUserActivityLineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ActivityUserCell];
    }
    
    return cell;
}

-(void)updateCell:(DFBaseLineCell *)cell message:(DFBaseLineItem *)item
{
    [cell updateWithItem:item];
}

@end
