
//
//  EncryptAndEcode.m
//  XiongMaoJiaSu
//
//  Created by 唐晓波的电脑 on 16/6/7.
//  Copyright © 2016年 ISOYasser. All rights reserved.
//

//加密解密
#import "EncryptAndEcode.h"
#import "AFNetworking.h"
#import "cccc.h"
#import "LCProgressHUD.h"
#import "SocketManagerBF.h"
@implementation EncryptAndEcode

- (void)connectToServer {
    // 1.与服务器通过三次握手建立连接
    NSString *host = @"47.74.23.169";
    int port = 5775;
    
    _socket.IPv4PreferredOverIPv6 = NO; // 设置支持IPV6
    //创建一个socket对象
    _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    
    //连接
    NSError *error = nil;
    [_socket connectToHost:host onPort:port error:&error];
    
    if (error) {
        NSLog(@"%@",error);
    }
}


#pragma mark -socket的代理
#pragma mark 发送数据
- (void)sendMessageAction {
    
    [_socket writeData:[@"我是txb数据" dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
}

static NSTimer *mytime;
#pragma mark 连接成功
-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    NSLog(@"-TCP连接成功--%s",__func__);
    SocketManagerBF * socketManager = [SocketManagerBF sharedSocketManager];
    socketManager.mySocket = sock;
     [self sendMessageAction];
    NSLog(@"didConnectToHost");
    //连上之后可以每隔30s发送一次心跳包
    mytime =[NSTimer scheduledTimerWithTimeInterval:30.0f target:self selector:@selector(sendMessageAction) userInfo:nil repeats:YES];
    [mytime fire];
    
}


#pragma mark 断开连接
-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    if (err) {
        NSLog(@"TCP连接失败");
             [self connectToServer];
//        self.status= -1;
//        if(self.reconnection_time>=0 && self.reconnection_time <= kMaxReconnection_time) {
//            [self.timer invalidate];
//            self.timer=nil;
//            int time =pow(2,self.reconnection_time);
//            self.timer= [NSTimer scheduledTimerWithTimeInterval:time target:selfselector:@selector(reconnection) userInfo:nil repeats:NO];
//            self.reconnection_time++;
//            NSLog(@"socket did reconnection,after %ds try again",time);
//        } else {
//            self.reconnection_time=0;
//            NSLog(@"socketDidDisconnect:%p withError: %@", sock, err);
////        }
    }else{
        NSLog(@"TCP正常断开");
    }
}


#pragma mark 数据发送成功
-(void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    NSLog(@"TCP数据发送成功%s",__func__);
    
    //发送完数据手动读取，-1不设置超时
    [sock readDataWithTimeout:-1 tag:tag];
}

#pragma mark 读取数据
-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
//    NSString *receiverStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"TCP取数据%s %@",__func__,receiverStr);
//    // 将messageDict进行序列化（这里也可以使用kryo进行序列化，详情见http://www.jianshu.com/p/43f2a39ce1fd）
//    NSData *contents = [NSJSONSerialization dataWithJSONObject:messageDict options:NSJSONWritingPrettyPrinted error:&error];
//    if(error)
//    {
//        MyLog(@"%s--------error:%@",__func__,error);
//    }
//    // 获取长度
//    int len = (int)contents.length;
//    
//    NSData *lengthData = [NSData dataWithBytes:&len length:sizeof(len)];
//    // 发送长度
//    [self.socket writeData:lengthData withTimeout:-1 tag:0];
//    // 发送真实数据
//    [self.socket writeData:contents withTimeout:-1 tag:0];
//    // 读取数据
//    [self.socket readDataWithTimeout:-1 tag:0];
    
    //断开连接
    //[self.socket disconnect];
}





//POST
+(void)httpanderrorUrl:(NSString *)url AndPostparameters:(NSDictionary *)parameters block:(void(^)(NSDictionary* responseObject))block block:(void(^)(NSError* error))block1{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//设置相应内容类型
    manager.requestSerializer.timeoutInterval = 8;//超时时间
    //获取当前系统语言
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
    NSString *currentLanguage = [languages objectAtIndex:0];
    NSDictionary *headerFieldValueDictionary;
    if([currentLanguage isEqualToString:@"en"]){
        headerFieldValueDictionary = @{@"LANGUAGE":@"en"};
    }
    else{
        headerFieldValueDictionary = @{@"LANGUAGE":@"zh-CN"};
    }
    manager.responseSerializer.acceptableContentTypes = nil;//[NSSet setWithObject:@"text/ plain"];
    manager.securityPolicy = [AFSecurityPolicy defaultPolicy];
    manager.securityPolicy.allowInvalidCertificates = YES;//忽略https证书
    manager.securityPolicy.validatesDomainName = NO;//是否验证域名
    
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject1) {
        //        NSString *key = @"4cb4e74033fa753935c873e664323486@";
        NSString *str1=[[NSString alloc]initWithData:responseObject1 encoding:NSUTF8StringEncoding];
        //不加密
        NSDictionary *responseObject =[AppEnvironment dictionaryWithJsonString:str1];
        block(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        block1(error);
    }];
}


