//
//  AppEnvironment.m
//  Potatso
//
//  Created by txb on 2018/5/15.
//  Copyright © 2018年 TouchingApp. All rights reserved.
//

#import "AppEnvironment.h"

@implementation AppEnvironment


//得到用户信息
+(NSDictionary *)UserInfodic{
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] valueForKey:@"LoginInfoResponse"];
    if (dic == nil) {
        return @{@"":@""};
    }
    return dic;
}


//写入国外域名段
+(void)getlist{
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


//获取设备码
+ (NSString *)getDeviceId {
    // 读取设备号
    NSString *localDeviceId = [SAMKeychain passwordForService:@"密码" account:@"账号"];
    if (!localDeviceId) {
        // 保存设备号
        CFUUIDRef deviceId = CFUUIDCreate(NULL);
        assert(deviceId != NULL);
        CFStringRef deviceIdStr = CFUUIDCreateString(NULL, deviceId);
        [SAMKeychain setPassword:[NSString stringWithFormat:@"%@", deviceIdStr] forService:@"密码" account:@"账号"];
        localDeviceId = [NSString stringWithFormat:@"%@", deviceIdStr];
    }
    return localDeviceId;
}


//字符串转字典
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

//展示错误的页面
+(void)ShowErrorLoading:(NSError *)error{
    dispatch_async(dispatch_get_main_queue(), ^{
        //回调或者说是通知主线程刷新
        if(error == nil){
            [LCProgressHUD  hide];
            return ;
        }
        
        //获取错误信息
        NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        
        if(errorData != nil){
            
            NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
            
            if (serializedData == nil) {
                NSData * data = error.userInfo[@"com.alamofire.serialization.response.error.data"];
                NSString * errorstr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"服务器的错误原因:%@",errorstr);
                
                //html解析
                TFHpple *Hpple = [[TFHpple alloc]initWithHTMLData:data];
                
                //测试1：获取简单的标题
                NSArray *array =[Hpple searchWithXPathQuery:@"//title"]; //获取到为title的标题
                
                for (TFHppleElement *HppleElement in array) {
                    
                    NSLog(@"测试1的目的标签内容:-- %@",HppleElement.text);
                    
                    [LCProgressHUD showFailure:HppleElement.text];
                }

            }else{
                
                [LCProgressHUD showFailure:[NSString stringWithFormat:@"%@",serializedData[@"msg"]]];
            }
        }
        else{
            [LCProgressHUD  hide];
        }
    });
}

//关闭页面(类方法里不能有self)
+(void)closeview{
//    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popViewControllerAnimated:YES];
}


//base64加密
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


//只允许输入数字
+ (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}


//tableview美化
+(void)setExtraCellLineHidden: (UITableView *)tableView{
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}


//字典转json
+ (NSString*)dictionaryToJson:(NSDictionary *)dic{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

//UI控件抖动
+(void)lockAnimationForView:(UIView*)view{
    CALayer *lbl = [view layer];
    CGPoint posLbl = [lbl position];
    CGPoint y = CGPointMake(posLbl.x-10, posLbl.y);
    CGPoint x = CGPointMake(posLbl.x+10, posLbl.y);
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction
                                  functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    [animation setAutoreverses:YES];
    [animation setDuration:0.08];
    [animation setRepeatCount:3];
    [lbl addAnimation:animation forKey:nil];
    
}


//监测网络状态
+ (void)monitorNetworking:(void(^)(NSString* responseObject))block
{
    AFNetworkReachabilityManager *networkManager = [AFNetworkReachabilityManager sharedManager];
    [networkManager startMonitoring];
    [networkManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
                block(@"网络不可达");
                // do something
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                block(@"4G");
                // do something
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                block(@"WIFI");
                // do something
                break;
            default:
                block(@"未知网络");
                break;
        }
    }];
}


/**
 *  MD5加密
 *
 *  @param string 需要加密的字符串
 *
 *  @return 返回加密后的结果
 */
+ (NSString *)md5:(NSString *)string{
    if (string == nil) {
        return @"";
    }
    // OC 字符串转换位C字符串
    const char *cStr = [string UTF8String];
    // 16位加密
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    // 1: 需要加密的C字符串
    // 2: 加密的字符串的长度
    // 3: 加密长度
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2]; // 32位
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02X", digest[i]];
    }
    // 返回一个32位长度的加密后的字符串
    return result;
}




