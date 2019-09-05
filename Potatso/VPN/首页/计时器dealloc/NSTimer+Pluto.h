//
//  NSTimer+Pluto.h
//  TimerDemo
//
//  Created by 马德茂 on 16/5/4.
//  Copyright © 2016年 马德茂. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Pluto)
/**
 *  创建一个不会造成循环引用的循环执行的Timer
 */
+ (instancetype)pltScheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo;

@end
