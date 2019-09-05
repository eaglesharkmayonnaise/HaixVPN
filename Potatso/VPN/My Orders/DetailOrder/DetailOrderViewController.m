//
//  DetailOrderViewController.m
//  Potatso
//
//  Created by txb on 2017/10/17.
//  Copyright © 2017年 TouchingApp. All rights reserved.
//

#import "DetailOrderViewController.h"

@interface DetailOrderViewController ()<PWCoreSDKDelegate>

@end

@implementation DetailOrderViewController{
    UILabel *labeTotalMoney;
    UIButton *pengdingbtn;
    UIButton *PayBtn;
    UILabel *labelmoney;
    UIView *bottomBK;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

// status, 0.Completed, 1.Pending, 2.Failed, 3.Invited  // 4.Free, 5.Invalid
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title= @"Invoice Summary";
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
    
    //viewback1
    UILabel *viewback1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 83.5 *SJhight, 376 *SJwidth, 65)];
    viewback1.backgroundColor = [UIColor whiteColor];
    [[self view] addSubview:viewback1];
    
    //pending
    pengdingbtn = [[UIButton alloc]initWithFrame:CGRectMake(20,viewback1.frame.origin.y + 13, 130, 18)];
    [pengdingbtn setTitle:@"Pending    " forState:0];
    //订单列表
    if ([self.orderdic[@"data"][@"order"][@"status"] intValue] == 0) {
        [pengdingbtn setImage:[UIImage imageNamed:@"订单成功"] forState:0];
        [pengdingbtn setTitle:@"CellCompleted    " forState:0];
        [pengdingbtn setTitleColor:[UIColor colorWithRed:0.17 green:0.81 blue:0.76 alpha:1] forState:0];
    }
    else if ([self.orderdic[@"data"][@"order"][@"status"] intValue] == 1) {
        [pengdingbtn setImage:[UIImage imageNamed:@"OrderPending"] forState:0];
        [pengdingbtn setTitleColor:[UIColor colorWithRed:1 green:0.48 blue:0.52 alpha:1] forState:0];
    }
    else if ([self.orderdic[@"data"][@"order"][@"status"] intValue] == 2) {
        [pengdingbtn setImage:[UIImage imageNamed:@"订单失败"] forState:0];
        [pengdingbtn setTitle:@"Pending    " forState:0];
        [pengdingbtn setTitleColor:[UIColor colorWithRed:1 green:0.48 blue:0.52 alpha:1] forState:0];
    }
    else if ([self.orderdic[@"data"][@"order"][@"status"] intValue] == 3) {
        [pengdingbtn setImage:[UIImage imageNamed:@"订单成功"] forState:0];
        [pengdingbtn setTitle:@"Invition Code    " forState:0];
        [pengdingbtn setTitleColor:[UIColor colorWithRed:0.17 green:0.81 blue:0.76 alpha:1] forState:0];
    }else{
        [pengdingbtn setImage:[UIImage imageNamed:@"订单成功"] forState:0];
        [pengdingbtn setTitle:@"Completed    " forState:0];
        [pengdingbtn setTitleColor:[UIColor colorWithRed:0.17 green:0.81 blue:0.76 alpha:1] forState:0];
    }
    
    
    pengdingbtn.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-bold" size:16];
    //图片在字体的左边距离10
    [pengdingbtn layoutButtonWithEdgeInsetsStyle: MKButtonEdgeInsetsStyleLeft imageTitleSpace: 10];
    [self.view addSubview:pengdingbtn];
    
    //Valid until 14:22 23 July 2017
    UILabel *labeValid = [[UILabel alloc] initWithFrame:CGRectMake(20, 121 *SJhight, kscreenw, 14)];
    labeValid.textColor = [UIColor colorWithRed:0.22 green:0.27 blue:0.34 alpha:1];
    labeValid.text = @"Valid until 14:22 23 July 2017";
    labeValid.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    [[self view] addSubview:labeValid];
    
    //money
    labelmoney = [[UILabel alloc] initWithFrame:CGRectMake(kscreenw - 300 -20, viewback1.frame.origin.y, 300, viewback1.frame.size.height)];
    labelmoney.textColor = [UIColor colorWithRed:1 green:0.48 blue:0.52 alpha:1];
    labelmoney.text = @"$99";
    if ([self.orderdic[@"data"][@"order"][@"status"] intValue] == 0 || [self.orderdic[@"data"][@"order"][@"status"] intValue] == 3) {
        labelmoney.textColor = [UIColor colorWithRed:0.17 green:0.81 blue:0.76 alpha:1];
    }
    labelmoney.text = [NSString stringWithFormat:@"$%@",self.orderdic[@"data"][@"order"][@"total"]];
    labelmoney.font = [UIFont fontWithName:@"SourceSansPro-bold" size:32];
    labelmoney.textAlignment =2;
    [[self view] addSubview:labelmoney];

    //viewback2
    UILabel *viewback2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 168*SJhight, 375 *SJwidth, 44 * 5 * SJhight + 10 )];
    viewback2.backgroundColor = [UIColor whiteColor];
    [[self view] addSubview:viewback2];
    
    // Months
    UILabel *labelMonths = [[UILabel alloc] initWithFrame:CGRectMake(20, 180 *SJhight , kscreenw, 22)];
    labelMonths.textColor = [UIColor colorWithRed:0.22 green:0.27 blue:0.34 alpha:1];
    labelMonths.text = @"6 Months PLan";
    labelMonths.text = [NSString stringWithFormat:@"$%@",self.orderdic[@"data"][@"order"][@"planName"]];
    labelMonths.font = [UIFont fontWithName:@"SourceSansPro-bold" size:20];
    [[self view] addSubview:labelMonths];

    //xian
    UILabel *labexian = [[UILabel alloc] initWithFrame:CGRectMake(20, 212 *SJhight, 335 *SJwidth, 2)];
    labexian.backgroundColor = [UIColor colorWithRed:0.89 green:0.93 blue:0.96 alpha:1];
    [[self view] addSubview:labexian];
    
    // Purchase Order
    UILabel *labelPurchase = [[UILabel alloc] initWithFrame:CGRectMake(20, 226 *SJhight , kscreenw, 18)];
    labelPurchase.textColor = [UIColor colorWithRed:0.22 green:0.27 blue:0.34 alpha:1];
    labelPurchase.text = @"Payment ID";
    labelPurchase.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    [[self view] addSubview:labelPurchase];
    UILabel *textPurchase = [[UILabel alloc] initWithFrame:CGRectMake(kscreenw - 200 - 20, 226 *SJhight, 200, 16)];
    textPurchase.textColor = [UIColor blackColor];
    textPurchase.text= @"2017021015435517911";
    textPurchase.text = [NSString stringWithFormat:@"%@",self.orderdic[@"data"][@"order"][@"_id"]];
    textPurchase.textAlignment = 2;
    textPurchase.font = [UIFont fontWithName:@"PingFangSC-Bold" size:16];
    [[self view] addSubview:textPurchase];

    // Devices Quantity
    UILabel *labelDate = [[UILabel alloc] initWithFrame:CGRectMake(20, 270 *SJhight , kscreenw, 18)];
    labelDate.textColor = [UIColor colorWithRed:0.22 green:0.27 blue:0.34 alpha:1];
    labelDate.text = @"Devices Quantity";
    labelDate.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    [[self view] addSubview:labelDate];
    UILabel *textDate = [[UILabel alloc] initWithFrame:CGRectMake(kscreenw - 200 - 20, 270 *SJhight, 200, 16)];
    textDate.textColor = [UIColor blackColor];
    textDate.text= @"3";
    textDate.text = [NSString stringWithFormat:@"%@",self.orderdic[@"data"][@"order"][@"deviceQuantity"]];
    textDate.textAlignment = 2;
    textDate.font = [UIFont fontWithName:@"PingFangSC-Bold" size:16];
    [[self view] addSubview:textDate];
    
    // Discount
    UILabel *labelService = [[UILabel alloc] initWithFrame:CGRectMake(20, 314 *SJhight , kscreenw, 18)];
    labelService.textColor = [UIColor colorWithRed:1 green:0.48 blue:0.52 alpha:1];
    labelService.text = @"Discount";
    labelService.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    [[self view] addSubview:labelService];
    UILabel *textService = [[UILabel alloc] initWithFrame:CGRectMake(kscreenw - 200 - 20, 314 *SJhight, 200, 16)];
    textService.textColor = [UIColor colorWithRed:1 green:0.48 blue:0.52 alpha:1];
    textService.text= @"- $0";
    textService.text = [NSString stringWithFormat:@"- $%@",self.orderdic[@"data"][@"order"][@"discount"]];
    textService.textAlignment = 2;
    textService.font = [UIFont fontWithName:@"PingFangSC-Bold" size:16];
    [[self view] addSubview:textService];
    
    // Total
    UILabel *labelDevices = [[UILabel alloc] initWithFrame:CGRectMake(20, 358 *SJhight , kscreenw, 18)];
    labelDevices.textColor = [UIColor colorWithRed:0.22 green:0.27 blue:0.34 alpha:1];
    labelDevices.text = @"Total";
    labelDevices.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    [[self view] addSubview:labelDevices];
    UILabel *textDevices = [[UILabel alloc] initWithFrame:CGRectMake(kscreenw - 200 - 20, 358 *SJhight, 200, 16)];
    textDevices.textColor = [UIColor colorWithRed:0.22 green:0.27 blue:0.34 alpha:1];
    textDevices.text= @"$99";
    textDevices.text = [NSString stringWithFormat:@"$%@",self.orderdic[@"data"][@"order"][@"total"]];
    textDevices.textAlignment = 2;
    textDevices.font = [UIFont fontWithName:@"PingFangSC-Bold" size:16];
    [[self view] addSubview:textDevices];
    
    //底部背景和付款
    bottomBK = [[UIView alloc] initWithFrame:CGRectMake(0, kscreenh - 64,  kscreenw, 64)];
    bottomBK.layer.shadowOffset = CGSizeMake(0, 2);
    bottomBK.layer.shadowColor = [[UIColor colorWithRed:0.71 green:0.71 blue:0.71 alpha:0.5] CGColor];
    bottomBK.layer.shadowOpacity = 1;
    bottomBK.layer.shadowRadius = 8;
    CAGradientLayer *gradientbottomBK = [CAGradientLayer layer];
    gradientbottomBK.frame = CGRectMake(0, 0,kscreenh - 64, 64);
    gradientbottomBK.colors = @[(id)[[UIColor colorWithRed:0.83 green:0.68 blue:1 alpha:1] CGColor],(id)[[UIColor colorWithRed:0.41 green:0.56 blue:1 alpha:1] CGColor]];
    gradientbottomBK.locations = @[@(0), @(1)];
    gradientbottomBK.startPoint = CGPointMake(1, 0);
    gradientbottomBK.endPoint = CGPointMake(0, 0.67);
    [[bottomBK layer] addSublayer:gradientbottomBK];
    [[self view] addSubview:bottomBK];
    
    //付款总额
    labeTotalMoney= [[UILabel alloc] initWithFrame:CGRectMake(20, kscreenh - 64 + (64 - 32)/2, 144, 32)];
    labeTotalMoney.textColor = [UIColor whiteColor];
    labeTotalMoney.text = [NSString stringWithFormat:@"$%@",self.orderdic[@"data"][@"order"][@"total"]];;
    labeTotalMoney.font = [UIFont fontWithName:@"SourceSansPro-Bold" size:32];
    [[self view] addSubview:labeTotalMoney];
    NSMutableAttributedString *attributedlabeTotalMoney = [[NSMutableAttributedString alloc]initWithString:labeTotalMoney.text];
    [attributedlabeTotalMoney addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"SourceSansPro-Bold" size:18] range:NSMakeRange(0, 1)];
    labeTotalMoney.attributedText = attributedlabeTotalMoney;
    
    //付款按钮
    PayBtn = [[UIButton alloc] initWithFrame:CGRectMake(227 *SJwidth, kscreenh - 64 + 10, 128, 44)];
    [PayBtn setTitle:@"Checkout" forState:0];
    PayBtn.tag = 100;
    PayBtn.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-SemiBold" size:20];
    [PayBtn addTarget:self action:@selector(PayCheckout:) forControlEvents:UIControlEventTouchUpInside];
    [PayBtn setTitleColor:[UIColor colorWithRed:0.46 green:0.59 blue:1 alpha:1] forState:0];
    PayBtn.backgroundColor = [UIColor whiteColor];
    PayBtn.layer.masksToBounds = YES;
    PayBtn.layer.cornerRadius = 22;
    [[self view] addSubview:PayBtn];
    if ([self.orderdic[@"data"][@"order"][@"status"] intValue] == 0) {
        labeTotalMoney.hidden = YES;
        
        [pengdingbtn setTitle:@"Completed    " forState:0];
        [PayBtn setTitle:@"Connect Now" forState:0];
        PayBtn.tag = 101;
        
        bottomBK.frame = CGRectMake(20, 573*SJhight, kscreenw - 40, 44);
        bottomBK.layer.cornerRadius = 6;
        bottomBK.layer.masksToBounds =YES;

        PayBtn.frame = bottomBK.frame;
        PayBtn.layer.cornerRadius = 6;
        PayBtn.backgroundColor = [UIColor clearColor];
        [PayBtn setTitleColor:[UIColor whiteColor] forState:0];
        PayBtn.layer.masksToBounds =YES;
    }
    if ([self.orderdic[@"data"][@"order"][@"status"] intValue] == 2) {
        [pengdingbtn setTitle:@"Failed    " forState:0];
    }
    if ([self.orderdic[@"data"][@"order"][@"Invited"] intValue] == 3) {
        [pengdingbtn setTitle:@"Invited    " forState:0];
    }
    // Do any additional setup after loading the view.
    
    
}

