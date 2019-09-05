//
//  NetUtil.h
//  NetUtil
//
//  Created by bailong on 16/1/27.
//  Copyright © 2016年 Qiniu Cloud Storage. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *    Network Type
 */
typedef NS_ENUM(NSUInteger, QNNetWorkType) {
    /**
     *    No network.
     */
    QNNetWorkType_None = 0,
    /**
     *    WIFI network
     */
    QNNetWorkType_WIFI,
    /**
     *    Mobile network(2G/3G/4G/...)
     */
    QNNetWorkType_MOBILE,
};

/**
 *    Namespace
 */
@interface QNNetworkInfo : NSObject

/**
 *    the ipv4 of the device
 *
 *    @return ipv4 string
 */
+ (NSString *)deviceIP;

/**
 *    the dns server list of the device, ipv4
 *
 *    @return ipv4 string list
 */
+ (NSArray *)localDNSServers;

/**
 *    networktype
 *
 *    @return networktype enum
 */
+ (QNNetWorkType)networkType;

/**
 *    network description
 *
 *    @return wife/evdo/gsm/...
 */
+ (NSString *)networkDescription;

@end
