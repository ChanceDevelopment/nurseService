//
//  ActivityLogModel.m
//  huayoutong
//
//  Created by HeDongMing on 16/4/17.
//  Copyright © 2016年 HeDongMing. All rights reserved.
//

#import "ActivityLogModel.h"
#import "Tool.h"
#import "HeSysbsModel.h"

@implementation ActivityLogModel
//活动的结束时间
@synthesize activityEndTime;
//活动的联系电话
@synthesize activityPhone;
//活动的地点
@synthesize activityPlace;
//活动的开始时间
@synthesize activityStartTime;
//活动的场所
@synthesize activityTownName;
//活动的类型名
@synthesize activityTypeName;
//活动的参加数
@synthesize attendCount;
//(日记)活动的收藏数
@synthesize collectCount;
//评论的列表
@synthesize commentList;
@synthesize commentStringList;
//内容
@synthesize content;
//创建时间
@synthesize createTime;
//创建者
@synthesize creator;
//日记或活动标记位0日记，1活动
@synthesize diaryOrActivity;
//活动或者日记的ID
@synthesize activityid;
//	(活动)用户是否参加了活动0不参加1参加
@synthesize isAttented;
//(活动)用户是否收藏活动
@synthesize isCollected;
//(活动)用户是否被邀请了活动0未邀请1邀请
@synthesize isInvited;
//点赞列表
@synthesize islikeList;
//用户是否点赞过
@synthesize isLike;
//日记或活动的图片（用逗号隔开）
@synthesize link;
//分享的ID
@synthesize shareId;
//日记图片的存储类型0本地服务器1七牛云服务器
@synthesize storageType;
//日记或活动的图片缩略图（用逗号隔开）
@synthesize thumbLink;
//参加人的列表
@synthesize attendList;

- (id)initModelWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        
        HeSysbsModel *sysModel = [HeSysbsModel getSysModel];
        
        id activityEndTimeObj = [dict objectForKey:@"activityEndTime"];
        if ([activityEndTimeObj isMemberOfClass:[NSNull class]] || activityEndTimeObj == nil) {
            NSTimeInterval  timeInterval = [[NSDate date] timeIntervalSince1970];
            activityEndTimeObj = [NSString stringWithFormat:@"%.0f000",timeInterval];
        }
        long long timestamp = [activityEndTimeObj longLongValue];
        NSString *activityEndTimeStr = [NSString stringWithFormat:@"%lld",timestamp];
        if ([activityEndTimeStr length] > 3) {
            //时间戳
            activityEndTimeStr = [activityEndTimeStr substringToIndex:[activityEndTimeStr length] - 3];
        }
        activityEndTimeStr = [Tool convertTimespToString:[activityEndTimeStr longLongValue] dateFormate:nil];
        if ([activityEndTimeStr isMemberOfClass:[NSNull class]] || activityEndTimeStr == nil) {
            activityEndTimeStr = @"";
        }
        self.activityEndTime = activityEndTimeStr;
        
        id activityStartTimeObj = [dict objectForKey:@"activityStartTime"];
        if ([activityStartTimeObj isMemberOfClass:[NSNull class]] || activityStartTimeObj == nil) {
            NSTimeInterval  timeInterval = [[NSDate date] timeIntervalSince1970];
            activityStartTimeObj = [NSString stringWithFormat:@"%.0f000",timeInterval];
        }
        timestamp = [activityStartTimeObj longLongValue];
        NSString *activityStartTimeStr = [NSString stringWithFormat:@"%lld",timestamp];
        if ([activityStartTimeStr length] > 3) {
            //时间戳
            activityStartTimeStr = [activityStartTimeStr substringToIndex:[activityStartTimeStr length] - 3];
        }
        activityStartTimeStr = [Tool convertTimespToString:[activityStartTimeStr longLongValue] dateFormate:nil];
        if ([activityStartTimeStr isMemberOfClass:[NSNull class]] || activityStartTimeStr == nil) {
            activityStartTimeStr = @"";
        }
        self.activityStartTime = activityStartTimeStr;
        
        activityPhone = [[NSString alloc] initWithFormat:@"%@",[dict objectForKey:@"activityPhone"]];
        activityPlace = [[NSString alloc] initWithFormat:@"%@",[dict objectForKey:@"activityPlace"]];
        activityTownName = [[NSString alloc] initWithFormat:@"%@",[dict objectForKey:@"activityTownName"]];
        activityTypeName = [[NSString alloc] initWithFormat:@"%@",[dict objectForKey:@"activityTypeName"]];
        attendCount = [[dict objectForKey:@"attendCount"] integerValue];
        collectCount = [[dict objectForKey:@"collectCount"] integerValue];
        
        NSString *itemID = [dict objectForKey:@"id"];
        if ([itemID isMemberOfClass:[NSNull class]] || itemID == nil) {
            itemID = @"";
        }
        activityid = [[NSString alloc] initWithString:itemID];
        
        NSArray *commentListArray = [dict objectForKey:@"commentList"];
        commentList = [[NSMutableArray alloc] initWithCapacity:0];
        commentStringList = [[NSMutableArray alloc] initWithCapacity:0];
        for (NSInteger index = 0; index < [commentListArray count]; index++) {
            id commentDict = commentListArray[index];
            NSString *commentcontent = [commentDict objectForKey:@"content"];
//            commentcontent = [Tool converUnicodeToChinese:commentcontent];
            NSString *creatorId = [commentDict objectForKey:@"creatorId"];
            NSString *creatorName = [commentDict objectForKey:@"creatorName"];
            NSString *creatorPhoto = [NSString stringWithFormat:@"%@%@",HYTIMAGEURL,[commentDict objectForKey:@"creatorPhoto"]];
            NSString *commentID = [commentDict objectForKey:@"id"];
            NSString *replyUserId = [commentDict objectForKey:@"replyUserId"];
            NSString *replyUserName = [commentDict objectForKey:@"replyUserName"];
            
            DFLineCommentItem *commentItem = [[DFLineCommentItem alloc] init];
            commentItem.userPhoto = creatorPhoto;
            commentItem.commentId = commentID;
            commentItem.userId = creatorId;
            commentItem.userNick = creatorName;
            if (replyUserId != nil && ![replyUserId isEqualToString:@""]) {
                commentItem.replyUserId = replyUserId;
                commentItem.replyUserNick = replyUserName;
            }
            commentItem.text = commentcontent;
            [commentStringList addObject:commentcontent];
            [commentList addObject:commentItem];
        }
        
        content = [[NSString alloc] initWithFormat:@"%@",[dict objectForKey:@"content"]];
