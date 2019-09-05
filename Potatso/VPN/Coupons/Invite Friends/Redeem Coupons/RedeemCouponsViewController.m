//
//  RedeemCouponsViewController.m
//  Potatso
//
//  Created by txb on 2017/10/9.
//  Copyright © 2017年 TouchingApp. All rights reserved.
//

#import "RedeemCouponsViewController.h"
#import "ZJAnimationPopView.h"
@interface RedeemCouponsViewController ()

@end

@implementation RedeemCouponsViewController{
    ZJAnimationPopView *popView;
    UITextField *textEntercode ;
}

-(void)viewWillAppear:(BOOL)animated{
//    self.navigationController.navigationBar.translucent = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = makecolor(218, 218, 218);
    self.navigationController.navigationBar.barTintColor = makecolor(218, 218, 218);
//    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.22 green:0.27 blue:0.34 alpha:1],NSFontAttributeName:[UIFont fontWithName:@"SourceSansPro-bold" size:16]}];
    // 自定义导航栏左侧按钮
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame =CGRectMake(0, 0, 40, 40);;
    [leftBtn setImage:[UIImage imageNamed:@"Black_back_icon"]  forState:0];
    [leftBtn addTarget:self action:@selector(closeview) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    //Invite Friends
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Invite Friends" style:UIBarButtonItemStylePlain target:self action:@selector(InviteFriends)];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    //Redeem Coupons
    UILabel *textInviteFriendslab = [[UILabel alloc] initWithFrame:CGRectMake(20, 94*SJhight -0, kscreenw, 32)];
    textInviteFriendslab.textColor = [UIColor colorWithRed:0.22 green:0.27 blue:0.34 alpha:1];
    textInviteFriendslab.text = @"Redeem Coupons";
    textInviteFriendslab.font = [UIFont fontWithName:@"SourceSansPro-bold" size:32];
    [[self view] addSubview:textInviteFriendslab];
    
    //RedeemCoupons info
    UILabel *textInviteFriends = [[UILabel alloc] initWithFrame:CGRectMake(20, 156 * SJhight -0, kscreenw -40, 168 * SJhight)];
    textInviteFriends.numberOfLines = 0;textInviteFriends.textColor = [UIColor colorWithRed:0.5 green:0.55 blue:0.65 alpha:1];NSString *textContent = @"Please enter your friend’s invitation code to redeem coupons. Each invitation code only can apply once.";NSRange textRange = NSMakeRange(0, textContent.length);NSMutableAttributedString *textString = [[NSMutableAttributedString alloc] initWithString:textContent];UIFont *font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];[textString addAttribute:NSFontAttributeName value:font range:textRange];NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];paragraphStyle.lineSpacing = 1.5;[textString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:textRange];textInviteFriends.attributedText = textString;[textInviteFriends sizeToFit];[[self view] addSubview:textInviteFriends];
    
    //code
    UIView *textcode = [[UIView alloc] initWithFrame:CGRectMake(20, 235.5 * SJhight -0 + 10, kscreenw -40, 167 * SJhight)];
    textcode.layer.cornerRadius = 4;
    textcode.backgroundColor = [UIColor whiteColor];
    textcode.layer.borderWidth = 1;
    textcode.layer.borderColor = [[UIColor colorWithRed:0.89 green:0.93 blue:0.96 alpha:1] CGColor];
    [[self view] addSubview:textcode];
    
    //Enter code
    textEntercode = [[UITextField alloc] initWithFrame:CGRectMake(40, 256 * SJhight -0 + 10, kscreenw - 80, 25)];
    textEntercode.textColor = [UIColor blackColor];
    [textEntercode setValue:[UIColor colorWithRed:0.5 green:0.55 blue:0.65 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    [textEntercode setValue:[UIFont fontWithName:@"SourceSansPro-bold" size:20] forKeyPath:@"_placeholderLabel.font"];
    textEntercode.placeholder = @"Enter invitation code";
    textEntercode.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:20];
    [[self view] addSubview:textEntercode];
    UILabel *layerxian = [[UILabel alloc] initWithFrame:CGRectMake(40, 287 * SJhight -0 + 10, kscreenw -80, 2)];
    layerxian.layer.borderWidth = 1;
    layerxian.layer.borderColor = [[UIColor colorWithRed:0.89 green:0.93 blue:0.96 alpha:1] CGColor];
    [[self view] addSubview:layerxian];
    
    //APPLY
    UIButton *btnapply = [[UIButton alloc] initWithFrame:CGRectMake(kscreenw/2 - 100, 328 * SJhight -0 + 10, 200 , 44)];
    btnapply.layer.cornerRadius = 22;
    btnapply.layer.shadowOffset = CGSizeMake(0, 2);
    btnapply.layer.shadowColor = [[UIColor colorWithRed:0.71 green:0.71 blue:0.71 alpha:0.5] CGColor];
    btnapply.layer.shadowOpacity = 1;
    btnapply.layer.shadowRadius = 8;
    [btnapply setTitleColor:[UIColor whiteColor] forState:0];
    [btnapply setTitle:@"Apply" forState:0];
    [btnapply addTarget:self action:@selector(btnapply) forControlEvents:UIControlEventTouchUpInside];
    CAGradientLayer *gradient = [CAGradientLayer layer];gradient.frame = CGRectMake(0, 0, 200, 44);gradient.colors = @[(id)[[UIColor colorWithRed:0.83 green:0.68 blue:1 alpha:1] CGColor],(id)[[UIColor colorWithRed:0.41 green:0.56 blue:1 alpha:1] CGColor]];gradient.locations = @[@(0), @(1)];gradient.startPoint = CGPointMake(1, 0);gradient.endPoint = CGPointMake(0, 0.67);gradient.cornerRadius = 22;[[btnapply layer] addSublayer:gradient];
    [[self view] addSubview:btnapply];
    
    // Do any additional setup after loading the view.
}

