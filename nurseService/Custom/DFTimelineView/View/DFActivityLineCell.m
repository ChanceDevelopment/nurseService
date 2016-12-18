
//
//  DFActivityLineCell.m
//  huayoutong
//
//  Created by Tony on 16/3/8.
//  Copyright © 2016年 HeDongMing. All rights reserved.
//

#import "DFActivityLineCell.h"
#import "DFTextImageLineCell.h"
#import "DFTextImageLineItem.h"
#import "DFActivityLineItem.h"

#import "MLLabel+Size.h"

#import "DFGridImageView.h"


#import "NSString+MLExpression.h"

#import "DFFaceManager.h"


#define TextFont [UIFont systemFontOfSize:14]
#define ActivityIconFont [UIFont fontWithName:@"Helvetica" size:13.0]
#define ContactFont [UIFont fontWithName:@"Helvetica" size:15.0]



#define TextLineHeight 1.2f

#define TextImageSpace 10

#define GridMaxWidth (BodyMaxWidth)*0.85

@interface DFActivityLineCell()

@property (strong, nonatomic) UILabel *activityIconLabel;
@property (strong, nonatomic) MLLinkLabel *textContentLabel;
@property (strong, nonatomic) MLLinkLabel *activityTimeLabel;
@property (strong, nonatomic) MLLinkLabel *activityAddressLabel;
@property (strong, nonatomic) MLLinkLabel *activityPhoneLabel;

@property (strong, nonatomic) DFGridImageView *gridImageView;

@end

