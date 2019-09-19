//
//  ViewController.m
//  VPN
//
//  Created by Apple on 16/9/20.
//  Copyright © 2016年 Apple. All rights reserved.
//
/*
 
 */

#import "ViewController.h"
#import "EncryptAndEcode.h"
#import "BUYViewController.h"
#import <AdSupport/ASIdentifierManager.h>
#import "AFNetworking.h"
#import "GetMiYao.h"
#import "GifView.h"
#import <libkern/OSAtomic.h>
#import "Potatso-Swift.h"
#import "SAMKeychain.h"
#import "LCProgressHUD.h"
#import "ProxyManager.h"
#import <AudioToolbox/AudioToolbox.h>
#import "XLCircleProgress.h"
#import "NYWaterWaveView.h"
#import "CouponsViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"
#import "SocketManagerBF.h"
#import "NSTimer+Pluto.h"
#import "SSRLinesViewController.h"
#import "ForgetSetPwdViewController.h"
#import "SystemPurchaseViewController.h"
#import "UIView+Frame.h"
#define Kscreenw [UIScreen mainScreen].bounds.size.width
#define Kscreenh [UIScreen mainScreen].bounds.size.height
#define GGBS [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString]
#define RGBColor(r,g,b) [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:1.0]
@interface ViewController ()
@property int circleProgress;

@property (nonatomic, strong) NSTimer *timerConncet;
@end



@implementation ViewController{
    UIButton *RoundInsidebutun;
    UIImageView *imageArrowbtn;
    GifView *imagegif;
    HomeVC *hc;
    XLCircleProgress *_circle;
    UILabel *labeBK;
    //下载速度
    UILabel *labeDownload;
    //上传数据
    UILabel *labeUPload;
    //VPN Status
    UILabel *Remaininglabe;
    //数字Hrs
    UILabel *textmin;
    //Hrs
    UILabel *textDs;
    //数字Min
    UILabel *textsec;
    //Min
    UILabel *textHrs;
    
    VAProgressCircle * progressCircle;
    NSTimer *randomTimer;
    CALayer *layerbutun;
    
    //底部线路选择
    UIButton *btn;
    UIImageView *imagebtn;
}

#pragma mark 重要：mark自定义线路

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;//电池栏颜色白色
}

