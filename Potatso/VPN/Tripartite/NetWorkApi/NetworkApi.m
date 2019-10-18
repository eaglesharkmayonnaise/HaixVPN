//
//  NetworkApiViewController.m
//  Potatso
//
//  Created by txb on 2018/5/14.
//  Copyright © 2018年 TouchingApp. All rights reserved.
//

#import "NetworkApi.h"

@interface NetworkApi ()

@end

@implementation NetworkApi

//续订
+(void)UserRenew:(void(^)(NSError* error))block1{
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"aryaToken"] == nil) {
        return;
    }
    [EncryptAndEcode httpUrl:[NSString stringWithFormat:@"%@user/renew",AryamaskUrl] AndPostparameters:nil AndHead:[[NSUserDefaults standardUserDefaults] valueForKey:@"aryaToken"]  block:^(NSDictionary *responseObject) {
        
        //存入过期时间
        [[NSUserDefaults standardUserDefaults] setValue:responseObject[@"data"][@"aryaToken"] forKey:@"aryaToken"];
        [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"plan"][@"endDateUnixTimestamp"]] forKey:@"UsernameExpired"];
        
        //登录信息
        [[NSUserDefaults standardUserDefaults] setObject:responseObject forKey:@"LoginInfoResponse"];
        
        //续订这里也获取ss配置
        [self Getusernodes:nil anddic:nil block:^(NSDictionary *responseObject) {
            
        //存入节点数据
//        [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"data"][@"nodes"][0] forKey:@"AryaLineConfiguration"];
            
        } block:^(NSError *error) {}];
        
    } block:^(NSError *error) {
        block1(error);
    }];
}

//发送设备信息给乐仑
+(void)GetLicenseView{
    
    __block NSString *AppNetStr =@"WIFI";
    [AppEnvironment monitorNetworking:^(NSString *responseObject) {
        AppNetStr = responseObject;
    }];
    
    int deviceType;
    if (kscreenw > 500) {
        deviceType = 3;
    }
    else{
        deviceType = 0;
    }
    struct utsname systemInfo;
    uname(&systemInfo);
    UIDevice *currentDevice = [UIDevice currentDevice];
    NSString *strName = currentDevice.name; //设备名称
    NSDictionary *dicCS=@{@"device_name":[NSString stringWithFormat:@"%@",strName],
                          @"deviceModel":[AppEnvironment deviceModelName],
                          @"appVersion":[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],
                          @"deviceOS":@(1),
                          @"deviceType":@(deviceType),
                          @"serialNumber":[AppEnvironment getDeviceId],
                          @"deviceVersion":[UIDevice currentDevice].systemVersion,
                          @"netStatus":AppNetStr,
                          @"deviceName":currentDevice.name //设备名称
                          };
    [self UserGetLicenseView:nil anddic:dicCS block:nil block:nil];
}


//验证账号是否已注册同时发送验证码
+(void)UserSendSMSandurl:(NSString *)url anddic:(NSDictionary *)parameters block:(void(^)(NSDictionary *responseObject))block block:(void(^)(NSError* error))block1{
    [EncryptAndEcode httpUrl:[NSString stringWithFormat:@"%@user/login?email=%@",AryamaskUrl,url] AndGETparameters:parameters AndHead:nil block:^(NSDictionary *responseObject) {
        block(responseObject);
    } block:^(NSError *error) {
        block1(error);
    }];
}

//验证验证码
+(void)UserVerifyEmailCatcha:(NSString *)url anddic:(NSDictionary *)parameters block:(void(^)(NSDictionary *responseObject))block block:(void(^)(NSError* error))block1{
    [EncryptAndEcode httpUrl:[NSString stringWithFormat:@"%@user/emailCaptchaVerify",AryamaskUrl] AndPostparameters:parameters AndHead:nil block:^(NSDictionary *responseObject) {
        block(responseObject);
    } block:^(NSError *error) {
        block1(error);
    }];
}


//设置密码
+(void)UserloginAfterCode:(NSString *)url anddic:(NSDictionary *)parameters block:(void(^)(NSDictionary *responseObject))block block:(void(^)(NSError* error))block1{
    [EncryptAndEcode httpUrl:[NSString stringWithFormat:@"%@user/password",AryamaskUrl] AndPostparameters:parameters AndHead:nil block:^(NSDictionary *responseObject) {
        block(responseObject);
    } block:^(NSError *error) {
        block1(error);
    }];
}

