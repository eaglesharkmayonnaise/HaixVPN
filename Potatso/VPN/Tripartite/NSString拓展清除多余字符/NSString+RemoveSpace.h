//
//  NSString+RemoveSpace.h
//  Potatso
//
//  Created by bananaon 2018/2/3.
//  Copyright © 2018年 TouchingApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (RemoveSpace)
+ (NSString *)removeSpaceAndNewline:(NSString *)str;
+ (NSString *)removeSpaceAndNewlinecopy:(NSString *)str;
+ (NSString *)removeSpaceAndNewlinecopy1:(NSString *)str;
+ (NSString *)removeSpaceAndNewlinemoney:(NSString *)str;
@end
