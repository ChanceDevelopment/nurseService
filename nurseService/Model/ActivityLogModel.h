//
//  ActivityLogModel.h
//  huayoutong
//
//  Created by HeDongMing on 16/4/17.
//  Copyright © 2016年 HeDongMing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "DFLineCommentItem.h"
#import "DFLineLikeItem.h"
#import "DFLineJoinItem.h"


//定义枚举类型
typedef enum {
    LogType = 0, //日记类型
    ActivityType //活动类型
} ActivityLog_Type;

@interface ActivityLogModel : NSObject
//活动的结束时间
@property(strong,nonatomic)NSString *activityEndTime;
//活动的联系电话
@property(strong,nonatomic)NSString *activityPhone;
//活动的地点
@property(strong,nonatomic)NSString *activityPlace;
//活动的开始时间
@property(strong,nonatomic)NSString *activityStartTime;
//活动的场所
@property(strong,nonatomic)NSString *activityTownName;
//活动的类型名
@property(strong,nonatomic)NSString *activityTypeName;
//活动的参加数
@property(assign,nonatomic)NSInteger attendCount;
//(日记)活动的收藏数
@property(assign,nonatomic)NSInteger collectCount;
//评论对象的列表
@property(strong,nonatomic)NSMutableArray *commentList;
//评论字符串的列表
@property(strong,nonatomic)NSMutableArray *commentStringList;
//参加人的列表
@property(strong,nonatomic)NSMutableArray *attendList;

//内容
@property(strong,nonatomic)NSString *content;
//创建时间
@property(strong,nonatomic)NSString *createTime;
//创建者
@property(strong,nonatomic)User *creator;
//日记或活动标记位0日记，1活动
@property(assign,nonatomic)ActivityLog_Type diaryOrActivity;
//活动或者日记的ID
@property(strong,nonatomic)NSString *activityid;
//	(活动)用户是否参加了活动0不参加1参加
@property(assign,nonatomic)BOOL isAttented;
//(活动)用户是否收藏活动
@property(assign,nonatomic)BOOL isCollected;
//(活动)用户是否被邀请了活动0未邀请1邀请
@property(assign,nonatomic)BOOL isInvited;
//点赞列表
@property(strong,nonatomic)NSMutableArray *islikeList;
//用户是否点赞过
@property(assign,nonatomic)BOOL isLike;
//日记或活动的图片（用逗号隔开）
@property(strong,nonatomic)NSMutableArray *link;
//分享的ID
@property(strong,nonatomic)NSString *shareId;
//日记图片的存储类型0本地服务器1七牛云服务器
@property(assign,nonatomic)NSInteger storageType;
//日记或活动的图片缩略图（用逗号隔开）
@property(strong,nonatomic)NSMutableArray *thumbLink;

- (id)initModelWithDict:(NSDictionary *)dict;

- (void)setCommentStringList:(NSMutableArray *)commentStringList;



@end
