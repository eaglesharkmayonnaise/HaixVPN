//
//  NSObject+RandomColor.m
//  AMTumblrHudDemo
//
//  Created by cdc on 16/4/28.
//  Copyright © 2016年 askar. All rights reserved.
//

#import "NSObject+RandomColor.h"

@implementation NSObject (RandomColor)

+(UIColor *) randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 ); //0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5; // 0.5 to 1.0,away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5; //0.5 to 1.0,away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}
@end
