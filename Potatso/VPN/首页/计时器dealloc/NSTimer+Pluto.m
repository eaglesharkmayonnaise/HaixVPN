//
//  NSTimer+Pluto.m
//  TimerDemo
//
//  Created by 马德茂 on 16/5/4.
//  Copyright © 2016年 马德茂. All rights reserved.
//

#import "NSTimer+Pluto.h"

@interface PltTimerTarget : NSObject

@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, weak) NSTimer *timer;

@end

@implementation PltTimerTarget

- (void)pltTimerTargetAction:(NSTimer *)timer
{
    if (self.target) {
        [self.target performSelector:self.selector withObject:timer afterDelay:0.0];
    } else {
        [self.timer invalidate];
        self.timer = nil;
    }
}

@end

@implementation NSTimer (Pluto)

+ (instancetype)pltScheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo
{
    PltTimerTarget *timerTarget = [[PltTimerTarget alloc] init];
    timerTarget.target = aTarget;
    timerTarget.selector = aSelector;
    NSTimer *timer = [NSTimer timerWithTimeInterval:ti target:timerTarget selector:@selector(pltTimerTargetAction:) userInfo:userInfo repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    timerTarget.timer = timer;
    return timerTarget.timer;
}

@end
