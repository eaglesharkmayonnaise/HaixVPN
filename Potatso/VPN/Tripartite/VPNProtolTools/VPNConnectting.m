//
//  VPNManager.m
//  XiongMaoVPNPro
//
//  Created by ISOYasser on 16/6/23.
//  Copyright © 2016年 ISOYasser. All rights reserved.
//

#import "VPNConnectting.h"



@interface VPNConnectting ()


@property (nonatomic, strong) NEVPNManager * vpnManager;
@end


@implementation VPNConnectting

//类的初始化
- (instancetype)init{
    if (self = [super init]) {
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self
               selector:@selector(vpnStatusDidChanged:)
                   name:NEVPNStatusDidChangeNotification
                 object:nil];
        _vpnManager = [self vpnManager];
    }
    
    return self;
}


static VPNConnectting* _instance = nil;
+(instancetype) shareInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init] ;
        
    }) ;
    
    return _instance ;
}


- (NEVPNManager *)vpnManager{
    if (!_vpnManager) {
        _vpnManager = [NEVPNManager sharedManager];
    }
    return _vpnManager;
}


-(void)VPNconnectZT
{
    NEVPNStatus status = self.vpnManager.connection.status;
    if (status == NEVPNStatusConnected
        || status == NEVPNStatusConnecting
        || status == NEVPNStatusReasserting) {
        //        //已连接
        //        //存进去沙盒
        //        [[NSUserDefaults standardUserDefaults] setObject:@"连接成功IOS8" forKey:@"判断连接"];
        //        NSNotification *notification =[NSNotification notificationWithName:@"连接成功" object:nil userInfo:nil];
        //        //通过通知中心发送通知
        //        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
    } else {
        //        //已断开
        //        NSNotification *notification =[NSNotification notificationWithName:@"连接失败" object:nil userInfo:nil];
        //        //通过通知中心发送通知
        //        [[NSNotificationCenter defaultCenter] postNotification:notification];
        //        //存进去沙盒进行判断是否在加速中
        //        [[NSUserDefaults standardUserDefaults] setObject:@"连接失败IOS8" forKey:@"判断连接"];
    }
}
-(void)VPNconnect
{
    NEVPNStatus status = self.vpnManager.connection.status;
    if (status == NEVPNStatusConnected
        || status == NEVPNStatusConnecting
        || status == NEVPNStatusReasserting) {
        [self disconnect];
        
    } else {
        [self connect];
    }
}

- (void)disconnect
{
    [self.vpnManager.connection stopVPNTunnel];
}

- (void)connect {
    [self connectVPN];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(vpnConfigDidChanged:)
               name:NEVPNConfigurationChangeNotification
             object:nil];
    
}

- (void)vpnConfigDidChanged:(NSNotification *)notification
{
    // TODO: Save configuration failed
    [self startConnecting];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NEVPNConfigurationChangeNotification
                                                  object:nil];
}

- (void)startConnecting
{
    NSError *startError;
    [self.vpnManager.connection startVPNTunnelAndReturnError:&startError];
    if (startError) {
        NSLog(@"Start VPN failed: [%@]", startError.localizedDescription);
    }
}
#pragma masrk-----连接VPN
- (void) connectVPN{
    //保存
    [self installProfile];
    
    [self.vpnManager loadFromPreferencesWithCompletionHandler:^(NSError *error) {
        if (error) {
            
            NSLog(@"Load config failed [%@]", error.localizedDescription);
            return;
        }
        
    }];
}

