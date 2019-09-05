//
//  UIImage+SVGManager.m
//  Potatso
//
//  Created by txb on 2018/6/13.
//  Copyright © 2018年 TouchingApp. All rights reserved.
//

#import "UIImage+SVGManager.h"
#import "SVGKImage.h"

@implementation UIImage (SVGManager)
+ (UIImage *)svgImageNamed:(NSString *)name size:(CGSize)size tintColor:(UIColor *)tintColor {
    SVGKImage *svgImage = [SVGKImage imageWithContentsOfURL:[NSURL URLWithString:name]];
    svgImage.size = size;
    CGRect rect = CGRectMake(0, 0, svgImage.size.width, svgImage.size.height);
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(svgImage.UIImage.CGImage);
    BOOL opaque = alphaInfo == kCGImageAlphaNoneSkipLast
    || alphaInfo == kCGImageAlphaNoneSkipFirst
    || alphaInfo == kCGImageAlphaNone;
    UIGraphicsBeginImageContextWithOptions(svgImage.size, opaque, svgImage.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, svgImage.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGContextClipToMask(context, rect, svgImage.UIImage.CGImage);
    CGContextSetFillColorWithColor(context, tintColor.CGColor);
    CGContextFillRect(context, rect);
    UIImage *imageOut = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageOut;
}
@end