/**
 *  加载控制器的时候设置打开抽屉模式  (因为在后面会关闭)
 */
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
//    设置打开抽屉模式
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    //关闭抽屉模式
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"aryaToken"] == nil) {
        RigistViewController *sign = [RigistViewController new];
        [self presentViewController:sign animated:YES completion:nil];
        return;
    }
    
    //发送设备信息给乐伦
    [NetworkApi GetLicenseView];
    
    //底部线路名称
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"当前用户选择的国家"] != nil) {
        [btn setTitle:[[NSUserDefaults standardUserDefaults] valueForKey:@"当前用户选择的国家"] forState:0];
        [btn layoutButtonWithEdgeInsetsStyle: MKButtonEdgeInsetsStyleRight imageTitleSpace: 10];
        
        CGSize titleSize = btn.titleLabel.bounds.size;
        imagebtn.image = [UIImage imageNamed:@"CountryMap"];
        imagebtn.x = kscreenw/2 - titleSize.width/2 - 18 - 10 - imagebtn.frame.size.width;
        imagebtn.image = [UIImage imageNamed:@"CountryMap"];
        
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"当前用户选择的国家"] hasPrefix:@"America"]) {
            imagebtn.image = [UIImage imageNamed:@"America"];
        } if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"当前用户选择的国家"] hasPrefix:@"Canada"]) {
            imagebtn.image = [UIImage imageNamed:@"Canada"];
        } if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"当前用户选择的国家"] hasPrefix:@"China"]) {
            imagebtn.image = [UIImage imageNamed:@"China"];
        } if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"当前用户选择的国家"] hasPrefix:@"HongKong"]) {
            imagebtn.image = [UIImage imageNamed:@"HongKong"];
        } if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"当前用户选择的国家"] hasPrefix:@"Japan"]) {
            imagebtn.image = [UIImage imageNamed:@"Japan"];
        } if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"当前用户选择的国家"] hasPrefix:@"Korea"]) {
            imagebtn.image = [UIImage imageNamed:@"Korea"];
        } if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"当前用户选择的国家"] hasPrefix:@"Philippines"]) {
            imagebtn.image = [UIImage imageNamed:@"Philippines"];
        } if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"当前用户选择的国家"] hasPrefix:@"Russian Federation"]) {
            imagebtn.image = [UIImage imageNamed:@"Russian Federation"];
        } if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"当前用户选择的国家"] hasPrefix:@"Singapore"]) {
            imagebtn.image = [UIImage imageNamed:@"Singapore"];
        } if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"当前用户选择的国家"] hasPrefix:@"United Kingdom"]) {
            imagebtn.image = [UIImage imageNamed:@"United Kingdom"];
        }
    }
    
    btn.hidden = YES;
    imagebtn.hidden = YES;
    
    [NetworkApi Getusernodes:nil anddic:nil block:^(NSDictionary *responseObject) {
        NSArray *ary = responseObject[@"data"][@"nodes"];
        for (int i = 0; i < ary.count; i++) {
            NSString *country = ary[i][@"country"];
            if ([country isEqualToString:@"jp"]) {
                [[NSUserDefaults standardUserDefaults] setObject:ary[i] forKey:@"AryaLineConfiguration"];
            }
        }
    } block:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

-(void)viewWillDisappear:(BOOL)animated{
 
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"";
    self.navigationController.navigationBar.barTintColor = RGBColor(200, 200, 200);
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.view.backgroundColor = [UIColor  whiteColor];
    
    //透明色
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0, 0, kscreenw, kscreenh);
    gradient.colors = @[	(id)[[UIColor colorWithRed:0.83 green:0.68 blue:1 alpha:1] CGColor],(id)[[UIColor colorWithRed:0.41 green:0.56 blue:1 alpha:1] CGColor]];
    gradient.locations = @[@(0), @(1)];
    gradient.startPoint = CGPointMake(1, 0);
    gradient.endPoint = CGPointMake(0, 0.5);
    [self.view.layer addSublayer:gradient];
    
    //左侧按钮
    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(5, 25 , 50, 50);
    if (kscreenh == 818) {
        menuBtn.frame = CGRectMake(5, 25 , 50, 50);
    }
    [menuBtn setImage:[UIImage imageNamed:@"burger menu"] forState:UIControlStateNormal];
    [menuBtn setImage:[UIImage imageNamed:@"burger menu"] forState:UIControlStateHighlighted    ];
    [menuBtn addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:menuBtn];
    
    //右侧按钮
    UIButton *RightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    RightBtn.frame = CGRectMake(kscreenw - 50 - 5, 25 , 50, 50);
    [RightBtn setImage:[UIImage imageNamed:@"BuyPackage"] forState:UIControlStateNormal];
    [RightBtn addTarget:self action:@selector(BuyPackage) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:RightBtn];
    
    //水波
    imagegif = [[GifView alloc]initWithFrame:CGRectMake(-20,kscreenh-170, kscreenw + 40 , 170) filePath:[[NSBundle mainBundle] pathForResource:@"水波动画.gif"ofType:nil]];
    [self.view addSubview:imagegif];
    
    //连接状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kaishijiasu) name:@"Alreadygettheline" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BuyPackage) name:@"GoBuyMyplane" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Connectted) name:@"连接成功" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Disconnceted) name:@"连接失败" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Connectteding) name:@"连接中" object:nil];
    
    //VPN Status
    Remaininglabe = [[UILabel alloc] initWithFrame:CGRectMake(0, 80 *SJhight, kscreenw, 22)];
    Remaininglabe.textColor = [UIColor whiteColor];
    Remaininglabe.textAlignment =1;
    Remaininglabe.text = @"狀態: 未連接";
    Remaininglabe.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:20];
    [[self view] addSubview:Remaininglabe];

    //min/hrs
    textmin= [[UILabel alloc] initWithFrame:CGRectMake(110 *SJwidth, 120 *SJhight, 60, 50)];
    textmin.textColor = [UIColor whiteColor];
    textmin.text = @"00";
    textmin.font = [UIFont fontWithName:@"SourceSansPro-bold" size:48.f];
    [[self view] addSubview:textmin];
    
    //Hrs
    textDs= [[UILabel alloc] initWithFrame:CGRectMake(163 *SJwidth, 120 *SJhight, 25, 16)];
    textDs.textColor = [UIColor whiteColor];
    textDs.text = @"Hrs";
    textDs.font = [UIFont fontWithName:@"SourceSansPro-bold" size:14.f];
    [[self view] addSubview:textDs];
    
    //sec/min
    textsec = [[UILabel alloc] initWithFrame:CGRectMake(191 *SJwidth, 120 *SJhight, 60, 50)];
    textsec.textColor = [UIColor whiteColor];
    textsec.text = @"00";
    textsec.font = [UIFont fontWithName:@"SourceSansPro-bold" size:48.f];
    [[self view] addSubview:textsec];
    
    //Hrs/min
    textHrs = [[UILabel alloc] initWithFrame:CGRectMake(244 *SJwidth, 120 *SJhight, 25, 16)];
    textHrs.textColor = [UIColor whiteColor];
    textHrs.text = @"Min";
    textHrs.font = [UIFont fontWithName:@"SourceSansPro-bold" size:14.f];
    [[self view] addSubview:textHrs];
    
    //动画圆
    _circle = [[XLCircleProgress alloc] initWithFrame:CGRectMake(104 *SJwidth -2, 206 *SJhight -2, 168 + 4, 168 + 4)];
    _circle.hidden = YES;
    self.circleProgress = 0;
    [self.view addSubview:_circle];
    
    //内圆
    layerbutun = [CALayer layer];
    layerbutun.frame = CGRectMake(118 *SJwidth, 220 *SJhight, 140 *SJwidth , 140 *SJwidth);
    layerbutun.backgroundColor = [[UIColor colorWithRed:0.22 green:0.27 blue:0.34 alpha:1] CGColor];
    layerbutun.shadowOffset = CGSizeMake(0,1.8);
    layerbutun.shadowOpacity = 1;
    layerbutun.shadowRadius = 4;    //修改的
    layerbutun.opacity = 0.7;      //修改的
    layerbutun.cornerRadius = layerbutun.frame.size.height/2.f;
    [self.view.layer addSublayer:layerbutun];
    RoundInsidebutun = [[UIButton alloc] initWithFrame:CGRectMake(118 *SJwidth , 220 *SJhight, 140 *SJwidth, 140 *SJwidth)];
    [RoundInsidebutun setBackgroundColor:[UIColor whiteColor]];
    RoundInsidebutun.layer.masksToBounds =YES;
    RoundInsidebutun.layer.cornerRadius =RoundInsidebutun.frame.size.height/2.f;
    [RoundInsidebutun addTarget:self action:@selector(kaishijiasu) forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:RoundInsidebutun];
    
    //unblockmy icon