//获取设备信息
+(void)UserGetLicenseView:(NSString *)url anddic:(NSDictionary *)parameters block:(void(^)(NSDictionary *responseObject))block block:(void(^)(NSError* error))block1{
    [EncryptAndEcode httpUrl:[NSString stringWithFormat:@"%@%@",AryamaskUrl,@"device"] AndPostparameters:parameters AndHead:nil block:^(NSDictionary *responseObject) {
//        block(nil);
    } block:^(NSError *error) {
//        block1(nil);
    }];
}

//验证账号是否已注册同时发送验证码
+(void)UserTryAgainCode:(NSString *)url anddic:(NSDictionary *)parameters block:(void(^)(NSDictionary *responseObject))block block:(void(^)(NSError* error))block1{
    [EncryptAndEcode httpUrl:[NSString stringWithFormat:@"%@user/login?email=%@",AryamaskUrl,url] AndGETparameters:parameters AndHead:nil block:^(NSDictionary *responseObject) {
        block(responseObject);
    } block:^(NSError *error) {
        block1(error);
    }];
}


//退出登录
+(void)UserLogOut:(NSString *)url anddic:(NSDictionary *)parameters block:(void(^)(NSDictionary *responseObject))block block:(void(^)(NSError* error))block1{
    [EncryptAndEcode httpUrl:[NSString stringWithFormat:@"%@user/logout",AryamaskUrl]  AndPostparameters:parameters AndHead:[[NSUserDefaults standardUserDefaults] valueForKey:@"aryaToken"] block:^(NSDictionary *responseObject) {
        
        block(responseObject);
    } block:^(NSError *error) {
        block1(error);
    }];
}

//老用户的登录操作
+(void)UserloginNew:(NSString *)url anddic:(NSDictionary *)parameters block:(void(^)(NSDictionary *responseObject))block block:(void(^)(NSError* error))block1{
    [EncryptAndEcode httpUrl:[NSString stringWithFormat:@"%@user/login",AryamaskUrl]  AndPostparameters:parameters AndHead:nil block:^(NSDictionary *responseObject) {
        //登录信息
        [[NSUserDefaults standardUserDefaults] setObject:responseObject forKey:@"LoginInfoResponse"];
        NSDictionary * LoginInfoResponse = [AppEnvironment UserInfodic];
        if (LoginInfoResponse[@"data"][@"plan"][@"MYPlan_ Formal"] == 0 && [[LoginInfoResponse allKeys]  containsObject:@"data"]) { //试用用户
            [AppEnvironment ShowInfosView:@"新用户"];
        }
        block(responseObject);
    } block:^(NSError *error) {
        block1(error);
    }];
}

//设备管理
+(void)UserGetDevice:(NSString *)url anddic:(NSDictionary *)parameters block:(void(^)(NSDictionary *responseObject))block block:(void(^)(NSError* error))block1{
    
    [EncryptAndEcode httpUrl:[NSString stringWithFormat:@"%@user/device",AryamaskUrl] AndGETparameters:parameters AndHead:[[NSUserDefaults standardUserDefaults] valueForKey:@"aryaToken"] block:^(NSDictionary *responseObject) {
        block(responseObject);
    } block:^(NSError *error) {
        block1(error);
    }];
}

//发送验证码
+(void)UsersendVerify:(NSString *)url anddic:(NSDictionary *)parameters block:(void(^)(NSDictionary *responseObject))block block:(void(^)(NSError* error))block1{
    
    [EncryptAndEcode httpUrl:[NSString stringWithFormat:@"%@user/sendVerify",AryamaskUrl] AndPostparameters:parameters AndHead:nil block:^(NSDictionary *responseObject) {
        block(responseObject);
    } block:^(NSError *error) {
        block1(error);
    }];
}

//获取ss配置(获取线路列表)
+(void)Getusernodes:(NSString *)url anddic:(NSDictionary *)parameters block:(void(^)(NSDictionary *responseObject))block block:(void(^)(NSError* error))block1{
    
    [EncryptAndEcode httpUrl:[NSString stringWithFormat:@"%@nodes",AryamaskUrl] AndGETparameters:parameters AndHead:[[NSUserDefaults standardUserDefaults] valueForKey:@"aryaToken"] block:^(NSDictionary *responseObject) {
        block(responseObject);
    } block:^(NSError *error) {
        block1(error);
    }];
}

//获取套餐
+(void)Oderplans:(NSString *)url anddic:(NSDictionary *)parameters block:(void(^)(NSDictionary *responseObject))block block:(void(^)(NSError* error))block1{
    
    [EncryptAndEcode httpUrl:[NSString stringWithFormat:@"%@order/plans",AryamaskUrl] AndGETparameters:parameters AndHead:[[NSUserDefaults standardUserDefaults] valueForKey:@"aryaToken"] block:^(NSDictionary *responseObject) {
        block(responseObject);
    } block:^(NSError *error) {
        block1(error);
    }];
}

