//
//  OSDecodeAndEncrypt.m
//  JieMaDemo
//
//  Created by MasterLambert on 2017/1/7.
//  Copyright © 2017年 MasterLambert. All rights reserved.
//

#import "OSDecodeAndEncrypt.h"

@implementation OSDecodeAndEncrypt

#pragma mark --- 加密
+ (NSString *) enCryptKey:(NSString *) key strPassword:(NSString *) str{
    NSInteger length_key = key.length;
    NSInteger length_str = str.length;
    NSMutableString * strDecode = [NSMutableString string];
    unsigned char key_str;
    unsigned char str_str;
    for (int i = 0;  i < length_str; i++) {
        str_str = [str characterAtIndex:i];
        for (int j = 0; j < length_key; j++) {
            
            key_str = [key characterAtIndex:j];
            str_str = str_str ^ key_str;
        }
        NSString * qb = [NSString stringWithFormat:@"%02X",str_str];
        [strDecode appendString:qb];
    }
    return strDecode;
}
#pragma mark --- 解密
+ (NSString *) deCryptKey:(NSString *) key strPassword:(NSString *) str{
    NSInteger length_str = str.length;
    NSMutableString * strDecode = [NSMutableString stringWithCapacity:length_str/2];
    char high,low;
    for ( int i = 0 ; i < length_str; i+=2) {
        high = [str characterAtIndex:i];
        low = [str characterAtIndex:i + 1];
        if (high >= '0' && high <= '9')
            high = high - '0';
        else if (high >= 'A' && high <= 'F')
            high = high - 'A' + 10;
        else if (high >= 'a' && high <= 'f')
            high = high - 'a' + 10;
        else
            return @"";
        
        if (low >= '0' && low <= '9')
            low = low - '0';
        else if (low >= 'A' && low <= 'F')
            low = low - 'A' + 10;
        else if (low >= 'a' && low <= 'f')
            low = low - 'a' + 10;
        else
            return @"";
        NSString * strP = [NSString stringWithFormat:@"%C",(unichar)(high << 4 | low)];
        [strDecode appendString:strP];
    }
    return [self xorEncodeKey:key strDecode:strDecode];
}

+ (NSString *) xorEncodeKey:(NSString *) key strDecode:(NSString *) str{
    NSUInteger length_key = key.length;
    NSUInteger length_str = str.length;
    NSMutableString * strDecode = [NSMutableString stringWithCapacity:length_str];
    char szDate;
    for (int i = 0; i < length_str; i++) {
        szDate = [str characterAtIndex:i];
        for (int j = 0; j < length_key; j++) {
            szDate = szDate ^ [key characterAtIndex:j];
        }
        [strDecode appendString:[NSString stringWithFormat:@"%c",szDate]];
    }
    return strDecode;
}

@end
