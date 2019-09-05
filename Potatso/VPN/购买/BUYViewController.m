//
//  BUYViewController.m
//  VPN
//
//  Created by Apple on 16/9/21.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "BUYViewController.h"
#import <StoreKit/StoreKit.h>//APP内支付
#import <AdSupport/ASIdentifierManager.h>
#import "LCProgressHUD.h"
#import "AFNetworking.h"
#import "GetMiYao.h"
#import "SAMKeychain.h"
@interface BUYViewController ()<SKPaymentTransactionObserver, SKProductsRequestDelegate>
@end

@implementation BUYViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self createLoadUI];
    NSDictionary *dic =  [GetMiYao toDict];
}

- (void) createLoadUI{

  
}
@end
