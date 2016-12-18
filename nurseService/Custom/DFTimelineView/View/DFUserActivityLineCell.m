//
//  DFTextImageLineCell.m
//  DFTimelineView
//
//  Created by Allen Zhong on 15/9/27.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFUserActivityLineCell.h"
#import "DFTextImageLineItem.h"

#import "MLLabel+Size.h"

#import "DFGridImageView.h"


#import "NSString+MLExpression.h"

#import "DFFaceManager.h"
#import "Tool.h"
#import "DFToolUtil.h"

#define TextFont [UIFont systemFontOfSize:14]

#define TextLineHeight 1.2f

#define TextImageSpace 10

#define GridMaxWidth (BodyMaxWidth)*0.85

@interface DFUserActivityLineCell()

@property (strong, nonatomic) MLLinkLabel *textContentLabel;

@property (strong, nonatomic) DFGridImageView *gridImageView;

@property (strong, nonatomic) MLLinkLabel *dateLabel;

@end


@implementation DFUserActivityLineCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initCell];
    }
    return self;
}


-(void) initCell
{
    self.userAvatarView.hidden = YES;
    self.userAvatarButton.hidden = YES;
    
    self.userNickLabel.font = [UIFont systemFontOfSize:15.0];
    self.userNickLabel.textColor = [UIColor redColor];
    
    if (_dateLabel == nil) {
        
        _dateLabel =[[MLLinkLabel alloc] initWithFrame:CGRectMake(self.userAvatarView.frame.origin.x, self.userNickLabel.frame.origin.y, self.userAvatarView.frame.size.width, self.userNickLabel.frame.size.height)];
        _dateLabel.font = [UIFont systemFontOfSize:20];
        _dateLabel.numberOfLines = 1;
        _dateLabel.adjustsFontSizeToFitWidth = NO;
        _dateLabel.textInsets = UIEdgeInsetsMake(0, 0, 2, 0);
        _dateLabel.textColor = [UIColor blackColor];
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        _dateLabel.dataDetectorTypes = MLDataDetectorTypeNone;
        _dateLabel.allowLineBreakInsideLinks = NO;
        _dateLabel.linkTextAttributes = nil;
        _dateLabel.activeLinkTextAttributes = nil;
        _dateLabel.lineHeightMultiple = TextLineHeight;
        _dateLabel.linkTextAttributes = @{NSForegroundColorAttributeName: HighLightTextColor};
        [self.contentView addSubview:_dateLabel];
    }
    
    if (_textContentLabel == nil) {
        
        _textContentLabel =[[MLLinkLabel alloc] initWithFrame:CGRectZero];
        _textContentLabel.font = TextFont;
        _textContentLabel.numberOfLines = 0;
        _textContentLabel.adjustsFontSizeToFitWidth = NO;
        _textContentLabel.textInsets = UIEdgeInsetsZero;
        
        _textContentLabel.dataDetectorTypes = MLDataDetectorTypeAll;
        _textContentLabel.allowLineBreakInsideLinks = NO;
        _textContentLabel.linkTextAttributes = nil;
        _textContentLabel.activeLinkTextAttributes = nil;
        _textContentLabel.lineHeightMultiple = TextLineHeight;
        _textContentLabel.linkTextAttributes = @{NSForegroundColorAttributeName: HighLightTextColor};
        
        __weak DFUserActivityLineCell *weakSelf = self;
        [_textContentLabel setDidClickLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
            NSString *tips = [NSString stringWithFormat:@"Click\nlinkType:%ld\nlinkText:%@\nlinkValue:%@",(unsigned long)link.linkType,linkText,link.linkValue];
            NSLog(@"%@", tips);
            NSNumber *linkTye = [NSNumber numberWithInteger:link.linkType];
            [[NSNotificationCenter defaultCenter] postNotificationName:LinkNOTIFICATION object:weakSelf userInfo:@{LINKVALUEKey:link.linkValue,LINKTypeKey:linkTye}];
        }];
        
        
        [self.bodyView addSubview:_textContentLabel];
    }
    
    if (_gridImageView == nil) {
        
        CGFloat x, y , width, height;
        
        x = 0;
        y = 0;
        width = GridMaxWidth;
        height = width;
        
        _gridImageView = [[DFGridImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        [self.bodyView addSubview:_gridImageView];
    }
    
}


-(void)updateWithItem:(DFTextImageLineItem *)item
{
    [super updateWithItem:item];
    
    long long dateline = item.ts / 1000;
    
    NSString *datelineStr = [NSString stringWithFormat:@"%lld",dateline];
    _dateLabel.text = [NSString stringWithFormat:@"%@  ",[Tool compareCurrentTime:datelineStr]];
    
    
    self.userNickLabel.text = [DFToolUtil FormatTime:@"HH:mm" timeInterval:item.ts];
    CGSize nickSize = [MLLinkLabel getViewSize:[[NSMutableAttributedString alloc] initWithString:self.userNickLabel.text] maxWidth:BodyMaxWidth font:self.userNickLabel.font lineHeight:self.userNickLabel.frame.size.height lines:1];
    if (nickSize.width < self.userNickLabel.frame.size.width) {
        nickSize.width = self.userNickLabel.frame.size.width;
    }
    
    
    CGSize dateSize = [MLLinkLabel getViewSize:[[NSMutableAttributedString alloc] initWithString:_dateLabel.text] maxWidth:BodyMaxWidth font:_dateLabel.font lineHeight:_dateLabel.frame.size.height lines:1];
    if (dateSize.width < _dateLabel.frame.size.width) {
        dateSize.width = _dateLabel.frame.size.width;
    }
    _dateLabel.frame = CGRectMake(self.userAvatarView.frame.origin.x, self.userNickLabel.frame.origin.y - 3, dateSize.width, self.userNickLabel.frame.size.height);
    _dateLabel.textAlignment = NSTextAlignmentLeft;
    CGRect frame = self.userNickLabel.frame;
    
    frame.size.width = nickSize.width;
    frame.origin.x = _dateLabel.frame.origin.x + dateSize.width + 5;
    self.userNickLabel.frame = frame;
    
    CGSize textSize = [MLLinkLabel getViewSize:item.attrText maxWidth:BodyMaxWidth font:TextFont lineHeight:TextLineHeight lines:0];
    
    _textContentLabel.attributedText = item.attrText;
    [_textContentLabel sizeToFit];
    
    _textContentLabel.frame = CGRectMake(0, 0, BodyMaxWidth, textSize.height);
    
    CGFloat gridHeight = [DFGridImageView getHeight:item.thumbImages maxWidth:GridMaxWidth oneImageWidth:item.width oneImageHeight:item.height];
    
    
    CGFloat x, y, width, height;
    x = _gridImageView.frame.origin.x;
    y = CGRectGetMaxY(_textContentLabel.frame)+TextImageSpace;
    width = _gridImageView.frame.size.width;
    height = gridHeight;
    _gridImageView.frame = CGRectMake(x, y, width, height);
    
    [_gridImageView updateWithImages:item.thumbImages srcImages:item.srcImages oneImageWidth:item.width oneImageHeight:item.height];
    
    [self updateBodyView:(textSize.height+gridHeight+TextImageSpace)];
    
}


+(CGFloat)getCellHeight:(DFTextImageLineItem *)item
{
    if (item.attrText == nil) {
        item.attrText  = [item.text expressionAttributedStringWithExpression:[[DFFaceManager sharedInstance] sharedMLExpression]];
    }
    
    CGSize textSize = [MLLinkLabel getViewSize:item.attrText maxWidth:BodyMaxWidth font:TextFont lineHeight:TextLineHeight lines:0];
    
    CGFloat height = [DFBaseLineCell getCellHeight:item];
    
    CGFloat gridHeight = [DFGridImageView getHeight:item.thumbImages maxWidth:GridMaxWidth oneImageWidth:item.width oneImageHeight:item.height];
    
    return height+textSize.height + gridHeight+TextImageSpace;
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com