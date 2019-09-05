//
//  AppEnvironment.h
//  Potatso
//
//  Created by txb on 2018/5/15.
//  Copyright © 2018年 TouchingApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppEnvironment : NSObject

//得到用户信息
+(NSDictionary *)UserInfodic;

//写入国外域名段
+(void)getlist;

//获取设备码
+ (NSString *)getDeviceId ;

//字符串转字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString ;

+ (NSString *)removeSpaceAndNewline:(NSString *)str;

//展示错误的页面
+(void)ShowErrorLoading:(NSError *)error;

//关闭页面(类方法里不能有self)
+(void)closeview;

//base64加密
+(NSString*) decode64:(NSString*)str;

//只允许输入数字
+ (BOOL)validateNumber:(NSString*)number;

//tableview美化
+(void)setExtraCellLineHidden: (UITableView *)tableView;

//字典转json
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;

//UI控件抖动
+(void)lockAnimationForView:(UIView*)view;

//监测网络状态
+ (void)monitorNetworking:(void(^)(NSString* responseObject))block;

//获取设备信息
+ (NSString*)deviceModelName;

//MD5加密
+ (NSString *)md5:(NSString *)string;

//距离当前时间差多少（用NSInteger表示）返回也是时间码
+ (NSInteger)intervalSinceNow: (NSString *) theDate;

//时间数量转为年月日
+ (NSString *)timeFormatted:(long int)totalSeconds;

//时间戳转时间
+(NSString *)UTCchangeDate:(NSString *)utc;
/**
 * 开始到结束的时间差
 */
+ (NSString *)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime;

//显示到期用户
+(void)ShowInfosView:(NSString *)info;

//获得连接时间的时长
+(NSString *)GetNowTime;

//获取连接时长
+(void)GetConnectTime;

//判断是否到期
+(NSString *)performTotime;
@end
