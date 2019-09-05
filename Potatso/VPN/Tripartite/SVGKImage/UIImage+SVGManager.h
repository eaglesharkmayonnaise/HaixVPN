//
//  UIImage+SVGManager.h
//  Potatso
//
//  Created by txb on 2018/6/13.
//  Copyright © 2018年 TouchingApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (SVGManager)
/**
 show svg image
 
 @param name svg name
 @param size image size
 @param tintColor image color
 @return svg image
 */
+ (UIImage *)svgImageNamed:(NSString *)name size:(CGSize)size tintColor:(UIColor *)tintColor ;

@end
