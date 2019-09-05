//
//  VerificationcodeViewController.m
//  rabbit
//
//  Created by txb on 2017/6/14.
//  Copyright © 2017年 yicheng. All rights reserved.
//

#import "SignViewController.h"
#import "AFNetworking.h"
#import "ViewController.h"
#import <sys/utsname.h>
#import "EncryptAndEcode.h"
#import "NewUserLoginViewController.h"
#import "ForgetSetPwdViewController.h"
//#import "QNNetworkInfo.h"
@interface SignViewController ()<UITextFieldDelegate>

@end

@implementation SignViewController
{
    UITextField *textpwd;
    NSString *license;
    UIButton *btnYZM;
    
    UILabel *labenum1;
    UILabel *labenum2;
    UILabel *labenum3;
    UILabel *labenum4;
    UILabel *labenum5;
    UILabel *labenum6;
    UILabel *btnYZMcopytile ;
    NSString *infostr;
    int timeDJS;//记录倒计时时间
    CAGradientLayer *gradientLayer1;
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
    [LCProgressHUD showSuccess:@"获取验证码成功"];
    gradientLayer1 = [CAGradientLayer layer];
    gradientLayer1.frame = self.view.bounds;
    gradientLayer1.colors = @[(id)[UIColor colorWithRed:0.41 green:0.56 blue:1 alpha:1].CGColor,(id)[UIColor colorWithRed:0.83 green:0.68 blue:1 alpha:1].CGColor];
    gradientLayer1.locations = @[@(0.15f),@(0.9f)];
    gradientLayer1.startPoint = CGPointMake(0, 1);
    gradientLayer1.endPoint = CGPointMake(1, 0);
    [self.view.layer addSublayer:gradientLayer1];
    [self BackColor:@"主题色"];
    
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
    
    //验证码
    UILabel *labephonenum = [[UILabel alloc]initWithFrame:CGRectMake(0 , SJhight * 106, kscreenw, 30)];
    labephonenum.font = [UIFont fontWithName:@"SourceSansPro-bold" size:32];
    labephonenum.text = @"Verification Code";
    labephonenum.textColor = [UIColor whiteColor];
    labephonenum.textAlignment =1;
    [self.view addSubview:labephonenum];
    
    //验证码解释
    UILabel *labephoneinfo= [[UILabel alloc]initWithFrame:CGRectMake(20 , SJhight * 158, kscreenw -40, 60)];
    labephoneinfo.font = [UIFont fontWithName:@"SourceSansPro-bold" size:16];
    labephoneinfo.text = [NSString stringWithFormat:@"%@%@",@"Please type the verification code\n sent to ",self.PhoneNum];
    labephoneinfo.numberOfLines=2;
    labephoneinfo.textColor = [UIColor whiteColor];
    labephoneinfo.textAlignment =1;
    [self.view addSubview:labephoneinfo];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:labephoneinfo.text];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"SourceSansPro-bold" size:20.0] range:NSMakeRange([labephoneinfo.text length] - [self.PhoneNum length] , [self.PhoneNum length])];
    labephoneinfo.attributedText = str;
    
    
    textpwd = [[UITextField alloc]initWithFrame:CGRectMake(103/375.f * kscreenw,labephonenum.frame.origin.y + labephonenum.frame.size.height +50, kscreenw -40-80, 50)];
    [textpwd addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    textpwd.tintColor = [UIColor clearColor];
    textpwd.textColor = [UIColor clearColor];
    textpwd.delegate =self;
    textpwd.text =@"";
    [self.view addSubview:textpwd];
    textpwd.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    textpwd.font =[UIFont fontWithName:@"SourceSansPro-bold" size:30];
    [textpwd becomeFirstResponder];
    //弹出键盘的作用
    UIButton *UPToKeyboard  =[[UIButton alloc]initWithFrame:CGRectMake(0, 262/667.f * kscreenh -10, kscreenw, 100)];
    [UPToKeyboard addTarget:self action:@selector(TCKeyboard) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:UPToKeyboard];
    
    //验证码
    labenum1 = [[UILabel alloc]initWithFrame:CGRectMake(55/375.f * kscreenw,262/667.f * kscreenh -10,36, 64)];
    labenum1.text=@"";
    labenum1.layer.masksToBounds =YES;
    labenum1.layer.cornerRadius = 6;
    labenum1.textAlignment=1;
    labenum1.textColor = [UIColor whiteColor];
    labenum1.layer.borderWidth = 2;
    labenum1.layer.borderColor = RGBA_COLOR(255, 255, 255, 0.6).CGColor;
    labenum1.backgroundColor =RGBA_COLOR(255, 255, 255, 0.2);
    labenum1.font = [UIFont fontWithName:@"SourceSansPro-bold" size:40];
    [self.view addSubview:labenum1];
    
    labenum2 = [[UILabel alloc]initWithFrame:CGRectMake(101/375.f * kscreenw,262/667.f * kscreenh-10, 36, 64)];
    labenum2.text=@"";
    labenum2.layer.masksToBounds =YES;
    labenum2.layer.cornerRadius = 6;
    labenum2.textAlignment=1;
    labenum2.textColor = [UIColor whiteColor];
    labenum2.backgroundColor = RGBA_COLOR(255, 255, 255, 0.2);
    labenum2.font = [UIFont fontWithName:@"SourceSansPro-bold" size:40];
    [self.view addSubview:labenum2];
    
    labenum3 = [[UILabel alloc]initWithFrame:CGRectMake(147/375.f * kscreenw,262/667.f * kscreenh-10, 36, 64)];
    labenum3.text=@"";
    labenum3.layer.masksToBounds =YES;
    labenum3.layer.cornerRadius = 6;
    labenum3.textAlignment=1;
    labenum3.textColor = [UIColor whiteColor];
    labenum3.backgroundColor = RGBA_COLOR(255, 255, 255, 0.2);
    labenum3.font = [UIFont fontWithName:@"SourceSansPro-bold" size:40];
    [self.view addSubview:labenum3];
    
    labenum4 = [[UILabel alloc]initWithFrame:CGRectMake(193/375.f * kscreenw,262/667.f * kscreenh-10, 36, 64)];
    labenum4.text=@"";
    labenum4.layer.masksToBounds =YES;
    labenum4.layer.cornerRadius = 6;
    labenum4.textAlignment=1;
    labenum4.textColor = [UIColor whiteColor];
    labenum4.backgroundColor = RGBA_COLOR(255, 255, 255, 0.2);
    labenum4.font = [UIFont fontWithName:@"SourceSansPro-bold" size:40];
    [self.view addSubview:labenum4];
    
    labenum5 = [[UILabel alloc]initWithFrame:CGRectMake(239/375.f * kscreenw,262/667.f * kscreenh-10, 36, 64)];
    labenum5.text=@"";
    labenum5.layer.masksToBounds =YES;
    labenum5.layer.cornerRadius = 6;
    labenum5.textAlignment=1;
    labenum5.textColor = [UIColor whiteColor];
    labenum5.backgroundColor = RGBA_COLOR(255, 255, 255, 0.2);
    labenum5.font = [UIFont fontWithName:@"SourceSansPro-bold" size:40];
    [self.view addSubview:labenum5];
    
    labenum6 = [[UILabel alloc]initWithFrame:CGRectMake(285/375.f * kscreenw,262/667.f * kscreenh-10, 36, 64)];
    labenum6.text=@"";
    labenum6.layer.masksToBounds =YES;
    labenum6.layer.cornerRadius = 6;
    labenum6.textAlignment=1;
    labenum6.textColor = [UIColor whiteColor];
    labenum6.backgroundColor = RGBA_COLOR(255, 255, 255, 0.2);
    labenum6.font = [UIFont fontWithName:@"SourceSansPro-bold" size:40];
    [self.view addSubview:labenum6];
    
    btnYZM = [[UIButton alloc]initWithFrame:CGRectMake(0 , 342/667.f * kscreenh, kscreenw, 30)];
    btnYZM.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-regular" size:16];
    [btnYZM addTarget:self action:@selector(TryAgainCode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnYZM];
    
    btnYZMcopytile= [[UILabel alloc]initWithFrame:CGRectMake(0 , 342/667.f * kscreenh, kscreenw, 30)];
    btnYZMcopytile.font = [UIFont fontWithName:@"SourceSansPro-regular" size:16];
    btnYZMcopytile.textAlignment = 1;
    btnYZMcopytile.textColor = [UIColor whiteColor];
    btnYZMcopytile.hidden=YES;
    [self.view addSubview:btnYZMcopytile];
    
    //倒计时
    [self DaoJiShi];
    
    btnYZM.userInteractionEnabled=NO;
}


#pragma mark 键盘显示的监听方法
-(void)TCKeyboard{
    [textpwd becomeFirstResponder];
}


//验证验证码
-(void)loginVerification{
    
    [LCProgressHUD showLoading:@""];
    
    [self BackColor:@"背景淡蓝色"];
    
    [NetworkApi UserVerifyEmailCatcha:nil anddic:@{@"email":self.PhoneNum,@"captcha":textpwd.text} block:^(NSDictionary *responseObject) {
        
        [LCProgressHUD  hide];
        
        [self BackColor:@"背景主题色"];
        
        if ([self.IsRegister isEqualToString:@"NO"]) {
            ForgetSetPwdViewController *forget = [ForgetSetPwdViewController new];
            forget.PhoneNum = self.PhoneNum;
            [self presentViewController:forget animated:YES completion:nil];
            return ;
        }
        
        ForgetSetPwdViewController * setup =  [ForgetSetPwdViewController new];
        setup.PhoneNum = self.PhoneNum;
        [self presentViewController:setup animated:YES completion:nil];
        
    } block:^(NSError *error) {
        
        [self BackColor:@"背景警告色"];
        
        [LCProgressHUD  hide];
        
        NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        if(errorData != nil){
            NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
            btnYZMcopytile.text = [NSString stringWithFormat:@"%@",serializedData[@"msg"]];
            btnYZMcopytile.hidden =NO;
            btnYZM.hidden = YES;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                btnYZMcopytile.hidden =YES;
                btnYZM.hidden = NO;
            });
        }
    }];
}


