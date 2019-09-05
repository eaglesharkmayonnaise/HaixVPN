//
//  MyOrdersTableViewCell.m
//  Potatso
//
//  Created by txb on 2017/10/11.
//  Copyright © 2017年 TouchingApp. All rights reserved.
//

#import "MyOrderPendTableViewCell.h"

@implementation MyOrderPendTableViewCell

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
    
    self.labeldevices = [[UILabel alloc]initWithFrame:CGRectMake(20,15, kscreenw, 20)];
    self.labeldevices.font = [UIFont fontWithName:@"SourceSansPro-bold" size:18];
    self.labeldevices.textColor = [UIColor colorWithRed:0.22 green:0.27 blue:0.34 alpha:1];;
    [self.contentView addSubview:self.labeldevices];
    
    self.labelExpires = [[UILabel alloc]initWithFrame:CGRectMake(20,self.labeldevices.frame.size.height + self.labeldevices.frame.origin.y +10, kscreenw, 30)];
    self.labelExpires.textColor = [UIColor colorWithRed:0.5 green:0.55 blue:0.65 alpha:1];
    self.labelExpires.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    [self.contentView addSubview:self.labelExpires];
    
    self.labelmoney = [[UILabel alloc]initWithFrame:CGRectMake(236 *SJwidth - 20,15 , 107 , 30)];
    self.labelmoney.textColor = [UIColor colorWithRed:0.22 green:0.27 blue:0.34 alpha:1];
    self.labelmoney.textAlignment = 2;
    self.labelmoney.font = [UIFont fontWithName:@"SourceSansPro-bold" size:18];
    [self.contentView addSubview:self.labelmoney];
    
    self.labelCompleted = [[UIButton alloc]initWithFrame:CGRectMake(236 *SJwidth - 20,self.labelmoney.frame.size.height + self.labelmoney.frame.origin.y , 100, 30)];
    [self.labelCompleted setTitle:@"Completed" forState:0];
    [self.labelCompleted setTitleColor:[UIColor colorWithRed:0.17 green:0.81 blue:0.76 alpha:1] forState:0];
    [self.labelCompleted setImage:[UIImage imageNamed:@"订单成功"] forState:0];
    self.labelCompleted.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-bold" size:16];
    [self.contentView addSubview:self.labelCompleted];
    [self.labelCompleted layoutButtonWithEdgeInsetsStyle: MKButtonEdgeInsetsStyleRight imageTitleSpace: 10];
    self.backgroundColor = [UIColor whiteColor];
    
    return self;
}


@end
