//
//  HomeTableViewCell.m
//  nurseService
//
//  Created by 梅阳阳 on 17/1/10.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "HomeTableViewCell.h"

@implementation HomeTableViewCell
@synthesize headImageView;
@synthesize nameL;
@synthesize titleL;
@synthesize timeL;
@synthesize detailTextView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellSize:(CGSize)cellsize
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier cellSize:cellsize];
    if (self) {
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 255)];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.userInteractionEnabled = YES;
        [self addSubview:bgView];

        
        CGFloat headImageX = 5;
        CGFloat headImageY = 25;
        CGFloat headImageW = 30;
        
        headImageView = [[AsynImageView alloc] initWithFrame:CGRectMake(headImageX, headImageY, headImageW, headImageW)];
        headImageView.backgroundColor = [UIColor clearColor];
        headImageView.layer.masksToBounds = YES;
        headImageView.placeholderImage = [UIImage imageNamed:@"defalut_icon"];
        headImageView.contentMode = UIViewContentModeScaleAspectFill;
        headImageView.layer.borderWidth = 0.0;
        headImageView.layer.cornerRadius = 20 / 2.0;
        headImageView.layer.masksToBounds = YES;
        [bgView addSubview:headImageView];
        
        
        CGFloat nameLX = 10+35;
        CGFloat nameLY = headImageY+5;
        CGFloat nameLW = SCREENWIDTH - 40;
        
        nameL = [[UILabel alloc] initWithFrame:CGRectMake(nameLX, nameLY, nameLW, 20)];
        nameL.userInteractionEnabled = YES;
        nameL.textColor = [UIColor blueColor];
        nameL.text = @"张三";
        nameL.font = [UIFont systemFontOfSize:15.0];
        nameL.backgroundColor = [UIColor clearColor];
        [bgView addSubview:nameL];
        
        CGFloat deletVX = SCREENWIDTH-15;
        CGFloat deletVY = 5;
        CGFloat deletVW = 10;
        
        UIImageView *deletV = [[UIImageView alloc] initWithFrame:CGRectMake(deletVX, deletVY, deletVW, deletVW)];
        deletV.backgroundColor = [UIColor clearColor];
        deletV.image = [UIImage imageNamed:@"icon_into_right"];
        deletV.userInteractionEnabled = YES;
        [bgView addSubview:deletV];
        
        UITapGestureRecognizer *deletTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deletCell)];
        [deletV addGestureRecognizer:deletTap];
        

        CGFloat titleLY = headImageY+headImageW+5;
        CGFloat titleLW = SCREENWIDTH-20;

        titleL = [[UILabel alloc] initWithFrame:CGRectMake(10, titleLY, titleLW, 20)];
        titleL.textColor = [UIColor blackColor];
        titleL.text = @"骨科类护士";
        titleL.font = [UIFont systemFontOfSize:14.0];
        titleL.backgroundColor = [UIColor clearColor];
        [bgView addSubview:titleL];

        
        CGFloat detailTextViewY = titleLY+20;
        CGFloat detailTextViewW = SCREENWIDTH-10;

        detailTextView = [[UITextView alloc] initWithFrame:CGRectMake(5, detailTextViewY, detailTextViewW, 150)];
        [bgView addSubview:detailTextView];
        detailTextView.backgroundColor = [UIColor clearColor];
        detailTextView.font = [UIFont systemFontOfSize:12.0];
        detailTextView.text = @"#################################################";
        
        CGFloat timeLY = detailTextViewY+150;
        
        timeL = [[UILabel alloc] initWithFrame:CGRectMake(10, timeLY, 200, 20)];
        timeL.textColor = [UIColor grayColor];
        timeL.text  = @"发布于08-14";
        timeL.font = [UIFont systemFontOfSize:12.0];
        timeL.backgroundColor = [UIColor clearColor];
        [bgView addSubview:timeL];

        CGFloat zanVX = SCREENWIDTH - 100;
        UIImageView *zanV = [[UIImageView alloc] initWithFrame:CGRectMake(zanVX, timeLY, 20, 20)];
        zanV.backgroundColor = [UIColor clearColor];
        zanV.image = [UIImage imageNamed:@"icon_like"];
        zanV.userInteractionEnabled = YES;
        [bgView addSubview:zanV];
        
        CGFloat mesVX = SCREENWIDTH - 50;
        UIImageView *mesV = [[UIImageView alloc] initWithFrame:CGRectMake(mesVX, timeLY, 20, 20)];
        mesV.backgroundColor = [UIColor clearColor];
        mesV.image = [UIImage imageNamed:@"icon_comment"];
        mesV.userInteractionEnabled = YES;
        [bgView addSubview:mesV];
        
    }
    return self;
}

- (void)deletCell{
    
}

@end