static  NEVPNProtocolIKEv2 *p;
#pragma masrk-----安装VPN
- (void)installProfile {
    
    NSString *stt=[NSString stringWithFormat:@"%@",[_dicall valueForKey:@"is_test"]];
    NSString *username=nil;
    NSString *usepasswod=nil;
    if([stt isEqualToString:@"1"])//非注册
    {
        
        username =[NSString stringWithFormat:@"0$%@$%@$%@",_fuwuqid,[_dicall valueForKey:@"test_uid"],[_dicall valueForKey:@"test_username"]];
        usepasswod=[NSString stringWithFormat:@"%@",[_dicall valueForKey:@"test_password"]];
    }
    else{//注册用户
        
        usepasswod=[NSString stringWithFormat:@"%@",[_dicall valueForKey:@"password"]];
        username =[NSString stringWithFormat:@"0$%@$%@$%@",_fuwuqid,[_dicall valueForKey:@"uid"],[_dicall valueForKey:@"username"]];
    }
    
    if(_dicall.count == 0)
    {
        username = @"熊猫加速器";usepasswod= @"123";
        self.server = @"10.0.0.2";
    }
    
    
    NSLog(@"-------%@----%@------%@",username,usepasswod,self.server);
    
    NSString *remoteIdentifier = self.server;
    NSString *localIdnetifier = self.server;
    
    
    // Save password & psk
    [self createKeychainValue:usepasswod forIdentifier:@"VPN_PASSWORD"];
    
    // [self createKeychainValue:_presharedKey.text forIdentifier:@"PSK"];
    // Load config from perference
    
    [self.vpnManager loadFromPreferencesWithCompletionHandler:^(NSError *error) {
        
        if (error) {
            
            NSLog(@"Load config failed [%@]", error.localizedDescription);
            return;
        }
        
        p = (NEVPNProtocolIKEv2 *)self.vpnManager.protocol;
        if (p) {
        } else {
            p = [[NEVPNProtocolIKEv2 alloc] init];
        }
        
        p.username = username;
        
        
        p.serverAddress = self.server;
        // Get password persistent reference from keychain
        // If password doesn't exist in keychain, should create it beforehand.
        // [self createKeychainValue:@"your_password" forIdentifier:@"VPN_PASSWORD"];
        p.passwordReference = [self searchKeychainCopyMatching:@"VPN_PASSWORD"];
        // PSK
        
        p.authenticationMethod = NEVPNIKEAuthenticationMethodCertificate | NEVPNIKEAuthenticationMethodNone | NEVPNIKEAuthenticationMethodSharedSecret;//证书连接方式
        // [self createKeychainValue:@"your_psk" forIdentifier:@"PSK"];
        p.sharedSecretReference = [self searchKeychainCopyMatching:@"PSK"];
        /*
         // certificate 证书
         p.identityData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"client" ofType:@"p12"]];
         p.identityDataPassword = @"[Your certificate import password]";
         */
        p.identityData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"client" ofType:@"p12"]];
        p.identityDataPassword = @"1234qwqw";
        p.localIdentifier = localIdnetifier;//本地标识符
        p.remoteIdentifier = remoteIdentifier;//局部标识符
        p.useExtendedAuthentication = YES;
        p.disconnectOnSleep = NO;//手机进入睡眠的时候断开VPN
        
        //按需连接，需要定义规则(这是在用到网络链接的时候，链接VPN)
        //        [self.vpnManager setOnDemandEnabled:YES];
        //        NSMutableArray *rules = [[NSMutableArray alloc] init];
        //        NEOnDemandRuleConnect *connectRule = [NEOnDemandRuleConnect new];
        //        [rules addObject:connectRule];
        //        [self.vpnManager setOnDemandRules:rules];
        
        //把协议放给p
        self.vpnManager.protocol = p;
        self.vpnManager.localizedDescription = @"熊猫加速器";
        self.vpnManager.enabled = YES;
        
        [self.vpnManager saveToPreferencesWithCompletionHandler:^(NSError *error) {
            if (error) {//初始化证书失败·
                NSLog(@"Save config failed [%@]", error.localizedDescription);
            }
            else{//安装成功
                
                [[NSUserDefaults standardUserDefaults] setObject:@"初始化成功" forKey:@"VPN配置"];
            }
        }];
        
        //        [self.vpnManager.connection startVPNTunnelAndReturnError:nil];
        //
        
        
        
        
        
    }];
    
}

- (void)judgeStatusVpn {
    
    
    
    [self.vpnManager loadFromPreferencesWithCompletionHandler:^(NSError *error) {
        
        [self vpnStatusDidChanged:nil];
        
    }];
    
}


//断开连接后改变配置
-(void)lianjieyincang
{
    
    [self.vpnManager loadFromPreferencesWithCompletionHandler:^(NSError *error) {
        if (error) {
            NSLog(@"Load config failed [%@]", error.localizedDescription);
            return;
        }
        p = (NEVPNProtocolIKEv2 *)self.vpnManager.protocol;
        if (p) {
        } else {
            p = [[NEVPNProtocolIKEv2 alloc] init];
        }
        p.username = @"熊猫加速器";
        p.serverAddress = @"10.0.0.2";
        self.vpnManager.protocol = p;
        [self.vpnManager saveToPreferencesWithCompletionHandler:^(NSError *error) {
        }];
        
    }];
    
}