@implementation DFActivityLineCell

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
    
    if (_activityIconLabel == nil) {
        
        _activityIconLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
        _activityIconLabel.backgroundColor = [UIColor colorWithRed:104.0 / 255.0 green:189.0 / 255.0 blue:43.0 / 255.0 alpha:1.0];
        _activityIconLabel.text = @"活动";
        _activityIconLabel.layer.cornerRadius = 7.0;
        _activityIconLabel.layer.masksToBounds = YES;
        _activityIconLabel.layer.borderWidth = 0;
        _activityIconLabel.layer.borderColor = [UIColor clearColor].CGColor;
        _activityIconLabel.textAlignment = NSTextAlignmentCenter;
        _activityIconLabel.textColor = [UIColor whiteColor];
        _activityIconLabel.font = ActivityIconFont;
//        _activityIconLabel.numberOfLines = 0;
//        _activityIconLabel.adjustsFontSizeToFitWidth = NO;
//        _activityIconLabel.textInsets = UIEdgeInsetsZero;
//        
//        _activityIconLabel.dataDetectorTypes = MLDataDetectorTypeAll;
//        _activityIconLabel.allowLineBreakInsideLinks = NO;
//        _activityIconLabel.linkTextAttributes = nil;
//        _activityIconLabel.activeLinkTextAttributes = nil;
//        _activityIconLabel.lineHeightMultiple = 0;
//        _activityIconLabel.linkTextAttributes = @{NSForegroundColorAttributeName: HighLightTextColor};
//        UILabel *tipLabel = [[UILabel alloc] ini]
        
//        [_activityIconLabel setDidClickLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
//            NSString *tips = [NSString stringWithFormat:@"Click\nlinkType:%ld\nlinkText:%@\nlinkValue:%@",(unsigned long)link.linkType,linkText,link.linkValue];
//            NSLog(@"%@", tips);
//        }];
        
        
        [self.bodyView addSubview:_activityIconLabel];
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
        
        __weak DFActivityLineCell *weakSelf = self;
        [_textContentLabel setDidClickLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
            NSString *tips = [NSString stringWithFormat:@"Click\nlinkType:%ld\nlinkText:%@\nlinkValue:%@",(unsigned long)link.linkType,linkText,link.linkValue];
            NSLog(@"%@", tips);
            NSNumber *linkTye = [NSNumber numberWithInteger:link.linkType];
            [[NSNotificationCenter defaultCenter] postNotificationName:LinkNOTIFICATION object:weakSelf userInfo:@{LINKVALUEKey:link.linkValue,LINKTypeKey:linkTye}];
        }];
        
        
        [self.bodyView addSubview:_textContentLabel];
    }
    
    if (_activityTimeLabel == nil) {
        
        _activityTimeLabel =[[MLLinkLabel alloc] initWithFrame:CGRectZero];
        _activityTimeLabel.font = ContactFont;
        _activityTimeLabel.numberOfLines = 1;
        _activityTimeLabel.adjustsFontSizeToFitWidth = NO;
        _activityTimeLabel.textInsets = UIEdgeInsetsZero;
        
        _activityTimeLabel.dataDetectorTypes = MLDataDetectorTypeAll;
        _activityTimeLabel.allowLineBreakInsideLinks = NO;
        _activityTimeLabel.linkTextAttributes = nil;
        _activityTimeLabel.activeLinkTextAttributes = nil;
        _activityTimeLabel.lineHeightMultiple = TextLineHeight;
        _activityTimeLabel.linkTextAttributes = @{NSForegroundColorAttributeName: HighLightTextColor};
        
        UIImageView *timeIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"activity_timeIcon"]];
        timeIcon.frame = CGRectZero;
        timeIcon.tag = -1;
        [_activityTimeLabel addSubview:timeIcon];
        
        __weak DFActivityLineCell *weakSelf = self;
        [_activityTimeLabel setDidClickLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
            NSString *tips = [NSString stringWithFormat:@"Click\nlinkType:%ld\nlinkText:%@\nlinkValue:%@",(unsigned long)link.linkType,linkText,link.linkValue];
            NSLog(@"%@", tips);
            NSNumber *linkTye = [NSNumber numberWithInteger:link.linkType];
            [[NSNotificationCenter defaultCenter] postNotificationName:LinkNOTIFICATION object:weakSelf userInfo:@{LINKVALUEKey:link.linkValue,LINKTypeKey:linkTye}];
        }];
        
        
        [self.bodyView addSubview:_activityTimeLabel];
    }
    
    if (_activityAddressLabel == nil) {
        
        _activityAddressLabel =[[MLLinkLabel alloc] initWithFrame:CGRectZero];
        _activityAddressLabel.font = ContactFont;
        _activityAddressLabel.numberOfLines = 2;
        _activityAddressLabel.adjustsFontSizeToFitWidth = NO;
        _activityAddressLabel.textInsets = UIEdgeInsetsZero;
        
        _activityAddressLabel.dataDetectorTypes = MLDataDetectorTypeAll;
        _activityAddressLabel.allowLineBreakInsideLinks = NO;
        _activityAddressLabel.linkTextAttributes = nil;
        _activityAddressLabel.activeLinkTextAttributes = nil;
        _activityAddressLabel.lineHeightMultiple = TextLineHeight;
        _activityAddressLabel.linkTextAttributes = @{NSForegroundColorAttributeName: HighLightTextColor};
        
        UIImageView *addressIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"activity_addressIcon"]];
        addressIcon.frame = CGRectZero;
        addressIcon.tag = -1;
        [_activityAddressLabel addSubview:addressIcon];
        
        __weak DFActivityLineCell *weakSelf = self;
        [_activityAddressLabel setDidClickLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
            NSString *tips = [NSString stringWithFormat:@"Click\nlinkType:%ld\nlinkText:%@\nlinkValue:%@",(unsigned long)link.linkType,linkText,link.linkValue];
            NSLog(@"%@", tips);
            NSNumber *linkTye = [NSNumber numberWithInteger:link.linkType];
            [[NSNotificationCenter defaultCenter] postNotificationName:LinkNOTIFICATION object:weakSelf userInfo:@{LINKVALUEKey:link.linkValue,LINKTypeKey:linkTye}];
        }];
        
        
        [self.bodyView addSubview:_activityAddressLabel];
    }
    
    if (_activityPhoneLabel == nil) {
        
        _activityPhoneLabel =[[MLLinkLabel alloc] initWithFrame:CGRectZero];
        _activityPhoneLabel.font = ContactFont;
        _activityPhoneLabel.numberOfLines = 1;
        _activityPhoneLabel.adjustsFontSizeToFitWidth = NO;
        _activityPhoneLabel.textInsets = UIEdgeInsetsZero;
        
        _activityPhoneLabel.dataDetectorTypes = MLDataDetectorTypePhoneNumber;
        _activityPhoneLabel.dataDetectorTypesOfAttributedLinkValue = MLLinkTypeOther;
        
        _activityPhoneLabel.allowLineBreakInsideLinks = NO;
        _activityPhoneLabel.linkTextAttributes = nil;
        _activityPhoneLabel.activeLinkTextAttributes = nil;
        _activityPhoneLabel.lineHeightMultiple = TextLineHeight;
        _activityPhoneLabel.linkTextAttributes = @{NSForegroundColorAttributeName: HighLightTextColor};
        
        UIImageView *phoneIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"activity_phoneIcon"]];
        phoneIcon.frame = CGRectZero;
        phoneIcon.tag = -1;
        [_activityPhoneLabel addSubview:phoneIcon];
        
        __weak DFActivityLineCell *weakSelf = self;
        [_activityPhoneLabel setDidClickLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
            NSString *tips = [NSString stringWithFormat:@"Click\nlinkType:%ld\nlinkText:%@\nlinkValue:%@",(unsigned long)link.linkType,linkText,link.linkValue];
            NSLog(@"%@", tips);
            NSNumber *linkTye = [NSNumber numberWithInteger:link.linkType];
            [[NSNotificationCenter defaultCenter] postNotificationName:LinkNOTIFICATION object:weakSelf userInfo:@{LINKVALUEKey:link.linkValue,LINKTypeKey:linkTye}];
        }];
        
        
        [self.bodyView addSubview:_activityPhoneLabel];
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


