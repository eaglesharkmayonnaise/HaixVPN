//
//  SocketManager.m
//  TCPSocketServer-Demo
//
//  Created by 郭艾超 on 16/7/2.
//  Copyright © 2016年 Steven. All rights reserved.
//

#import "SocketManagerBF.h"
#import "GCDAsyncSocket.h"

@implementation SocketManagerBF
+ (SocketManagerBF *)sharedSocketManager
{
    static SocketManagerBF *socket = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        socket = [[SocketManagerBF alloc] init];
    });
    return socket;
}
@end
