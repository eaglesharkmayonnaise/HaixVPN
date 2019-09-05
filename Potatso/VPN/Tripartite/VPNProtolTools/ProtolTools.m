//
//  ProtolTools.m
//  XiongMaoVPNPro
//
//  Created by ISOYasser on 16/6/25.
//  Copyright © 2016年 ISOYasser. All rights reserved.
//

#import "ProtolTools.h"

@implementation ProtolTools

//vpn缓存protocol的路径
#define NEVPNProtocolIKEv2Path [NSSearchPathForDirectoriesInDomains (NSCachesDirectory,NSUserDomainMask,YES)[0] stringByAppendingPathComponent:@"NEVPNProtocolIKEv2.data"]

#define NEVPNProtocolIKEv2Key @"NEVPNProtocolIKEv2Key"
+ (void) saverProtol:(NEVPNProtocolIKEv2 *) protocol{
    NSMutableData *data = [NSMutableData data];
    
    // 将数据区连接到一个 NSKeyedArchiver 对象
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:protocol forKey:NEVPNProtocolIKEv2Key];
//    NSString *cachePath = NSSearchPathForDirectoriesInDomains (NSCachesDirectory,NSUserDomainMask,YES)[0];
//    // 2. 拼接完整路径「全路径」
//    NSString *filePath = [cachePath stringByAppendingPathComponent:@"person.data"];
    [archiver finishEncoding];
    
    // 将存档的数据写入文件
    [data writeToFile:NEVPNProtocolIKEv2Path atomically:YES];

}

+ (NEVPNProtocolIKEv2 *)getProtocol{
    NSData *data = [NSData dataWithContentsOfFile:NEVPNProtocolIKEv2Path];
    // 根据数据，解析成一个NSKeyedUnarchiver对象
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NETunnelProviderProtocol * p = [unarchiver decodeObjectForKey:NEVPNProtocolIKEv2Key];
    // 恢复完毕
    [unarchiver finishDecoding];
    
    return p;

}

@end
