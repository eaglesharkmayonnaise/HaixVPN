//
//  VerificationcodeViewController.m
//  rabbit
//
//  Created by txb on 2017/6/14.
//  Copyright © 2017年 yicheng. All rights reserved.
//

#import "NewUserLoginViewController.h"
#import "AFNetworking.h"
#import "ViewController.h"
#import "EncryptAndEcode.h"
#import "NewUserLoginViewController.h"
#import "ForgetSetPwdViewController.h"
//#import "QNNetworkInfo.h"
@interface NewUserLoginViewController ()<UITextFieldDelegate>

@end

@implementation NewUserLoginViewController
{
    UITextField *textpwd;
    NSString *license;
    UIButton *btnYZM;
    UILabel *labexian1 ;
    NSString *infostr;
    CAGradientLayer *gradientLayer1;
    HXHUD *hxhud ;
}

//禁止黏贴复制
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController) {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;//电池栏颜色白色
}

-(void)closenowview{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    infostr =@"Resend";
    gradientLayer1 = [CAGradientLayer layer];
    gradientLayer1.frame = self.view.bounds;
    gradientLayer1.colors = @[(id)[[UIColor colorWithRed:0.17 green:0.81 blue:0.76 alpha:1] CGColor],(id)[[UIColor colorWithRed:0.46 green:0.59 blue:1 alpha:1] CGColor]];
    gradientLayer1.locations = @[@(0.15f),@(0.9f)];
    gradientLayer1.startPoint = CGPointMake(0, 1);
    gradientLayer1.endPoint = CGPointMake(1, 0);
    [self.view.layer addSublayer:gradientLayer1];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //左上角按钮
    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(18, 32, 18, 16);
    if (kscreenw == 375) {//x
        menuBtn.frame = CGRectMake(18, 50, 24, 20);
    }
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"nac_icon_back_White"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(closenowview) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:menuBtn];
    
    //LOG IN
    UILabel *labephonenum = [[UILabel alloc]initWithFrame:CGRectMake(0 , SJhight * 106, kscreenw, 30)];
    labephonenum.font = [UIFont fontWithName:@"SourceSansPro-bold" size:32];
    labephonenum.text = @"LOG IN";
    labephonenum.textColor = [UIColor whiteColor];
    labephonenum.textAlignment =1;
    [self.view addSubview:labephonenum];
    
    //验证码解释
    UILabel *labephoneinfo= [[UILabel alloc]initWithFrame:CGRectMake(20 , SJhight * 158, kscreenw -40, 35)];
    labephoneinfo.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:16];
    labephoneinfo.text = @"Please enter the password to login";
    labephoneinfo.numberOfLines=0;
    labephoneinfo.textColor = [UIColor whiteColor];
    labephoneinfo.textAlignment =1;
    [self.view addSubview:labephoneinfo];
    
    
    textpwd = [[UITextField alloc]initWithFrame:CGRectMake(57 * SJwidth,   SJhight *280, kscreenw - 57 * SJwidth *2, 35)];
    textpwd.clearButtonMode = UITextFieldViewModeAlways;
    [textpwd addTarget:self action:@selector(textFieldDidEditing:) forControlEvents:UIControlEventEditingChanged];//输入空格监听
    [self.view addSubview:textpwd];
    textpwd.textColor = [UIColor whiteColor];
    textpwd.font =[UIFont fontWithName:@"SourceSansPro-bold" size:24];
    textpwd.text= @"";
    textpwd.placeholder = @"enter your password";
    [textpwd setValue:RGB_color(255, 255, 255, 0.3) forKeyPath:@"_placeholderLabel.textColor"];
    textpwd.delegate =self;
    textpwd.clearButtonMode = UITextFieldViewModeAlways;
    textpwd.autocorrectionType = UITextAutocorrectionTypeNo;
    textpwd.keyboardType = UIKeyboardTypeAlphabet;
    textpwd.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    UIView *layer1 = [[UIView alloc] initWithFrame:CGRectMake(56* SJwidth, textpwd.frame.origin.y + textpwd.frame.size.height,kscreenw - 56* SJwidth * 2, 2)];
    layer1.layer.borderWidth = 2;
    layer1.alpha = 0.6;
    layer1.layer.borderColor = [[UIColor whiteColor] CGColor];
    [[self view] addSubview:layer1];
    
    //forget password
    UIButton *labeForget= [[UIButton alloc]initWithFrame:CGRectMake(0 , layer1.frame.size.height + layer1.frame.origin.y + 20, kscreenw , 20)];
    labeForget.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:16];
    [labeForget addTarget:self action:@selector(labeForget) forControlEvents:UIControlEventTouchUpInside];
    [labeForget setTitle:@"Forget Passworld ?" forState:0];
    labeForget.alpha = 1.0;
    [self.view addSubview:labeForget];
    
    btnYZM = [[UIButton alloc]initWithFrame:CGRectMake(0 , labeForget.frame.size.height + labeForget.frame.origin.y + 20, kscreenw, 50)];
    btnYZM.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-bold" size:37];
    [btnYZM setTitle:@"LOG IN" forState:0];
    btnYZM.alpha = 0.3;
    [btnYZM addTarget:self action:@selector(loginNew) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnYZM];
    // Do any additional setup after loading the view.
}