//    imageArrowbtn = [[UIImageView alloc] initWithFrame:CGRectMake( RoundInsidebutun.frame.origin.x + (140 *SJwidth - 87)/2, RoundInsidebutun.frame.origin.y + (140 *SJwidth - 54)/2, RoundInsidebutun.bounds.size.width, RoundInsidebutun.bounds.size.height)];
    imageArrowbtn = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, RoundInsidebutun.bounds.size.width/3*2, RoundInsidebutun.bounds.size.height/3*2)];
    imageArrowbtn.center = RoundInsidebutun.center;
    imageArrowbtn.image = [UIImage imageNamed:@"DisConnectImage"];
    [imageArrowbtn setUserInteractionEnabled:YES];
    [[self view] addSubview:imageArrowbtn];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(kaishijiasu)];
    [imageArrowbtn addGestureRecognizer:tap];
    
    //渐变
    [self SetprogressCircle];
    
    //下载箭头
    UIImageView *imageDownLoad = [[UIImageView alloc] initWithFrame:CGRectMake(56 *SJwidth, 473*SJhight, 16, 18)];
    imageDownLoad.image = [UIImage imageNamed:@"DownLoad"];
    [[self view] addSubview:imageDownLoad];
    
    //Download
    UILabel *textDownLoad = [[UILabel alloc] initWithFrame:CGRectMake(78 *SJwidth, 477 *SJhight,60, 14)];
    textDownLoad.textColor = [UIColor colorWithRed:0.22 green:0.27 blue:0.34 alpha:1];textDownLoad.text = @"Download";
    textDownLoad.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:12];
    [[self view] addSubview:textDownLoad];
    
    //上传箭头
    UIImageView *imageUPLoad = [[UIImageView alloc] initWithFrame:CGRectMake(216 *SJwidth, 473*SJhight, 16, 18)];
    imageUPLoad.image = [UIImage imageNamed:@"UPLoad"];
    [[self view] addSubview:imageUPLoad];
    
    //Upload
    UILabel *textUpload = [[UILabel alloc] initWithFrame:CGRectMake(238 *SJwidth, 477 *SJhight, 60, 14)];
    textUpload.textColor = [UIColor colorWithRed:0.22 green:0.27 blue:0.34 alpha:1];
    textUpload.text = @"Upload";
    textUpload.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:12];
    [[self view] addSubview:textUpload];

    //Download数据
    labeDownload = [[UILabel alloc] initWithFrame:CGRectMake(56 *SJwidth, 503 *SJhight,114 * SJwidth + 33, 26)];
    labeDownload.textColor = [UIColor blackColor];
    labeDownload.text = @"62.65";
    labeDownload.textAlignment =0;
    labeDownload.font = [UIFont fontWithName:@"SourceSansPro-bold" size:24];
    [[self view] addSubview:labeDownload];
    
    //UPload数据
    labeUPload = [[UILabel alloc] initWithFrame:CGRectMake(216 *SJwidth, 503 *SJhight, kscreenw, 26)];
    labeUPload.textColor = [UIColor blackColor ];
    labeUPload.text = @"14.25";
    labeUPload.textAlignment =0;
    labeUPload.font = [UIFont fontWithName:@"SourceSansPro-bold" size:24];
    [[self view] addSubview:labeUPload];
    
    
    //线路选择
    btn = [[UIButton alloc]initWithFrame:CGRectMake(0,SJhight*607, kscreenw, 20)];
    [btn setImage:[UIImage imageNamed:@"next"] forState:0];
    [btn setTitle:@"Automatic" forState:UIControlStateNormal];
    [btn setTitleColor: [UIColor colorWithRed:0.22 green:0.27 blue:0.34 alpha:1] forState:0];
    [btn addTarget:self action:@selector(showListView) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-bold" size:20];
    [btn layoutButtonWithEdgeInsetsStyle: MKButtonEdgeInsetsStyleRight imageTitleSpace: 10];
    [self.view addSubview:btn];
    
    
    imagebtn = [[UIImageView alloc]initWithFrame:CGRectMake(0, btn.frame.origin.y + 3.5, 20, 13)];
    CGSize titleSize = btn.titleLabel.bounds.size;
    imagebtn.image = [UIImage imageNamed:@"CountryMap"];
    imagebtn.x = kscreenw/2 - titleSize.width/2 - 15 - imagebtn.frame.size.width;
    imagebtn.layer.shadowColor = [UIColor blackColor].CGColor;//阴影颜色
    imagebtn.layer.shadowOffset = CGSizeMake(0, 0);//偏移距离
    imagebtn.layer.shadowOpacity = 0.1;//不透明度
    imagebtn.layer.shadowRadius = 2.0;//半径
    [self.view addSubview:imagebtn];
    
    //shadowview
    labeBK = [[UILabel alloc]initWithFrame:self.view.frame];
    labeBK.backgroundColor = [UIColor blackColor];
    labeBK.alpha = 0.3;
    labeBK.hidden = YES;
    [self.view addSubview:labeBK ];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ShowShadowViewHide:) name:@"ShowShadowViewHide" object:nil];
    
    
    //续订 (过期需要登录页面)
    [self UserToken];
    
    //监听流量
    [[MonitorFlow shareNetworkSpeed] start];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(XZSpeed:) name:GSDownloadNetworkSpeedNotificationKey object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(SCSpeed:) name:GSUploadNetworkSpeedNotificationKey object:nil];
    
