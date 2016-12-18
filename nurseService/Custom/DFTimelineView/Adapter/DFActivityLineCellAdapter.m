//
//  DFActivityLineCellAdapter.m
//  huayoutong
//
//  Created by Tony on 16/3/8.
//  Copyright © 2016年 HeDongMing. All rights reserved.
//

#import "DFActivityLineCellAdapter.h"
#import "DFActivityLineCell.h"

#define ActivityCell @"timeline_cell_activity"

@implementation DFActivityLineCellAdapter

-(CGFloat) getCellHeightByCount:(DFBaseLineItem *)item
{
    return [DFActivityLineCell getCellHeight:item];
}

-(UITableViewCell *)getCell:(UITableView *)tableView
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ActivityCell];
    if (cell == nil ) {
        cell = [[DFActivityLineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ActivityCell];
    }
    
    return cell;
}

-(void)updateCell:(DFBaseLineCell *)cell message:(DFBaseLineItem *)item
{
    [cell updateWithItem:item];
}

@end
