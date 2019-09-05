
//
//  AddGamesCollectionViewCell.m
//  XiongMaoJiaSu
//
//  Created by 唐晓波的电脑 on 16/5/25.
//  Copyright © 2016年 ISOYasser. All rights reserved.
//

#import "SheTuancell.h"

@implementation SheTuancell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _topImage  = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width/2 -30, 10, 60, 60)];
//            _topImage.contentMode = UIViewContentModeScaleAspectFit;
        _topImage.layer.masksToBounds =YES;
        _topImage.layer.cornerRadius =30;
        [self.contentView addSubview:_topImage];
        
        _botlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, self.frame.size.width, 20)];
        _botlabel.textAlignment = 1;
        _botlabel.textColor = [UIColor whiteColor];
        _botlabel.font = [UIFont fontWithName:@"Helvetica-Light" size:15];
        [self.contentView addSubview:_botlabel];
        _btninfo= [[UIButton alloc] initWithFrame:CGRectMake(0, _botlabel.frame.origin.y + _botlabel.frame.size.height, self.frame.size.width, 20)];
        _btninfo.titleLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:12.f];
        [_btninfo setTitleColor:[UIColor blackColor] forState:0];
        [self.contentView addSubview:_btninfo];
    }
    
    return self;
}

@end
