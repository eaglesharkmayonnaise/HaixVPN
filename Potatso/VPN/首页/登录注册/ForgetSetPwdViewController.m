//
//  VerificationcodeViewController.m
//  rabbit
//
//  Created by txb on 2017/6/14.
//  Copyright © 2017年 yicheng. All rights reserved.
//

#import "ForgetSetPwdViewController.h"
#import "AFNetworking.h"
#import "ViewController.h"
#import "EncryptAndEcode.h"
#import "NewUserLoginViewController.h"
//#import "QNNetworkInfo.h"
@interface ForgetSetPwdViewController ()<UITextFieldDelegate>

@end

@implementation ForgetSetPwdViewController
{
    UITextField *textpwd;
    UITextField *textpwdRepeat;
    NSString *license;
    UIButton *btnYZM;
    UILabel *labexian1 ;
    NSString *infostr;
    CAGradientLayer *gradientLayer1;
    HXHUD *hxhud;
}

//禁止黏贴复制
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController) {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;
}

-(void)closenowview{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;//电池栏颜色白色
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    infostr =@"Setup Password";
    gradientLayer1 = [CAGradientLayer layer];
    gradientLayer1.frame = self.view.bounds;
    gradientLayer1.colors = @[(id)[[UIColor colorWithRed:0.17 green:0.81 blue:0.76 alpha:1] CGColor],(id)[[UIColor colorWithRed:0.46 green:0.59 blue:1 alpha:1] CGColor]];
    gradientLayer1.locations = @[@(0.15f),@(0.9f)];
    gradientLayer1.startPoint = CGPointMake(0, 1);
    gradientLayer1.endPoint = CGPointMake(1, 0);
    [self.view.layer addSublayer:gradientLayer1];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //验证码解释
    UILabel *labephoneinfo= [[UILabel alloc]initWithFrame:CGRectMake(20 , SJhight * 158, kscreenw -40, 35)];
    labephoneinfo.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:16];
    labephoneinfo.text = @"Please enter your new password for later login";
    labephoneinfo.numberOfLines=0;
    labephoneinfo.textColor = [UIColor whiteColor];
    labephoneinfo.textAlignment =1;
    [self.view addSubview:labephoneinfo];
    
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
    labephonenum.text = @"Setup Password";
    labephonenum.textColor = [UIColor whiteColor];
    labephonenum.textAlignment =1;
    [self.view addSubview:labephonenum];
    
    //设置密码
    textpwd = [[UITextField alloc]initWithFrame:CGRectMake(57 * SJwidth,   SJhight *225, kscreenw - 57 * SJwidth *2, 31)];
    textpwd.clearButtonMode = UITextFieldViewModeAlways;
    [textpwd addTarget:self action:@selector(textFieldDidEditing:) forControlEvents:UIControlEventEditingChanged];//输入空格监听
    [self.view addSubview:textpwd];
    textpwd.textColor = [UIColor whiteColor];
    textpwd.font =[UIFont fontWithName:@"SourceSansPro-bold" size:24];
    textpwd.delegate =self;
    textpwd.text= @"";
    textpwd.placeholder = @"password";
    [textpwd setValue:RGB_color(255, 255, 255, 0.3) forKeyPath:@"_placeholderLabel.textColor"];
    textpwd.delegate =self;
    textpwd.clearButtonMode = UITextFieldViewModeAlways;
    textpwd.keyboardType = UIKeyboardTypeAlphabet;
    textpwd.autocorrectionType = UITextAutocorrectionTypeNo;
    textpwd.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    UIView *layer1 = [[UIView alloc] initWithFrame:CGRectMake(56* SJwidth, SJhight *262,kscreenw - 56* SJwidth * 2, 2)];
    layer1.layer.borderWidth = 2;
    layer1.alpha = 0.6;
    layer1.layer.borderColor = [[UIColor whiteColor] CGColor];
    [[self view] addSubview:layer1];
    
    //设置密码
    textpwdRepeat = [[UITextField alloc]initWithFrame:CGRectMake(57 * SJwidth,   SJhight *285, kscreenw - 57 * SJwidth *2, 31)];
    textpwdRepeat.clearButtonMode = UITextFieldViewModeAlways;
    [textpwdRepeat addTarget:self action:@selector(textFieldDidEditing:) forControlEvents:UIControlEventEditingChanged];//输入空格监听
    [self.view addSubview:textpwdRepeat];
    textpwdRepeat.textColor = [UIColor whiteColor];
    textpwdRepeat.delegate =self;
    textpwdRepeat.font =[UIFont fontWithName:@"SourceSansPro-bold" size:24];
    textpwdRepeat.text= @"";
    textpwdRepeat.placeholder = @"re-enter";
    [textpwdRepeat setValue:RGB_color(255, 255, 255, 0.3) forKeyPath:@"_placeholderLabel.textColor"];
    textpwdRepeat.delegate =self;
    textpwdRepeat.clearButtonMode = UITextFieldViewModeAlways;
    textpwdRepeat.keyboardType = UIKeyboardTypeAlphabet;
    textpwdRepeat.autocorrectionType = UITextAutocorrectionTypeNo;
    textpwdRepeat.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    UIView *layer2 = [[UIView alloc] initWithFrame:CGRectMake(56* SJwidth, SJhight *322,kscreenw - 56* SJwidth * 2, 2)];
    layer2.layer.borderWidth = 2;
    layer2.alpha = 0.6;
    layer2.layer.borderColor = [[UIColor whiteColor] CGColor];
    [[self view] addSubview:layer2];
    
    
    btnYZM = [[UIButton alloc]initWithFrame:CGRectMake(0 , SJhight *332, kscreenw, 50)];
    btnYZM.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-bold" size:37];
    [btnYZM setTitle:@"SIGN UP" forState:0];
    btnYZM.alpha = 0.6;
    [btnYZM addTarget:self action:@selector(loginAfterCode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnYZM];
    
    UILabel *WarningLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SJhight *386 , kscreenw, 16)];
    WarningLabel.lineBreakMode = NSLineBreakByWordWrapping;
    WarningLabel.numberOfLines = 0;
    WarningLabel.textColor = [UIColor whiteColor];
    WarningLabel.textAlignment = 1 ;
    WarningLabel.alpha = 0.30;
    WarningLabel.text = @"Must have more than 8 characters";
    WarningLabel.font = [UIFont fontWithName:@"SourceSansPro-Bold" size:16];
    [[self view] addSubview:WarningLabel];
    
    // Do any additional setup after loading the view.
}

