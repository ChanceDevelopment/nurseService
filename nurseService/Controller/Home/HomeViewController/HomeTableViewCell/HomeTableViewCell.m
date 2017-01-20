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
        
        self.backgroundColor = [UIColor colorWithWhite:237.0 / 255.0 alpha:1.0];
        
        CGFloat bgViewX = 0;
        CGFloat bgViewY = 10;
        CGFloat bgViewW = SCREENWIDTH;
        CGFloat bgViewH = cellsize.height - 2 * bgViewY;
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(bgViewX, bgViewY, bgViewW, bgViewH)];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.userInteractionEnabled = YES;
        [self addSubview:bgView];

        
        CGFloat headImageX = 10;
        CGFloat headImageY = 10;
        CGFloat headImageW = 35;
        CGFloat headImageH = 35;
        
        headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(headImageX, headImageY, headImageW, headImageH)];
        headImageView.backgroundColor = [UIColor clearColor];
        headImageView.layer.masksToBounds = YES;
        headImageView.image = [UIImage imageNamed:@"appIcon"];
        headImageView.contentMode = UIViewContentModeScaleAspectFill;
        headImageView.layer.borderWidth = 0.0;
        headImageView.layer.cornerRadius = headImageW / 2.0;
        headImageView.layer.masksToBounds = YES;
        [bgView addSubview:headImageView];
        
        
        CGFloat nameLX = CGRectGetMaxX(headImageView.frame) + 10;
        CGFloat nameLY = headImageY;
        CGFloat nameLW = SCREENWIDTH - 10 - nameLX;
        CGFloat namelH = headImageH;
        nameL = [[UILabel alloc] initWithFrame:CGRectMake(nameLX, nameLY, nameLW, headImageH)];
        nameL.userInteractionEnabled = YES;
        nameL.textColor = [UIColor colorWithRed:0.082 green:0.494 blue:0.984 alpha:1.00];
        nameL.text = @"张三";
        nameL.font = [UIFont systemFontOfSize:15.0];
        nameL.backgroundColor = [UIColor clearColor];
        [bgView addSubview:nameL];
        
        CGFloat titleLX = 10;
        CGFloat titleLY = CGRectGetMaxY(headImageView.frame) + 10;
        CGFloat titleLW = SCREENWIDTH - 2 * titleLX;
        CGFloat titleLH = 30;
        
        titleL = [[UILabel alloc] initWithFrame:CGRectMake(titleLX, titleLY, titleLW, titleLH)];
        titleL.textColor = [UIColor blackColor];
        titleL.text = @"骨科类护士";
        titleL.numberOfLines = 0;
        titleL.font = [UIFont systemFontOfSize:15.0];
        titleL.backgroundColor = [UIColor clearColor];
        [bgView addSubview:titleL];
        
//        CGFloat deletVX = SCREENWIDTH-15;
//        CGFloat deletVY = 5;
//        CGFloat deletVW = 10;
//        
//        UIImageView *deletV = [[UIImageView alloc] initWithFrame:CGRectMake(deletVX, deletVY, deletVW, deletVW)];
//        deletV.backgroundColor = [UIColor clearColor];
//        deletV.image = [UIImage imageNamed:@"icon_into_right"];
//        deletV.userInteractionEnabled = YES;
////        [bgView addSubview:deletV];
//        
//        UITapGestureRecognizer *deletTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deletCell)];
//        [deletV addGestureRecognizer:deletTap];
        
        CGFloat detailTextViewX = 10;
        CGFloat detailTextViewY = CGRectGetMaxY(titleL.frame) + 5;
        CGFloat detailTextViewH = 30;
        CGFloat detailTextViewW = SCREENWIDTH - 2 * detailTextViewX;

        detailTextView = [[UILabel alloc] initWithFrame:CGRectMake(detailTextViewX, detailTextViewY, detailTextViewW, detailTextViewH)];
        [bgView addSubview:detailTextView];
        detailTextView.backgroundColor = [UIColor clearColor];
        detailTextView.font = [UIFont systemFontOfSize:14.0];
        detailTextView.text = @"#################################################";
        detailTextView.userInteractionEnabled = NO;
        detailTextView.numberOfLines = 0;

        CGFloat timeLX = 10;
        CGFloat timeLY = bgViewH - 30 - 5;
        CGFloat timeLH = 30;
        CGFloat timeLW = 200;
        
        timeL = [[UILabel alloc] initWithFrame:CGRectMake(timeLX, timeLY, timeLW, timeLH)];
        timeL.textColor = [UIColor grayColor];
        timeL.text  = @"发布于08-14";
        timeL.font = [UIFont systemFontOfSize:13.0];
        timeL.backgroundColor = [UIColor clearColor];
        [bgView addSubview:timeL];

        CGFloat zanVX = SCREENWIDTH - 100;
        UIImageView *zanV = [[UIImageView alloc] initWithFrame:CGRectMake(zanVX, timeLY, 20, 20)];
        zanV.backgroundColor = [UIColor clearColor];
        zanV.image = [UIImage imageNamed:@"icon_like"];
        zanV.hidden = YES;
        zanV.userInteractionEnabled = YES;
        [bgView addSubview:zanV];

        self.zanLabel = [[UILabel alloc]initWithFrame:CGRectMake(zanVX+22, timeLY, 200, 20)];
        self.zanLabel.text = @"1";
        self.zanLabel.hidden = YES;
        _zanLabel.textColor = [UIColor grayColor];
        _zanLabel.font = [UIFont systemFontOfSize:14.0];
        _zanLabel.backgroundColor = [UIColor clearColor];
        [bgView addSubview:_zanLabel];
        
        CGFloat mesVX = SCREENWIDTH - 50;
        UIImageView *mesV = [[UIImageView alloc] initWithFrame:CGRectMake(mesVX, timeLY, 20, 20)];
        mesV.backgroundColor = [UIColor clearColor];
        mesV.hidden = YES;
        mesV.image = [UIImage imageNamed:@"icon_comment"];
        mesV.userInteractionEnabled = YES;
        [bgView addSubview:mesV];
        self.commentLabel = [[UILabel alloc]initWithFrame:CGRectMake(mesVX+22, timeLY, 200, 20)];
        self.commentLabel.text = @"1";
        self.commentLabel.hidden = YES;
        _commentLabel.textColor = [UIColor grayColor];
        _commentLabel.font = [UIFont systemFontOfSize:14.0];
        _commentLabel.backgroundColor = [UIColor clearColor];
        [bgView addSubview:_commentLabel];
        
    }
    return self;
}

- (void)deletCell{
    
}

- (void)drawRect:(CGRect)rect
{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    
    //上分割线，
    CGContextSetStrokeColorWithColor(context, ([UIColor clearColor]).CGColor);
    CGContextStrokeRect(context, CGRectMake(0, -1, rect.size.width, 1));
    
    //下分割线
    CGContextSetStrokeColorWithColor(context, ([UIColor clearColor]).CGColor);
    CGContextStrokeRect(context, CGRectMake(0, rect.size.height, rect.size.width, 1));
}

@end