-(void)updateWithItem:(DFActivityLineItem *)item
{
    [super updateWithItem:item];
    
    NSLog(@"%@",item.likesStr);
    //活动图标的size
    NSAttributedString *activityIconText = [[NSAttributedString alloc] initWithString:item.activityIconText];
    if (item.activityIconText == nil) {
        activityIconText = [[NSAttributedString alloc] initWithString:@""];
    }
    CGSize activityIconSize = [MLLinkLabel getViewSize:activityIconText maxWidth:BodyMaxWidth font:ActivityIconFont lineHeight:TextLineHeight lines:0];
    activityIconSize.height = 20;
//    _activityIconLabel.text = activityIconText;
    [_activityIconLabel sizeToFit];
    
    _activityIconLabel.frame = CGRectMake(0, 0, 50, activityIconSize.height);
    
    //活动标题的size
    CGSize textSize = [MLLinkLabel getViewSize:item.attrText maxWidth:BodyMaxWidth font:TextFont lineHeight:TextLineHeight lines:0];
    
    _textContentLabel.attributedText = item.attrText;
    [_textContentLabel sizeToFit];
    
    _textContentLabel.frame = CGRectMake(0, CGRectGetMaxY(_activityIconLabel.frame), BodyMaxWidth, textSize.height);
    
    //活动时间的size
    NSAttributedString *activityTimeText = [[NSAttributedString alloc] initWithString:item.activityDate];
    if (item.activityDate == nil) {
        activityTimeText = [[NSAttributedString alloc] initWithString:@""];
    }
    CGSize activityDateSize = [MLLinkLabel getViewSize:activityTimeText maxWidth:BodyMaxWidth font:ContactFont lineHeight:TextLineHeight lines:0];
    if (item.activityDate == nil || [item.activityDate isEqualToString:[NSString stringWithFormat:@"%@",EMPTYSTRING]]){
        activityDateSize.height = 0;
        _activityTimeLabel.hidden = YES;
    }
    
    _activityTimeLabel.attributedText = activityTimeText;
    [_activityTimeLabel sizeToFit];
    
    _activityTimeLabel.frame = CGRectMake(0, CGRectGetMaxY(_textContentLabel.frame), BodyMaxWidth, activityDateSize.height);
    
    CGFloat imageW = 20;
    CGFloat imageH = 20;
    CGFloat imageX = 0;
    CGFloat imageY = (activityDateSize.height - imageH) / 2.0 + 2;
    UIImageView *timeIcon = [_activityTimeLabel viewWithTag:-1];
    timeIcon.frame = CGRectMake(imageX, imageY, imageW, imageH);
    
    //活动地址的size
    NSAttributedString *activityAddressText = [[NSAttributedString alloc] initWithString:item.activityAddress];
    if (item.activityAddress == nil) {
        activityAddressText = [[NSAttributedString alloc] initWithString:@""];
    }
    CGSize activityAddressSize = [MLLinkLabel getViewSize:activityAddressText maxWidth:BodyMaxWidth font:ContactFont lineHeight:TextLineHeight lines:0];
    if (item.activityAddress == nil || [item.activityAddress isEqualToString:[NSString stringWithFormat:@"%@",EMPTYSTRING]]){
        activityDateSize.height = 0;
        _activityAddressLabel.hidden = YES;
    }
    _activityAddressLabel.attributedText = activityAddressText;
    [_activityAddressLabel sizeToFit];
    
    _activityAddressLabel.frame = CGRectMake(0, CGRectGetMaxY(_activityTimeLabel.frame), BodyMaxWidth, activityAddressSize.height);
    
    imageY = (activityDateSize.height - imageH) / 2.0 + 2;
    UIImageView *addressIcon = [_activityAddressLabel viewWithTag:-1];
    addressIcon.frame = CGRectMake(imageX, imageY, imageW, imageH);
    
    //活动联系人电话的size
    NSAttributedString *activityPhoneText = [[NSAttributedString alloc] initWithString:item.activityContactPhone];
    if (item.activityContactPhone == nil || [item.activityContactPhone isEqualToString:[NSString stringWithFormat:@"%@:",EMPTYSTRING]]) {
        activityPhoneText = [[NSAttributedString alloc] initWithString:@""];
    }
    CGSize activityPhoneSize = [MLLinkLabel getViewSize:activityPhoneText maxWidth:BodyMaxWidth font:ContactFont lineHeight:TextLineHeight lines:0];
    if (item.activityContactPhone == nil || [item.activityContactPhone isEqualToString:[NSString stringWithFormat:@"%@",EMPTYSTRING]]){
        activityPhoneSize.height = 0;
        _activityPhoneLabel.hidden = YES;
    }
    _activityPhoneLabel.attributedText = activityPhoneText;
    [_activityPhoneLabel sizeToFit];
    
    _activityPhoneLabel.frame = CGRectMake(0, CGRectGetMaxY(_activityAddressLabel.frame), BodyMaxWidth, activityPhoneSize.height);
    
    imageY = (activityPhoneSize.height - imageH) / 2.0 + 2;
    UIImageView *phoneIcon = [_activityPhoneLabel viewWithTag:-1];
    phoneIcon.frame = CGRectMake(imageX, imageY, imageW, imageH);
    
    CGFloat gridHeight = [DFGridImageView getHeight:item.thumbImages maxWidth:GridMaxWidth oneImageWidth:item.width oneImageHeight:item.height];
    
    CGFloat x, y, width, height;
    x = _gridImageView.frame.origin.x;
    y = CGRectGetMaxY(_activityPhoneLabel.frame) + TextImageSpace;
    width = _gridImageView.frame.size.width;
    height = gridHeight;
    _gridImageView.frame = CGRectMake(x, y, width, height);
    
    [_gridImageView updateWithImages:item.thumbImages srcImages:item.srcImages oneImageWidth:item.width oneImageHeight:item.height];
    
    [self updateBodyView:(activityIconSize.height + textSize.height + activityDateSize.height + activityAddressSize.height + activityPhoneSize.height + gridHeight + TextImageSpace)];
    
}