//    NYWaterWaveView *waterWaveView = [[NYWaterWaveView alloc]initWithFrame:CGRectMake(0,kscreenh-200, kscreenw, 200)];
//    [self.view addSubview:waterWaveView];
    
    //ssr部分
    hc =[[HomeVC alloc]init];
    [hc Managersetup];
    [hc handleRefreshUI];

    
//    //sockct + protobuf 开始TCP连接
//    ProtobufManage * ptbm = [ProtobufManage new];
//    [ptbm startprotobuf];
    
    //ios画圆
    [self StartTimeForTemporary];
    
    //获得连接时间的时长
    [NSTimer pltScheduledTimerWithTimeInterval:1.0 target:self selector:@selector(ShowConnectTime) userInfo:nil];
  
}

//显示首页连接时间
-(void)ShowConnectTime{
    NSArray *ConnectArray = [[AppEnvironment GetNowTime] componentsSeparatedByString:@":"];
    if ([ConnectArray[0] intValue] != 0) {
        textmin.text = ConnectArray[0];
        textDs.text = @"Day";
        textsec.text = ConnectArray[1];
        textHrs.text = @"Hrs";
    }
   else if ([ConnectArray[2] intValue] != 0) {
        textmin.text = ConnectArray[2];
        textDs.text = @"Min";
        textsec.text = ConnectArray[3];
        textHrs.text = @"sec";
    }
   else if ([ConnectArray[3] intValue] != 0){
       textmin.text = ConnectArray[2];
       textDs.text = @"Min";
       textsec.text = ConnectArray[3];
       textHrs.text = @"sec";
   }
   else{
       textmin.text = @"00";
       textDs.text = @"Min";
       textsec.text = @"00";
       textHrs.text = @"sec";
   }
    
    //如果已过期则跳到购买同时关掉加速
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"UB判断连接"] isEqualToString:@"1"]) {
        if ([[AppEnvironment performTotime] isEqualToString:@"过期"]) {
            [self kaishijiasu];
        }
    }
    NSLog(@"连接后的时间差%@",[AppEnvironment GetNowTime])  ;
}

