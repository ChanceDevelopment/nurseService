//
//  appAPIDefine.h
//  huayoutong
//
//  Created by HeDongMing on 16/3/2.
//  Copyright © 2016年 HeDongMing. All rights reserved.
//

#ifndef appAPIDefine_h
#define appAPIDefine_h

#define FL_URL @"http://118.178.186.59:8080/nurseDoor/"
#define BASEURL @"http://118.178.186.59:8080/nurseDoor/"
#define WEBBASEURL @"http://118.178.186.59:8080/nurseDoor/"
//华幼通图片服务器
#define HYTIMAGEURL @"http://118.178.186.59:8080/"
//七牛图片服务器
#define QNIMAGEURL @"http://7xr4f5.com2.z0.glb.qiniucdn.com/"
//分享页面的地址
#define SHAREPAGEWEBSITE @"http://huayoutong.com/mobilex/view/share"



//------------------------------

#define PIC_URL @"http://118.178.186.59:8080/"
#define API_URL @"http://118.178.186.59:8080/nurseDoor/"
//#define API_URL @"http://118.178.186.59:8080/nurseDoorText/"

//登录
#define LOGINURL @"nurseAnduser/NurseLogin.action"
//注册
#define REGISTERURL @"nurseAnduser/NurseRegistered.action"
//短信验证码
#define SMSCODE @"nurseAnduser/sendSmsCode.action"
//评价
#define EVALUATEURL @"nurseAnduser/selectnurserated.action"
//1.3 基本信息完善
#define MODIFYUSERINFO @"nurseAnduser/NurseInfoAdd.action"         //
//1.3.1修改个人信息
#define UPDATENURSEINFO @"nurseAnduser/updateNurseInfo.action"     
//1.4 专业信息认证
#define NURSEINFOIDENTIFY @"nurseAnduser/NurseInfoIdentify.action"
//1.5更新护士端的经纬度
#define NURSELATIUDE @"latitude/nurselatiude.action"
//1.6通过ID查询护士信息
#define SELECTBURSEBYID @"nurseAnduser/selectfornursebyid.action"
//1.9.1根据护士ID查询护士的基本信息和专业信息
#define NURSEBASICSINFO @"nurseAnduser/SelectNurseBasicsInfo.action"
//1.9.3根据护士ID查询余额支付宝账号和密码
#define SELECTNURSETHREEINFO @"nurseAnduser/selectNurseThreeInfo.action"
//1.9.5 护士查看自己填写过的护理报告
#define ALLREPORTBYNURSE @"report/selectReportByUserIdAndPersonCardByNurseId.action"
//2.2接取订单
#define ORDERRECEIVER @"orderReceiver/orderReceiver.action"
//2.3接单状态修改
#define UPDATEORDERSTATE @"orderReceiver/updateOrderState.action"
//2.6根据订单id查询订单详情
#define ORDERDESCRIPTION @"orderReceiver/OrderSendDescriptionByNurse.action"
//2.7获取当前接单开关
#define ORDERRECEIVESTATE @"orderReceiver/orderReceiverState.action"
//2.8修改当前接单开关
#define UPDATEORDERRECEIVERSTATE @"orderReceiver/UpdateorderReceiverState.action"

//2.9取消订单
#define CANCLEORDER @"orderSend/cancelOrder.action"
//2.9.1 护士取消专属订单(正接单取消)
#define CANCLEEXCLUSIVEORDER @"orderReceiver/giveUpExclusiveOrder.action"
//4.4查询所有二级服务信息
#define ALLSERVICEINFO @"content/SelectContentAllinfo.action"

//5.1 护士账单
#define SELECTNURSEBILL @"nurseAnduser/selectNurseBills.action"
//6.3 护理报告详情页
#define SELECTREPORTDETAIL @"selectReportdetails.action"
//6.4 填写护理报告
#define SELECTREPORTDETAILSTAY @"selectReportdetailsStay.action"

//8.2 护士对用户的评价
#define ADDNURSEEVALUATE @"nurseevaluate/addnurseevaluate.action"
//9.1绑定支付密码和账号
#define BINDACCOUNTANDPAW @"nurseAnduser/BindAccountAndPassword.action"
//9.3查询我的粉丝
#define SELECTFOLLOWBYID @"follow/selectfollowbybefollowid.action"
//18.1提现
#define NURSEDRAWMONEY @"nurseAnduser/drawMoney.action"
//19.3重置密码
#define RESETPASSWORD @"nurseAnduser/ResetPasswordUpdate.action"



//签到
#define TOSIGNIN @"nurseAnduser/nurseToSignin.action"
//是否签到
#define SIGNINSTATE @"nurseAnduser/selectNurseIsSignined.action"
//关注总榜
#define USERREGISTERED @"mark/UserRegistered.action"
//护士总榜排行
#define NURSEMARKRANKING @"mark/nurseMarkRanking.action"
//6.4护士近一月积分排行榜
#define NURSEMONTHRANKING @"mark/nurseMarkThirtyDayRanking.action"
//护士近一周排行榜
#define NURSESEVENDAYRANKING @"mark/nurseMarkSevenDayRanking.action"
//6.3护士近一周积分排行总榜
#define NURSEMARKSEVENDAYDES @"mark/nurseMarkSevenDayDesc.action"
//6.2积分近一个月排行总榜
#define MURSEMARKMONTHDES @"mark/nurseMarkThirtyDayDesc.action"
//6.1 积分排行总榜
#define NURSEMARKDES @"mark/nurseMarkDesc.action"

