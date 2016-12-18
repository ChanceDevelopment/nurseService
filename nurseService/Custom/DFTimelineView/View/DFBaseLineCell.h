//
//  DFBaseLineCell.h
//  DFTimelineView
//
//  Created by Allen Zhong on 15/9/27.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

//#import "UIImageView+WebCache.h"
#import "DFBaseLineItem.h"

#import "Const.h"


#define Margin 15

#define Padding 10

#define UserAvatarSize 40

#define  BodyMaxWidth [UIScreen mainScreen].bounds.size.width - UserAvatarSize - 3*Margin




@protocol DFLineCellDelegate <NSObject>

@optional
-(void) onLike:(NSString *) itemId;
-(void) onComment:(NSString *) itemId;
-(void) onShare:(NSString *) itemId;

//删除活动或者日记
- (void)deleteActivityDiary:(NSString *)itemId;

//收藏活动，collect为YES，收藏该活动，NO:取消收藏该活动
-(void)collectActivity:(NSString *)itemId collected:(BOOL)collect;
//参加活动，join为YES，收藏该活动，NO:取消收藏该活动
-(void)joinActivity:(NSString *)itemId joined:(BOOL)join;

-(void) onClickUser:(NSString *) userId;

-(void) onClickComment:(NSString *) commentId itemId:(NSString *) itemId;

- (void) onDeleteCommentWithCommentID:(NSString *) commentId itemId:(NSString *) itemId;

@end

@interface DFBaseLineCell : UITableViewCell

@property (nonatomic, strong) UIImageView *userAvatarView;
@property (nonatomic, strong) UIButton *userAvatarButton;
@property (nonatomic, strong) MLLinkLabel *userNickLabel;

@property (nonatomic, strong) UIView *bodyView;

@property (nonatomic, assign) id<DFLineCellDelegate> delegate;

//点赞评论的工具栏是否还显示
- (BOOL)isToolBarShow;

- (BOOL)isMenuItemShow;

- (void)hideEditMenu;

-(void) updateWithItem:(DFBaseLineItem *) item;

+(CGFloat) getCellHeight:(DFBaseLineItem *) item;

-(void)updateBodyView:(CGFloat) height;

-(void) hideLikeCommentToolbar;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com