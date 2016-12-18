//
//  DFLikeJoinView.m
//  huayoutong
//
//  Created by HeDongMing on 16/4/13.
//  Copyright © 2016年 HeDongMing. All rights reserved.
//

#import "DFLikeJoinView.h"
#import "Const.h"
#import "MLClickColorLinkLabel.h"
#import "MLLabel+Size.h"

#define TopMargin 3
#define BottomMargin 3

#define LikeJoinLabelFont [UIFont systemFontOfSize:13]
#define JoinBgRadius 3.0

#define LikeLabelLineHeight 1.1f

#define LikeIconSize 15
#define LikeIconLeftMargin 5
#define LikeIconTopMargin 5

#define LikeLabelIconSpace 5
#define LikeLabelRightMargin 10

#define JoinDetailLabelFont [UIFont systemFontOfSize:14]

#define JoinDetailLabelLineHeight 1.2f


#define JoinDetailLabelMargin 10

#define NumDetailSpace 5

#define LinkLabelTag 100

@interface DFLikeJoinView()
@property (nonatomic, strong) UIView *JoinBg;
@property (strong, nonatomic) MLLinkLabel *jointotalNumLabel;
@property (strong, nonatomic) UIImageView *joinIconView;
@property (strong, nonatomic) MLLinkLabel *joinDetailLabel;
@property (strong, nonatomic) UIView *divider;
@property (strong, nonatomic) NSMutableArray *joinLabels;

@end

@implementation DFLikeJoinView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _joinLabels = [NSMutableArray array];
        
        [self initView];
    }
    return self;
}

- (void)initView
{
    CGFloat x,y,width,height;
    
    if (_JoinBg == nil) {
        x = 0;
        y = 0;
        width = self.frame.size.width;
        height = self.frame.size.height;
        
        _JoinBg = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        _JoinBg.backgroundColor = [UIColor colorWithWhite:237.0 / 255.0 alpha:1.0];
        _JoinBg.layer.borderWidth = 0;
        _JoinBg.layer.cornerRadius = JoinBgRadius;
        [self addSubview:_JoinBg];
    }
    
    if (_joinIconView == nil) {
        x = LikeIconLeftMargin;
        y = LikeIconTopMargin;
        width = LikeIconSize;
        height = width;
        _joinIconView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        _joinIconView.image = [UIImage imageNamed:@"attend_disabled"];
        [self addSubview:_joinIconView];
    }
    
    if (_jointotalNumLabel == nil) {
        
        _jointotalNumLabel =[[MLLinkLabel alloc] initWithFrame:CGRectZero];
        _jointotalNumLabel.font = LikeJoinLabelFont;
        _jointotalNumLabel.numberOfLines = 1;
        _jointotalNumLabel.adjustsFontSizeToFitWidth = NO;
        _jointotalNumLabel.textInsets = UIEdgeInsetsZero;
        
        _jointotalNumLabel.dataDetectorTypes = MLDataDetectorTypeAll;
        _jointotalNumLabel.allowLineBreakInsideLinks = NO;
        _jointotalNumLabel.linkTextAttributes = nil;
        _jointotalNumLabel.activeLinkTextAttributes = nil;
        _jointotalNumLabel.lineHeightMultiple = LikeLabelLineHeight;
        _jointotalNumLabel.linkTextAttributes = @{NSForegroundColorAttributeName: HighLightTextColor};
        [self addSubview:_jointotalNumLabel];
    }
    
    
    if (_divider == nil) {
        _divider = [[UIView alloc] initWithFrame:CGRectZero];
        _divider.backgroundColor = [UIColor colorWithWhite:225.0 / 255.0 alpha:1.0];
        [self addSubview:_divider];
    }
    
    if (_joinDetailLabel == nil) {
        
        _joinDetailLabel =[[MLLinkLabel alloc] initWithFrame:CGRectZero];
        _joinDetailLabel.font = LikeJoinLabelFont;
        _joinDetailLabel.numberOfLines = 0;
        _joinDetailLabel.adjustsFontSizeToFitWidth = NO;
        _joinDetailLabel.textInsets = UIEdgeInsetsZero;
        
        _joinDetailLabel.dataDetectorTypes = MLDataDetectorTypeAll;
        _joinDetailLabel.allowLineBreakInsideLinks = NO;
        _joinDetailLabel.linkTextAttributes = nil;
        _joinDetailLabel.activeLinkTextAttributes = nil;
        _joinDetailLabel.lineHeightMultiple = LikeLabelLineHeight;
        _joinDetailLabel.linkTextAttributes = @{NSForegroundColorAttributeName: HighLightTextColor};
        [self addSubview:_joinDetailLabel];
    }
}

