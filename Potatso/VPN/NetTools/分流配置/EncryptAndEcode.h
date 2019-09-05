//
//  EncryptAndEcode.h
//  XiongMaoJiaSu
//
//  Created by 唐晓波的电脑 on 16/6/7.
//  Copyright © 2016年 ISOYasser. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EncryptAndEcode : NSObject

+(void)httpUrl:(NSString *)url AndPostparameters:(NSDictionary *)parameters block:(void(^)(NSDictionary* responseObject))block;
+(void)httpanderrorUrl:(NSString *)url AndPostparameters:(NSDictionary *)parameters block:(void(^)(NSDictionary* responseObject))block block:(void(^)(NSError* error))block1;
+(void)httpUrl:(NSString *)url AndGetparameters:(NSDictionary *)parameters block:(void(^)(NSDictionary* responseObject))block block1:(void(^)(NSError *error))block1;
+(void)httpUrl:(NSString *)url AndGETparameters:(NSDictionary *)parameters block:(void(^)(NSString* responseObject))block;
+ (void)downFileFromServerblock:(void(^)(NSArray* responseObject))block errorblock:(void(^)(NSString * error))block1;
@end
