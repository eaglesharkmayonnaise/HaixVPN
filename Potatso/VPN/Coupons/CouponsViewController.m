//
//  CouponsViewController.m
//  Potatso
//
//  Created by txb on 2017/10/9.
//  Copyright © 2017年 TouchingApp. All rights reserved.
//

#import "CouponsViewController.h"
#import "InviteFriendsViewController.h"
#import "CouponsViewControllerTableViewCell.h"
@interface CouponsViewController ()

@end

@implementation CouponsViewController
{
    UITableView *tabelviewPackage;
    UIButton *couponbtn;
}

-(void)viewWillAppear:(BOOL)animated{
//    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

//优惠券
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = makecolor(218, 218, 218);
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.22 green:0.27 blue:0.34 alpha:1],NSFontAttributeName:[UIFont fontWithName:@"SourceSansPro-bold" size:16]}];
    self.title= @"Coupons";
    
    // 自定义导航栏左侧按钮
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 40, 40);;
    [leftBtn setImage:[UIImage imageNamed:@"Black_back_icon"]  forState:0];
    [leftBtn addTarget:self action:@selector(closeview) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    //Purchase
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Rules" style:UIBarButtonItemStylePlain target:self action:@selector(Rules)];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    //Invite Friends
    UILabel *InviteFriendslabe = [[UILabel alloc] initWithFrame:CGRectMake(19.5*SJwidth, 83.5 * SJhight -0, 159*SJwidth, 81*SJhight)];
    InviteFriendslabe.layer.cornerRadius = 4;
    InviteFriendslabe.userInteractionEnabled =YES;
    InviteFriendslabe.backgroundColor = [UIColor whiteColor];
    [[self view] addSubview:InviteFriendslabe];
    UILabel *InviteFriends = [[UILabel alloc] initWithFrame:CGRectMake(30*SJwidth, 97 * SJhight -0, 150, 20)];
    InviteFriends.textColor = [UIColor colorWithRed:0.22 green:0.27 blue:0.34 alpha:1];
    InviteFriends.text = @"Invite Friends";
    InviteFriends.font = [UIFont fontWithName:@"SourceSansPro-bold" size:16];
    [[self view] addSubview:InviteFriends];
    UILabel *textGetcoupons = [[UILabel alloc] initWithFrame:CGRectMake(30*SJwidth, 119 * SJhight -0, 70, 20)];
    textGetcoupons.textColor = [UIColor colorWithRed:0.5 green:0.55 blue:0.65 alpha:1];
    textGetcoupons.text = @"Get coupons";
    textGetcoupons.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    [[self view] addSubview:textGetcoupons];
    UIImageView *InviteFriendimage = [[UIImageView alloc] initWithFrame:CGRectMake(86*SJwidth, 109* SJhight -0, 84*SJwidth, 45*SJhight)];
    InviteFriendimage.image = [UIImage imageNamed:@"invite"];
    [[self view] addSubview:InviteFriendimage];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(InviteFriends)];
    //别忘了添加到testView上
    [InviteFriendslabe addGestureRecognizer:tap];
    
    //Invite Friends
    UILabel *RedeemCouponslabe = [[UILabel alloc] initWithFrame:CGRectMake(197.5*SJwidth, 83.5 * SJhight -0, 159*SJwidth, 81*SJhight)];
    RedeemCouponslabe.layer.cornerRadius = 4;
    RedeemCouponslabe.backgroundColor = [UIColor whiteColor];
    [[self view] addSubview:RedeemCouponslabe];
    UILabel *RedeemCoupon = [[UILabel alloc] initWithFrame:CGRectMake(208*SJwidth, 97 * SJhight -0, 150, 20)];
    RedeemCoupon.textColor = [UIColor colorWithRed:0.22 green:0.27 blue:0.34 alpha:1];
    RedeemCoupon.text = @"Redeem Coupons";
    RedeemCoupon.font = [UIFont fontWithName:@"SourceSansPro-bold" size:16];
    [[self view] addSubview:RedeemCoupon];
    UILabel *textApplyic = [[UILabel alloc] initWithFrame:CGRectMake(208*SJwidth, 119 * SJhight -0, 120, 20)];
    textApplyic.textColor = [UIColor colorWithRed:0.5 green:0.55 blue:0.65 alpha:1];
    textApplyic.text = @"Apply invitation code";
    textApplyic.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    [[self view] addSubview:textApplyic];
    UIImageView *RedeemCouponsimage = [[UIImageView alloc] initWithFrame:CGRectMake(276*SJwidth, 118* SJhight -0, 70*SJwidth, 36*SJhight)];
    RedeemCouponsimage.image = [UIImage imageNamed:@"coupon"];
    [[self view] addSubview:RedeemCouponsimage];
    
    //背景图片
    UIImageView *NULLimage = [[UIImageView alloc] initWithFrame:CGRectMake(138*SJwidth, 264* SJhight -0, 100*SJwidth, 162*SJhight)];
    NULLimage.image = [UIImage imageNamed:@"bottle"];
    [[self view] addSubview:NULLimage];
    UILabel *textNULL = [[UILabel alloc] initWithFrame:CGRectMake(0, 456* SJhight -0, kscreenw, 20)]
    ;textNULL.textColor = [UIColor colorWithRed:0.5 green:0.55 blue:0.65 alpha:1];
    textNULL.textAlignment = NSTextAlignmentCenter;
    textNULL.text = @"You don’t have any coupons yet.";
    textNULL.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    [[self view] addSubview:textNULL];
    
    //Package套餐
    tabelviewPackage  = [[UITableView alloc]initWithFrame:CGRectMake(20,RedeemCouponslabe.frame.size.height + RedeemCouponslabe.frame.origin.y + 20, kscreenw - 40,85 * 4 + 120)];
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
    
    CouponsViewControllerTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[CouponsViewControllerTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
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
    couponbtn = [[UIButton alloc] initWithFrame:CGRectMake(kscreenw - 72 -50 , 85/2-16 + row * 85 + row * 20 + 20, 72, 32)];
    [couponbtn addTarget:self action:@selector(couponbtnSelect:) forControlEvents:UIControlEventTouchUpInside];
    couponbtn.tag = 100 + row;
    couponbtn.layer.cornerRadius = 16;
    couponbtn.layer.borderWidth = 1;
    [couponbtn setTitleColor:[UIColor colorWithRed:0.46 green:0.59 blue:1 alpha:1] forState:0];
    [couponbtn setTitle:@"Use Now" forState:0];
    couponbtn.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-bold" size:14];
    couponbtn.layer.borderColor = [[UIColor colorWithRed:0.46 green:0.59 blue:1 alpha:1] CGColor];
    couponbtn.layer.masksToBounds = YES;
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

-(void)couponbtnSelect:(UIButton *)btn{
    
}

-(void)InviteFriends{
    InviteFriendsViewController *invite = [InviteFriendsViewController new];
    [self.navigationController pushViewController:invite animated:YES];
}

-(void)Rules{
}


-(void)closeview
{
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    //关闭抽屉模式
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
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
