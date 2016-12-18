//
//  DFActivityDetailLineCell.m
//  huayoutong
//
//  Created by HeDongMing on 16/4/12.
//  Copyright © 2016年 HeDongMing. All rights reserved.
//

#import "DFUserNewsActivityDetailLineCell.h"
#import "DFTextImageLineCell.h"
#import "DFTextImageLineItem.h"
#import "DFActivityDetailLineItem.h"

#import "MLLabel+Size.h"

#import "DFGridImageView.h"


#import "NSString+MLExpression.h"

#import "DFFaceManager.h"

#import "DFLikeJoinView.h"

#define TextFont [UIFont systemFontOfSize:14]
#define ActivityIconFont [UIFont fontWithName:@"Helvetica" size:13.0]
#define ContactFont [UIFont fontWithName:@"Helvetica" size:15.0]



#define TextLineHeight 1.2f

#define TextImageSpace 10

#define JoinViewSpace 10

#define GridMaxWidth (BodyMaxWidth)*0.85

@interface DFUserNewsActivityDetailLineCell()

@property (strong, nonatomic) UILabel *activityIconLabel;
@property (strong, nonatomic) MLLinkLabel *textContentLabel;
@property (strong, nonatomic) MLLinkLabel *activityTimeLabel;
@property (strong, nonatomic) MLLinkLabel *activityAddressLabel;
@property (strong, nonatomic) MLLinkLabel *activityPhoneLabel;
//收藏
@property (strong, nonatomic) MLLinkLabel *collectionActivityLabel;
//参加
@property (strong, nonatomic) MLLinkLabel *joinActivityLabel;
//@property (strong, nonatomic) UIButton *collectionActivityButton;
//@property (strong, nonatomic) UIButton *joinActivityButton;

@property (strong, nonatomic) DFGridImageView *gridImageView;
//参加人的详情View
@property (strong, nonatomic) DFLikeJoinView *joinView;

@property (strong,nonatomic)DFActivityDetailLineItem *myActivityItem;

@end

