//  WYFoldTableView
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import "WYTableViewCell.h"

@implementation WYTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}
///** 初始化方法  注册Cell */
//+ (instancetype)initWithTableView:(UITableView *)tableView
//{
//    static NSString *const WYTableViewIdentifier = @"tableViewCell";
//    WYTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WYTableViewIdentifier];
//    if (!cell) {
//        cell = [[WYTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:WYTableViewIdentifier];
//    }
//    return cell;
////    BoAiTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
////    if (!cell) {
////        cell = [[BoAiTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
////    }
//}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    self.labelpoint = [[UILabel alloc]initWithFrame:CGRectMake(20,40, 10, 10)];
    self.labelpoint.layer.cornerRadius = 5;
    self.labelpoint.layer.masksToBounds = YES;
    self.labelpoint.backgroundColor =  [UIColor colorWithRed:0.17 green:0.81 blue:0.76 alpha:1];;
    self.labelpoint.hidden =YES;
    [self.contentView addSubview:self.labelpoint];
    
    UIImageView *imagePhone = [[UIImageView alloc]initWithFrame:CGRectMake(20,(85 -25)/2, 17, 25)];
    imagePhone.image = [UIImage imageNamed:@"ImagePhone"];
    imagePhone.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:imagePhone];
    
    self.labeldevidesname = [[UILabel alloc]initWithFrame:CGRectMake(55,  15, kscreenw -80, 30)];
    self.labeldevidesname.textColor = [UIColor colorWithRed:0.22 green:0.27 blue:0.34 alpha:1];;
    self.labeldevidesname.font = [UIFont fontWithName:@"SourceSansPro-bold" size:18];
    [self.contentView addSubview:self.labeldevidesname];
    
    self.labeldevidesinfo = [[UILabel alloc]initWithFrame:CGRectMake(55, self.labeldevidesname.frame.origin.y + self.labeldevidesname.frame.size.height , kscreenw -80, 30)];
    self.labeldevidesinfo.textColor = [UIColor colorWithRed:0.5 green:0.55 blue:0.65 alpha:1];
    self.labeldevidesinfo.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    [self.contentView addSubview:self.labeldevidesinfo];
    
    self.switchdevides = [[UISwitch alloc] initWithFrame:CGRectMake(304 *SJwidth,self.labeldevidesname.frame.origin.y + 10, 51, 31)];;
    self.switchdevides.onTintColor = [UIColor colorWithRed:0.46 green:0.59 blue:1 alpha:1];
    [self.contentView addSubview:self.switchdevides];
    return self;
}



@end