// 距离当前时间差多少（用NSInteger表示）返回也是时间戳
+ (NSInteger)intervalSinceNow: (NSString *) theDate{
    [self UTCchangeDate:theDate];
    
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d=[date dateFromString:theDate];
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSTimeInterval cha= now-late;
    NSInteger time = round(cha);
    return time;
}


//时间戳转时间 2000-02-01 09:09:09 这种
+(NSString *)UTCchangeDate:(NSString *)utc{
    
    NSTimeInterval time = [utc doubleValue];
    
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:time];
    
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *staartstr=[dateformatter stringFromDate:date];
    
    [[AppEnvironment SetuserDefaultsGroup] setObject:staartstr forKey:@"SaveUserTime_tunl"];
    
    return staartstr;
}

+(NSUserDefaults *)SetuserDefaultsGroup{
    return [[NSUserDefaults alloc] initWithSuiteName:@"group.unblockmy.ios"];
}


/**
 * 开始到结束的时间差(两个时间戳的比较)
 */
+ (NSString *)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime{
    
    //当前时间
    NSDateFormatter*formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString*dateStrnow = [formatter stringFromDate:[NSDate date]];
    NSLog(@"当前时间是%@",dateStrnow);
    
    //传入的时间戳转时间
    NSTimeInterval time2=[startTime doubleValue];//传入的时间戳str如果是精确到毫秒的记得要/1000
    NSDate *detailDate=[NSDate dateWithTimeIntervalSince1970:time2];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; //实例化一个NSDateFormatter对象
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    endTime = [dateFormatter stringFromDate: detailDate];

    
    NSDateFormatter *date11 = [[NSDateFormatter alloc]init];
    
    [date11 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *startD =[date11 dateFromString:dateStrnow];
    
    NSDate *endD = [date11 dateFromString:endTime];
    
    NSTimeInterval start = [startD timeIntervalSince1970]*1;
    
    NSTimeInterval end = [endD timeIntervalSince1970]*1;
    
    NSTimeInterval value = end - start;
    
    int second = (int)value %60;//秒
    
    int minute = (int)value /60%60;
    
    int house = (int)value % (24 * 3600)/3600;
    
    int day = (int)value / (24 * 3600);
    
    NSString *str;
    
    if (day != 0) {
        
        str = [NSString stringWithFormat:@"耗时%d天%d小时%d分%d秒",day,house,minute,second];
        return [NSString stringWithFormat:@"%dDay %dHrs",day,house];
        
    }else if (day==0 && house != 0) {
        
        str = [NSString stringWithFormat:@"耗时%d小时%d分%d秒",house,minute,second];
        return [NSString stringWithFormat:@"%dHrs %dMin", house ,minute];
        
    }else if (day== 0 && house== 0 && minute!=0) {
        
        str = [NSString stringWithFormat:@"耗时%d分%d秒",minute,second];
        return [NSString stringWithFormat:@"%dHrs %dMin", 00 ,minute];
        
    }else{
        
        str = [NSString stringWithFormat:@"耗时%d秒",second];
        return [NSString stringWithFormat:@"%dHrs %dMin", 00 ,00];
        
    }

}


//获取设备信息
+ (NSString*)deviceModelName
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //iPhone 系列
    if ([deviceModel isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceModel isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceModel isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceModel isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceModel isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceModel isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceModel isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([deviceModel isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceModel isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([deviceModel isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceModel isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceModel isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceModel isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceModel isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceModel isEqualToString:@"iPhone9,1"])    return @"iPhone 7 (CDMA)";
    if ([deviceModel isEqualToString:@"iPhone9,3"])    return @"iPhone 7 (GSM)";
    if ([deviceModel isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus (CDMA)";
    if ([deviceModel isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus (GSM)";
    
    //iPod 系列
    if ([deviceModel isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceModel isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceModel isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceModel isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceModel isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    
    //iPad 系列
    if ([deviceModel isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceModel isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceModel isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceModel isEqualToString:@"iPad2,4"])      return @"iPad 2 (32nm)";
    if ([deviceModel isEqualToString:@"iPad2,5"])      return @"iPad mini (WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,6"])      return @"iPad mini (GSM)";
    if ([deviceModel isEqualToString:@"iPad2,7"])      return @"iPad mini (CDMA)";
    
    if ([deviceModel isEqualToString:@"iPad3,1"])      return @"iPad 3(WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,2"])      return @"iPad 3(CDMA)";
    if ([deviceModel isEqualToString:@"iPad3,3"])      return @"iPad 3(4G)";
    if ([deviceModel isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,5"])      return @"iPad 4 (4G)";
    if ([deviceModel isEqualToString:@"iPad3,6"])      return @"iPad 4 (CDMA)";
    
    if ([deviceModel isEqualToString:@"iPad4,1"])      return @"iPad Air";
    if ([deviceModel isEqualToString:@"iPad4,2"])      return @"iPad Air";
    if ([deviceModel isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([deviceModel isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceModel isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceModel isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceModel isEqualToString:@"x86_64"])       return @"Simulator";
    
    if ([deviceModel isEqualToString:@"iPad4,4"]
        ||[deviceModel isEqualToString:@"iPad4,5"]
        ||[deviceModel isEqualToString:@"iPad4,6"])      return @"iPad mini 2";
    
    if ([deviceModel isEqualToString:@"iPad4,7"]
        ||[deviceModel isEqualToString:@"iPad4,8"]
        ||[deviceModel isEqualToString:@"iPad4,9"])      return @"iPad mini 3";
    
    return deviceModel;
}





//显示到期用户和被冻结用户
static ZJAnimationPopView* popView;
+(void)ShowInfosView:(NSString *)info{
    NSString *textinfo1;
    NSString *textinfo2;
    NSString *textinfo3;
    if ([info isEqualToString:@"过期"]) {
        textinfo1 = @"EXPIRED! ";
        textinfo2 = @"Congratulations! You’ve just got a ¥ 18 coupon! You can check it out in your coupons list. ";
        textinfo3 = @"Got It";
    }
    else if ([info isEqualToString:@"新用户"]) {
        textinfo1 = @"Prompt";
        textinfo2 = @"Hello, new registered users can experience free 24 hours";
        textinfo3 = @"Use";
    }
    else{
        textinfo1 = @"Account is frozen ";
        textinfo2 = @"Sorry，you account has been frozen                                                                                                 ";
        textinfo3 = @"OK";
    }
    
    // 1.Get custom view【获取自定义控件】
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 265, 320)];
    customView.layer.cornerRadius = 10;
    customView.layer.masksToBounds =YES;
    customView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(customView.frame.size.width/2 - 40, 30, 80, 92)];
    imageView.image = [UIImage imageNamed:@"激活失败"]; //激活失败
    if ([info isEqualToString:@"新用户"]) {
       imageView.image = [UIImage imageNamed:@"新用户感叹号"];
    }
    [customView addSubview:imageView];
    
    //notifcation
    UILabel *textInviteFriendslab = [[UILabel alloc] initWithFrame:CGRectMake(0,imageView.frame.size.height + imageView.frame.origin.y + 12, customView.frame.size.width, 32)];
    textInviteFriendslab.textAlignment =1;
    textInviteFriendslab.text = textinfo1;
    textInviteFriendslab.font = [UIFont fontWithName:@"SourceSansPro-bold" size:16];
    [customView addSubview:textInviteFriendslab];
    
    //info
    UILabel *textLayer = [[UILabel alloc] initWithFrame:CGRectMake(20, textInviteFriendslab.frame.size.height + textInviteFriendslab.frame.origin.y + 5, customView.frame.size.width - 40, 60)];textLayer.lineBreakMode = NSLineBreakByWordWrapping;textLayer.numberOfLines = 0;textLayer.textColor = [UIColor colorWithRed:0.5 green:0.55 blue:0.65 alpha:1];textLayer.textAlignment = NSTextAlignmentCenter;NSString *textContent = textinfo2;NSRange textRange = NSMakeRange(0, textContent.length);NSMutableAttributedString *textString = [[NSMutableAttributedString alloc] initWithString:textContent];UIFont *font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];[textString addAttribute:NSFontAttributeName value:font range:textRange];NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];paragraphStyle.lineSpacing = 1.25;[textString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:textRange];textLayer.attributedText = textString;[textLayer sizeToFit];
    [customView addSubview:textLayer];
    
    //Click ON
    UIButton *layer = [[UIButton alloc] initWithFrame:CGRectMake(customView.frame.size.width/2 -64,textLayer.frame.size.height + textLayer.frame.origin.y + 10, 128, 32)];
    layer.layer.cornerRadius = 16;
    [layer addTarget:self action:@selector(GotIt) forControlEvents:UIControlEventTouchUpInside];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0, 0, 128, 32);gradient.colors = @[(id)[[UIColor colorWithRed:0.83 green:0.68 blue:1 alpha:1] CGColor],    (id)[[UIColor colorWithRed:0.41 green:0.56 blue:1 alpha:1] CGColor]];gradient.locations = @[@(0), @(1)];gradient.startPoint = CGPointMake(1, 0);gradient.endPoint = CGPointMake(0, 1);gradient.cornerRadius = 16;[[layer layer] addSublayer:gradient];
    [layer setTitle:textinfo3 forState:0];
    [layer setTitleColor:[UIColor whiteColor] forState:0];
    layer.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-bold" size:16];
    [customView addSubview:layer];
    
    // 2.Init【初始化】
   popView = [[ZJAnimationPopView alloc] initWithCustomView:customView popStyle:ZJAnimationPopStyleShakeFromTop dismissStyle:ZJAnimationDismissStyleCardDropToTop];
    
    // 3.Set properties,can not be set【设置属性，可不设置使用默认值，见注解】
    // 3.1 显示时点击背景是否移除弹框
    popView.isClickBGDismiss = YES;
    // 3.2 显示时背景的透明度
    popView.popBGAlpha = 0.5f;
    // 3.3 显示时是否监听屏幕旋转
    popView.isObserverOrientationChange = YES;
    // 3.4 显示时动画时长
    popView.popAnimationDuration = 0.4f;
    // 3.5 移除时动画时长
    popView.dismissAnimationDuration = 0.4f;
    
    // 3.6 显示完成回调
    popView.popComplete = ^{
        NSLog(@"显示完成");
    };
    // 3.7 移除完成回调
    popView.dismissComplete = ^{
        NSLog(@"移除完成");
    };
    
    // 4.pop view【显示弹框】
    [popView pop];
}

+(void)GotIt{
    //已到期
    if ([[AppEnvironment UserInfodic][@"data"][@"plan"][@"remain"] intValue] == 0) {
        [popView dismiss];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GoBuyMyplane" object:nil];
        return;
    }
    if ([AppEnvironment UserInfodic][@"data"][@"plan"][@"MYPlan_ Formal"] == 0) { //试用用户
         [popView dismiss];
        return;
    }
    [popView dismiss];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GoBuyMyplane" object:nil];
}

//获取连接时长
+(void)GetConnectTime{
    [NSTimer pltScheduledTimerWithTimeInterval:1.0 target:self selector:@selector(GetNowTime) userInfo:nil];
}

//获得连接时间的时长
+(NSString *)GetNowTime{
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"UB判断连接"] isEqualToString:@"1"]) {
        NSString* timestr = [NSString stringWithFormat:@"%@",[[[NSUserDefaults alloc] initWithSuiteName:@"group.unblockmy.ios"] valueForKey:@"startTime"]];
        int time = [timestr intValue];
        if (time <= 1) {
            return @"0000-00-00 00:00:00:00";;
        }
       return [self timeFormattedConnect:(long)[self intervalSinceNowConnect:timestr]]; //连接时间的输出形式
    }else{
        return @"0000-00-00 00:00:00:00";;
    }
}


//距离当前时间差多少（用NSInteger表示）
+ (NSInteger)intervalSinceNowConnect: (NSString *) theDate{
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d=[date dateFromString:theDate];
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSTimeInterval cha= now-late;
    NSInteger time = round(cha);
    return time;
}


// 用来比较的时间判断是否到期了
+(NSString *)performTotime{

    NSString *createdAtString = [AppEnvironment UTCchangeDate:[AppEnvironment UserInfodic][@"data"][@"plan"][@"endDateUnixTimestamp"]];;
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSDate *createdAtDate = [fmt dateFromString:createdAtString];
    
    // 手机当前时间
    NSDate *nowDate = [NSDate date];
    
    NSComparisonResult result = [nowDate compare:createdAtDate];
    
    if (result == NSOrderedAscending) { // 升序, 越往右边越大  //未过期
        return @"未过期";
        
    } else { // 降序, 越往右边越小   //过期了
        
      return @"过期";
    }
}



//时间数量转为年月日00:00:00 用来计算首页连接时间
+ (NSString *)timeFormattedConnect:(long int)value{
    long int second = (int)value %60;//秒
    
    long int minute = (int)value /60%60;
    
    long int house = (int)value % (24 * 3600)/3600;
    
    long int day = (int)value / (24 * 3600);
    
    if (day != 0) {
        
        return [NSString stringWithFormat:@"%02ld:%02ld:00:00",day,house];
        
    }else if (day==0 && house != 0) {
        
        return [NSString stringWithFormat:@"00:%02ld:%02ld:00",house,minute];
        
    }else {
        if (minute == 0) {
            minute = 00;
        }
        return [NSString stringWithFormat:@"00:00:%02ld:%02ld",minute,second];
    }
    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld:%02ld",day,house, minute, second];
}



//处理内存警告⚠️
//+(void)didReceiveMemoryWarning{
//
//    [super didReceiveMemoryWarning];//即使没有显示在window上，也不会自动的将self.view释放。
//    // Add code to clean up any of your own resources that are no longer necessary.
//
//    // 此处做兼容处理需要加上ios6.0的宏开关，保证是在6.0下使用的,6.0以前屏蔽以下代码，否则会在下面使用self.view时自动加载viewDidUnLoad
//
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
//
//        //需要注意的是self.isViewLoaded是必不可少的，其他方式访问视图会导致它加载 ，在WWDC视频也忽视这一点。
//
//        if (self.isViewLoaded && !self.view.window)// 是否是正在使用的视图
//        {
//            // Add code to preserve data stored in the views that might be
//            // needed later.
//
//            // Add code to clean up other strong references to the view in
//            // the view hierarchy.
//            self.view = nil;// 目的是再次进入时能够重新加载调用viewDidLoad函数。
//        }
//
//    }
//}

//查看各个控件对应的key值在这里采用了runtime机制，方法如下
//unsigned int count = 0;
//Ivar *ivarList = class_copyIvarList([UILabel class], &count);
//for (int i = 0; i<count; i++) {
//    Ivar ivar = ivarList[i];
//    printf("%s\n",ivar_getName(ivar));
//}
//free(ivarList);


/**
 *根据给定的size的宽高比自动缩放原图片、自动判断截取位置,进行图片截取
 * UIImage image 原始的图片
 * CGSize size 截取图片的size
 */
+(UIImage *)clipImage:(UIImage *)image toRect:(CGSize)size{
    
    //被切图片宽比例比高比例小 或者相等，以图片宽进行放大
    if (image.size.width*size.height <= image.size.height*size.width) {
        
        //以被剪裁图片的宽度为基准，得到剪切范围的大小
        CGFloat width  = image.size.width;
        CGFloat height = image.size.width * size.height / size.width;
        
        // 调用剪切方法
        // 这里是以中心位置剪切，也可以通过改变rect的x、y值调整剪切位置
        return [self imageFromImage:image inRect:CGRectMake(0, (image.size.height -height)/2, width, height)];
        
    }else{ //被切图片宽比例比高比例大，以图片高进行剪裁
        
        // 以被剪切图片的高度为基准，得到剪切范围的大小
        CGFloat width  = image.size.height * size.width / size.height;
        CGFloat height = image.size.height;
        
        // 调用剪切方法
        // 这里是以中心位置剪切，也可以通过改变rect的x、y值调整剪切位置
        return [self imageFromImage:image inRect:CGRectMake((image.size.width -width)/2, 0, width, height)];
    }
    return nil;
}

/**
 *从图片中按指定的位置大小截取图片的一部分
 * UIImage image 原始的图片
 * CGRect rect 要截取的区域
 */
+(UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect{
    
    //将UIImage转换成CGImageRef
    CGImageRef sourceImageRef = [image CGImage];
    
    //按照给定的矩形区域进行剪裁
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    
    //将CGImageRef转换成UIImage
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    //返回剪裁后的图片
    return newImage;
}

@end
