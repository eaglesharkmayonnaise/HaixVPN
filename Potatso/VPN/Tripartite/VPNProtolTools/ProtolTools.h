//
//  ProtolTools.h
//  XiongMaoVPNPro
//
//  Created by ISOYasser on 16/6/25.
//  Copyright © 2016年 ISOYasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NetworkExtension/NetworkExtension.h>

@interface ProtolTools : NSObject

+ (void) saverProtol:(NEVPNProtocolIKEv2 *) protocol;

+ (NEVPNProtocolIKEv2 *) getProtocol;

@end