//        content = [Tool converUnicodeToChinese:content];
        
        id createTimeObj = [dict objectForKey:@"createTime"];
        if ([createTimeObj isMemberOfClass:[NSNull class]] || createTimeObj == nil) {
            NSTimeInterval  timeInterval = [[NSDate date] timeIntervalSince1970];
            createTimeObj = [NSString stringWithFormat:@"%.0f000",timeInterval];
        }
        timestamp = [createTimeObj longLongValue];
        NSString *createTimeStr = [NSString stringWithFormat:@"%lld",timestamp];
        if ([createTimeStr length] > 3) {
            //时间戳
            createTimeStr = [createTimeStr substringToIndex:[createTimeStr length] - 3];
        }
        createTimeStr = [Tool convertTimespToString:[createTimeStr longLongValue]];
        if ([createTimeStr isMemberOfClass:[NSNull class]] || createTimeStr == nil) {
            createTimeStr = @"";
        }
        self.createTime = createTimeStr;
        
        NSString *creatorId = [[NSString alloc] initWithFormat:@"%@",[dict objectForKey:@"creatorId"]];
        NSString *creatorName = [[NSString alloc] initWithFormat:@"%@",[dict objectForKey:@"creatorName"]];
        NSString *creatorPhoto = [[NSString alloc] initWithFormat:@"%@%@",HYTIMAGEURL,[dict objectForKey:@"creatorPhoto"]];
        
        creator = [[User alloc] init];
        creator.userID = creatorId;
        creator.nickname = creatorName;
        creator.headurl = creatorPhoto;
        
        NSInteger type = [[dict objectForKey:@"diaryOrActivity"] integerValue];
        if (type == 1) {
            diaryOrActivity = ActivityType;
        }
        else{
            diaryOrActivity = LogType;
        }
        
        
        
        isAttented = [[dict objectForKey:@"isAttented"] boolValue];
        isCollected = [[dict objectForKey:@"isCollected"] boolValue];
        isInvited = [[dict objectForKey:@"isInvited"] boolValue];
        
        NSArray *isLikeArray = [dict objectForKey:@"islikeList"];
        islikeList = [[NSMutableArray alloc] initWithCapacity:0];
        
        //默认没有点赞
        self.isLike = NO;
        for (NSInteger index = 0; index < [isLikeArray count]; index++) {
            id likeDict = isLikeArray[index];
            NSString *likeID = [likeDict objectForKey:@"id"];
            NSString *photo = [[NSString alloc] initWithFormat:@"%@%@",HYTIMAGEURL,[likeDict objectForKey:@"photo"]];
            NSString *truename = [likeDict objectForKey:@"truename"];
            DFLineLikeItem *likeItem = [[DFLineLikeItem alloc] init];
            likeItem.userId = likeID;
            likeItem.itemID = [NSString stringWithFormat:@"like/%@/%@/%ld",itemID,likeID,index];
            NSLog(@"likeItem.itemID = %@",likeItem.itemID);
            likeItem.userPhoto = photo;
            likeItem.userNick = truename;
            [islikeList addObject:likeItem];
            if ([sysModel.user.userID isEqualToString:likeItem.userId]) {
                //如果数组里面有用户，证明用户点赞过
                self.isLike = YES;
            }
        }
        
        
        NSArray *attendListArray = [dict objectForKey:@"attendList"];
        attendList = [[NSMutableArray alloc] initWithCapacity:0];
        for (NSInteger index = 0; index < [attendListArray count]; index++) {
            id attendDict = attendListArray[index];
            NSString *attendID = [attendDict objectForKey:@"id"];
            NSString *photo = [[NSString alloc] initWithFormat:@"%@%@",HYTIMAGEURL,[attendDict objectForKey:@"photo"]];
            NSString *truename = [attendDict objectForKey:@"truename"];
            DFLineJoinItem *joinItem = [[DFLineJoinItem alloc] init];
            joinItem.userId = attendID;
            joinItem.joinId = [NSString stringWithFormat:@"join/%@/%@/%ld",itemID,attendID,index];
            joinItem.userPhoto = photo;
            joinItem.userNick = truename;
            [attendList addObject:joinItem];
        }
        
        
        //日记图片的存储类型0本地服务器1七牛云服务器
        storageType = [[dict objectForKey:@"storageType"] integerValue];
        NSString *imageLinkPre = HYTIMAGEURL;
        if (storageType == 1) {
            imageLinkPre = QNIMAGEURL;
        }
        NSString *linkStr = [dict objectForKey:@"link"];
        link = [[NSMutableArray alloc] initWithCapacity:0];
        NSArray *linkArray = [linkStr componentsSeparatedByString:@","];
        
        for (NSString *linkstring in linkArray) {
            NSString *imageUrl = [NSString stringWithFormat:@"%@%@",imageLinkPre,linkstring];
            [link addObject:imageUrl];
        }
        
        NSString *thumbLinkStr = [dict objectForKey:@"thumbLink"];
        
        thumbLink = [[NSMutableArray alloc] initWithCapacity:0];
        
        if (![thumbLinkStr isMemberOfClass:[NSNull class]] && ![thumbLinkStr isEqualToString:@""] && thumbLinkStr != nil) {
            NSArray *thumbLinkArray = [thumbLinkStr componentsSeparatedByString:@","];
            for (NSString *linkstring in thumbLinkArray) {
                NSString *imageUrl = [NSString stringWithFormat:@"%@%@",imageLinkPre,linkstring];
                [thumbLink addObject:imageUrl];
            }
        }
        
        
        shareId = [[NSString alloc] initWithFormat:@"%@",[dict objectForKey:@"shareId"]];
        
    }
    return self;
}

- (void)setCommentStringList:(NSMutableArray *)mycommentStringList
{
    commentStringList = [[NSMutableArray alloc] initWithArray:mycommentStringList];
    for (NSInteger index = 0; index < [mycommentStringList count]; index++) {
        NSString *comment = mycommentStringList[index];
        DFLineCommentItem *item = commentList[index];
        item.text = comment;
    }
}
@end
