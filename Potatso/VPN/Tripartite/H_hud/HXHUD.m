//
//  HXHUD.m
//  
//
//  Created by cdc on 16/4/29.
//  Copyright © 2016年 Cem Olcay. All rights reserved.
//

#import "HXHUD.h"

#import "AppDelegate.h"
#import "NSObject+RandomColor.h"
#define kShowHideAnimateDuration 0.2


#define FadeDuration    0.3

#define APPDELEGATE     ((AppDelegate*)[[UIApplication sharedApplication] delegate])





#pragma mark - GiFHUD Private

@interface HXHUD ()
{
    NSMutableArray *hudRects;
    BOOL flag;
}

@property (nonatomic, strong) UIView *overlayView;
@property (nonatomic, assign) BOOL shown;

@end



#pragma mark - GiFHUD Implementation
@implementation HXHUD



#pragma mark Lifecycle
- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self setAlpha:0];
//        [self setCenter:APPDELEGATE.window.center];
        [self setClipsToBounds:NO];
        [self.layer setBackgroundColor:[[UIColor colorWithWhite:0 alpha:1] CGColor]];
        
        [self.layer setMasksToBounds:YES];
        
        [self configUI];
        [self setHudColor:nil];
        [APPDELEGATE.window addSubview:self];
    }
    return self;
}



#pragma mark HUD

- (void)showWithOverlay:(BOOL)bg{
    flag=bg;
    [self dismiss:^{
        [APPDELEGATE.window addSubview:[self overlay:bg]];
        [self show];
    }];
}

- (void)show {
    [self dismiss:^{
        [APPDELEGATE.window bringSubviewToFront:self];
        [self setShown:YES];
        [self fadeIn];
    }];
}


- (void)hide {
    if (![self shown])
        return;
    
    [[self  overlay:flag] removeFromSuperview];
    [self fadeOut];
}

- (void)dismiss:(void(^)(void))complated {
    if (![self shown])
        return complated ();
    
    [self fadeOutComplate:^{
        [[self overlay:flag] removeFromSuperview];
        complated ();
    }];
}

#pragma mark Effects

- (void)fadeIn {
    //   [self.imageView startAnimating];
    [UIView animateWithDuration:FadeDuration animations:^{
        [self setAlpha:1];
    }];
}

- (void)fadeOut {
    [UIView animateWithDuration:FadeDuration animations:^{
        [self setAlpha:0];
    } completion:^(BOOL finished) {
        [self setShown:NO];
        //    [self.imageView stopAnimating];
    }];
}

- (void)fadeOutComplate:(void(^)(void))complated {
    [UIView animateWithDuration:FadeDuration animations:^{
        [self setAlpha:0];
    } completion:^(BOOL finished) {
        [self setShown:NO];
        //      [self.imageView stopAnimating];
        complated ();
    }];
}


- (UIView *)overlay : (BOOL)bg{
    
    if (!self.overlayView) {
        self.overlayView = [[UIView alloc] initWithFrame:APPDELEGATE.window.frame];
        if(bg==NO)
        {
        [self.overlayView setBackgroundColor:[UIColor clearColor]];
        }else{
            [self.overlayView setBackgroundColor:[UIColor clearColor]];
        }
            [self.overlayView setAlpha:0];
        
        [UIView animateWithDuration:FadeDuration animations:^{
            [self.overlayView setAlpha:0.3];
        }];
    }
    return self.overlayView;
}


- (void)configUI {
    self.backgroundColor = [UIColor clearColor];
    
    UIView *rect1 = [self drawRectAtPosition:CGPointMake(10, 2)];
    UIView *rect2 = [self drawRectAtPosition:CGPointMake(27, 2)];
    UIView *rect3 = [self drawRectAtPosition:CGPointMake(44, 2)];
//    UIView *rect4 = [self drawRectAtPosition:CGPointMake(61, 2)];
//    UIView *rect5 = [self drawRectAtPosition:CGPointMake(78, 2)];
    
    [self addSubview:rect1];
    [self addSubview:rect2];
    [self addSubview:rect3];
//    [self addSubview:rect4];
//    [self addSubview:rect5];
    
    [self doAnimateCycleWithRects:@[rect1, rect2, rect3]];
}

#pragma mark - animation

- (void)doAnimateCycleWithRects:(NSArray *)rects {
    __weak typeof(self) wSelf = self;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (0.25 * 0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [wSelf animateRect:rects[0] withDuration:0.5];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (0.25 * 0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [wSelf animateRect:rects[1] withDuration:0.5];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (0.2 * 0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [wSelf animateRect:rects[2] withDuration:0.5];
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (0.2 * 0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [wSelf animateRect:rects[3] withDuration:0.5];
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (0.2 * 0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                        [wSelf animateRect:rects[4] withDuration:0.5];
//
//                    });
//                });
            });
        });
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [wSelf doAnimateCycleWithRects:rects];
    });
}

- (void)animateRect:(UIView *)rect withDuration:(NSTimeInterval)duration {
    [rect setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    
    [UIView animateWithDuration:duration
                     animations:^{
                         rect.alpha = 1;
                         rect.transform = CGAffineTransformMakeScale(0.3,0.3);
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:duration
                                          animations:^{
                                              rect.alpha = 0.5;
                                              rect.transform = CGAffineTransformMakeScale(1.5, 1.5);
                                          } completion:^(BOOL f) {
                                              
                                          }];
                     }];
}

#pragma mark - drawing

- (UIView *)drawRectAtPosition:(CGPoint)positionPoint {
    UIView *rect = [[UIView alloc] init];
    CGRect rectFrame;
    rectFrame.size.width = 12;
    rectFrame.size.height = 12;
    rectFrame.origin.x = positionPoint.x;
    rectFrame.origin.y = positionPoint.y;
    rect.frame = rectFrame;
    rect.backgroundColor = [UIColor whiteColor];
    rect.alpha = 0.5;
    rect.layer.cornerRadius = 6;
    //    rect.transform = CGAffineTransformMakeScale(0,0);
    if (hudRects == nil) {
        hudRects = [[NSMutableArray alloc] init];
    }
    [hudRects addObject:rect];
    return rect;
}

#pragma mark - Setters

- (void)setHudColor:(UIColor *)hudColor{
    
    for (UIView *rect in hudRects) {
        if(hudColor==nil)
        {
            rect.backgroundColor =[UIColor whiteColor];
        }else{
            rect.backgroundColor=hudColor;
        }}
}


- (void)dealloc {
    hudRects = nil;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


@end
