//
//  RankTableViewCell.m
//  nurseService
//
//  Created by 梅阳阳 on 16/12/21.
//  Copyright © 2016年 iMac. All rights reserved.
//

#import "RankTableViewCell.h"

@implementation RankTableViewCell
@synthesize rankNum,rankImageView,headImageView,pickName,coinNum,followBlock;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellSize:(CGSize)cellsize
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier cellSize:cellsize];
    if (self) {
        
        rankImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 20, 20)];
        rankImageView.backgroundColor = [UIColor clearColor];
        rankImageView.image = [UIImage imageNamed:@"icon_rank_first"];
        [self addSubview:rankImageView];

        
        rankNum = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 40, 44)];
        rankNum.textColor = [UIColor blackColor];
        rankNum.font = [UIFont systemFontOfSize:13.0];
        rankNum.backgroundColor = [UIColor clearColor];
        rankNum.text = @"3";
        [self addSubview:rankNum];

        headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(55, 2, 40, 40)];
        headImageView.backgroundColor = [UIColor clearColor];
        headImageView.layer.masksToBounds = YES;
        headImageView.contentMode = UIViewContentModeScaleAspectFill;
        headImageView.image = [UIImage imageNamed:@"index1"];
        headImageView.layer.borderWidth = 0.0;
        headImageView.layer.cornerRadius = 40 / 2.0;
        headImageView.layer.masksToBounds = YES;
        [self addSubview:headImageView];
        
        pickName = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 80, 44)];
        pickName.textColor = [UIColor blackColor];
        pickName.font = [UIFont systemFontOfSize:15.0];
        pickName.text = @"昵称";
        pickName.backgroundColor = [UIColor clearColor];
        [self addSubview:pickName];
        
        UIImageView *coinImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH-115, 14, 15, 15)];
        coinImageView.backgroundColor = [UIColor clearColor];
        coinImageView.image = [UIImage imageNamed:@"icon_integral"];
        [self addSubview:coinImageView];
        
        
        coinNum = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH-95, 0, 40, 44)];
        coinNum.textColor = [UIColor yellowColor];
        coinNum.font = [UIFont systemFontOfSize:13.0];
        coinNum.backgroundColor = [UIColor clearColor];
        coinNum.text  =@"111";
        [self addSubview:coinNum];
        
        UIButton *followBt = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH-50, 12, 40, 20)];
        [followBt setTitle:@"+关注" forState:UIControlStateNormal];
        followBt.titleLabel.font = [UIFont systemFontOfSize:10.0];
        [followBt setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
        followBt.layer.borderColor = [UIColor purpleColor].CGColor;
        [followBt.layer setBorderWidth:0.6];
        [followBt.layer setCornerRadius:4.0];
        followBt.backgroundColor = [UIColor clearColor];
        [followBt addTarget:self action:@selector(followAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:followBt];
        
        
        UILabel *offLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 43, SCREENWIDTH, 1)];
        offLine.backgroundColor = [UIColor grayColor];
        [self addSubview:offLine];
    }
    return self;
}

- (void)followAction:(UIButton*)sender{
    NSLog(@"followAction");
    if (self.followBlock) {
        self.followBlock();
    }
}
@end
