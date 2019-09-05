//
//  InviteFriendsViewController.m
//  Potatso
//
//  Created by txb on 2017/10/9.
//  Copyright © 2017年 TouchingApp. All rights reserved.
//

#import "InviteFriendsViewController.h"
#import "RedeemCouponsViewController.h"
@interface InviteFriendsViewController ()

@end

@implementation InviteFriendsViewController

-(void)viewWillAppear:(BOOL)animated{
//    self.navigationController.navigationBar.translucent = NO;
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = makecolor(218, 218, 218);
    self.navigationController.navigationBar.barTintColor = makecolor(218, 218, 218);
//    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.22 green:0.27 blue:0.34 alpha:1],NSFontAttributeName:[UIFont fontWithName:@"SourceSansPro-bold" size:16]}];
    // 自定义导航栏左侧按钮
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 40, 40);;
    [leftBtn setImage:[UIImage imageNamed:@"Black_back_icon"]  forState:0];
    [leftBtn addTarget:self action:@selector(closeview) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    //Redeem Coupons
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Redeem Coupons" style:UIBarButtonItemStylePlain target:self action:@selector(RedeemCoupons)];
//    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    //InviteFriends
    UILabel *textInviteFriendslab = [[UILabel alloc] initWithFrame:CGRectMake(20, 94*SJhight -0, kscreenw, 32)];
    textInviteFriendslab.textColor = [UIColor colorWithRed:0.22 green:0.27 blue:0.34 alpha:1];
    textInviteFriendslab.text = @"Invite Friends";
    textInviteFriendslab.font = [UIFont fontWithName:@"SourceSansPro-bold" size:32];
    [[self view] addSubview:textInviteFriendslab];
    
    
    //InviteFriends info
    UILabel *textLayer = [[UILabel alloc] initWithFrame:CGRectMake(20,156 *SJhight, 335 *SJwidth, 60)];textLayer.lineBreakMode = NSLineBreakByWordWrapping;textLayer.numberOfLines = 0;textLayer.textColor = [UIColor colorWithRed:0.22 green:0.27 blue:0.34 alpha:1];NSString *textContent = @"If you like this app, kindly invite your friends to use it.  Both of you will receive coupons.";NSRange textRange = NSMakeRange(0, textContent.length);NSMutableAttributedString *textString = [[NSMutableAttributedString alloc] initWithString:textContent];UIFont *font = [UIFont fontWithName:@"SourceSansPro-SemiBold" size:16];[textString addAttribute:NSFontAttributeName value:font range:textRange];NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];paragraphStyle.lineSpacing = 1.5;[textString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:textRange];textLayer.attributedText = textString;[textLayer sizeToFit];[[self view] addSubview:textLayer];

    
    UILabel *textLayer_1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 228*SJhight, 335*SJwidth, 80)];textLayer_1.lineBreakMode = NSLineBreakByWordWrapping;textLayer_1.numberOfLines = 0;textLayer_1.textColor = [UIColor colorWithRed:0.22 green:0.27 blue:0.34 alpha:1];NSString *textContent_1 = @"Inviter：When an invitee registers and buys,Buy 3 days for one month, 18 days for half a year, 30 days for one year";NSRange textRange_1 = NSMakeRange(0, textContent_1.length);NSMutableAttributedString *textString_1 = [[NSMutableAttributedString alloc] initWithString:textContent_1];UIFont *font_1 = [UIFont fontWithName:@"SourceSansPro-Regular" size:16];[textString_1 addAttribute:NSFontAttributeName value:font_1 range:textRange_1];NSMutableParagraphStyle *paragraphStyle_1 = [[NSMutableParagraphStyle alloc] init];paragraphStyle_1.lineSpacing = 1.5;[textString_1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle_1 range:textRange_1];[textString_1 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"SourceSansPro-SemiBold" size:16] range:NSMakeRange(0,6)];;textLayer_1.attributedText = textString_1;[textLayer_1 sizeToFit];[[self view] addSubview:textLayer_1];
    
    
    UILabel *textLayer1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 307*SJhight, 335*SJwidth, 72*SJhight)];textLayer1.lineBreakMode = NSLineBreakByWordWrapping;textLayer1.numberOfLines = 0;textLayer1.textColor = [UIColor colorWithRed:0.22 green:0.27 blue:0.34 alpha:1];NSString *textContent1 = @"Invitees：When purchasing a package, you can use the invitation's invitation code to give a 10% discount";NSRange textRange1 = NSMakeRange(0, textContent1.length);NSMutableAttributedString *textString1 = [[NSMutableAttributedString alloc] initWithString:textContent1];UIFont *font1 = [UIFont fontWithName:@"SourceSansPro-Regular" size:16];[textString1 addAttribute:NSFontAttributeName value:font1 range:textRange1];NSMutableParagraphStyle *paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];paragraphStyle1.lineSpacing = 1.5;[textString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:textRange1];[textString1 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"SourceSansPro-SemiBold" size:16] range:NSMakeRange(0,8)];;textLayer1.attributedText = textString1;[textLayer1 sizeToFit];[[self view] addSubview:textLayer1];
    
    
    //渐变色背景
    UIView *layerBJ = [[UIView alloc] initWithFrame:CGRectMake(20, 448 *SJhight -0, kscreenw -40, 114 * SJhight)];
    layerBJ.layer.cornerRadius = 4;
    layerBJ.layer.shadowOffset = CGSizeMake(0, 2);
    layerBJ.layer.shadowColor = [[UIColor colorWithRed:0.71 green:0.71 blue:0.71 alpha:0.5] CGColor];
    layerBJ.layer.shadowOpacity = 1;layerBJ.layer.shadowRadius = 8;
    CAGradientLayer *gradient = [CAGradientLayer layer];gradient.frame = CGRectMake(0, 0, kscreenw - 40, 114 * SJhight);gradient.colors = @[	(id)[[UIColor colorWithRed:0.83 green:0.68 blue:1 alpha:1] CGColor],	(id)[[UIColor colorWithRed:0.41 green:0.56 blue:1 alpha:1] CGColor]];gradient.locations = @[@(0), @(1)];gradient.startPoint = CGPointMake(1, 0);gradient.endPoint = CGPointMake(0, 0.67);gradient.cornerRadius = 4;[[layerBJ layer] addSublayer:gradient];
    [[self view] addSubview:layerBJ];
    
    //Your personal invitation code
    UILabel *textypic= [[UILabel alloc] initWithFrame:CGRectMake(0, 468 * SJhight -0, kscreenw, 20)];
    textypic.textAlignment=1;
    textypic.textColor = [UIColor whiteColor];textypic.text = @"Your personal invitation code";
    textypic.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    [[self view] addSubview:textypic];
    
    //Your personal invitation code
    UILabel *ypiclabe = [[UILabel alloc] initWithFrame:CGRectMake(0, 498 * SJhight -0, kscreenw, 50)];
    ypiclabe.text = [AppEnvironment UserInfodic][@"data"][@"invitedCode"];
    ypiclabe.textColor = [UIColor whiteColor];
    ypiclabe.font = [UIFont fontWithName:@"PingFangSC-Regular" size:44];
    ypiclabe.textAlignment =1 ;
    [[self view] addSubview:ypiclabe];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tag)];
    ypiclabe.userInteractionEnabled = YES;
    [ypiclabe addGestureRecognizer:tap];
    
    //Invitation Rules
    UIButton *RulesInv = [[UIButton alloc] initWithFrame:CGRectMake(0, 508 * SJhight -0 , kscreenw, 30)];
    [RulesInv setTitle: @"Invitation Rules" forState:0];
    [RulesInv setTitleColor:[UIColor colorWithRed:0.46 green:0.59 blue:1 alpha:1] forState:0];
    RulesInv.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-bold" size:16];
    [RulesInv addTarget:self action:@selector(InvitationRules) forControlEvents:UIControlEventTouchUpInside];
//    [[self view] addSubview:RulesInv];
    


}


-(void)tag{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [AppEnvironment UserInfodic][@"data"][@"invitedCode"];
    dispatch_async(dispatch_get_main_queue(), ^{
        [LCProgressHUD showSuccess:@"已复制"];
    });
}

-(void)InvitationRules{
    
}

-(void)RedeemCoupons{
    RedeemCouponsViewController * view = [RedeemCouponsViewController new];
    [self.navigationController pushViewController:view animated:YES];
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
