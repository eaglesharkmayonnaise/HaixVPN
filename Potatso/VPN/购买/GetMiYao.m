//
//  GetMiYao.m
//  VPN
//
//  Created by Apple on 16/9/26.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "GetMiYao.h"
#import "SAMKeychain.h"
@implementation GetMiYao

+ (NSString *)getDeviceId {
    // 读取设备号
    NSString *localDeviceId = [SAMKeychain passwordForService:@"密码" account:@"账号"];
    if (!localDeviceId) {
        // 保存设备号
        CFUUIDRef deviceId = CFUUIDCreate(NULL);
        assert(deviceId != NULL);
        CFStringRef deviceIdStr = CFUUIDCreateString(NULL, deviceId);
        [SAMKeychain setPassword:[NSString stringWithFormat:@"%@", deviceIdStr] forService:@"密码" account:@"账号"];
        localDeviceId = [NSString stringWithFormat:@"%@", deviceIdStr];
    }
    return localDeviceId;
}

@end
