//
//  MonitorFlow.h
//  MonitorFlow
//
//  Created by Yes-Cui on 16/10/27.
//  Copyright © 2016年 Yes-Cui. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MonitorFlow;
// 88kB/s
extern NSString *const GSDownloadNetworkSpeedNotificationKey;
// 2MB/s
extern NSString *const GSUploadNetworkSpeedNotificationKey;
@interface MonitorFlow : NSObject
@property (nonatomic, copy, readonly) NSString*downloadNetworkSpeed;
@property (nonatomic, copy, readonly) NSString *uploadNetworkSpeed;
+ (instancetype)shareNetworkSpeed;
- (void)start;
- (void)stop;
@end

