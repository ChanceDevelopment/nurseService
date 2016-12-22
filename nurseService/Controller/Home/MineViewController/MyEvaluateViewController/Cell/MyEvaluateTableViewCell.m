//
//  MyEvaluateTableViewCell.m
//  nurseService
//
//  Created by 梅阳阳 on 16/12/22.
//  Copyright © 2016年 iMac. All rights reserved.
//

#import "MyEvaluateTableViewCell.h"

@implementation MyEvaluateTableViewCell
@synthesize headImageView,telephoneNum,evaluateInfo,startNum,time;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellSize:(CGSize)cellsize
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier cellSize:cellsize];
    if (self) {
        
        headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 40, 40)];
        headImageView.backgroundColor = [UIColor clearColor];
        headImageView.layer.masksToBounds = YES;
        headImageView.contentMode = UIViewContentModeScaleAspectFill;
        headImageView.image = [UIImage imageNamed:@"index1"];
        headImageView.layer.borderWidth = 0.0;
        headImageView.layer.cornerRadius = 40 / 2.0;
        headImageView.layer.masksToBounds = YES;
        [self addSubview:headImageView];
        
        telephoneNum = [[UILabel alloc] initWithFrame:CGRectMake(55, 0, 120, 25)];
        telephoneNum.textColor = [UIColor blackColor];
        telephoneNum.font = [UIFont systemFontOfSize:15.0];
        telephoneNum.text = @"18819187722";
        telephoneNum.backgroundColor = [UIColor clearColor];
        [self addSubview:telephoneNum];
        
        evaluateInfo = [[UILabel alloc] initWithFrame:CGRectMake(55, 20, 120, 44)];
        evaluateInfo.textColor = [UIColor blackColor];
        evaluateInfo.font = [UIFont systemFontOfSize:15.0];
        evaluateInfo.text = @"lallallalallalalalallalallal";
        evaluateInfo.backgroundColor = [UIColor clearColor];
        [self addSubview:evaluateInfo];
        
        CGFloat starX = SCREENWIDTH-90;
        CGFloat starW = 15;
        for (int i = 0; i<5; i++) {
            UIImageView *starImageView = [[UIImageView alloc] initWithFrame:CGRectMake(starX+starW*i, 10, starW, starW)];
            starImageView.backgroundColor = [UIColor clearColor];
            if (i < [startNum integerValue]) {
                starImageView.image = [UIImage imageNamed:@"icon_star_yellow"];
            }else{
                starImageView.image = [UIImage imageNamed:@"icon_star_normal"];
            }
            [self addSubview:starImageView];
        }
        
        time = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH-130, 40, 130, 30)];
        time.textColor = [UIColor grayColor];
        time.font = [UIFont systemFontOfSize:15.0];
        time.text = @"2016/12/22 12:21";
        time.backgroundColor = [UIColor clearColor];
        [self addSubview:time];
        
        UILabel *offLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 69, SCREENWIDTH, 1)];
        offLine.backgroundColor = [UIColor grayColor];
        [self addSubview:offLine];
    }
    return self;
}

@end