static int m;
- (void)vpnStatusDidChanged:(NSNotification *)notification
{
    
    NEVPNStatus status = _vpnManager.connection.status;
    switch (status) {
        case NEVPNStatusConnected:
        {
            //存进去沙盒
            [[NSUserDefaults standardUserDefaults] setObject:@"连接成功8" forKey:@"判断连接"];
            
            NSNotification *notification =[NSNotification notificationWithName:@"连接成功" object:nil userInfo:nil];
            //通过通知中心发送通知
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            self.CallBackBlock();
        }
            break;
        case NEVPNStatusInvalid:
        case NEVPNStatusDisconnected:
        {
            
            if([[[NSUserDefaults standardUserDefaults] objectForKey:@"判断连接"] isEqualToString:@"连接成功8"])
            {
                NSNotification *notification =[NSNotification notificationWithName:@"连接失败" object:nil userInfo:nil];
                //通过通知中心发送通知
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                //存进去沙盒进行判断是否在加速中
                [[NSUserDefaults standardUserDefaults] setObject:@"连接失败8" forKey:@"判断连接"];
                //                [self lianjieyincang];
                //                self.weilianjie();
                
            }
        }
            
            //ljgg
            break;
        case NEVPNStatusConnecting:
        case NEVPNStatusReasserting:
        {
            //            self.lianjiezhong();
            //            NSNotification *notification =[NSNotification notificationWithName:@"连接中" object:nil userInfo:nil];
            //            //通过通知中心发送通知
            //            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }
            
            //正在连接中...
            
            //            _actionButton.enabled = YES;
            //            [_actionButton setTitle:@"Connecting..." forState:UIControlStateNormal];
            //            _activityIndicator.hidden = NO;
            //            [_activityIndicator startAnimating];
            break;
        case NEVPNStatusDisconnecting:
            
            //正在失去连接。。。
            //            _actionButton.enabled = NO;
            //            [_actionButton setTitle:@"Disconnecting..." forState:UIControlStateDisabled];
            //            _activityIndicator.hidden = NO;
            //            [_activityIndicator startAnimating];
            break;
        default:
            break;
    }
}



static NSString * const serviceName = @"im.zorro.ipsec_demo.vpn_config";

- (NSMutableDictionary *)newSearchDictionary:(NSString *)identifier {
    NSMutableDictionary *searchDictionary = [[NSMutableDictionary alloc] init];
    
    [searchDictionary setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    
    NSData *encodedIdentifier = [identifier dataUsingEncoding:NSUTF8StringEncoding];
    [searchDictionary setObject:encodedIdentifier forKey:(__bridge id)kSecAttrGeneric];
    [searchDictionary setObject:encodedIdentifier forKey:(__bridge id)kSecAttrAccount];
    [searchDictionary setObject:serviceName forKey:(__bridge id)kSecAttrService];
    return searchDictionary;
}


- (NSData *)searchKeychainCopyMatching:(NSString *)identifier {
    NSMutableDictionary *searchDictionary = [self newSearchDictionary:identifier];
    
    // Add search attributes
    [searchDictionary setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    
    // Add search return types
    // Must be persistent ref !!!!
    [searchDictionary setObject:@YES forKey:(__bridge id)kSecReturnPersistentRef];
    
    CFTypeRef result = NULL;
    SecItemCopyMatching((__bridge CFDictionaryRef)searchDictionary, &result);
    
    return (__bridge_transfer NSData *)result;
}

- (BOOL)createKeychainValue:(NSString *)password forIdentifier:(NSString *)identifier {
    NSMutableDictionary *dictionary = [self newSearchDictionary:identifier];
    
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)dictionary);
    
    NSData *passwordData = [password dataUsingEncoding:NSUTF8StringEncoding];
    [dictionary setObject:passwordData forKey:(__bridge id)kSecValueData];
    
    status = SecItemAdd((__bridge CFDictionaryRef)dictionary, NULL);
    
    if (status == errSecSuccess) {
        return YES;
    }
    return NO;
}

@end