- (void)showListView{
  
//    SocketManager * scman =[SocketManager sharedInstance];
//    //发送消息
//    [scman SendUserprotobuf];
    
    SSRLinesViewController *ssrlines = [SSRLinesViewController new];
    [self presentViewController:ssrlines animated:YES completion:nil];
}


//打开左侧登录
- (void)showMenu{
    //这里的话是通过遍历循环拿到之前在AppDelegate中声明的那个MMDrawerController属性，然后判断是否为打开状态，如果是就关闭，否就是打开(初略解释，里面还有一些条件)
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

//打开右侧
-(void)rightBtn{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

//连接中
-(void)Connectteding{
   [LCProgressHUD hide];
    Remaininglabe.text = @"狀態: 連接中";
   imageArrowbtn.image = [UIImage imageNamed:@"DisConnectImage"];
}

//已连接
-(void)Connectted{
    Remaininglabe.text = @"狀態: 已連接";
    imageArrowbtn.image = [UIImage imageNamed:@"ConnectImage"];

    // 将大图动画回小图的位置和大小
    [UIView animateWithDuration:0.3 animations:^{
        // 改变大小
        layerbutun.frame = CGRectMake(118 *SJwidth, 220 *SJhight, 140 *SJwidth , 140 *SJwidth);
        layerbutun.backgroundColor = [[UIColor colorWithRed:0.22 green:0.27 blue:0.34 alpha:0.4] CGColor];
        layerbutun.shadowOffset = CGSizeMake(0,1.8);
        layerbutun.shadowOpacity = 1;
        layerbutun.shadowRadius = 4;    //修改的
        layerbutun.opacity = 0.7;      //修改的
        RoundInsidebutun.frame = layerbutun.frame;
        RoundInsidebutun.layer.cornerRadius =RoundInsidebutun.frame.size.height/2.f;
//        imageArrowbtn.frame =CGRectMake(RoundInsidebutun.frame.origin.x + (140 *SJwidth - 87)/2, RoundInsidebutun.frame.origin.y + (140 *SJwidth - 54)/2, 87, 54);

    }];
}

//未连接
-(void)Disconnceted{
    
    Remaininglabe.text = @"狀態: 未連接";
    [LCProgressHUD hide];
    imageArrowbtn.image = [UIImage imageNamed:@"DisConnectImage"];
    progressCircle.hidden = YES;

    // 将大图动画回小图的位置和大小
    [UIView animateWithDuration:0.3 animations:^{
        // 改变大小
        layerbutun.frame = CGRectMake(118 *SJwidth, 220 *SJhight, 140 *SJwidth , 140 *SJwidth);
        layerbutun.backgroundColor = [[UIColor colorWithRed:0.22 green:0.27 blue:0.34 alpha:1] CGColor];
        layerbutun.shadowOffset = CGSizeMake(0,1.8);
        layerbutun.shadowOpacity = 1;
        layerbutun.shadowRadius = 4;    //修改的
        layerbutun.opacity = 0.7;      //修改的
        RoundInsidebutun.frame = layerbutun.frame;
        RoundInsidebutun.layer.cornerRadius =RoundInsidebutun.frame.size.height/2.f;
//        imageArrowbtn.frame = CGRectMake( RoundInsidebutun.frame.origin.x + (140 *SJwidth - 87)/2, RoundInsidebutun.frame.origin.y + (140 *SJwidth - 54)/2, 87, 54);
    }];
}

-(void)switchAction{

    CKAlertViewController *alertVC = [CKAlertViewController alertControllerWithTitle:@"发现新版本" message:@"1. 日夜赶工,修复了一堆bug.\n2. 跟着产品经理改来改去,增加了很多功能.\n3. 貌似性能提升了那么一点点." ];
    alertVC.messageAlignment = NSTextAlignmentLeft;
    CKAlertAction *cancel = [CKAlertAction actionWithTitle:@"我知道了" handler:^(CKAlertAction *action) {
        NSLog(@"点击了 %@ 按钮",action.title);
    }];
    CKAlertAction *update = [CKAlertAction actionWithTitle:@"立即更新" handler:^(CKAlertAction *action) {
        NSLog(@"点击了 %@ 按钮",action.title);
    }];
    [alertVC addAction:cancel];
    [alertVC addAction:update];
    [self presentViewController:alertVC animated:NO completion:nil];
}

//点击连接
-(void)kaishijiasu{
    
    //前往更新
//    [self switchAction];
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"AryaLineConfiguration"] == nil) {
        [self UserToken];
        return;
    }
    
    //触感反馈
    if (kscreenw  <= 320) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }else{
        AudioServicesPlaySystemSound(1520);
    }
    
    //已到期
    if ([[AppEnvironment UserInfodic][@"data"][@"plan"][@"remain"] intValue] == 0) {
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"UB判断连接"] isEqualToString:@"1"]) {
            [hc handleConnectButtonPressed];
        }
        [AppEnvironment ShowInfosView:@"过期"];
        return;
    }
    
    //被冻结
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoginInfoResponse"][@"data"][@"disable"] integerValue] == 1) {
        [AppEnvironment ShowInfosView:nil];
        return;
    }
    
    //为空的时候直接连接
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"UB判断连接"]  == nil) {
         [hc handleConnectButtonPressed];
        return;
    }
    
    //已连接变成未连接
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"UB判断连接"] isEqualToString:@"1"]) {
        [hc handleConnectButtonPressed];
        return;
    }
    
    //圆扩散 整个动画效果
    [self SetprogressCircle];
    // 将大图动画回小图的位置和大小
    layerbutun.shadowRadius = 4;
    [UIView animateWithDuration:0.3 animations:^{
        // 改变大小
        layerbutun.frame = CGRectMake(118 *SJwidth + 10, 220 *SJhight + 10 , 140 *SJwidth -20 , 140 *SJwidth - 20);
        layerbutun.backgroundColor = [[UIColor colorWithRed:0.22 green:0.27 blue:0.34 alpha:1] CGColor];
        layerbutun.shadowOffset = CGSizeMake(0,1.8);
        layerbutun.shadowOpacity = 1;
        layerbutun.shadowRadius = 4;    //修改的
        layerbutun.opacity = 0.3;      //修改的
        RoundInsidebutun.frame = layerbutun.frame;
        RoundInsidebutun.layer.cornerRadius = RoundInsidebutun.frame.size.height/2.f;
//        imageArrowbtn.frame =CGRectMake( RoundInsidebutun.frame.origin.x + (140 *SJwidth- 20 - 67)/2, RoundInsidebutun.frame.origin.y + (140 *SJwidth - 12.5 - 41.5)/2, 67, 54-12.5);
        
        //间隔两秒之后做出判断 测试
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [hc handleConnectButtonPressed];
        });
    }];
    
    // 保存可连接
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.haixvpn.chinese.net"];
    [shared setObject:@"可连" forKey:@"设置可连or不可连"];
    [shared synchronize];
    [SAMKeychain setPassword:@"可连" forService:@"设置不可连" account:@"设置不可连"];
}

