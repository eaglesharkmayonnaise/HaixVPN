//
//  NSString+RemoveSpace.m
//  Potatso
//
//  Created by bananaon 2018/2/3.
//  Copyright © 2018年 TouchingApp. All rights reserved.
//

#import "NSString+RemoveSpace.h"

@implementation NSString (RemoveSpace)

+ (NSString *)removeSpaceAndNewline:(NSString *)str{
    NSString *temp = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"(" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@")" withString:@""];
    return temp;
}

+ (NSString *)removeSpaceAndNewlinecopy:(NSString *)str{
    NSString *temp = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"(" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@")" withString:@""];
    return temp;
}

+ (NSString *)removeSpaceAndNewlinecopy1:(NSString *)str{
    NSString *temp = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    return temp;
}

+ (NSString *)removeSpaceAndNewlinemoney:(NSString *)str{
    NSString *temp = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"$" withString:@""];
    return temp;
}


@end
