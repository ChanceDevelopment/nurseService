//
//  OrderFinishedTableViewCell.m
//  nurseService
//
//  Created by 梅阳阳 on 16/12/31.
//  Copyright © 2016年 iMac. All rights reserved.
//

#import "OrderFinishedTableViewCell.h"

@implementation OrderFinishedTableViewCell
@synthesize serviceContentL;
@synthesize orderIdNum;
@synthesize orderReceiveTime;
@synthesize orderFinshTime;
@synthesize orderMoney;
@synthesize orderStateL;
@synthesize evaluateBt;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellSize:(CGSize)cellsize
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier cellSize:cellsize];
    if (self) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(5, 0, SCREENWIDTH-10, 150)];
        bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bgView];
        [bgView.layer setMasksToBounds:YES];
        bgView.layer.cornerRadius = 4.0;
        
        serviceContentL = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 200, 44)];
        serviceContentL.textColor = APPDEFAULTORANGE;
        serviceContentL.font = [UIFont systemFontOfSize:15.0];
        serviceContentL.backgroundColor = [UIColor clearColor];
        serviceContentL.adjustsFontSizeToFitWidth = YES;
        [bgView addSubview:serviceContentL];

        orderStateL = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH-20-40, 0, 40, 50)];
        orderStateL.textColor = [UIColor grayColor];
        orderStateL.font = [UIFont systemFontOfSize:12.0];
        orderStateL.backgroundColor = [UIColor clearColor];
        [bgView addSubview:orderStateL];
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(10, 44, SCREENWIDTH-20, 1)];
        [bgView addSubview:line];
        line.backgroundColor = [UIColor colorWithWhite:237.0 / 255.0 alpha:1.0];
        
        orderIdNum = [[UILabel alloc] initWithFrame:CGRectMake(10, 45, SCREENWIDTH-30, 20)];
        orderIdNum.textColor = [UIColor blackColor];
        orderIdNum.font = [UIFont systemFontOfSize:12.0];
        orderIdNum.backgroundColor = [UIColor clearColor];
        [bgView addSubview:orderIdNum];
        
        orderReceiveTime = [[UILabel alloc] initWithFrame:CGRectMake(10, 65, 200, 20)];
        orderReceiveTime.textColor = [UIColor blackColor];
        orderReceiveTime.font = [UIFont systemFontOfSize:12.0];
        orderReceiveTime.backgroundColor = [UIColor clearColor];
        [bgView addSubview:orderReceiveTime];
        
        orderFinshTime = [[UILabel alloc] initWithFrame:CGRectMake(10, 85, 200, 20)];
        orderFinshTime.textColor = [UIColor blackColor];
        orderFinshTime.font = [UIFont systemFontOfSize:12.0];
        orderFinshTime.backgroundColor = [UIColor clearColor];
        [bgView addSubview:orderFinshTime];
        
        orderMoney = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH-150, 65, 130, 30)];
        orderMoney.textColor = [UIColor orangeColor];
        orderMoney.textAlignment = NSTextAlignmentRight;
        orderMoney.font = [UIFont systemFontOfSize:15.0];
        orderMoney.backgroundColor = [UIColor clearColor];
        orderMoney.adjustsFontSizeToFitWidth = YES;
        [bgView addSubview:orderMoney];
    
        UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 111, SCREENWIDTH-20, 1)];
        [bgView addSubview:line1];
        line1.backgroundColor = [UIColor colorWithWhite:237.0 / 255.0 alpha:1.0];
        
        UIButton *reportBt = [[UIButton alloc] initWithFrame:CGRectMake(0, 111, SCREENWIDTH/2.0-5, 35)];
        [reportBt setTitle:@"护理报告" forState:UIControlStateNormal];
        [reportBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        reportBt.titleLabel.font = [UIFont systemFontOfSize:15.0];
        reportBt.backgroundColor = [UIColor clearColor];
        [reportBt addTarget:self action:@selector(reportAction) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:reportBt];
        
        UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH/2.0-5, 113, 1, 30)];
        [bgView addSubview:line2];
        line2.backgroundColor = [UIColor colorWithWhite:237.0 / 255.0 alpha:1.0];
        
        evaluateBt = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH/2.0-5, 111, SCREENWIDTH/2.0-5, 35)];
        [evaluateBt setTitle:@"去评价" forState:UIControlStateNormal];
        [evaluateBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        evaluateBt.titleLabel.font = [UIFont systemFontOfSize:15.0];
        evaluateBt.backgroundColor = [UIColor clearColor];
        [evaluateBt addTarget:self action:@selector(evaluateAction) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:evaluateBt];
    }
    return self;
}

- (void)reportAction{
    if (self.reportBlock) {
        self.reportBlock();
    }
}

- (void)evaluateAction{
    if (self.evaluateBlock) {
        self.evaluateBlock();
    }
}

@end