//下载速度
-(void)XZSpeed:(NSNotification *)notification{
    NSString * infoDic = [notification object];
    if (infoDic.length == 4) {
        infoDic = [infoDic stringByReplacingOccurrencesOfString :@"0B/s" withString:@"0.0KB/s"];
    }
    NSMutableAttributedString *downstr ;
    if ([infoDic containsString:@"KB"]) {
        infoDic = [infoDic stringByReplacingOccurrencesOfString :@"KB/s" withString:@" KB/s"];
        downstr = [[NSMutableAttributedString alloc] initWithString:infoDic];
        [downstr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(infoDic.length - 5,5)];
        [downstr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"SourceSansPro-Light" size:14] range:NSMakeRange(infoDic.length - 5,5)];
    } else {
        infoDic = [infoDic stringByReplacingOccurrencesOfString :@"M" withString:@" M"];
        downstr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",infoDic]];
        [downstr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(infoDic.length - 4,4)];
        [downstr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"SourceSansPro-Light" size:14] range:NSMakeRange(infoDic.length - 4,4)];
    }
    labeDownload.attributedText = downstr;
}


//上传速速
-(void)SCSpeed:(NSNotification *)notification{
    NSString * infoDic = [notification object];
    if (infoDic.length == 4) {
        infoDic = [infoDic stringByReplacingOccurrencesOfString :@"0B/s" withString:@"0.0KB/s"];
    }
    NSMutableAttributedString *upstr ;
    if ([infoDic containsString:@"KB"]) {
        infoDic = [infoDic stringByReplacingOccurrencesOfString :@"KB/s" withString:@" KB/s"];
        upstr = [[NSMutableAttributedString alloc] initWithString:infoDic];
        [upstr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(infoDic.length - 5,5)];
        [upstr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"SourceSansPro-Light" size:14] range:NSMakeRange(infoDic.length - 5,5)];
    } else {
        infoDic = [infoDic stringByReplacingOccurrencesOfString :@"M" withString:@" M"];
        upstr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",infoDic]];
        [upstr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(infoDic.length - 4,4)];
        [upstr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"SourceSansPro-Light" size:14] range:NSMakeRange(infoDic.length - 4,4)];
    }
    labeUPload.attributedText = upstr;
}