-(void)btnapply
{
    [NetworkApi invitedCode:nil anddic:@{@"invitedCode":textEntercode.text,@"planTypeID":@""} block:^(NSDictionary *responseObject) {
        // 1.Get custom view【获取自定义控件】
        UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 265, 320)];
        customView.layer.cornerRadius = 10;
        customView.layer.masksToBounds =YES;
        customView.backgroundColor = [UIColor whiteColor];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(customView.frame.size.width/2 - 40, 30, 80, 92)];
        imageView.image = [UIImage imageNamed:@"激活成功"]; //激活失败
        [customView addSubview:imageView];
        
        //notifcation
        UILabel *textInviteFriendslab = [[UILabel alloc] initWithFrame:CGRectMake(0,imageView.frame.size.height + imageView.frame.origin.y + 12, customView.frame.size.width, 32)];
        textInviteFriendslab.textAlignment =1;
        textInviteFriendslab.text = @"Successful! ";
        textInviteFriendslab.font = [UIFont fontWithName:@"SourceSansPro-bold" size:16];
        [customView addSubview:textInviteFriendslab];
        
        //info
        UILabel *textLayer = [[UILabel alloc] initWithFrame:CGRectMake(20, textInviteFriendslab.frame.size.height + textInviteFriendslab.frame.origin.y + 5, customView.frame.size.width - 40, 60)];textLayer.lineBreakMode = NSLineBreakByWordWrapping;textLayer.numberOfLines = 0;textLayer.textColor = [UIColor colorWithRed:0.5 green:0.55 blue:0.65 alpha:1];textLayer.textAlignment = NSTextAlignmentCenter;NSString *textContent = @"Congratulations! You’ve just got a ¥ 18 coupon! You can check it out in your coupons list. ";NSRange textRange = NSMakeRange(0, textContent.length);NSMutableAttributedString *textString = [[NSMutableAttributedString alloc] initWithString:textContent];UIFont *font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];[textString addAttribute:NSFontAttributeName value:font range:textRange];NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];paragraphStyle.lineSpacing = 1.25;[textString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:textRange];textLayer.attributedText = textString;[textLayer sizeToFit];
        [customView addSubview:textLayer];
        
        //Click ON
        UIButton *layer = [[UIButton alloc] initWithFrame:CGRectMake(customView.frame.size.width/2 -64,textLayer.frame.size.height + textLayer.frame.origin.y + 10, 128, 32)];
        layer.layer.cornerRadius = 16;
        [layer addTarget:self action:@selector(GotIt) forControlEvents:UIControlEventTouchUpInside];
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = CGRectMake(0, 0, 128, 32);gradient.colors = @[(id)[[UIColor colorWithRed:0.83 green:0.68 blue:1 alpha:1] CGColor],    (id)[[UIColor colorWithRed:0.41 green:0.56 blue:1 alpha:1] CGColor]];gradient.locations = @[@(0), @(1)];gradient.startPoint = CGPointMake(1, 0);gradient.endPoint = CGPointMake(0, 1);gradient.cornerRadius = 16;[[layer layer] addSublayer:gradient];
        [layer setTitle:@"Got It" forState:0];
        [layer setTitleColor:[UIColor whiteColor] forState:0];
        layer.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-bold" size:16];
        [customView addSubview:layer];
        
        // 2.Init【初始化】
        popView= [[ZJAnimationPopView alloc] initWithCustomView:customView popStyle:ZJAnimationPopStyleShakeFromTop dismissStyle:ZJAnimationDismissStyleCardDropToTop];
        
        // 3.Set properties,can not be set【设置属性，可不设置使用默认值，见注解】
        // 3.1 显示时点击背景是否移除弹框
        popView.isClickBGDismiss = YES;
        // 3.2 显示时背景的透明度
        popView.popBGAlpha = 0.5f;
        // 3.3 显示时是否监听屏幕旋转
        popView.isObserverOrientationChange = YES;
        // 3.4 显示时动画时长
        popView.popAnimationDuration = 0.4f;
        // 3.5 移除时动画时长
        popView.dismissAnimationDuration = 0.4f;
        
        // 3.6 显示完成回调
        popView.popComplete = ^{
            NSLog(@"显示完成");
        };
        // 3.7 移除完成回调
        popView.dismissComplete = ^{
            NSLog(@"移除完成");
        };
        
        // 4.pop view【显示弹框】
        [popView pop];
        
    } block:^(NSError *error) {
        [AppEnvironment ShowErrorLoading:error];
    }];
    
}


-(void)GotIt{
    [popView dismiss];
}


-(void)InvitationRules{
    
}


-(void)InviteFriends{
    
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
