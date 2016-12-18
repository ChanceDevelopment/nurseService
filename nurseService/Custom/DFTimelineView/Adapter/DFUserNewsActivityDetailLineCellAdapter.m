//
//  DFUserNewsActivityDetailLineCellAdapter.m
//  huayoutong
//
//  Created by Tony on 16/4/28.
//  Copyright © 2016年 HeDongMing. All rights reserved.
//

#import "DFUserNewsActivityDetailLineCellAdapter.h"
#import "DFUserNewsActivityDetailLineCell.h"

#define UserNewsActivityDetailCell @"timeline_cell_usernewsactivityDetail"

@implementation DFUserNewsActivityDetailLineCellAdapter

-(CGFloat) getCellHeightByCount:(DFBaseLineItem *)item
{
    return [DFUserNewsActivityDetailLineCell getCellHeight:item];
}

-(UITableViewCell *)getCell:(UITableView *)tableView
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UserNewsActivityDetailCell];
    if (cell == nil ) {
        cell = [[DFUserNewsActivityDetailLineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:UserNewsActivityDetailCell];
    }
    
    return cell;
}

-(void)updateCell:(DFBaseLineCell *)cell message:(DFBaseLineItem *)item
{
    [cell updateWithItem:item];
}

@end
