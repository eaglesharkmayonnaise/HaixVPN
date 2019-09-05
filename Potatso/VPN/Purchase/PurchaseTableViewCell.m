//
//  PurchaseTableViewCell.m
//  Potatso
//
//  Created by txb on 2017/10/10.
//  Copyright © 2017年 TouchingApp. All rights reserved.
//

#import "PurchaseTableViewCell.h"

@implementation PurchaseTableViewCell{

}
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
    [self SetUI];
    
    return self;
}


-(void)SetUI{
     // 设置阴影
    // one year plan
    self.labelYear = [[UILabel alloc]initWithFrame:CGRectMake(20,20, 120, 18)];
    self.labelYear.textColor = [UIColor colorWithRed:0.22 green:0.27 blue:0.34 alpha:1];
    self.labelYear.font = [UIFont fontWithName:@"SourceSansPro-Bold" size:18];
    self.labelYear.text = @"1 Year Plan";
    [self.contentView addSubview:self.labelYear];
    
    //lablRecommend
    self.layerview = [[UIView alloc] initWithFrame:CGRectMake(self.labelYear.frame.size.width + self.labelYear.frame.origin.x - 20,22, 30, 14)];self.layerview.layer.cornerRadius = 3;self.layerview.layer.shadowOffset = CGSizeMake(0, 2);self.layerview.layer.shadowColor = [[UIColor colorWithRed:0.71 green:0.71 blue:0.71 alpha:0.5] CGColor];self.layerview.layer.shadowOpacity = 1;self.layerview.layer.shadowRadius = 8;
    CAGradientLayer *gradient = [CAGradientLayer layer];gradient.frame = CGRectMake(0, 0, 30, 14);gradient.colors = @[    (id)[[UIColor colorWithRed:1 green:0.73 blue:0.41 alpha:1] CGColor],    (id)[[UIColor colorWithRed:1 green:0.5 blue:0.55 alpha:1] CGColor]];gradient.locations = @[@(0), @(1)];gradient.startPoint = CGPointZero;gradient.endPoint = CGPointMake(1, 1);gradient.cornerRadius = 3;[[self.layerview layer] addSublayer:gradient];
    [[self contentView] addSubview:self.layerview];
    
    self.lablRecommend = [[UILabel alloc]initWithFrame:CGRectMake(self.labelYear.frame.size.width + self.labelYear.frame.origin.x - 20,22, 30, 14)];
    self.lablRecommend.layer.masksToBounds = YES;
    self.lablRecommend.layer.cornerRadius = 4;
    self.lablRecommend.textAlignment =1;
    self.lablRecommend.font = [UIFont fontWithName:@"SourceSansPro-Bold" size:10];
    self.lablRecommend.text = @"BEST";
    self.lablRecommend.textColor = [UIColor whiteColor];
    [self.contentView addSubview:self.lablRecommend];
    
    
    // 1.6/mouth
    self.lablePackage = [[UILabel alloc]initWithFrame:CGRectMake(self.labelYear.frame.origin.x,self.labelYear.frame.origin.x + self.labelYear.frame.size.height +10, 88, 18)];
    self.lablePackage.text = @"¥1.6/mouth";
    self.lablePackage.textColor =[UIColor colorWithRed:0.5 green:0.55 blue:0.65 alpha:1];
    self.lablePackage.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:16];
    [self.contentView addSubview:self.lablePackage];
    
    self.image$ = [[UIImageView alloc]initWithFrame:CGRectMake(kscreenw - 20 - 32- 18, 0, 32, 32)];
    self.image$.image = [UIImage imageNamed:@"Triangle"];
    [self.contentView addSubview:self.image$];
    
    // money
    self.lableMoney = [[UILabel alloc]initWithFrame:CGRectMake(kscreenw - 150 - 20 - 40,25, 150, 32)];
    self.lableMoney.textColor = [UIColor colorWithRed:0.46 green:0.59 blue:1 alpha:1];
    self.lableMoney.font = [UIFont fontWithName:@"SourceSansPro-Bold" size:32];
    self.lableMoney.text = @"$ 600";
    self.lableMoney.textAlignment =2;
    [self.contentView addSubview:self.lableMoney];
}
@end
