//
//  MyEvaluateTableViewCell.m
//  nurseService
//
//  Created by 梅阳阳 on 16/12/22.
//  Copyright © 2016年 iMac. All rights reserved.
//

#import "MyEvaluateTableViewCell.h"

@implementation MyEvaluateTableViewCell
@synthesize headImageView,telephoneNum,evaluateInfo,time;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellSize:(CGSize)cellsize
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier cellSize:cellsize];
    if (self) {
        
        CGFloat pointY = 15;
        headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, pointY, 40, 40)];
        headImageView.backgroundColor = [UIColor clearColor];
        headImageView.layer.masksToBounds = YES;
        headImageView.image = [UIImage imageNamed:@"defalut_icon"];
        headImageView.contentMode = UIViewContentModeScaleAspectFill;
        headImageView.layer.borderWidth = 0.0;
        headImageView.layer.cornerRadius = 40 / 2.0;
        headImageView.layer.masksToBounds = YES;
        [self addSubview:headImageView];
        
        pointY = 0;
        telephoneNum = [[UILabel alloc] initWithFrame:CGRectMake(55, pointY, 120, 25)];
        telephoneNum.textColor = [UIColor blackColor];
        telephoneNum.font = [UIFont systemFontOfSize:15.0];
        telephoneNum.backgroundColor = [UIColor clearColor];
        [self addSubview:telephoneNum];
        
        pointY = 20;
        UILabel *serviceType = [[UILabel alloc] initWithFrame:CGRectMake(55, pointY, 200, 25)];
        serviceType.textColor = [UIColor blackColor];
        serviceType.text = @"护理项:111111111";
        serviceType.font = [UIFont systemFontOfSize:15.0];
        serviceType.backgroundColor = [UIColor clearColor];
        [self addSubview:serviceType];
        
        pointY = 40;
        evaluateInfo = [[UILabel alloc] initWithFrame:CGRectMake(55, pointY, 120, 44)];
        evaluateInfo.textColor = [UIColor blackColor];
        evaluateInfo.font = [UIFont systemFontOfSize:15.0];
        evaluateInfo.backgroundColor = [UIColor clearColor];
        [self addSubview:evaluateInfo];
        
        time = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH-135, 40, 130, 30)];
        time.textColor = [UIColor grayColor];
        time.textAlignment = NSTextAlignmentRight;
        time.adjustsFontSizeToFitWidth = YES;
        time.font = [UIFont systemFontOfSize:15.0];
        time.backgroundColor = [UIColor clearColor];
        [self addSubview:time];
        
        UILabel *offLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 69, SCREENWIDTH, 1)];
        offLine.backgroundColor = [UIColor grayColor];
        [self addSubview:offLine];
    }
    return self;
}

@end