//get
+(void)httpUrl:(NSString *)url AndGETparameters:(NSDictionary *)parameters AndHead:(NSString *) head block:(void(^)(NSDictionary* responseObject))block block:(void(^)(NSError* error))block1{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//设置相应内容类型
    manager.requestSerializer.timeoutInterval = 8;//超时时间
    manager.responseSerializer.acceptableContentTypes = nil;//[NSSet setWithObject:@"text/ plain"];
    manager.securityPolicy = [AFSecurityPolicy defaultPolicy];
    manager.securityPolicy.allowInvalidCertificates = YES;//忽略https证书
    manager.securityPolicy.validatesDomainName = NO;//是否验证域名
    [manager.requestSerializer setValue:head forHTTPHeaderField:@"ARYATOKEN"];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject1) {
        
        NSString *str1=[[NSString alloc]initWithData:responseObject1 encoding:NSUTF8StringEncoding];
        NSDictionary *responseObject =[AppEnvironment dictionaryWithJsonString:str1];
        block(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"--error-----%@",error);
        block1(error);
    }];
}


//post head
+(void)httpUrl:(NSString *)url AndPostparameters:(NSDictionary *)parameters AndHead:(NSString *) head block:(void(^)(NSDictionary* responseObject))block block:(void(^)(NSError* error))block1{

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//设置相应内容类型
    manager.requestSerializer.timeoutInterval = 8;//超时时间
    manager.responseSerializer.acceptableContentTypes = nil;//[NSSet setWithObject:@"text/ plain"];
    manager.securityPolicy = [AFSecurityPolicy defaultPolicy];
    manager.securityPolicy.allowInvalidCertificates = YES;//忽略https证书
    manager.securityPolicy.validatesDomainName = NO;//是否验证域名
    [manager.requestSerializer setValue:head forHTTPHeaderField:@"ARYATOKEN"];
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject1) {
        //        NSString *key = @"4cb4e74033fa753935c873e664323486@";
        NSString *str1=[[NSString alloc]initWithData:responseObject1 encoding:NSUTF8StringEncoding];
        //不加密
        NSDictionary *responseObject =[AppEnvironment dictionaryWithJsonString:str1];
        block(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block1(error);
    }];
}


//todo
//proxylist
static NSURLSessionDownloadTask *_downloadTask;
+ (void)downFileFromServerblock:(void(^)(NSArray* responseObject))block errorblock:(void(^)(NSString * error))block1{
    dispatch_async(dispatch_get_main_queue(), ^{
        //           [LCProgressHUD showLoading:@"导入中"];
    });
    // 1. 创建url
    NSString *urlStr = @"https://raw.githubusercontent.com/aishuidedabai/Pro-x-ylist/master/Potatso2.pcf";
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *Url = [NSURL URLWithString:urlStr];
    
    // 创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:Url];
    
    // 创建会话
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDownloadTask *downLoadTask = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            // 下载成功
            // 注意 location是下载后的临时保存路径, 需要将它移动到需要保存的位置
            NSError *saveError;
            // 创建一个自定义存储路径
            NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
            NSString *savePath = [cachePath stringByAppendingPathComponent:@"filenameiplist"];
            NSURL *saveURL = [NSURL fileURLWithPath:savePath];
            //检查文件是否存在
            // 做存在的事情
            BOOL isClearSuccess = [ClearCacheTool clearCache];;
            if (isClearSuccess) {
                NSLog(@"清除成功");
            }else{
                NSLog(@"清除失败");
            }
            // 文件复制到cache路径中
            [[NSFileManager defaultManager] copyItemAtURL:location toURL:saveURL error:&saveError];
            
            if (!saveError) {
                NSString *textFileContents = [NSString stringWithContentsOfFile:savePath encoding:NSUTF8StringEncoding error:nil];
                NSArray *lines = [textFileContents componentsSeparatedByString:@"\n"];
                NSMutableArray *chinaiparr = [[NSMutableArray alloc]init];
                for (NSString *ip in lines) {
                    if (ip != nil) {
                        [chinaiparr addObject:ip];
                    }
                }
                [[NSUserDefaults standardUserDefaults] setObject:chinaiparr forKey:@"Foreignurl"];
                
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [AppEnvironment getlist];
                });
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [AppEnvironment getlist];
            });
        }
    }];
    // 恢复线程, 启动任务
    [downLoadTask resume];
}



@end