-(void)textFieldDidEditing:(UITextField *)textField{
    if ([textField.text length] > 0) {
        [self BackColor:@"背景淡蓝色"];
    }
    if ([textField.text length] == 0) {
        btnYZM.alpha = 0.6;
    }
    else{
        btnYZM.alpha = 1;
    }
}


//重置密码
-(void)loginAfterCode{
    [self BackColor:@"背景淡蓝色"];
    if (textpwd.text == nil) {
        return;
    }
    if (![textpwd.text isEqualToString:textpwdRepeat.text]) {
        [LCProgressHUD showFailure:@"The password must same"];
        return;
    }
    
    //加载的点点大小
    hxhud = [[HXHUD alloc] initWithFrame:CGRectMake(kscreenw/2 -  56/2 , btnYZM.frame.origin.y + btnYZM.frame.size.height/2, kscreenw, 20)];
    [hxhud showWithOverlay:YES]; //调用hud并传入是否有背景层颜色
    [hxhud setHudColor:nil];
    [self.view addSubview:hxhud];
    btnYZM.hidden = YES;
    
    [NetworkApi UserloginAfterCode:nil anddic:@{@"email":self.PhoneNum,@"password":textpwd.text,@"serialNumber":[AppEnvironment getDeviceId]} block:^(NSDictionary *responseObject) {
        [LCProgressHUD  hide];
        [hxhud hide];
        btnYZM.hidden = NO;
        
        NewUserLoginViewController *SetPwd = [NewUserLoginViewController new];
        SetPwd.PhoneNum = self.PhoneNum;
        [self presentViewController:SetPwd animated:YES completion:nil];
        
    } block:^(NSError *error) {
        [self BackColor:@"背景警告色"];
        [hxhud hide];
        btnYZM.hidden = NO;
        [AppEnvironment ShowErrorLoading:error];
    }];

}

//返回到根视图
-(void)closeview{
    
    UIViewController *vc = self;
    while (vc.presentingViewController) {
        vc = vc.presentingViewController;
    }
    [vc dismissViewControllerAnimated:YES completion:nil];
}



-(void)BackColor:(NSString *)str{
    
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