//BuyPackage 购买套餐
-(void)BuyPackage{
    SystemPurchaseViewController *Buy = [SystemPurchaseViewController new];
    [self.navigationController pushViewController:Buy animated:YES];
}


//倒计时临时用户时间
-(void)StartTimeForTemporary{
    //    __weak typeof(self) weakSelf = self;
    //倒计时时间
    __block NSInteger timeOut = 60 * 60 * 24;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //每秒执行一次
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        //倒计时结束，关闭
        if (timeOut > 60 * 60 * 24) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                _circle.progress = 0;
            });
        } else {
            double seconds = timeOut / 1201.f ;
            dispatch_async(dispatch_get_main_queue(), ^{
                _circle.progress = seconds;
            });
            timeOut--;
        }
    });
    dispatch_resume(_timer);
}


//阴影背景的隐藏和显示
-(void)ShowShadowViewHide:(NSNotification *)Orhide{
    if ([[Orhide object] isEqualToString:@"1"]) {
        labeBK.hidden = NO;
    }else{
        labeBK.hidden = YES;
    }
}


- (void)dealloc{
    [[NSNotificationCenter  defaultCenter] removeObserver:self  name:GSDownloadNetworkSpeedNotificationKey object:nil];
    [[NSNotificationCenter  defaultCenter] removeObserver:self  name:GSUploadNetworkSpeedNotificationKey object:nil];
}


