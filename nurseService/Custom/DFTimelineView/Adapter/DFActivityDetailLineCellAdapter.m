//
//  DFActivityDetailLineCellAdapter.m
//  huayoutong
//
//  Created by HeDongMing on 16/4/12.
//  Copyright © 2016年 HeDongMing. All rights reserved.
//

#import "DFActivityDetailLineCellAdapter.h"
#import "DFActivityDetailLineCell.h"

#define ActivityDetailCell @"timeline_cell_activityDetail"

@implementation DFActivityDetailLineCellAdapter

-(CGFloat) getCellHeightByCount:(DFBaseLineItem *)item
{
    return [DFActivityDetailLineCell getCellHeight:item];
}

-(UITableViewCell *)getCell:(UITableView *)tableView
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ActivityDetailCell];
    if (cell == nil ) {
        cell = [[DFActivityDetailLineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ActivityDetailCell];
    }
    
    return cell;
}

-(void)updateCell:(DFBaseLineCell *)cell message:(DFBaseLineItem *)item
{
    [cell updateWithItem:item];
}

@end
