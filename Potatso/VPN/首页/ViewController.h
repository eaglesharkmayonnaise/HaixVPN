//
//  ViewController.h
//  VPN
//
//  Created by Apple on 16/9/20.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VAProgressCircle.h"
@interface ViewController : UIViewController<VAProgressCircleDelegate>
/**
 选中行数
 */
@property (nonatomic, assign) NSInteger selectedIndex;

-(void)MyPlane;

+(void)ShowShadowViewHide:(NSString *)Orhide;
@end