//2.1查看可接取的订单
#define ORDERLOOKRECEIVER @"orderReceiver/orderLookReceiver.action"
//2.4正在进行中的订单
#define ORDERSTATENOW @"orderReceiver/OrderStateAccessNow.action"
//2.5查询已完成订单
#define ORDERSTATESUCCESS @"orderReceiver/OrderStateAccessSuccess.action"
//帖子
#define ESSENCEARTICLE @"post/selectPostThreeLevelDetailsInfo.action"

#define ROLLPICTURE @"post/selectPostRollPicInfo.action"

#define ALLPOSTINFODETAIL @"post/selectPostInfoByOneTOTwo.action"

#define NURSESELECTPOST @"post/selectPostNursefFocus.action"

#define kThreeLevelDetails @"post/selectPostThreeLevelDetailsInfoByPostTwoId.action"

//绑定角色
#define BIND_PHONE_USER @"/bang_phone_user"
//绑定角色的时候获取验证码
#define GET_BIND_MESSAGE  @"send_vali_message"
//退出登录
#define APP_LOGOUT @"/new_app_logout"
//重置密码的短信验证接口，用短信验证是否当前手机
#define SEND_RESETPWD @"/send_resetpwd_message"
//重置密码接口
#define RESET_PASSWORD @"/reset_password"

//获取短信验证码
//退出登录
#define LOUOUT @"/new_app_logout"
//获取用户的信息
#define GETUSERDATA @"/my/personal_info"
//删除图片
#define DELEPHOTO @"/album/delete"

//校园通知
#define SCHOOLNOTIFICATION @"/my/my_school_notification"
//将通知设置为已读
#define MARK_NOTIFICATION_READ @"/my/mark_notification_read"

/*******用户好友管理*********/
//请求添加好友
#define ADD_FRIEND @"/my/add_friend"
//接受好友请求
#define RECEIVE_INVITE @"/my/recive_invite"
//请求好友的申请
#define REQUEST_FRIENDINVITE @"/my/my_friend_invite"
//查找要添加的好友
#define SEARCH_FRIEND @"/my/search_friend"
//删除好友
#define CANCEL_FRIEND @"/my/cancel_friend"
//修改用户备注
#define MODIFY_NOTENAME @"/my/modi_noteName"
//请求用户的好友列表
#define REQUEST_BUDDY @"/my/my_friends"

/*******活动日记部分*******/
//获取活动日记接口
#define GETACTIVITYDIARY @"/diary_activity/attention_list"
//获取日记活动详情
#define DIARY_ACTIVITY_DETAIL @"/diary_activity/list_diary"
//点赞
#define DIARY_ACTIVITY_ADDLIKE @"/diary_activity/addLike"
//评论
#define DIARY_ACTIVITY_COMMENT @"/diary_activity/storeDiaryActivityComment"
//删除日记活动
#define DIARY_ACTIVITY_DELETE @"/diary_activity/deleteDiaryActivity"
//发布日记活动
#define DIARY_ACTIVITY_DISTRIBUTELOGACTIVITY @"diary_activity/upload_to_qi_niu"
//活动发布活动的地点还有活动类型
#define DIARY_ACTIVITY_PUBLISH @"/diary_activity/publish"
//收藏或取消收藏活动
#define DIARY_ACTIVITY_ADDCOLLECT @"/diary_activity/addCollect"
//参加或取消参加活动
#define DIARY_ACTIVITY_ADDATTEND @"/diary_activity/addAttend"
//删除评论
#define DIARY_ACTIVITY_DELETECOMMENT @"/diary_activity/deleteDiaryActivityComment"
//加载专门某个用户的活动日记
#define GETPERSONALACTIVITYDIARY  @"/my/personal_page"
//消息记录
#define MYMESSAGE @"/my/my_message"
//我收藏的活动
#define MYCOLLECTACTIVITY @"/my/my_collect"
//我参加的活动
#define MYATTENDACTIVITY @"/my/my_attend"


//意见反馈
#define FEEDBACK @"/feedback/create"
/********广场部分*********/
#define GETDIARY_ACTIVITY_PLAZA_LIST @"/diary_activity/activity_list"

/********相册部分*********/
//获取当前用户的相册权限
#define GET_USER_ALBUMTYPE @"/new_album/getType"
//进入对应相册返回相片列表
#define ALBUM_LIST_PHOTO @"/new_album/list-photo"
//相册列表（我的相册、班级相册、学校相册）
#define GET_ALBUM_LIST @"/new_album/list-by-type"
//上传照片前先请求服务器拿取云端的上传KEY凭证
#define GET_UPLOAD_ALBUM_UPLOADKEY @"/new_album/getUploadKey"
//上传照片到云端
#define UPLOAD_PHOTO_CLOUND @"/new_album/uploadCloud"
//上传照片到云端后手机端发送命令到后台生成缩略图
#define ALBUM_CREATTHUMBNAIL @"/new_album/createThumbnail"
//删除图片
#define ALBUM_DELETE @"/album/delete"

//找回密码
#define FINDUSERPASSWORD @"/user/getPassword.action"
//根据用户ID获取当前登录用户详细信息
#define GETUSERINFO @"/user/findUserByUsername.action"
//更新用户信息
#define UPDATEUSERINFO @"/user/updateUserByJsonData.action"
//创建用户动态
#define CREATUSERDYNAMIC @"/bbs/createTopic.action"
//点赞
#define CREATEPRAISE @"/bbs/createPraise.action"
//回复
#define CREATEREPLY @"/bbs/createReply.action"
//动态删除
#define DELETEDYNAMIC @"/bbs/deletTopicByTopicId.action"
//删除回复
#define DELETEREPLY @"/bbs/deletReplyById.action"
//取消点赞
#define CANCELPRAISE @"/bbs/deletPraise.action"

#endif /* appAPIDefine_h */