//验证折扣码
+(void)ValidinvitedCode:(NSString *)url anddic:(NSDictionary *)parameters block:(void(^)(NSDictionary *responseObject))block block:(void(^)(NSError* error))block1{
    
    [EncryptAndEcode httpUrl:[NSString stringWithFormat:@"%@order/invitedCode/valid",AryamaskUrl] AndPostparameters:parameters AndHead:[[NSUserDefaults standardUserDefaults] valueForKey:@"aryaToken"] block:^(NSDictionary *responseObject) {
        block(responseObject);
    } block:^(NSError *error) {
        block1(error);
    }];
}

//创建订单
+(void)Createorder:(NSString *)url anddic:(NSDictionary *)parameters block:(void(^)(NSDictionary *responseObject))block block:(void(^)(NSError* error))block1{
    
    [EncryptAndEcode httpUrl:[NSString stringWithFormat:@"%@order",AryamaskUrl] AndPostparameters:parameters AndHead:[[NSUserDefaults standardUserDefaults] valueForKey:@"aryaToken"] block:^(NSDictionary *responseObject) {
        block(responseObject);
    } block:^(NSError *error) {
        block1(error);
    }];
}

//获取订单列表
+(void)Getorderlist:(NSString *)url anddic:(NSDictionary *)parameters block:(void(^)(NSDictionary *responseObject))block block:(void(^)(NSError* error))block1{
    
    [EncryptAndEcode httpUrl:[NSString stringWithFormat:@"%@order",AryamaskUrl] AndGETparameters:parameters AndHead:[[NSUserDefaults standardUserDefaults] valueForKey:@"aryaToken"] block:^(NSDictionary *responseObject) {
        block(responseObject);
    } block:^(NSError *error) {
        block1(error);
    }];
}

//展示订单详情
+(void)Getorderinfo:(NSString *)url anddic:(NSDictionary *)parameters block:(void(^)(NSDictionary *responseObject))block block:(void(^)(NSError* error))block1{
    
    [EncryptAndEcode httpUrl:[NSString stringWithFormat:@"%@order/%@",AryamaskUrl,url] AndGETparameters:parameters AndHead:[[NSUserDefaults standardUserDefaults] valueForKey:@"aryaToken"] block:^(NSDictionary *responseObject) {
        block(responseObject);
    } block:^(NSError *error) {
        block1(error);
    }];
}

//验证邀请码
+(void)invitedCode:(NSString *)url anddic:(NSDictionary *)parameters block:(void(^)(NSDictionary *responseObject))block block:(void(^)(NSError* error))block1{
    [EncryptAndEcode httpUrl:[NSString stringWithFormat:@"%@order/invitedCode/valid%@",AryamaskUrl,url] AndPostparameters:parameters AndHead:[[NSUserDefaults standardUserDefaults] valueForKey:@"aryaToken"] block:^(NSDictionary *responseObject) {
        block(responseObject);
    } block:^(NSError *error) {
        block1(error);
    }];
}


//DownLoad CountryMap.json
+ (void)DownLoadCountryMapjson{
//    // 1. 创建url
    NSString *urlStr = @"http://testapi.aryamask.com/static/json/nodeCountryMap.json";
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"#%^{}\"[]|\\<> "].invertedSet];

    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *Url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:Url];
    NSURLSession *session = [NSURLSession sharedSession];

    NSURLSessionDownloadTask *downLoadTask = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            // 下载成功
            // 注意 location是下载后的临时保存路径, 需要将它移动到需要保存的位置
            NSError *saveError;

            // 创建一个自定义存储路径
            NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
            NSString *savePath = [cachePath stringByAppendingPathComponent:@"nodeCountryMapjson"];
            NSURL *saveURL = [NSURL fileURLWithPath:savePath];

            // 做存在的事情（清除上一个文件）
            [ClearCacheTool clearCache];;

            // 文件复制到cache路径中
            [[NSFileManager defaultManager] copyItemAtURL:location toURL:saveURL error:&saveError];

            if (!saveError) {
                NSString *textFileContents =  [NSString stringWithContentsOfFile:savePath encoding:NSUTF8StringEncoding error:nil] ;
                // 将文件数据化
                NSData *data = [[NSData alloc] initWithContentsOfFile:savePath];
                // 对数据进行JSON格式化并返回字典形式
                [[NSUserDefaults standardUserDefaults] setObject:[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil] forKey:@"CountryMap.json"];
            }
        }
        else{
            //重新获取
            [self DownLoadCountryMapjson];
        }
    }];
    // 恢复线程, 启动任务
    [downLoadTask resume];
    

    
}



@end
