//
//  MyOrdersViewController.m
//  Potatso
//
//  Created by txb on 2017/10/11.
//  Copyright © 2017年 TouchingApp. All rights reserved.
//

#import "NewCouponViewController.h"
#import "NewCouponTableViewCell.h"
#import "MyOrdersViewController.h"
@interface NewCouponViewController ()

@end

@implementation NewCouponViewController{
    
    UITableView *tabelviewPackage;
    UIButton *couponbtn;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title= @"";
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.view.backgroundColor = ViewBackColor;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.22 green:0.27 blue:0.34 alpha:1],NSFontAttributeName:[UIFont fontWithName:@"SourceSansPro-bold" size:16]}];
    
    // 自定义导航栏左侧按钮
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 40, 40);;
    [leftBtn setImage:[UIImage imageNamed:@"Black_back_icon"]  forState:0];
    [leftBtn addTarget:self action:@selector(closeview) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    //My Orders
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"RedeemCoupons" style:UIBarButtonItemStylePlain target:self action:@selector(RedeemCoupons)];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    //Do not use coupon
    UILabel *couponlabe = [[UILabel alloc] initWithFrame:CGRectMake(20, 83.5 *SJhight, kscreenw - 40, 45)];
    couponlabe.layer.cornerRadius = 4;
    couponlabe.text = @"   Do not use coupon";
    couponlabe.font = [UIFont fontWithName:@"SourceSansPro-bold" size:16];
    couponlabe.backgroundColor = [UIColor whiteColor];
    couponlabe.layer.borderWidth = 1;
    couponlabe.textColor = [UIColor colorWithRed:0.22 green:0.27 blue:0.34 alpha:1];
    couponlabe.layer.borderColor = [[UIColor colorWithRed:0.89 green:0.93 blue:0.96 alpha:1] CGColor];
    couponlabe.layer.shadowOffset = CGSizeMake(0, 0.5);
    couponlabe.layer.shadowColor = [[UIColor colorWithRed:1 green:1 blue:1 alpha:0.1] CGColor];
    couponlabe.layer.shadowOpacity = 1;
    couponlabe.layer.shadowRadius = 0;
    [[self view] addSubview:couponlabe];
    couponbtn = [[UIButton alloc] initWithFrame:CGRectMake(319 *SJwidth, 98 *SJhight, 16, 16)];
    [couponbtn setImage:[UIImage imageNamed:@"灰色对勾"] forState:0];
    [couponbtn setImage:[UIImage imageNamed:@"绿色对勾"] forState:UIControlStateSelected];
    couponbtn.tag =104;
    [couponbtn addTarget:self action:@selector(couponbtnSelect:) forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:couponbtn];
    
    //available coupons
    UILabel *textavailable = [[UILabel alloc] initWithFrame:CGRectMake(20, 148 *SJhight, kscreenw - 40, 20)];
    textavailable.numberOfLines = 0;
    textavailable.textColor = [UIColor colorWithRed:1 green:0.48 blue:0.52 alpha:1];
    textavailable.font = [UIFont fontWithName:@"SourceSansPro-bold" size:14];
    NSString *label_text2 = @"4 available coupons";
    NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc]initWithString:label_text2];
    [attributedString2 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.5 green:0.55 blue:0.65 alpha:1] range:NSMakeRange(1, label_text2.length - 1)];
    textavailable.attributedText = attributedString2;
    [[self view] addSubview:textavailable];
    
    //Package套餐
    tabelviewPackage  = [[UITableView alloc]initWithFrame:CGRectMake(20,textavailable.frame.size.height + textavailable.frame.origin.y, kscreenw - 40,85 * 4 + 120)];
    tabelviewPackage.delegate =self;
    tabelviewPackage.dataSource = self;
    tabelviewPackage.scrollEnabled = NO;
    tabelviewPackage.backgroundColor = ViewBackColor;
    [self.view addSubview:tabelviewPackage];
    tabelviewPackage.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self setExtraCellLineHidden:tabelviewPackage];
    
    // Do any additional setup after loading the view.
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}


-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


//分区之间的颜色
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = ViewBackColor;
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0;//分区之间的距离
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section) {
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger row = indexPath.section;
    static NSString *identifier = @"Cell";
    
    NewCouponTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[NewCouponTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    if (row == 0) {
        cell.labelNewUserCoupon.text= @"New User Coupon";
        cell.labelExpires.text = @"Expires on 30 Oct 2018";
    }
    if (row == 1) {
        cell.labelNewUserCoupon.text= @"Refer Friends Coupon";
        cell.labelExpires.text = @"Expires on 30 Oct 2018 ";
    }
    if (row == 2) {
        cell.labelNewUserCoupon.text= @"Refer Friends Coupon";
        cell.labelExpires.text = @"Expires on 30 Oct 2018 ";
    }
    if (row == 3) {
        cell.labelNewUserCoupon.text= @"Refer Friends Coupon";
        cell.labelExpires.text = @"Expires on 30 Oct 2018 ";
    }
    couponbtn = [[UIButton alloc] initWithFrame:CGRectMake(319 *SJwidth - 20 , 85/2-8 + row * 85 + row * 20 + 20, 16, 16)];
    [couponbtn addTarget:self action:@selector(couponbtnSelect:) forControlEvents:UIControlEventTouchUpInside];
    couponbtn.tag = 100 + row;
    [couponbtn setImage:[UIImage imageNamed:@"灰色对勾"] forState:0];
    [couponbtn setImage:[UIImage imageNamed:@"绿色对勾"] forState:UIControlStateSelected];
    [tabelviewPackage addSubview:couponbtn];
    
    UILabel *labelmoney = [[UILabel alloc]initWithFrame:CGRectMake(19, 25, 140, 30)];
    NSArray *arr =@[@"¥216",@"¥120",@"¥72",@"¥30"];
    labelmoney.text = arr[row];
    labelmoney.textColor = [UIColor whiteColor];
    labelmoney.font = [UIFont fontWithName:@"SourceSansPro-bold" size:27];
    NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc]initWithString:labelmoney.text];
    [attributedString2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, 1)];
    labelmoney.attributedText = attributedString2;
    [cell.contentView addSubview:labelmoney];
    
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 4;
    cell.accessoryType=UITableViewCellAccessoryNone;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;//设置cell点击效果（无显示）
    return cell;
}


-(void)couponbtnSelect:(UIButton *)sender
{
    
    for (int i = 0; i < 5; i++) {
        UIButton *btn = (UIButton *)[[sender superview]viewWithTag:100 + i];
        [btn setSelected:NO];
    }
    UIButton *button = (UIButton *)sender;
    [button setSelected:YES];
    
}



-(void)RedeemCoupons
{
    MyOrdersViewController *myorder = [MyOrdersViewController new];
    [self.navigationController pushViewController:myorder animated:YES];
}


-(void)closeview{
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
