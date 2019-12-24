//
//  MyPlanViewController.m
//  Potatso
//
//  Created by txb on 2017/9/28.
//  Copyright © 2017年 TouchingApp. All rights reserved.
//

#import "MyPlanViewController.h"
#import "ViewController.h"
#import "PurchaseViewController.h"
#import "SystemPurchaseViewController.h"
#import "ServiceViewController.h"
@interface MyPlanViewController ()<UINavigationControllerDelegate>

@end

@implementation MyPlanViewController

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //    如果不想让其他页面的导航栏变为透明 需要重置
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //去掉导航栏黑线
    [[UINavigationBar appearance]  setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
//     self.navigationController.navigationBar.alpha = 0;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary * LoginInfoResponse = [AppEnvironment UserInfodic];
    
    self.view.backgroundColor = makecolor(218, 218, 218);
    // 设置导航控制器的代理为self
    self.navigationController.delegate = self;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.22 green:0.27 blue:0.34 alpha:1], NSFontAttributeName:[UIFont fontWithName:@"SourceSansPro-bold" size:16]}];
    
    // 自定义导航栏左侧按钮
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 40, 40);;
    [leftBtn setImage:[UIImage imageNamed:@"Black_back_icon"]  forState:0];
    [leftBtn addTarget:self action:@selector(closeview) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;

    //标题
    UILabel *labeBT = [[UILabel alloc]initWithFrame:CGRectMake(25,94*SJhight, 250, 48)];
    labeBT.text =@"我的方案";
    labeBT.font = [UIFont fontWithName:@"SourceSansPro-bold" size:34];
    [self.view addSubview:labeBT];
    
    //套餐图片
    UIImageView *imagePlan = [[UIImageView alloc]initWithFrame:CGRectMake(20, 146*SJhight, 335*SJwidth, 160 * SJhight)];
    imagePlan.layer.cornerRadius = 4;
    imagePlan.layer.masksToBounds =YES;
    imagePlan.image = [UIImage imageNamed:@"MYPlan_试用"];
    [self.view addSubview:imagePlan];
    
    //套餐label
    UILabel *labelplan = [[UILabel alloc] initWithFrame:CGRectMake(40, 166*SJhight,kscreenw, 32)];
    labelplan.numberOfLines = 0;
    labelplan.text = @"1 Month Plan";
    labelplan.alpha = 0.57;
    labelplan.textColor = [UIColor whiteColor];
    labelplan.text = LoginInfoResponse[@"data"][@"plan"][@"planName"];
    labelplan.font = [UIFont fontWithName:@"SourceSansPro-bold" size:32];
    [self.view addSubview:labelplan];
    
    //INUSE
    UILabel *labelINUSE = [[UILabel alloc] initWithFrame:CGRectMake( kscreenw - 120 - 20 , 166*SJhight, 100, 14)];
    labelINUSE.textAlignment = 2;
    labelINUSE.text = LoginInfoResponse[@"data"][@"plan"][@"status"];
    labelINUSE.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    labelINUSE.textColor = [UIColor whiteColor];
    [self.view addSubview:labelINUSE];
    
    //DayLeft
    UILabel *labeDayLeft = [[UILabel alloc] initWithFrame:CGRectMake(40, 231 *SJhight, kscreenw - 80, 64)];
    labeDayLeft.numberOfLines = 1;
    labeDayLeft.font = [UIFont fontWithName:@"SourceSansPro-bold" size:64];
    NSString *labeDayLeftstr = @"27 Days Left";
    labeDayLeft.textColor = [UIColor whiteColor];
    imagePlan.image = [UIImage imageNamed:@"MYPlan_ Formal"];
    labeDayLeftstr = [AppEnvironment dateTimeDifferenceWithStartTime:[NSString stringWithFormat:@"%@",LoginInfoResponse[@"data"][@"plan"][@"endDateUnixTimestamp"]]endTime:nil];
    
    if (LoginInfoResponse[@"data"][@"plan"][@"MYPlan_ Formal"] == 0) { //试用用户
        imagePlan.image = [UIImage imageNamed:@"MYPlan_试用"];
    }
    if ([LoginInfoResponse[@"data"][@"plan"][@"status"] isEqualToString:@"EXPIRED"]) {
        imagePlan.image = [UIImage imageNamed:@"MYPlan_Expired"];
        labeDayLeftstr = @"00Hrs  00Min";
    }
    
    NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc]initWithString:labeDayLeftstr];
    NSRange rangeday = [labeDayLeftstr rangeOfString:@"Day"];//匹配得到的下标
    NSRange rangehrs = [labeDayLeftstr rangeOfString:@"Hrs"];
    NSRange rangeMin = [labeDayLeftstr rangeOfString:@"Min"];
    [attributedString2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"SourceSansPro-Regular" size:14] range:rangeday];
    [attributedString2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"SourceSansPro-Regular" size:14] range:rangehrs];
    [attributedString2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"SourceSansPro-Regular" size:14] range:rangeMin];
    labeDayLeft.attributedText = attributedString2;
    [self.view addSubview:labeDayLeft];
    
    //Ayraline
    UILabel *labeAyraline = [[UILabel alloc] initWithFrame:CGRectMake( kscreenw - 120 - 20  , 272*SJhight , 100, 14)];
    labeAyraline.textAlignment = 2;
    labeAyraline.text = @"HaixVPN";
    labeAyraline.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    labeAyraline.textColor = [UIColor whiteColor];
    [self.view addSubview:labeAyraline];
    
    //CurrentPlanLable
    UILabel *LabelPlanLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 326 * SJhight, kscreenw, 80 *SJhight)];
    LabelPlanLable.backgroundColor = [UIColor whiteColor];
    [[self view] addSubview:LabelPlanLable];
    UILabel *textCurrentPlan = [[UILabel alloc] initWithFrame:CGRectMake(20, 344 * SJhight, 150, 16)];
    textCurrentPlan.text =@"當前方案";
    textCurrentPlan.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    textCurrentPlan.textColor = [UIColor colorWithRed:0.22 green:0.27 blue:0.34 alpha:1];
    [self.view addSubview:textCurrentPlan];
    UILabel *textMonthtPlan = [[UILabel alloc] initWithFrame:CGRectMake(20, 370 * SJhight, 150, 30)];
    textMonthtPlan.text = LoginInfoResponse[@"data"][@"plan"][@"planName"];
    textMonthtPlan.font = [UIFont fontWithName:@"SourceSansPro-bold" size:18];
    textMonthtPlan.textColor = [UIColor blackColor];
    [self.view addSubview:textMonthtPlan];
    UIButton *btnUpgrade = [[UIButton alloc] initWithFrame:CGRectMake(259 *SJwidth, 354 *SJhight, 96, 32)];
    btnUpgrade.layer.cornerRadius = 15;
    btnUpgrade.layer.borderWidth = 2;
    btnUpgrade.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-bold" size:14];
    [btnUpgrade setTitle:@"Buy" forState:0];
    if (LoginInfoResponse[@"data"][@"plan"][@"MYPlan_ Formal"] == 0) { //试用用户
        [btnUpgrade setTitle:@"購買" forState:0];;
    }
    [btnUpgrade setTitleColor:ZTblue forState:0];
    btnUpgrade.layer.masksToBounds = YES;
    [btnUpgrade addTarget:self action:@selector(upgrade) forControlEvents:UIControlEventTouchUpInside];
    btnUpgrade.layer.borderColor = [[UIColor colorWithRed:0.46 green:0.59 blue:1 alpha:1] CGColor];
    [[self view] addSubview:btnUpgrade];
    
    //ServiceDuration
    UILabel *LabelService = [[UILabel alloc] initWithFrame:CGRectMake(0, 406 * SJhight +2, kscreenw, 80 *SJhight)];
    LabelService.backgroundColor = [UIColor whiteColor];
    [[self view] addSubview:LabelService];
    UILabel *textService = [[UILabel alloc] initWithFrame:CGRectMake(20, 424 * SJhight, 150, 16)];
    textService.text =@"服務區間";
    textService.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    textService.textColor = [UIColor colorWithRed:0.22 green:0.27 blue:0.34 alpha:1];
    [self.view addSubview:textService];
    UILabel *textServiceDuration = [[UILabel alloc] initWithFrame:CGRectMake(20, 450 * SJhight, kscreenw, 30)];
    textServiceDuration.text =  [AppEnvironment UTCchangeDate:[[NSUserDefaults standardUserDefaults] valueForKey:@"UsernameExpired"]];;
    textServiceDuration.font = [UIFont fontWithName:@"SourceSansPro-bold" size:18];
    textServiceDuration.textColor = [UIColor blackColor];
    [self.view addSubview:textServiceDuration];
    
    //Devices QuantityLable 增加设备
    UILabel *LabelDevicesQuantity = [[UILabel alloc] initWithFrame:CGRectMake(0, 486 * SJhight +4, kscreenw, 80 *SJhight)];
    LabelDevicesQuantity.backgroundColor = [UIColor whiteColor];
    [[self view] addSubview:LabelDevicesQuantity];
    UILabel *textDevices = [[UILabel alloc] initWithFrame:CGRectMake(20, 504 * SJhight, 150, 16)];
    textDevices.text =@"裝置數量";
    textDevices.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    textDevices.textColor = [UIColor colorWithRed:0.22 green:0.27 blue:0.34 alpha:1];
    [self.view addSubview:textDevices];
    UILabel *textDevicesQuantity = [[UILabel alloc] initWithFrame:CGRectMake(20, 530 * SJhight, 150, 30)];
    textDevicesQuantity.text = [NSString stringWithFormat:@"%@ Devices",LoginInfoResponse[@"data"][@"plan"][@"deviceQuantity"]];
    textDevicesQuantity.font = [UIFont fontWithName:@"SourceSansPro-bold" size:18];
    textDevicesQuantity.textColor = [UIColor blackColor];
    [self.view addSubview:textDevicesQuantity];
    UIButton *btnPurchase = [[UIButton alloc] initWithFrame:CGRectMake(259 *SJwidth, 514 *SJhight, 96, 32)];
    btnPurchase.layer.cornerRadius = 15;
    btnPurchase.layer.borderWidth = 2;
    btnPurchase.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-bold" size:14];
    [btnPurchase setTitle:@"Purchase" forState:0];
    [btnPurchase setTitleColor:ZTblue forState:0];
    btnPurchase.layer.masksToBounds = YES;
    [btnPurchase addTarget:self action:@selector(Purchase) forControlEvents:UIControlEventTouchUpInside];
    btnPurchase.layer.borderColor = [[UIColor colorWithRed:0.46 green:0.59 blue:1 alpha:1] CGColor];
    btnPurchase.hidden = YES;
    [[self view] addSubview:btnPurchase];
    // Do any addzz  itional setup after loading the view.
}

-(void)upgrade
{
//    SystemPurchaseViewController *system = [SystemPurchaseViewController new];
//    [self.navigationController pushViewController:system animated:YES];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"聯絡客服" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"確認" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ServiceViewController *service = [ServiceViewController new];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:service];
        [self presentViewController:navi animated:YES completion:nil];
    }];
    
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 增加设备
-(void)Purchase{
    PurchaseViewController *purchase = [PurchaseViewController new];
    [self.navigationController pushViewController:purchase animated:YES];
}

-(void)closeview{
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
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
