//
//  Tool.h
//  iGangGan
//
//  Created by HeDongMing on 15/12/9.
//  Copyright © 2015年 iMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sys/utsname.h"
#import "User.h"

@interface Tool : NSObject

+ (void)setExtraCellLineHidden: (UITableView *)tableView;

+ (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize;
+ (BOOL)checkTelephoneNumber:(NSString *)telephoneNumber;
//获取openUUID
+ (NSString *)getDeviceUUid;

+ (NSString *)getVersion;
+ (NSString *)getPlatformInfo;
+ (NSString *)getCurrentTime;
+ (int)addFileSkipBackupAttribute: (NSString*) filePath;
+ (void)canceliClouldBackup;
//IOS5或者以上的版本处理不备份都iCloud的方法
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;
+ (NSString *) checkRegisterAccount:(NSString *)userNameVal;
+ (NSString *) checkRegisterPassword:(NSString *)userPwdVal;
+ (NSDictionary *)getUserDict;
+ (void)initUserWithDict:(NSDictionary *)dict;

+ (int)getUpValueWithValue:(int)value1 otherValue:(int)value2;
+ (int)getColumnNumWithTotalNum:(NSInteger)totalCount;
+ (int)getRowNumWithTotalNum:(NSInteger)totalCount;
+ (int)getRowNumWithTotalNum:(NSInteger)totalCount withMaxRow:(NSInteger)maxrow MaxColumn:(NSInteger)maxcolumn;
+ (int)getColumnNumWithTotalNum:(NSInteger)totalCount withMaxColumn:(NSInteger)maxcolumn;

+ (NSString *)compareCurrentTime:(NSString *)comparedateline;

+ (User *)getUserWithDict:(NSDictionary *)dict;
+ (NSString *)getUserHeadImageURLWithiconAddress:(NSString *)iconAddress;
+ (NSString *)getUserDataPath;
//还没上传到服务器的图片数据的路径
+ (NSString *)getUn_UploadPath;

+ (NSString *)convertTimespToString:(long long)timesp;
+ (long long)convertStringToTimesp:(NSString *)timeString;
+ (NSDate *)convertTimespToDate:(long long)timesp;

+ (NSString *)convertTimespToString:(long long)timesp dateFormate:(NSString *)dateFormate;
+ (long long)convertStringToTimesp:(NSString *)timeString dateFormate:(NSString *)dateFormate;
+ (NSDate *)convertTimespToDate:(long long)timesp dateFormate:(NSString *)dateFormate;

+ (NSDate *)convertTimesToDate:(NSString *)time dateFormate:(NSString *)dateFormate;

+ (NSString *)getAppID;

+ (NSData *)convertHexStrToData:(NSString *)str ;
+ (NSString *)convertDataToHexStr:(NSData *)data;

+ (NSData *)stringToHexData:(NSString *)string;
+ (BOOL)isUserHaveLogin;

+ (UIImage *) buttonImageFromColor:(UIColor *)color withImageSize:(CGSize)imageSize;

//获取app的版本号
+ (NSString *)getAppVersion;
+ (NSString *)getAppBuildVersion;
//获取系统的版本号
+ (NSString *)getSysVersion;
//获取app的协议头
+ (NSString *)getAppScheme;
//判断字符串是否手机号码
+ (BOOL)isMobileNumber:(NSString *)mobileNum;
+ (BOOL) IsIdentityCard:(NSString *)IDCardNumber;
//判断是否数字或字母
+ (BOOL)isNumOrAbc:(NSString *)str;


+ (NSString *)replaceUnicode:(NSString *)unicodeStr;

//删除<null>字段
+ (NSMutableDictionary *)deleteNullFromDic:(NSDictionary *)dic;
//删除错误的字符串
+ (NSString *)deleteErrorStringInString:(NSString *)inputString;
//删除错误的字符串
+ (NSString *)deleteErrorStringInData:(NSData *)inputData;
//将十六进制的字符串转换成NSString则可使用如下方式:
+ (NSString *)convertHexStrToString:(NSString *)str;
//将NSString转换成十六进制的字符串则可使用如下方式:
+ (NSString *)convertStringToHexStr:(NSString *)str;


//初始化推送服务
+ (void)initPush;

+ (void)callPhoneWithPhone:(NSString *)phone;
@end
