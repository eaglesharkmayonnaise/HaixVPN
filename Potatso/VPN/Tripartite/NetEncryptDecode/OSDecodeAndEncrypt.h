//
//  OSDecodeAndEncrypt.h
//  JieMaDemo
//
//  Created by MasterLambert on 2017/1/7.
//  Copyright © 2017年 MasterLambert. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OSDecodeAndEncrypt : NSObject

/**
 加密

 @param key 钥匙
 @param str 要加密字符串
 @return 加密后的字符串
 */
+ (NSString *) enCryptKey:(NSString *) key strPassword:(NSString *) str;

/**
 解密

 @param key 钥匙
 @param str 要解密的字符串
 @return 解密后的字符串
 */
+ (NSString *) deCryptKey:(NSString *) key strPassword:(NSString *) str;

@end
