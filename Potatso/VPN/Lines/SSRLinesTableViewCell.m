//
//  SSRLinesTableViewCell.m
//  Potatso
//
//  Created by txb on 2017/10/27.
//  Copyright © 2017年 TouchingApp. All rights reserved.
//

#import "SSRLinesTableViewCell.h"

@implementation SSRLinesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//@property UIImageView *CountrySelcet;
//@property UIImageView *CountryImage;
//@property UILabel *Country;
//@property UIImageView *CountryDelay;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    self.CountrySelcet = [[UIImageView alloc]initWithFrame:CGRectMake(20,19, 12, 8)];
    [self.contentView addSubview:self.CountrySelcet];
    
    self.CountryImage = [[UIImageView alloc]initWithFrame:CGRectMake(52,19, 20, 14)];
    self.CountryImage.layer.shadowColor = [UIColor blackColor].CGColor;//阴影颜色
    self.CountryImage.layer.shadowOffset = CGSizeMake(0, 0);//偏移距离
    self.CountryImage.layer.shadowOpacity = 0.1;//不透明度
    self.CountryImage.layer.shadowRadius = 2.0;//半径
    [self.contentView addSubview:self.CountryImage];
    
    self.Country = [[UILabel alloc]initWithFrame:CGRectMake(88*SJwidth,17, 187*SJwidth , 18)];
    self.Country.textColor = [UIColor colorWithRed:0.22 green:0.27 blue:0.34 alpha:1];
    self.Country.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    [self.contentView addSubview:self.Country];
    
//    self.CountryDelay = [[UIImageView alloc]initWithFrame:CGRectMake(340 *SJwidth,19, 15, 16)];
//    self.CountrySelcet.image = [UIImage imageNamed:@"great"];
//    [self.contentView addSubview:self.CountryDelay];
    
//    self.CountryDelay = [[UIImageView alloc]initWithFrame:CGRectMake(340 *SJwidth,19, 15, 16)];
    
    //菊花转圈
    self.LoadingWording = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.LoadingWording.center = CGPointMake(100.0f, 100.0f);
    [self.LoadingWording setFrame:CGRectMake(340 *SJwidth - 30 ,self.Country.frame.origin.y + 1, 60, 18)];
    [self.contentView addSubview:self.LoadingWording];
    self.LoadingWording.color = [UIColor colorWithRed:0.46 green:0.59 blue:1 alpha:1];
    [self.LoadingWording setHidesWhenStopped:YES]; //当旋转结束时隐藏
    [self.LoadingWording startAnimating];
    
    self.CountryDelay = [[UILabel alloc]initWithFrame:CGRectMake(340 *SJwidth - 30 ,self.Country.frame.origin.y + 1, 60, 18)];
    self.CountryDelay.textColor = [UIColor colorWithRed:0.19 green:0.82 blue:0.77 alpha:1];
    self.CountryDelay.backgroundColor = [UIColor whiteColor];
    self.CountryDelay.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:14];
    [self.contentView addSubview:self.CountryDelay];
    
    
//    self.backgroundColor = [UIColor whiteColor];
    return self;
}


@end
