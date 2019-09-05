//
//  MyOrdersTableViewCell.m
//  Potatso
//
//  Created by txb on 2017/10/11.
//  Copyright © 2017年 TouchingApp. All rights reserved.
//

#import "NewCouponTableViewCell.h"

@implementation NewCouponTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    UIImageView *imageback = [[UIImageView alloc]initWithFrame:CGRectMake(-5,-5, kscreenw-30 , 95)];
    imageback.image = [UIImage imageNamed:@"套餐分组背景图"];
    [self.contentView addSubview:imageback];
    
    self.labelNewUserCoupon = [[UILabel alloc]initWithFrame:CGRectMake(120*SJwidth -10,18, kscreenw, 20)];
    self.labelNewUserCoupon.font = [UIFont fontWithName:@"SourceSansPro-bold" size:16];
    self.labelNewUserCoupon.textColor = [UIColor colorWithRed:0.22 green:0.27 blue:0.34 alpha:1];
    [self.contentView addSubview:self.labelNewUserCoupon];
    
    self.labelExpires = [[UILabel alloc]initWithFrame:CGRectMake(120*SJwidth -10,self.labelNewUserCoupon.frame.size.height + self.labelNewUserCoupon.frame.origin.y , kscreenw , 30)];
    self.labelExpires.textColor =  [UIColor colorWithRed:0.5 green:0.55 blue:0.65 alpha:1];
    self.labelExpires.font = [UIFont fontWithName:@"SourceSansPro-bold" size:12];
    [self.contentView addSubview:self.labelExpires];
    self.backgroundColor = ViewBackColor;
    
    return self;
}


@end
