//
//  HeaderView.m
//  WSWTableViewFoldOpen
//
//  Created by WSWshallwe on 2017/5/25.
//  Copyright © 2017年 shallwe. All rights reserved.
//

#import "HeaderView.h"

@interface HeaderView ()

@property (nonatomic,strong) UIImageView *iv;

@end

@implementation HeaderView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self customView];
    }
    return self;
}
-(void)customView
{
    self.labelyear = [[UILabel alloc]initWithFrame:CGRectMake(20,15, kscreenw, 20)];
    self.labelyear.textColor = [UIColor blackColor];
    self.labelyear.font = [UIFont fontWithName:@"PingFangSC-Bold" size:18];
    [self addSubview:self.labelyear];
    
    self.labelyearinfo = [[UILabel alloc]initWithFrame:CGRectMake(20,self.labelyear.frame.size.height + self.labelyear.frame.origin.y , kscreenw , 30)];
    self.labelyearinfo.textColor = [UIColor colorWithRed:0.5 green:0.55 blue:0.65 alpha:1];
    self.labelyearinfo.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    [self addSubview:self.labelyearinfo];
    
    //添加点击的手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    tap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tap];
}

-(void)onTap:(UITapGestureRecognizer *)tap
{
    if (self.block) {
        self.block();
    }
}

-(void)updateWithStatus:(int)status
{
    if (status == 1) {
        _iv.image = [UIImage imageNamed:@"rightward"];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationsEnabled:YES];
        _iv.transform = CGAffineTransformMakeRotation(M_PI_2);
        [UIView commitAnimations];
    }else if (status == 2){
        _iv.image = [UIImage imageNamed:@"downward"];//为了合上也有动画
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.25];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationsEnabled:YES];
        _iv.transform = CGAffineTransformMakeRotation(- M_PI_2);
        [UIView commitAnimations];
    }else {
        _iv.image = [UIImage imageNamed:@"rightward"];//防止一开始就有动画
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