@implementation DFUserNewsActivityDetailLineCell


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
        
        __weak DFUserNewsActivityDetailLineCell *weakSelf = self;
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
        
        __weak DFUserNewsActivityDetailLineCell *weakSelf = self;
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
        
        __weak DFUserNewsActivityDetailLineCell *weakSelf = self;
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
        _activityPhoneLabel.allowLineBreakInsideLinks = NO;
        _activityPhoneLabel.linkTextAttributes = nil;
        _activityPhoneLabel.activeLinkTextAttributes = nil;
        _activityPhoneLabel.lineHeightMultiple = TextLineHeight;
        _activityPhoneLabel.linkTextAttributes = @{NSForegroundColorAttributeName: HighLightTextColor};
        
        UIImageView *phoneIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"activity_phoneIcon"]];
        phoneIcon.frame = CGRectZero;
        phoneIcon.tag = -1;
        [_activityPhoneLabel addSubview:phoneIcon];
        
        __weak DFUserNewsActivityDetailLineCell *weakSelf = self;
        [_activityPhoneLabel setDidClickLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
            NSString *tips = [NSString stringWithFormat:@"Click\nlinkType:%ld\nlinkText:%@\nlinkValue:%@",(unsigned long)link.linkType,linkText,link.linkValue];
            NSLog(@"%@", tips);
            NSNumber *linkTye = [NSNumber numberWithInteger:link.linkType];
            [[NSNotificationCenter defaultCenter] postNotificationName:LinkNOTIFICATION object:weakSelf userInfo:@{LINKVALUEKey:link.linkValue,LINKTypeKey:linkTye}];
        }];
        
        
        [self.bodyView addSubview:_activityPhoneLabel];
    }
    
    //收藏活动的按钮
    if (_collectionActivityLabel == nil) {
        _collectionActivityLabel =[[MLLinkLabel alloc] initWithFrame:CGRectZero];
        _collectionActivityLabel.font = ContactFont;
        _collectionActivityLabel.numberOfLines = 1;
        _collectionActivityLabel.adjustsFontSizeToFitWidth = NO;
        _collectionActivityLabel.textInsets = UIEdgeInsetsMake(-3, 0, 0, 0);
        _collectionActivityLabel.backgroundColor = [UIColor colorWithWhite:237.0 /255.0 alpha:1.0];
        _collectionActivityLabel.layer.cornerRadius = 3.0;
        _collectionActivityLabel.layer.masksToBounds = YES;
        _collectionActivityLabel.textColor = [UIColor grayColor];
        _collectionActivityLabel.dataDetectorTypes = MLDataDetectorTypeAll;
        _collectionActivityLabel.allowLineBreakInsideLinks = NO;
        _collectionActivityLabel.linkTextAttributes = nil;
        _collectionActivityLabel.activeLinkTextAttributes = nil;
        _collectionActivityLabel.lineHeightMultiple = TextLineHeight;
        _collectionActivityLabel.linkTextAttributes = @{NSForegroundColorAttributeName: HighLightTextColor};
        
        UITapGestureRecognizer *collectTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(collectActivityTap:)];
        collectTap.numberOfTapsRequired = 1;
        collectTap.numberOfTouchesRequired = 1;
        [_collectionActivityLabel addGestureRecognizer:collectTap];
        
        UIButton *collectionButton = [[UIButton alloc] init];
        [collectionButton setBackgroundImage:[UIImage imageNamed:@"collection_default"] forState:UIControlStateNormal];
        [collectionButton setBackgroundImage:[UIImage imageNamed:@"collection_disabled"] forState:UIControlStateSelected];
        collectionButton.frame = CGRectZero;
        collectionButton.tag = -1;
        [_collectionActivityLabel addSubview:collectionButton];

        [self.bodyView addSubview:_collectionActivityLabel];
    }
    
    //参加活动的按钮
    if (_joinActivityLabel == nil) {
        _joinActivityLabel =[[MLLinkLabel alloc] initWithFrame:CGRectZero];
        _joinActivityLabel.font = ContactFont;
        _joinActivityLabel.numberOfLines = 1;
        _joinActivityLabel.adjustsFontSizeToFitWidth = NO;
        _joinActivityLabel.textInsets = UIEdgeInsetsMake(-3, 0, 0, 0);
        _joinActivityLabel.backgroundColor = [UIColor colorWithWhite:237.0 /255.0 alpha:1.0];
        _joinActivityLabel.layer.cornerRadius = 3.0;
        _joinActivityLabel.layer.masksToBounds = YES;
        _joinActivityLabel.textColor = [UIColor grayColor];
        _joinActivityLabel.dataDetectorTypes = MLDataDetectorTypeAll;
        _joinActivityLabel.allowLineBreakInsideLinks = NO;
        _joinActivityLabel.linkTextAttributes = nil;
        _joinActivityLabel.activeLinkTextAttributes = nil;
        _joinActivityLabel.lineHeightMultiple = TextLineHeight;
        _joinActivityLabel.linkTextAttributes = @{NSForegroundColorAttributeName: HighLightTextColor};
        
        
        UIButton *joinButton = [[UIButton alloc] init];
        [joinButton setBackgroundImage:[UIImage imageNamed:@"attend_default"] forState:UIControlStateNormal];
        [joinButton setBackgroundImage:[UIImage imageNamed:@"attend_disabled"] forState:UIControlStateSelected];
        joinButton.frame = CGRectZero;
        joinButton.tag = -1;
        [_joinActivityLabel addSubview:joinButton];
        
        UITapGestureRecognizer *joinTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(joinActivityTap:)];
        joinTap.numberOfTapsRequired = 1;
        joinTap.numberOfTouchesRequired = 1;
        [_joinActivityLabel addGestureRecognizer:joinTap];
        
        [self.bodyView addSubview:_joinActivityLabel];
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
    
    if (_joinView == nil) {
        CGFloat x, y , width, height;
        
        x = 0;
        y = 0;
        width = 0;
        height = 0;
        
        _joinView = [[DFLikeJoinView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        [self.bodyView addSubview:_joinView];
    }
    
}


-(void)updateWithItem:(DFActivityDetailLineItem *)item
{
    [super updateWithItem:item];
    
    _myActivityItem = item;
    
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
        activityAddressSize.height = 0;
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
    if (item.activityContactPhone == nil) {
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
    
    //收藏
    NSInteger collectNum = item.collectNum;
    NSAttributedString *activityCollectionText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%ld人已收藏",EMPTYSTRING,collectNum]];
    if (activityCollectionText == nil) {
        activityCollectionText = [[NSAttributedString alloc] initWithString:@""];
    }
    CGSize activityCollectionSize = [MLLinkLabel getViewSize:activityCollectionText maxWidth:(BodyMaxWidth - 5) / 2.0 font:ContactFont lineHeight:TextLineHeight lines:0];
    _collectionActivityLabel.attributedText = activityCollectionText;
    [_collectionActivityLabel sizeToFit];
    _collectionActivityLabel.frame = CGRectMake(0, CGRectGetMaxY(_activityPhoneLabel.frame), (BodyMaxWidth - 5) / 2.0, activityCollectionSize.height);
    imageY = (activityCollectionSize.height - imageH) / 2.0;
    UIButton *collectionIcon = [_collectionActivityLabel viewWithTag:-1];
    collectionIcon.frame = CGRectMake(imageX, imageY, imageW, imageH);
    if (item.isCollect) {
        collectionIcon.selected = YES;
    }
    else{
        collectionIcon.selected = NO;
    }
    
    //参加
    NSInteger joinNum = item.attendNum;
    if (joinNum == 0) {
        _joinView.hidden = YES;
    }
    else{
        _joinView.hidden = NO;
    }
    NSAttributedString *activityJoinText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%ld人已参加",EMPTYSTRING,joinNum]];
    if (activityJoinText == nil) {
        activityJoinText = [[NSAttributedString alloc] initWithString:@""];
    }
    CGSize activityJoinSize = [MLLinkLabel getViewSize:activityJoinText maxWidth:(BodyMaxWidth - 5) / 2.0 font:ContactFont lineHeight:TextLineHeight lines:0];
    _joinActivityLabel.attributedText = activityJoinText;
    [_joinActivityLabel sizeToFit];
    _joinActivityLabel.frame = CGRectMake(0 + (BodyMaxWidth - 5) / 2.0 + 5, CGRectGetMaxY(_activityPhoneLabel.frame), (BodyMaxWidth - 5) / 2.0, activityJoinSize.height);
    imageY = (activityJoinSize.height - imageH) / 2.0;
    UIButton *joinIcon = [_joinActivityLabel viewWithTag:-1];
    joinIcon.frame = CGRectMake(imageX, imageY, imageW, imageH);
    if (item.isJoin) {
        joinIcon.selected = YES;
    }
    else{
        joinIcon.selected = NO;
    }
    
    CGFloat gridHeight = [DFGridImageView getHeight:item.thumbImages maxWidth:GridMaxWidth oneImageWidth:item.width oneImageHeight:item.height];
    
    //网格图的视图区域
    CGFloat x, y, width, height;
    x = _gridImageView.frame.origin.x;
    y = CGRectGetMaxY(_collectionActivityLabel.frame) + TextImageSpace;
    width = _gridImageView.frame.size.width;
    height = gridHeight;
    _gridImageView.frame = CGRectMake(x, y, width, height);
    
    [_gridImageView updateWithImages:item.thumbImages srcImages:item.srcImages oneImageWidth:item.width oneImageHeight:item.height];
    
    //参加人详情的视图区域
    CGFloat joinHeight = 0;
//    [DFLikeJoinView getHeight:item maxWidth:BodyMaxWidth];
    x = _joinView.frame.origin.x;
    y = CGRectGetMaxY(_gridImageView.frame) + JoinViewSpace;
    width = BodyMaxWidth;
    height = joinHeight;
    _joinView.frame = CGRectMake(x, y, width, height);
    [_joinView updateWithItem:item];
    _joinView.hidden = YES;
    
    [self updateBodyView:(activityIconSize.height + textSize.height + activityDateSize.height + activityAddressSize.height + activityPhoneSize.height + activityCollectionSize.height + gridHeight + joinHeight + TextImageSpace)];
    
}


+(CGFloat)getCellHeight:(DFActivityDetailLineItem *)item
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
    
    //收藏的size
    NSInteger collectNum = item.collectNum;
    NSAttributedString *activityCollectionText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%ld人已收藏",EMPTYSTRING,collectNum]];
    if (activityCollectionText == nil) {
        activityCollectionText = [[NSAttributedString alloc] initWithString:@""];
    }
    CGSize activityCollectionSize = [MLLinkLabel getViewSize:activityCollectionText maxWidth:(BodyMaxWidth - 5) / 2.0 font:ContactFont lineHeight:TextLineHeight lines:1];
    
    //基本资料的高度包括点赞评论
    CGFloat height = [DFBaseLineCell getCellHeight:item];
    
    //图片区域的高度
    CGFloat gridHeight = [DFGridImageView getHeight:item.thumbImages maxWidth:GridMaxWidth oneImageWidth:item.width oneImageHeight:item.height];
    
    //参加人详情的视图区域的高度
    CGFloat joinHeight = 0;
//    [DFLikeJoinView getHeight:item maxWidth:BodyMaxWidth];
    
    return height +activityIconSize.height + textSize.height + activityDateSize.height + activityAddressSize.height + activityPhoneSize.height +  gridHeight + activityCollectionSize.height + TextImageSpace + joinHeight + JoinViewSpace;
}

#pragma mark - TapMethod

- (void)collectActivityTap:(UITapGestureRecognizer *)tap
{
    MLLinkLabel *linkLabel = (MLLinkLabel *)tap.view;
    UIButton *collectionButton = [linkLabel viewWithTag:-1];
    NSString *itemID = _myActivityItem.itemId;
    
    NSInteger collectNum = _myActivityItem.collectNum;
    if (collectionButton.selected) {
        //已经收藏，做取消操作
        collectNum--;
        [self.delegate collectActivity:itemID collected:NO];
    }
    else{
        collectNum++;
        [self.delegate collectActivity:itemID collected:YES];
    }
    collectionButton.selected = !collectionButton.selected;
    
    NSAttributedString *activityCollectionText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%ld人已收藏",EMPTYSTRING,collectNum]];
    if (activityCollectionText == nil) {
        activityCollectionText = [[NSAttributedString alloc] initWithString:@""];
    }
    CGSize activityCollectionSize = [MLLinkLabel getViewSize:activityCollectionText maxWidth:(BodyMaxWidth - 5) / 2.0 font:ContactFont lineHeight:TextLineHeight lines:0];
    _collectionActivityLabel.attributedText = activityCollectionText;
    [_collectionActivityLabel sizeToFit];
    _collectionActivityLabel.frame = CGRectMake(0, CGRectGetMaxY(_activityPhoneLabel.frame), (BodyMaxWidth - 5) / 2.0, activityCollectionSize.height);
}

- (void)joinActivityTap:(UITapGestureRecognizer *)tap
{
    MLLinkLabel *linkLabel = (MLLinkLabel *)tap.view;
    UIButton *joinButton = [linkLabel viewWithTag:-1];
    NSString *itemID = _myActivityItem.itemId;
    if (joinButton.selected) {
        //已经参加，做取消操作
        [self.delegate joinActivity:itemID joined:NO];
    }
    else{
        [self.delegate joinActivity:itemID joined:YES];
    }
    joinButton.selected = !joinButton.selected;
    
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
