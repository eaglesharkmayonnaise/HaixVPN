//
//  RigistViewController.m
//  Potatso
//
//  Created by txb on 2017/9/14.
//  Copyright © 2017年 TouchingApp. All rights reserved.
//

#import "RigistViewController.h"
#import "SignViewController.h"
#import "NewUserLoginViewController.h"
#define NUM @"0123456789"
#define ALPHA @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
#define ALPHANUM @"@.ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

@interface RigistViewController ()<UITextFieldDelegate>

@end

@implementation RigistViewController{
    
    UITextField *textphone;
    NSInteger i;//定义全局变量;
    NSString *numP;
    UILabel* labedianji;
    UIButton *NextBtn;
    HXHUD *hxhud ;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;//电池栏颜色白色
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    CAGradientLayer *gradientLayer1 = [CAGradientLayer layer];
    gradientLayer1.frame = self.view.bounds;
    gradientLayer1.colors = @[(id)[UIColor colorWithRed:0.41 green:0.56 blue:1 alpha:1].CGColor,(id)[UIColor colorWithRed:0.83 green:0.68 blue:1 alpha:1].CGColor];
    gradientLayer1.locations = @[@(0.15f),@(0.9f)];
    gradientLayer1.startPoint = CGPointMake(0, 1);
    gradientLayer1.endPoint = CGPointMake(1, 0);
    [self.view.layer addSublayer:gradientLayer1];

    //手机号码
    UILabel *labephonenum = [[UILabel alloc]initWithFrame:CGRectMake(0 , SJhight * 106, kscreenw, 30)];
    labephonenum.font = [UIFont fontWithName:@"SourceSansPro-bold" size:32];
    labephonenum.text = @"LOG IN";
    labephonenum.textColor = [UIColor whiteColor];
    labephonenum.textAlignment =1;
    [self.view addSubview:labephonenum];
    
    //手机号码解释
    UILabel *labephoneinfo= [[UILabel alloc]initWithFrame:CGRectMake(20 , SJhight * 158, kscreenw -40, 35)];
    labephoneinfo.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:16.f];
    labephoneinfo.text = @"Please enter your email to login";
    labephoneinfo.numberOfLines=0;
    labephoneinfo.textColor = [UIColor whiteColor];
    labephoneinfo.textAlignment =1;
    [self.view addSubview:labephoneinfo];
    
    //具体号码UILabel *textLayer = [[UILabel alloc] initWithFrame:CGRectMake(57, 248, 58, 24)];
    textphone = [[UITextField alloc]initWithFrame:CGRectMake(57 * SJwidth, SJhight *245, kscreenw - 57 * SJwidth *2, 35)];
    //    [textphone addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    textphone.placeholder= @"E-mail";
    [textphone setValue:[UIFont fontWithName:@"SourceSansPro-bold" size:24] forKeyPath:@"_placeholderLabel.font"];
    [textphone setValue:RGB_color(255, 255, 255, 0.3) forKeyPath:@"_placeholderLabel.textColor"];
    textphone.clearButtonMode = UITextFieldViewModeAlways;
    [self.view addSubview:textphone];
    textphone.textColor = [UIColor whiteColor];
    textphone.font =[UIFont fontWithName:@"SourceSansPro-bold" size:24];
    textphone.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    textphone.autocorrectionType = UITextAutocorrectionTypeNo;
    textphone.keyboardType = UIKeyboardTypeASCIICapable;
    textphone.text= @"";
    textphone.delegate =self;
    textphone.autocorrectionType = UITextAutocorrectionTypeNo;
    textphone.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    i = 0;
    [textphone addTarget:self action:@selector(textFieldDidEditing:) forControlEvents:UIControlEventEditingChanged];
    
    UIView *layer1 = [[UIView alloc] initWithFrame:CGRectMake(56* SJwidth,textphone.frame.size.height + textphone.frame.origin.y ,kscreenw - 56* SJwidth * 2, 2)];
    layer1.layer.borderWidth = 1;
    layer1.layer.borderColor = [[UIColor whiteColor] CGColor];
    [[self view] addSubview:layer1];
    
    //下一步的按钮
    NextBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 324 *SJwidth, kscreenw -40, 44)];
    if (kscreenh == 812) {//x
        NextBtn.frame = CGRectMake(20, 324 *SJwidth + 60, kscreenw -40, 44);
    }
    NextBtn.layer.cornerRadius = 20;
    NextBtn.backgroundColor = [UIColor whiteColor];
    [NextBtn setTitleColor:[UIColor colorWithRed:0.46 green:0.59 blue:1 alpha:1] forState:0];
    [NextBtn setTitle:@"Next" forState:0];
    NextBtn.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:20];
    [NextBtn addTarget:self action:@selector(SendSMS) forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:NextBtn];
    
    labedianji  = [[UILabel alloc]initWithFrame:CGRectMake(0,kscreenh -50, kscreenw, 20)];
    labedianji.textColor = [UIColor whiteColor];
    labedianji.userInteractionEnabled =YES;
    labedianji.textAlignment=1;
    NSString *label_text2 = @"Login Agreements Compliance with Aryaline Privacy Policy";
    NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc]initWithString:label_text2];
    [attributedString2 addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(label_text2.length -14, 14)];
    [attributedString2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"SourceSansPro-bold" size:14] range:NSMakeRange(label_text2.length -14, 14)];
    [attributedString2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Regular" size:12] range:NSMakeRange(0, label_text2.length)];
    //下划线
    [attributedString2 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(label_text2.length -14, 14)];
    labedianji.attributedText = attributedString2;
    
    [labedianji yb_addAttributeTapActionWithStrings:@[@"Privacy Policy",@"service"] tapClicked:^(UILabel *label, NSString *string, NSRange range, NSInteger index) {
        
    }];
    
//    [labedianji yb_addAttributeTapActionWithStrings:@[@"Privacy Policy",@"service"] tapClicked:^(NSString *string, NSRange range, NSInteger index) {
//
////        [self presentViewController:sv animated:YES completion:nil];
//    }];
    
    //设置是否有点击效果，默认是YES
    labedianji.enabledTapEffect = NO;
    [self.view addSubview:labedianji];
    
    
    //监听键盘高度
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillChangeFrame:)name:UIKeyboardWillChangeFrameNotification object:nil];
    
    // Do any additional setup after loading the view.
}