-(void)layoutSubviews
{
    CGFloat x,y,width,height;
    x = 0;
    y = 0;
    width = self.frame.size.width;
    height = self.frame.size.height;
    
    _JoinBg.frame = CGRectMake(x, y, width, height);
    
}

-(void) updateWithItem:(DFBaseLineItem *) item
{
    CGFloat x, y, width, height;
    
    
    
    _divider.hidden = YES;
    
    if (item.joins.count > 0) {
        
        _joinDetailLabel.hidden = NO;
        _jointotalNumLabel.hidden = NO;
        _joinIconView.hidden = NO;
        
        _joinLabels = [[NSMutableArray alloc] initWithArray:item.joins];
        
        x = LikeIconLeftMargin + LikeIconSize + LikeLabelIconSpace;
        y = TopMargin;
        width = self.frame.size.width - x - LikeLabelRightMargin;
        
        NSString *joinNum = [NSString stringWithFormat:@":%ld人已参加",[item.joins count]];
        NSMutableAttributedString *joinsNmuStr = [[NSMutableAttributedString alloc] initWithString:joinNum attributes:@{NSForegroundColorAttributeName: HighLightTextColor}];
        
        _jointotalNumLabel.attributedText = joinsNmuStr;
        
        [_jointotalNumLabel sizeToFit];
        
        CGSize textSize = [MLLinkLabel getViewSize:joinsNmuStr maxWidth:width font:LikeJoinLabelFont lineHeight:LikeLabelLineHeight lines:1];
        _jointotalNumLabel.frame = CGRectMake(x, y, width, textSize.height);
        
        
        //显示分割线
        y = CGRectGetMaxY(_jointotalNumLabel.frame) + NumDetailSpace;
        _divider.hidden = NO;
        _divider.frame = CGRectMake(0, y, self.frame.size.width, 0.5);
        
        //显示参加人详情
        x = LikeIconLeftMargin + LikeLabelIconSpace;
        y = CGRectGetMaxY(_jointotalNumLabel.frame) + 2 * NumDetailSpace;
        width = self.frame.size.width - x - LikeLabelRightMargin;
        _joinDetailLabel.attributedText = item.joinStr;
        
        [_joinDetailLabel sizeToFit];
        
        textSize = [MLLinkLabel getViewSize:item.joinStr maxWidth:width font:LikeJoinLabelFont lineHeight:LikeLabelLineHeight lines:0];
        _joinDetailLabel.frame = CGRectMake(x, y, width, textSize.height);
        
    }
    
}

+(CGFloat) getHeight:(DFBaseLineItem *)item maxWidth:(CGFloat)maxWidth
{
    CGFloat height = TopMargin + 3 * NumDetailSpace;
    if ([item.joins count] == 0) {
        return 0.0;
    }
    
    if (item.joins.count > 0) {
        
        CGFloat width = maxWidth -  LikeIconLeftMargin - LikeIconSize - LikeLabelIconSpace - LikeLabelRightMargin;
        
        NSString *joinNum = [NSString stringWithFormat:@"%@%ld人已参加",EMPTYSTRING,[item.joins count]];
        NSMutableAttributedString *joinsNmuStr = [[NSMutableAttributedString alloc] initWithString:joinNum attributes:@{NSForegroundColorAttributeName: HighLightTextColor}];
        CGSize textSize = [MLLinkLabel getViewSize:joinsNmuStr maxWidth:width font:LikeJoinLabelFont lineHeight:LikeLabelLineHeight lines:1];
        
        height+= textSize.height;
    }
    
    if (item.joins.count > 0) {
        CGFloat width = maxWidth - JoinDetailLabelMargin * 2;
        CGSize textSize = [MLLinkLabel getViewSize:item.joinStr maxWidth:width font:LikeJoinLabelFont lineHeight:LikeLabelLineHeight lines:0];
        height += textSize.height;
        
        
        height += BottomMargin;
    }
    
    return height;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
