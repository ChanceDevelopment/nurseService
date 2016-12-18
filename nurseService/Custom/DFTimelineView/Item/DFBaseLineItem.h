//
//  DFBaseLineItem.h
//  DFTimelineView
//
//  Created by Allen Zhong on 15/9/27.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//


typedef NS_ENUM(NSUInteger, LineItemType){
    LineItemTypeTextImage,   //普通图文类
    LineItemTypeShare,      //分享类
    LineItemTypeActivity,   //活动类
    LineItemTypeActivityDetail,   //活动详情类
    LineItemTypeCollectActivity,   //收藏活动类
    LineItemTypeUserActivity,   //个人用户活动类
    LineItemTypeUserActivityDetail,   //个人用户活动详细类
    LineItemTypeUserNewsActivityDetail,   //个人用户信息活动详细类
};


@interface DFBaseLineItem : NSObject

//时间轴itemID 需要全局唯一 一般服务器下发
@property (nonatomic, strong) NSString *itemId;

@property (nonatomic, assign) LineItemType itemType;

@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *userNick;
@property (nonatomic, strong) NSString *userAvatar;

@property (nonatomic, strong) NSString *title;


@property (nonatomic, strong) NSString *location;

@property (nonatomic, assign) long long ts;

//是否已经点赞
@property (nonatomic, assign) BOOL isLike;
//是否已经参加
@property (nonatomic, assign) BOOL isJoin;
//是否已经收藏
@property (nonatomic, assign) BOOL isCollect;
//是否被邀请参加
@property (nonatomic, assign) BOOL isInvited;

@property (nonatomic, strong) NSMutableArray *likes;
@property (nonatomic, strong) NSMutableArray *comments;
@property (nonatomic, strong) NSMutableArray *joins;
@property (nonatomic, strong) NSMutableArray *collects;

@property (nonatomic, assign) NSInteger collectNum; //收藏的人数
@property (nonatomic, assign) NSInteger attendNum; //收藏的人数

@property (nonatomic, strong) NSMutableAttributedString *joinStr;

@property (nonatomic, strong) NSMutableAttributedString *likesStr;

@property (nonatomic, strong) NSMutableArray *commentStrArray;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com