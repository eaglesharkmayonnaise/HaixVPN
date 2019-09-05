//
//  ProxyManager.m
//  Potatso
//
//  Created by LEI on 2/23/16.
//  Copyright © 2016 TouchingApp. All rights reserved.
//

#import "ProxyManager.h"
#import <ShadowPath/ShadowPath.h>
#import <netinet/in.h>
#import "PotatsoBase.h"
#import <arpa/inet.h>
#include <dns.h>
#include <netdb.h>

@interface ProxyManager ()
@property (nonatomic) BOOL socksProxyRunning;
@property (nonatomic) int socksProxyPort;
@property (nonatomic) BOOL httpProxyRunning;
@property (nonatomic) int httpProxyPort;
@property (nonatomic) BOOL shadowsocksProxyRunning;
@property (nonatomic) int shadowsocksProxyPort;
@property (nonatomic, copy) SocksProxyCompletion socksCompletion;
@property (nonatomic, copy) HttpProxyCompletion httpCompletion;
@property (nonatomic, copy) ShadowsocksProxyCompletion shadowsocksCompletion;
- (void)onSocksProxyCallback: (int)fd;
- (void)onHttpProxyCallback: (int)fd;
- (void)onShadowsocksCallback:(int)fd;
@end

void http_proxy_handler(int fd, void *udata) {
    ProxyManager *provider = (__bridge ProxyManager *)udata;
    [provider onHttpProxyCallback:fd];
}

void shadowsocks_handler(int fd, void *udata) {
    ProxyManager *provider = (__bridge ProxyManager *)udata;
    [provider onShadowsocksCallback:fd];
}

int sock_port (int fd) {
    struct sockaddr_in sin;
    socklen_t len = sizeof(sin);
    if (getsockname(fd, (struct sockaddr *)&sin, &len) < 0) {
        NSLog(@"getsock_port(%d) error: %s",
              fd, strerror (errno));
        return 0;
    }else{
        return ntohs(sin.sin_port);
    }
}

@implementation ProxyManager

+ (ProxyManager *)sharedManager {
    static dispatch_once_t onceToken;
    static ProxyManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [ProxyManager new];
    });
    return manager;
}

- (void)startSocksProxy:(SocksProxyCompletion)completion {
    self.socksCompletion = [completion copy];
    NSString *confContent = [NSString stringWithContentsOfURL:[Potatso sharedSocksConfUrl] encoding:NSUTF8StringEncoding error:nil];
    confContent = [confContent stringByReplacingOccurrencesOfString:@"${ssport}" withString:[NSString stringWithFormat:@"%d", [self shadowsocksProxyPort]]];
    int fd = [[AntinatServer sharedServer] startWithConfig:confContent];
    [self onSocksProxyCallback:fd];
}

- (void)stopSocksProxy {
    [[AntinatServer sharedServer] stop];
    self.socksProxyRunning = NO;
}

- (void)onSocksProxyCallback:(int)fd {
    NSError *error;
    if (fd > 0) {
        self.socksProxyPort = sock_port(fd);
        self.socksProxyRunning = YES;
    }else {
        error = [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier] code:100 userInfo:@{NSLocalizedDescriptionKey: @"Fail to start socks proxy"}];
    }
    if (self.socksCompletion) {
        self.socksCompletion(self.socksProxyPort, error);
    }
}

# pragma mark - Shadowsocks

- (void)startShadowsocks: (ShadowsocksProxyCompletion)completion {
    self.shadowsocksCompletion = [completion copy];
    [NSThread detachNewThreadSelector:@selector(_startShadowsocks) toTarget:self withObject:nil];
}

