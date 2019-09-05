//
//  GCDSocketManager.h
//  Potatso
//
//  Created by txb on 2017/10/20.
//  Copyright © 2017年 TouchingApp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"
@interface GCDSocketManager : NSObject

@property(nonatomic,strong) GCDAsyncSocket *socket;

//单例
+ (instancetype)sharedSocketManager;

//连接
- (void)connectToServer;

//断开
- (void)cutOffSocket;

@end
