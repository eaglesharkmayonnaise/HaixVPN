//
//  EncryptAndEcode.h
//  XiongMaoJiaSu
//
//  Created by 唐晓波的电脑 on 16/6/7.
//  Copyright © 2016年 ISOYasser. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCDAsyncSocket.h" // for TCP
#import "GCDAsyncUdpSocket.h" // for UDP

@interface EncryptAndEcode : NSObject

@property (nonatomic,assign) GCDAsyncSocket *socket;

//socket
-(void)connectToServer;
-(void)sendMessageAction;



//post
+(void)httpUrl:(NSString *)url AndPostparameters:(NSDictionary *)parameters AndHead:(NSString *) head block:(void(^)(NSDictionary* responseObject))block block:(void(^)(NSError* error))block1;

//get
+(void)httpUrl:(NSString *)url AndGETparameters:(NSDictionary *)parameters AndHead:(NSString *) head block:(void(^)(NSDictionary* responseObject))block block:(void(^)(NSError* error))block1;

//download proxylist
+ (void)downFileFromServerblock:(void(^)(NSArray* responseObject))block errorblock:(void(^)(NSString * error))block1;
@end