-(void)DaoJiShi
{
    __block NSInteger time = 60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
   dispatch_source_t timerCountdown = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(timerCountdown,DISPATCH_TIME_NOW,1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(timerCountdown, ^{
        
        if(time <= 0 ){ //倒计时结束，关闭
            
            dispatch_source_cancel(timerCountdown);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [btnYZM setTitle:@"Resend" forState:0];
                [btnYZM setTitleColor:[UIColor whiteColor] forState:0];
                btnYZM.userInteractionEnabled=YES;
            });
            
        }else{
            
            int seconds = time % 60;
            timeDJS= seconds;
            dispatch_async(dispatch_get_main_queue(), ^{
                [btnYZM setTitleColor:[UIColor whiteColor] forState:0];
                //倒计时 读秒
                [btnYZM setTitle:[NSString stringWithFormat:@"%@ (%d s)",infostr,seconds] forState:0];
                if(seconds==0){
                    [btnYZM setTitle:[NSString stringWithFormat:@"%@ (%d s)",infostr,60]forState:0];
                }
            });
            
            time--;
        }
    });
    
    dispatch_resume(timerCountdown);
}

//重新获取验证码
-(void)TryAgainCode{
    
    [LCProgressHUD showLoading:nil];
    
    [NetworkApi UsersendVerify:nil anddic:@{@"email":[NSString removeSpaceAndNewline:self.PhoneNum]} block:^(NSDictionary *responseObject) {
        [LCProgressHUD  hide];
        [self DaoJiShi];
    } block:^(NSError *error) {
       [LCProgressHUD  hide];
        
        NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        if(errorData != nil){
            NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
            btnYZMcopytile.text = [NSString stringWithFormat:@"%@",serializedData[@"msg"]];
            btnYZMcopytile.hidden =NO;
            btnYZM.hidden = YES;
            
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
               btnYZMcopytile.hidden =YES;
                btnYZM.hidden = NO;
            });
        }
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


- (void) textFieldDidChange:(id) sender {
    NSString *codestr = textpwd.text;
    [self BackColor:@"背景主题色"];
    if(textpwd.text.length==0){
        textpwd.text=nil;
        labenum1.text=@"";
        labenum1.layer.borderWidth =2;
        labenum1.layer.borderColor = RGBA_COLOR(255, 255, 255, 0.6).CGColor;;
        labenum2.text=@"";
        labenum2.layer.borderWidth =0;
        labenum3.text=@"";
        labenum3.layer.borderWidth =0;
        labenum4.text=@"";
        labenum4.layer.borderWidth =0;
        labenum5.text=@"";
        labenum5.layer.borderWidth =0;
        labenum6.text=@"";
        labenum6.layer.borderWidth =0;
    }
    if(textpwd.text.length==1){
        labenum1.text=codestr;;
        labenum1.layer.borderWidth =0;
        labenum2.text=@"";
        labenum2.layer.borderWidth =2;
        labenum2.layer.borderColor = RGBA_COLOR(255, 255, 255, 0.6).CGColor;;
        labenum3.text=@"";
        labenum3.layer.borderWidth =0;
        labenum4.text=@"";
        labenum4.layer.borderWidth =0;
        labenum5.text=@"";
        labenum5.layer.borderWidth =0;
        labenum6.text=@"";
        labenum6.layer.borderWidth =0;
        
    }
    if(textpwd.text.length==2){
        labenum1.text=[codestr substringWithRange:NSMakeRange(textpwd.text.length-2,1)];;
        labenum1.layer.borderWidth =0;
        labenum2.text=[codestr substringWithRange:NSMakeRange(textpwd.text.length-1,1)];;
        labenum2.layer.borderWidth =0;
        labenum3.text=@"";
        labenum3.layer.borderWidth =2;
        labenum3.layer.borderColor = RGBA_COLOR(255, 255, 255, 0.6).CGColor;;
        labenum4.text=@"";
        labenum4.layer.borderWidth =0;
        labenum5.text=@"";
        labenum5.layer.borderWidth =0;
        labenum6.text=@"";
        labenum6.layer.borderWidth =0;
    }
    if(textpwd.text.length==3){
        labenum1.text=[codestr substringWithRange:NSMakeRange(textpwd.text.length-3,1)];;
        labenum1.layer.borderWidth =0;
        labenum2.text=[codestr substringWithRange:NSMakeRange(textpwd.text.length-2,1)];;
        labenum2.layer.borderWidth =0;
        labenum3.text=[codestr substringWithRange:NSMakeRange(textpwd.text.length-1,1)];;
        labenum3.layer.borderWidth =0;
        labenum4.text=@"";
        labenum4.layer.borderWidth =2;
        labenum4.layer.borderColor = RGBA_COLOR(255, 255, 255, 0.6).CGColor;;
        labenum5.text=@"";
        labenum5.layer.borderWidth =0;
        labenum6.text=@"";
        labenum6.layer.borderWidth =0;
    }
    if(textpwd.text.length==4){
        labenum1.text=[codestr substringWithRange:NSMakeRange(textpwd.text.length-4,1)];;
        labenum1.layer.borderWidth =0;
        labenum2.text=[codestr substringWithRange:NSMakeRange(textpwd.text.length-3,1)];;
        labenum2.layer.borderWidth =0;
        labenum3.text=[codestr substringWithRange:NSMakeRange(textpwd.text.length-2,1)];;
        labenum3.layer.borderWidth =0;
        labenum4.text=[codestr substringWithRange:NSMakeRange(textpwd.text.length-1,1)];;
        labenum4.layer.borderWidth =0;
        labenum5.text=@"";
        labenum5.layer.borderWidth =2;
        labenum5.layer.borderColor = RGBA_COLOR(255, 255, 255, 0.6).CGColor;;
        labenum6.text=@"";
        labenum6.layer.borderWidth =0;
    }
    if(textpwd.text.length==5){
        labenum1.text=[codestr substringWithRange:NSMakeRange(textpwd.text.length-5,1)];;
        labenum1.layer.borderWidth =0;
        labenum2.text=[codestr substringWithRange:NSMakeRange(textpwd.text.length-4,1)];;
        labenum2.layer.borderWidth =0;
        labenum3.text=[codestr substringWithRange:NSMakeRange(textpwd.text.length-3,1)];;
        labenum3.layer.borderWidth =0;
        labenum4.text=[codestr substringWithRange:NSMakeRange(textpwd.text.length-2,1)];;
        labenum4.layer.borderWidth =0;
        labenum5.text=[codestr substringWithRange:NSMakeRange(textpwd.text.length-1,1)];;
        labenum5.layer.borderWidth =0;
        labenum6.text=@"";
        labenum6.layer.borderWidth =2;
        labenum6.layer.borderColor = RGBA_COLOR(255, 255, 255, 0.6).CGColor;;
    }
    if( textpwd.text.length==6)
    {
        labenum1.text=[codestr substringWithRange:NSMakeRange(textpwd.text.length-6,1)];;
        labenum1.layer.borderWidth =0;
        labenum2.text=[codestr substringWithRange:NSMakeRange(textpwd.text.length-5,1)];;
        labenum2.layer.borderWidth =0;
        labenum3.text=[codestr substringWithRange:NSMakeRange(textpwd.text.length-4,1)];;
        labenum3.layer.borderWidth =0;
        labenum4.text=[codestr substringWithRange:NSMakeRange(textpwd.text.length-3,1)];;
        labenum4.layer.borderWidth =0;
        labenum5.text=[codestr substringWithRange:NSMakeRange(textpwd.text.length-2,1)];;
        labenum5.layer.borderWidth =0;
        labenum6.text=[codestr substringWithRange:NSMakeRange(textpwd.text.length-1,1)];;
        labenum6.layer.borderWidth =0;
        
        if ([gradientLayer1.colors isEqual: @[(id)[[UIColor colorWithRed:0.17 green:0.81 blue:0.76 alpha:1] CGColor],(id)[[UIColor colorWithRed:0.46 green:0.59 blue:1 alpha:1] CGColor]]]) {
            [btnYZM setTitle:@"Verifying.." forState:0];
        }
        [self loginVerification];
    }
    
}

//清理所有
-(void)cleanall{
    
    [self BackColor:@"背景主题色"];
    textpwd.text=nil;
    labenum1.text=@"";
    labenum1.layer.borderWidth =2;
    labenum1.layer.borderColor = RGBA_COLOR(255, 255, 255, 0.6).CGColor;;
    labenum2.text=@"";
    labenum2.layer.borderWidth =0;
    labenum3.text=@"";
    labenum3.layer.borderWidth =0;
    labenum4.text=@"";
    labenum4.layer.borderWidth =0;
    labenum5.text=@"";
    labenum5.layer.borderWidth =0;
    labenum6.text=@"";
    labenum6.layer.borderWidth =0;
}


-(void)BackColor:(NSString *)str{
    
    if ([str isEqualToString:@"背景警告色"]) {
         gradientLayer1.colors = @[	(id)[[UIColor colorWithRed:1 green:0.73 blue:0.41 alpha:1] CGColor],	(id)[[UIColor colorWithRed:1 green:0.5 blue:0.55 alpha:1] CGColor]];
    }
    else if ([str isEqualToString:@"背景淡蓝色"]) {
       gradientLayer1.colors = @[(id)[[UIColor colorWithRed:0.17 green:0.81 blue:0.76 alpha:1] CGColor],(id)[[UIColor colorWithRed:0.46 green:0.59 blue:1 alpha:1] CGColor]];
    }
    else{
           gradientLayer1.colors = @[(id)[UIColor colorWithRed:0.83 green:0.68 blue:1 alpha:1].CGColor,(id)[UIColor colorWithRed:0.41 green:0.56 blue:1 alpha:1].CGColor];
    }
}

//限制位数
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == textpwd) {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 6){
            return NO;
        }
        return [AppEnvironment validateNumber:string];
    }
    
    return YES;
}



@end
