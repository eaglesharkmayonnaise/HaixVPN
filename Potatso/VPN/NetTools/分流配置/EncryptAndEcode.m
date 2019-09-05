
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
#import "LCProgressHUD.h"
#import "ClearCacheTool.h"
@implementation EncryptAndEcode

//解密
+(void)httpUrl:(NSString *)url AndPostparameters:(NSDictionary *)parameters block:(void(^)(NSDictionary* responseObject))block
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//设置相应内容类型
    manager.requestSerializer.timeoutInterval = 8;//超时时间
    
    
    manager.responseSerializer.acceptableContentTypes = nil;//[NSSet setWithObject:@"text/ plain"];
    manager.securityPolicy = [AFSecurityPolicy defaultPolicy];
    manager.securityPolicy.allowInvalidCertificates = YES;//忽略https证书
    manager.securityPolicy.validatesDomainName = NO;//是否验证域名
    //获取当前系统语言
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
    NSString *currentLanguage = [languages objectAtIndex:0];
    NSDictionary *headerFieldValueDictionary;
    if([currentLanguage isEqualToString:@"en"]){
        headerFieldValueDictionary = @{@"LANGUAGE":@"en"};
//        [request setValue:@"en" forHTTPHeaderField:@"LANGUAGE"];
    }
    else{
          headerFieldValueDictionary = @{@"LANGUAGE":@"zh-CN"};
//        [request setValue:@"zh-CN" forHTTPHeaderField:@"LANGUAGE"];
    }
    
    
    if (headerFieldValueDictionary != nil) {
        for (NSString *httpHeaderField in headerFieldValueDictionary.allKeys) {
            NSString *value = headerFieldValueDictionary[httpHeaderField];
            [manager.requestSerializer setValue:value forHTTPHeaderField:httpHeaderField];
        }
    }
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject1) {
        NSString *str1=[[NSString alloc]initWithData:responseObject1 encoding:NSUTF8StringEncoding];
        //不加密
        NSDictionary *responseObject =[self dictionaryWithJsonString:str1];
        block(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
        if(error == nil)
        {
            [LCProgressHUD  hide];
            return ;
        }
        [LCProgressHUD showFailure:@"网络连接失败，请切换网络尝试"];
        //获取错误信息
        NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        if(errorData != nil)
        {
            NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
           
            if([NSString stringWithFormat:@"%@",serializedData].length>10){
             
                [LCProgressHUD showFailure:[NSString stringWithFormat:@"%@",[serializedData valueForKey:@"msg"]]];
            }
            else{
                
            }
        }
        
    }];
}




//解密
+(void)httpanderrorUrl:(NSString *)url AndPostparameters:(NSDictionary *)parameters block:(void(^)(NSDictionary* responseObject))block block:(void(^)(NSError* error))block1
{
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
        //        [request setValue:@"en" forHTTPHeaderField:@"LANGUAGE"];
    }
    else{
        headerFieldValueDictionary = @{@"LANGUAGE":@"zh-CN"};
        //        [request setValue:@"zh-CN" forHTTPHeaderField:@"LANGUAGE"];
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
        NSDictionary *responseObject =[self dictionaryWithJsonString:str1];
        block(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
         block1(error);
    }];
}

//get
+(void)httpUrl:(NSString *)url AndGETparameters:(NSDictionary *)parameters block:(void(^)(NSString* responseObject))block
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//设置相应内容类型
    manager.requestSerializer.timeoutInterval = 8;//超时时间
    manager.responseSerializer.acceptableContentTypes = nil;//[NSSet setWithObject:@"text/ plain"];
    manager.securityPolicy = [AFSecurityPolicy defaultPolicy];
    manager.securityPolicy.allowInvalidCertificates = YES;//忽略https证书
    manager.securityPolicy.validatesDomainName = NO;//是否验证域名
    
    //获取当前系统语言
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
    NSString *currentLanguage = [languages objectAtIndex:0];
    NSDictionary *headerFieldValueDictionary;
    if([currentLanguage isEqualToString:@"en"]){
        headerFieldValueDictionary = @{@"LANGUAGE":@"en"};
        //        [request setValue:@"en" forHTTPHeaderField:@"LANGUAGE"];
    }
    else{
        headerFieldValueDictionary = @{@"LANGUAGE":@"zh-CN"};
        //        [request setValue:@"zh-CN" forHTTPHeaderField:@"LANGUAGE"];
    }
 
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject1) {
        
        NSString *str1=[[NSString alloc]initWithData:responseObject1 encoding:NSUTF8StringEncoding];
        
        block(str1);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"--get-----%@",error);
    }];
}



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
                    [self getlist];
                });
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self getlist];
            });
        }
    }];
    // 恢复线程, 启动任务
    [downLoadTask resume];
}

+(void)getlist{
    //写入国外域名段
    NSString *textFileContents = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Potatso2"ofType:@"pcf"] encoding:NSUTF8StringEncoding error:nil];
    NSArray *lines = [textFileContents componentsSeparatedByString:@"\n"];
    NSMutableArray *chinaiparr = [[NSMutableArray alloc]init];
    for (NSString *ip in lines) {
        if (ip != nil) {
            [chinaiparr addObject:ip];
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:chinaiparr forKey:@"Foreignurl"];
}


+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        return nil;
    }
    return dic;
}


+ (NSString *)removeSpaceAndNewline:(NSString *)str{
    NSString *temp = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"(" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@")" withString:@""];
    return temp;
}


+(NSString*) decode64:(NSString*)str {
    
    str = [str stringByReplacingOccurrencesOfString:@"-" withString:@"+"];
    str = [str stringByReplacingOccurrencesOfString:@"_" withString:@"/"];
    if(str.length%4){
        NSInteger length = (4-str.length%4) + str.length;
        str = [str stringByPaddingToLength: length withString:@"=" startingAtIndex:0];
    }
    NSData* decodeData = [[NSData alloc] initWithBase64EncodedString:str options:0];
    NSString* decodeStr = [[NSString alloc] initWithData:decodeData encoding:NSUTF8StringEncoding];
    return decodeStr;
}


+ (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}


@end
