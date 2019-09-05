//
//  HXHUD.h
//  
//
//  Created by cdc on 16/4/29.
//  Copyright © 2016年 Cem Olcay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXHUD : UIView
- (void)showWithOverlay:(BOOL)bg;
- (void)hide;
- (void)setHudColor:(UIColor *)hudColor;
@end