//发送验证码
-(void)SendSMS{

    //加载的点点大小
    hxhud = [[HXHUD alloc] initWithFrame:CGRectMake(kscreenw/2 -  56/2 , NextBtn.frame.origin.y + NextBtn.frame.size.height/2, kscreenw, 20)];
    [hxhud showWithOverlay:YES]; //调用hud并传入是否有背景层颜色
    [hxhud setHudColor:nil];
    [self.view addSubview:hxhud];
    NextBtn.hidden = YES;
    
    [NetworkApi UserSendSMSandurl:[NSString removeSpaceAndNewline:textphone.text] anddic:nil block:^(NSDictionary *responseObject) {
        [LCProgressHUD  hide];
        [hxhud hide];
        NextBtn.hidden = NO;

        if ([[NSString stringWithFormat:@"%@",responseObject[@"data"][@"isRegister"]] isEqualToString:@"1"]) {
            [[NSUserDefaults standardUserDefaults] setValue:[NSString removeSpaceAndNewline:textphone.text] forKey:@"AppUsername"];
            NewUserLoginViewController * set = [NewUserLoginViewController new];
            set.PhoneNum = [NSString removeSpaceAndNewline:textphone.text];
            [self presentViewController:set animated:YES completion:nil];
            return ;
        }
        SignViewController *sign = [SignViewController new];
        sign.PhoneNum = [NSString removeSpaceAndNewline:textphone.text];
        sign.IsRegister =[NSString stringWithFormat:@"%@",responseObject[@"data"][@"isRegister"]];
        [self presentViewController:sign animated:YES completion:nil];
    } block:^(NSError *error) {
        NextBtn.hidden = NO;
        [hxhud hide];
        [AppEnvironment ShowErrorLoading:error];
    }];
}

//
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ALPHANUM] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return [string isEqualToString:filtered];
}


//添加号码空格和判断位数
-(void)textFieldDidEditing:(UITextField *)textField{
    
    if( textphone.text.length<=0){
        //动画抖动
        [AppEnvironment lockAnimationForView:textphone];
    }
}


//监听出的键盘高度
-(void)keyboardWillChangeFrame:(NSNotification*)notif{
    
    NSDictionary*userInfo = notif.userInfo;
    //动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView animateWithDuration:duration animations:^{
        if(self.view.frame.origin.y + self.view.frame.size.height== keyboardF.origin.y) {
            //键盘消失
            labedianji.frame = CGRectMake(0,kscreenh -50, kscreenw, 20);
        }else{
            labedianji.frame = CGRectMake(0,keyboardF.origin.y -30, kscreenw, 20);
            //键盘出现
        }
    }];
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
