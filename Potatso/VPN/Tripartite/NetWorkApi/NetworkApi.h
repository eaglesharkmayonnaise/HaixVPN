//
//  NetworkApiViewController.h
//  Potatso
//
//  Created by txb on 2018/5/14.
//  Copyright © 2018年 TouchingApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NetworkApi : NSObject
//发送设备信息给乐仑
+(void)GetLicenseView;
//续订
+(void)UserRenew:(void(^)(NSError* error))block1;
//验证账号是否已注册同时发送验证码
+(void)UserSendSMSandurl:(NSString *)url anddic:(NSDictionary *)parameters block:(void(^)(NSDictionary *responseObject))block block:(void(^)(NSError* error))block1;
//验证验证码
+(void)UserVerifyEmailCatcha:(NSString *)url anddic:(NSDictionary *)parameters block:(void(^)(NSDictionary *responseObject))block block:(void(^)(NSError* error))block1;
//设置密码
+(void)UserloginAfterCode:(NSString *)url anddic:(NSDictionary *)parameters block:(void(^)(NSDictionary *responseObject))block block:(void(^)(NSError* error))block1;
//获取设备信息
+(void)UserGetLicenseView:(NSString *)url anddic:(NSDictionary *)parameters block:(void(^)(NSDictionary *responseObject))block block:(void(^)(NSError* error))block1;
//重新发送验证码
+(void)UserTryAgainCode:(NSString *)url anddic:(NSDictionary *)parameters block:(void(^)(NSDictionary *responseObject))block block:(void(^)(NSError* error))block1;
//老用户的登录操作
+(void)UserloginNew:(NSString *)url anddic:(NSDictionary *)parameters block:(void(^)(NSDictionary *responseObject))block block:(void(^)(NSError* error))block1;
//退出登录
+(void)UserLogOut:(NSString *)url anddic:(NSDictionary *)parameters block:(void(^)(NSDictionary *responseObject))block block:(void(^)(NSError* error))block1;
//设备管理
+(void)UserGetDevice:(NSString *)url anddic:(NSDictionary *)parameters block:(void(^)(NSDictionary *responseObject))block block:(void(^)(NSError* error))block1
    ;
//发送验证码
+(void)UsersendVerify:(NSString *)url anddic:(NSDictionary *)parameters block:(void(^)(NSDictionary *responseObject))block block:(void(^)(NSError* error))block1;
//获取ss配置
+(void)Getusernodes:(NSString *)url anddic:(NSDictionary *)parameters block:(void(^)(NSDictionary *responseObject))block block:(void(^)(NSError* error))block1;
//获取套餐内容
+(void)Oderplans:(NSString *)url anddic:(NSDictionary *)parameters block:(void(^)(NSDictionary *responseObject))block block:(void(^)(NSError* error))block1;
//验证折扣码
+(void)ValidinvitedCode:(NSString *)url anddic:(NSDictionary *)parameters block:(void(^)(NSDictionary *responseObject))block block:(void(^)(NSError* error))block1;
//创建订单
+(void)Createorder:(NSString *)url anddic:(NSDictionary *)parameters block:(void(^)(NSDictionary *responseObject))block block:(void(^)(NSError* error))block1;
//获取订单列表
+(void)Getorderlist:(NSString *)url anddic:(NSDictionary *)parameters block:(void(^)(NSDictionary *responseObject))block block:(void(^)(NSError* error))block1;
//获取订单详情
+(void)Getorderinfo:(NSString *)url anddic:(NSDictionary *)parameters block:(void(^)(NSDictionary *responseObject))block block:(void(^)(NSError* error))block1;
//验证邀请码
+(void)invitedCode:(NSString *)url anddic:(NSDictionary *)parameters block:(void(^)(NSDictionary *responseObject))block block:(void(^)(NSError* error))block1;
//DownLoad CountryMap.json
+ (void)DownLoadCountryMapjson;
@end