+(CGFloat)getCellHeight:(DFActivityLineItem *)item
{
    //活动图标的size
    NSAttributedString *activityIconText = [[NSAttributedString alloc] initWithString:item.activityIconText];
    if (item.activityIconText == nil) {
        activityIconText = [item.activityIconText expressionAttributedStringWithExpression:[[DFFaceManager sharedInstance] sharedMLExpression]];
    }
    CGSize activityIconSize = [MLLinkLabel getViewSize:activityIconText maxWidth:BodyMaxWidth font:ActivityIconFont lineHeight:TextLineHeight lines:0];
    
    
    
    //活动标题的size
    if (item.attrText == nil) {
        item.attrText  = [item.text expressionAttributedStringWithExpression:[[DFFaceManager sharedInstance] sharedMLExpression]];
    }
    
    CGSize textSize = [MLLinkLabel getViewSize:item.attrText maxWidth:BodyMaxWidth font:TextFont lineHeight:TextLineHeight lines:0];
    
    //活动时间的size
    NSAttributedString *activityTimeText = [[NSAttributedString alloc] initWithString:item.activityDate];
    if (item.activityDate == nil) {
        activityTimeText = [item.activityDate expressionAttributedStringWithExpression:[[DFFaceManager sharedInstance] sharedMLExpression]];
    }
    CGSize activityDateSize = [MLLinkLabel getViewSize:activityTimeText maxWidth:BodyMaxWidth font:ContactFont lineHeight:TextLineHeight lines:0];
    
    
    
    //活动地址的size
    NSAttributedString *activityAddressText = [[NSAttributedString alloc] initWithString:item.activityAddress];
    if (item.activityAddress == nil) {
        activityAddressText = [item.activityAddress expressionAttributedStringWithExpression:[[DFFaceManager sharedInstance] sharedMLExpression]];
    }
    CGSize activityAddressSize = [MLLinkLabel getViewSize:activityAddressText maxWidth:BodyMaxWidth font:ContactFont lineHeight:TextLineHeight lines:0];
    
    
    //活动联系人电话的size
    NSAttributedString *activityPhoneText = [[NSAttributedString alloc] initWithString:item.activityContactPhone];
    if (item.activityContactPhone == nil) {
        activityPhoneText = activityAddressText = [item.activityDate expressionAttributedStringWithExpression:[[DFFaceManager sharedInstance] sharedMLExpression]];
    }
    CGSize activityPhoneSize = [MLLinkLabel getViewSize:activityPhoneText maxWidth:BodyMaxWidth font:ContactFont lineHeight:TextLineHeight lines:0];
    
    //基本资料的高度包括点赞评论
    CGFloat height = [DFBaseLineCell getCellHeight:item];
    
    //图片区域的高度
    CGFloat gridHeight = [DFGridImageView getHeight:item.thumbImages maxWidth:GridMaxWidth oneImageWidth:item.width oneImageHeight:item.height];
    
    return height +activityIconSize.height + textSize.height + activityDateSize.height + activityAddressSize.height + activityPhoneSize.height +  gridHeight + TextImageSpace;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