- (void)_startShadowsocks {
    NSString *confContent = [NSString stringWithContentsOfURL:[Potatso sharedProxyConfUrl] encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *json = [confContent jsonDictionary];
    __block NSString *host = [NSString stringWithFormat:@"%@",json[@"host"]];
    if ([self isStringContainNumberWith:host]) {
        host= [self getIPAddressByHostName:host];//dns解析域名
    }
    else{
        host = [self removeSpaceAndNewline:host];//去空格
    }
    NSNumber *port = json[@"port"];
    NSString *password = json[@"password"];
    NSString *authscheme = json[@"authscheme"];
    NSString *protocol = json[@"protocol"];
    NSString *obfs = json[@"obfs"];
    NSString *obfs_param = json[@"obfs_param"];
//    NSString *aclpath = [[NSBundle mainBundle] pathForResource:@"chn"ofType:@"acl"];
    BOOL ota = [json[@"ota"] boolValue];
    if (host && port && password && authscheme) {
        profile_t profile;
        memset(&profile, 0, sizeof(profile_t));
        profile.remote_host = strdup([host UTF8String]);
        profile.remote_port = [port intValue];
        profile.password = strdup([password UTF8String]);
        profile.method = strdup([authscheme UTF8String]);
        profile.local_addr = "127.0.0.1";
//        profile.acl = strdup([aclpath UTF8String]);
        profile.local_port = 0;
        profile.timeout = 600;
        profile.auth = ota;
        if (protocol.length > 0) {
            profile.protocol = strdup([protocol UTF8String]);
        }
        if (obfs.length > 0) {
            profile.obfs = strdup([obfs UTF8String]);
        }
        if (obfs_param.length > 0) {
            profile.obfs_param = strdup([obfs_param UTF8String]);
        }
        start_ss_local_server(profile, shadowsocks_handler, (__bridge void *)self);
    }else {
        if (self.shadowsocksCompletion) {
            self.shadowsocksCompletion(0, nil);
        }
        return;
    }
}

- (void)stopShadowsocks {
    // Do nothing
}

- (void)onShadowsocksCallback:(int)fd {
    NSError *error;
    if (fd > 0) {
        self.shadowsocksProxyPort = sock_port(fd);
        self.shadowsocksProxyRunning = YES;
    }else {
        error = [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier] code:100 userInfo:@{NSLocalizedDescriptionKey: @"Fail to start http proxy"}];
    }
    if (self.shadowsocksCompletion) {
        self.shadowsocksCompletion(self.shadowsocksProxyPort, error);
    }
}

# pragma mark - Http Proxy

- (void)startHttpProxy:(HttpProxyCompletion)completion {
    self.httpCompletion = [completion copy];
    [NSThread detachNewThreadSelector:@selector(_startHttpProxy:) toTarget:self withObject:[Potatso sharedHttpProxyConfUrl]];
}

- (void)_startHttpProxy: (NSURL *)confURL {
    struct forward_spec *proxy = NULL;
    if (self.shadowsocksProxyPort > 0) {
        proxy = (malloc(sizeof(struct forward_spec)));
        memset(proxy, 0, sizeof(struct forward_spec));
        proxy->type = SOCKS_5;
        proxy->gateway_host = "127.0.0.1";
        proxy->gateway_port = self.shadowsocksProxyPort;
    }
    shadowpath_main(strdup([[confURL path] UTF8String]), proxy, http_proxy_handler, (__bridge void *)self);
}

- (void)stopHttpProxy {
    //    polipoExit();
    //    self.httpProxyRunning = NO;
}

- (void)onHttpProxyCallback:(int)fd {
    NSError *error;
    if (fd > 0) {
        self.httpProxyPort = sock_port(fd);
        self.httpProxyRunning = YES;
    }else {
        error = [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier] code:100 userInfo:@{NSLocalizedDescriptionKey: @"Fail to start http proxy"}];
    }
    if (self.httpCompletion) {
        self.httpCompletion(self.httpProxyPort, error);
    }
}

//域名解IP
- (NSString*)getIPAddressByHostName:(NSString*)strHostName
{
    const char* szname = [strHostName UTF8String];
    struct hostent* phot ;
    @try{
        phot = gethostbyname(szname);
    }
    @catch (NSException * e){
        return nil;
    }
    struct in_addr ip_addr;
    memcpy(&ip_addr,phot->h_addr_list[0],4);///h_addr_list[0]里4个字节,每个字节8位，此处为一个数组，一个域名对应多个ip地址或者本地时一个机器有多个网卡
    char ip[20] = {0};
    inet_ntop(AF_INET, &ip_addr, ip, sizeof(ip));
    NSString* strIPAddress = [NSString stringWithUTF8String:ip];
    return strIPAddress;
}


// 判断字符串中是否包含英文字母
- (BOOL)isStringContainNumberWith:(NSString *)str {
    NSRegularExpression *numberRegular = [NSRegularExpression regularExpressionWithPattern:@"[A-Za-z]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSInteger count = [numberRegular numberOfMatchesInString:str options:NSMatchingReportProgress range:NSMakeRange(0, str.length)];
    //count是str中包含[A-Za-z]数字的个数，只要count>0，说明str中包含
    if (count > 0) {
        return YES;
    }
    return NO;
}

//清楚空格
- (NSString *)removeSpaceAndNewline:(NSString *)str{
    NSString *temp = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return temp;
}

@end