-(void)textFieldDidEditing:(UITextField *)textField{
    if ([textField.text length] == 0) {
        btnYZM.alpha = 0.3;
        [self BackColor:@"背景淡蓝色"];
    }
    else{
        btnYZM.alpha = 1;
    }
}

//忘记密码
-(void)labeForget{
    
    //加载的点点大小
    hxhud = [[HXHUD alloc] initWithFrame:CGRectMake(kscreenw/2 -  56/2 , btnYZM.frame.origin.y + btnYZM.frame.size.height/2, kscreenw, 20)];
    [hxhud showWithOverlay:YES]; //调用hud并传入是否有背景层颜色
    [hxhud setHudColor:nil];
    [self.view addSubview:hxhud];
    btnYZM.hidden = YES;
    
    [NetworkApi UsersendVerify:nil anddic:@{@"email":[NSString removeSpaceAndNewline:self.PhoneNum]} block:^(NSDictionary *responseObject) {
        [LCProgressHUD  hide];
        [hxhud hide];
        btnYZM.hidden = NO;
        
        SignViewController *sign = [SignViewController new];
        sign.PhoneNum = self.PhoneNum;
        sign.IsRegister = @"NO";
        [self presentViewController:sign animated:YES completion:nil];
    } block:^(NSError *error) {
        btnYZM.hidden = NO;
        [hxhud hide];
        [AppEnvironment ShowErrorLoading:error];
    }];
}


//新用户的登录操作(设置完密码之后的登录)
-(void)loginNew{
    
    [self BackColor:@"背景淡蓝色"];
    //加载的点点大小
    hxhud = [[HXHUD alloc] initWithFrame:CGRectMake(kscreenw/2 -  56/2 , btnYZM.frame.origin.y + btnYZM.frame.size.height/2, kscreenw, 20)];
    [hxhud showWithOverlay:YES]; //调用hud并传入是否有背景层颜色
    [hxhud setHudColor:nil];
    [self.view addSubview:hxhud];
    btnYZM.hidden = YES;

    if (textpwd.text == nil) {
        return;
    }
    
    [NetworkApi UserloginNew:nil anddic:@{@"email":self.PhoneNum,@"password":[NSString stringWithFormat:@"%@",textpwd.text],@"serialNumber":[AppEnvironment getDeviceId]} block:^(NSDictionary *responseObject) {
        
        [LCProgressHUD  hide];
        [hxhud hide];
        btnYZM.hidden = NO;
        
        [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"plan"][@"endDateUnixTimestamp"]] forKey:@"UsernameExpired"];
        
        [[NSUserDefaults standardUserDefaults] setValue:self.PhoneNum forKey:@"UsernameSave"];
        
        [[NSUserDefaults standardUserDefaults] setValue:responseObject[@"data"][@"aryaToken"] forKey:@"aryaToken"];
        
        [[NSUserDefaults standardUserDefaults] setObject:responseObject forKey:@"LoginInfoResponse"];
        
        //获取ss配置
        [NetworkApi Getusernodes:nil anddic:nil block:^(NSDictionary *responseObject) {
            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"data"][@"nodes"][0] forKey:@"AryaLineConfiguration"];
        } block:^(NSError *error) {}];
        
        [self closeview];
        
    } block:^(NSError *error) {
        [self BackColor:@"背景警告色"];
        btnYZM.hidden = NO;
        [hxhud hide];
        [AppEnvironment ShowErrorLoading:error];
    }];
}


//返回到根视图
-(void)closeview
{
    UIViewController *vc = self;
    while (vc.presentingViewController) {
        vc = vc.presentingViewController;
    }
    [vc dismissViewControllerAnimated:YES completion:nil];
}


-(void)BackColor:(NSString *)str
{
    if ([str isEqualToString:@"背景警告色"]) {
        gradientLayer1.colors = @[(id)[[UIColor colorWithRed:1 green:0.73 blue:0.41 alpha:1] CGColor],    (id)[[UIColor colorWithRed:1 green:0.5 blue:0.55 alpha:1] CGColor]];
    }
    else if ([str isEqualToString:@"背景淡蓝色"]) {
        gradientLayer1.colors = @[(id)[[UIColor colorWithRed:0.17 green:0.81 blue:0.76 alpha:1] CGColor],(id)[[UIColor colorWithRed:0.46 green:0.59 blue:1 alpha:1] CGColor]];
    }
    else{
        gradientLayer1.colors = @[(id)[UIColor colorWithRed:0.83 green:0.68 blue:1 alpha:1].CGColor,(id)[UIColor colorWithRed:0.41 green:0.56 blue:1 alpha:1].CGColor];
    }
}


@end