//绘画圆1
- (void)addProgress{
    int randomIncrement = self.circleProgress + arc4random_uniform(101 - self.circleProgress) / 3;
    if(self.circleProgress != randomIncrement && randomIncrement > self.circleProgress) {
        self.circleProgress = randomIncrement;
        [progressCircle setProgress:self.circleProgress];
    }
    else{
        self.circleProgress++;
        [progressCircle setProgress:self.circleProgress];
    }
}
//绘画圆2
- (void)randomIncrement{
    if(arc4random() % 2 == 1) {
        [self addProgress];
    }
}
//绘画圆3
-(void)SetprogressCircle{
    if(self.circleProgress){
        self.circleProgress = 0;
        if([randomTimer isValid]){
            [randomTimer invalidate];
        }
        [progressCircle removeFromSuperview];
        progressCircle = nil;
        //渐变
        progressCircle = [[VAProgressCircle alloc] initWithFrame:CGRectMake(118 *SJwidth - 15,220 *SJhight - 15, 140 *SJwidth  + 30,  140 *SJwidth + 30)];
        [progressCircle setColor:[UIColor whiteColor] withHighlightColor:[UIColor whiteColor] ];
        [progressCircle setTransitionColor:[UIColor whiteColor] withHighlightTransitionColor:[UIColor whiteColor]];
        progressCircle.transitionType = VAProgressCircleColorTransitionTypeGradual; //开启渐变色
        UITapGestureRecognizer *tapCircle = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(kaishijiasu)];
        progressCircle.userInteractionEnabled =YES;
        progressCircle.hidden = NO;
        [progressCircle addGestureRecognizer:tapCircle];
        [self.view addSubview:progressCircle];
    }
    randomTimer = [NSTimer scheduledTimerWithTimeInterval:0.06 target:self selector:@selector(randomIncrement) userInfo:nil repeats:YES];
}

//验证用户是否过期
-(void) UserToken{
    //续订 (过期需要登录页面)
    [NetworkApi UserRenew:^(NSError *error) {
        NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        if(errorData != nil){
            NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
            if ([serializedData[@"code"] integerValue] >= 400) {
                [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"aryaToken"];
                RigistViewController *sign = [RigistViewController new];
                [self presentViewController:sign animated:YES completion:nil];
                if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"UB判断连接"] isEqualToString:@"1"]) {
                    [hc handleConnectButtonPressed];
                }
            }
        }
    }];
}
@end