//用户付款
-(void)PayCheckout:(UIButton *)btn{
    
    //续订 (过期需要登录页面)
    [NetworkApi UserRenew:^(NSError *error) {
    }];
    
    if (btn.tag == 101) {//Connect Now
        //返回根视图
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
    
    Payments *pay = [Payments new];
//    pay.PlaneTypedic = self.orderdic[@"data"][@"order"];
//    [pay initPaymentwall];
//    [[PWCoreSDK sharedInstance] showPaymentVCWithParentVC:self paymentObject:pay.payment paymentOption:pay.options delegate:self];

//    if ([self.orderdic[@"data"][@"order"][@"status"] intValue] == 0) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"Alreadygettheline" object:nil];
//        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"UB判断连接"] isEqualToString:@"1"]) {
//            //间隔两秒之后做出判断
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"Alreadygettheline" object:nil];
//            });
//        }
//
//
//    }
}

-(void)paymentResponse:(PWCoreSDKResponse *)response{
    NSLog(@"----%lu",(unsigned long)response.responseCode);
    if (response.responseCode == PWPaymentResponseCodeSuccessful) {
        [LCProgressHUD showSuccess:@"successful"];
        labeTotalMoney.hidden = YES;
        [pengdingbtn setTitle:@"Completed    " forState:0];
        [PayBtn setTitle:@"Connect Now" forState:0];
        PayBtn.tag = 101;
        
        labelmoney.textColor = [UIColor colorWithRed:0.17 green:0.81 blue:0.76 alpha:1];
        [pengdingbtn setTitleColor:[UIColor colorWithRed:0.17 green:0.81 blue:0.76 alpha:1] forState:0];
        
        [pengdingbtn setImage:[UIImage imageNamed:@"订单成功"] forState:0];
        [pengdingbtn setTitle:@"Completed    " forState:0];
        [PayBtn setTitle:@"Connect Now" forState:0];
        PayBtn.tag = 101;
        
        bottomBK.frame = CGRectMake(20, 573*SJhight, kscreenw - 40, 44);
        bottomBK.layer.cornerRadius = 6;
        bottomBK.layer.masksToBounds =YES;
        
        PayBtn.frame = bottomBK.frame;
        PayBtn.layer.cornerRadius = 6;
        PayBtn.backgroundColor = [UIColor clearColor];
        [PayBtn setTitleColor:[UIColor whiteColor] forState:0];
        PayBtn.layer.masksToBounds =YES;
        
    }else{
        [LCProgressHUD showFailure:@"failed"];
    }
}

-(void)closeview{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
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
