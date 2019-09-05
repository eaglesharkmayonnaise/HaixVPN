//
//  Settings.m
//  Potatso
//
//  Created by LEI on 7/13/16.
//  Copyright © 2016 TouchingApp. All rights reserved.
//

#import "Settings.h"
#import "Potatso.h"

#define kSettingsKeyStartTime @"startTime"

@interface Settings ()
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@end

@implementation Settings

+ (Settings *)shared {
    static Settings *settings;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        settings = [Settings new];
    });
    return settings;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _userDefaults = [[NSUserDefaults alloc] initWithSuiteName: [Potatso sharedGroupIdentifier]];
    }
    return self;
}

- (void)setStartTime:(NSDate *)startTime {
    NSTimeInterval sec = [startTime timeIntervalSinceNow];
    NSDate * currentDate = [[NSDate alloc] initWithTimeIntervalSinceNow:sec];
    
    //设置时间输出格式：
    NSDateFormatter * df = [[NSDateFormatter alloc] init ];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * na = [df stringFromDate:currentDate];
    [self.userDefaults setObject:na forKey:kSettingsKeyStartTime];
    [self.userDefaults synchronize];
}
#pragma mark 返回连接时间date形式
// if let time = Settings.shared().startTime
- (NSString *)startTime {
    return [self.userDefaults objectForKey:kSettingsKeyStartTime];
}

@end
