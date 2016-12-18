//
//  DFTimeLineViewController.h
//  DFTimelineView
//
//  Created by Allen Zhong on 15/9/27.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFBaseLineItem.h"

#import "DFLineLikeItem.h"
#import "DFLineCommentItem.h"
#import "DFLineJoinItem.h"
#import "DFBaseTimeLineViewController.h"

@protocol MyTableViewDelgate <NSObject>

@optional
- (void)didSelectTableAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface DFTimeLineViewController : DFBaseTimeLineViewController
@property(assign,nonatomic)id<MyTableViewDelgate>myTableDelegate;

-(void) addItem:(DFBaseLineItem *) item;

-(void) addItem:(DFBaseLineItem *) item atIndex:(NSInteger)index;

-(void) addLikeItem:(DFLineLikeItem *) likeItem itemId:(NSString *) itemId;

-(void) deleteLikeItem:(DFLineLikeItem *) likeItem itemId:(NSString *) itemId;

-(void) addCommentItem:(DFLineCommentItem *) commentItem itemId:(NSString *) itemId replyCommentId:(NSString *) replyCommentId;
- (void)deleteCommentItem:(NSString *)commentID itemId:(NSString *)itemId;

-(void) addJoinItem:(DFLineJoinItem *) joinItem itemId:(NSString *) itemId;
-(void) deleteJoinItem:(DFLineJoinItem *) joinItem itemId:(NSString *) itemId;

//移除某个item，如果itemID为nil，移除全部
- (void)removeItmeWithItemId:(NSString *)itemID;
//修改某个item
-(void) modifyItem:(DFBaseLineItem *) item;

//Unicode编码转中文
- (void)translateUnicdoeToChinese:(NSString *)unicodeString;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com