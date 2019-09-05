//
//  PurchaseViewController.m
//  Potatso
//
//  Created by txb on 2017/9/28.
//  Copyright © 2017年 TouchingApp. All rights reserved.
//

#import "PurchaseViewController.h"

@interface PurchaseViewController ()

@end

@implementation PurchaseViewController
{
    UILabel *lablenum;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];//    NSUserDefaults *shared = [[NSUserDefaults alloc]
}

-(void)closeview{
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Purchase";
    self.view.backgroundColor = makecolor(218, 218, 218);
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];

    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:0.22 green:0.27 blue:0.34 alpha:1],NSFontAttributeName:[UIFont fontWithName:@"SourceSansPro-bold" size:16]}];
    
    // 自定义导航栏左侧按钮
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 40, 40);;
    [leftBtn setImage:[UIImage imageNamed:@"Black_back_icon"]  forState:0];
    [leftBtn addTarget:self action:@selector(closeview) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    //当前套餐
    UILabel *textplan = [[UILabel alloc] initWithFrame:CGRectMake(20, 94 * SJhight -0, 300, 100)];
    textplan.numberOfLines = 0;
    textplan.font = [UIFont fontWithName:@"SourceSansPro-bold" size:24];
    textplan.textColor = [UIColor colorWithRed:0.22 green:0.27 blue:0.34 alpha:0.8];
    textplan.text = @"Your current plan is\n1 Month Plan";
    NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc]initWithString:textplan.text];
    [attributedString2 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(20, textplan.text.length -20)];
    textplan.attributedText = attributedString2;
    [[self view] addSubview:textplan];
    
    //套餐介绍
    UILabel *textplaninfo = [[UILabel alloc] initWithFrame:CGRectMake(20, 178 *SJhight -0, kscreenw -40, 196)];
    textplaninfo.lineBreakMode = NSLineBreakByWordWrapping;
    textplaninfo.numberOfLines = 0;
    textplaninfo.textColor = [UIColor colorWithRed:0.5 green:0.55 blue:0.65 alpha:1];
    NSString *textContent = @"Purchase more devices enable more your devices to access network in proxy mode at the same time.\n\nThe service duration of device quantities you purchase, as well as the amount you need to pay will automatically be adjusted to your current plan. ";
    textplaninfo.text = textContent;
    textplaninfo.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    [[self view] addSubview:textplaninfo];
    
    //套餐具体操作背景
    UIView *planlabelbj = [[UIView alloc] initWithFrame:CGRectMake(20, textplaninfo.frame.size.height + textplaninfo.frame.origin.y , kscreenw - 40, 93)];
    planlabelbj.layer.cornerRadius = 4;
    planlabelbj.backgroundColor = [UIColor whiteColor];
    planlabelbj.layer.shadowOffset = CGSizeMake(0, 2);
    planlabelbj.layer.shadowColor = [[UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:0.5] CGColor];
    planlabelbj.layer.shadowOpacity = 1;
    planlabelbj.layer.shadowRadius = 4;
    [[self view] addSubview:planlabelbj];
    
    // Device Quantity
    UILabel *textDevice = [[UILabel alloc] initWithFrame:CGRectMake(40, planlabelbj.frame.origin.y + 20, 150, 16)];
    textDevice.text = @"Device Quantity";
    textDevice.textColor = [UIColor colorWithRed:0.22 green:0.27 blue:0.34 alpha:0.8];
    textDevice.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    [[self view] addSubview:textDevice];
    
     // Amount
    UILabel *textAmount = [[UILabel alloc] initWithFrame:CGRectMake(271 *SJwidth, planlabelbj.frame.origin.y + 20, 80, 16)];
    textAmount.text = @"Amount";
    textAmount.textColor = [UIColor colorWithRed:0.22 green:0.27 blue:0.34 alpha:0.8];
    textAmount.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    [[self view] addSubview:textAmount];
   
    //数量lable
    lablenum= [[UILabel alloc] initWithFrame:CGRectMake(40, textDevice.frame.origin.y + textDevice.frame.size.height +20, 99, 24)];
    lablenum.font =  [UIFont fontWithName:@"SourceSansPro-bold" size:16];
    lablenum.text =@"1";
    lablenum.textAlignment =1;
    [[self view] addSubview:lablenum];
    
    // 减数量
    UIButton *btnLess = [[UIButton alloc] initWithFrame:CGRectMake(40, textDevice.frame.origin.y + textDevice.frame.size.height +20, 24, 24)];
    btnLess.backgroundColor = [UIColor colorWithRed:0.95 green:0.97 blue:1 alpha:1];
    btnLess.layer.cornerRadius = 12;
    btnLess.layer.masksToBounds =YES;
    [btnLess setTitle:@"-" forState:0];
    btnLess.tag =1;
    [btnLess setTitleColor:[UIColor blackColor] forState:0];
    [btnLess addTarget:self action:@selector(LessAddNum:) forControlEvents:UIControlEventTouchUpInside];
    btnLess.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btnLess.contentEdgeInsets = UIEdgeInsetsMake(-4,7, 0, 0);
    btnLess.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-bold" size:16];
    [[self view] addSubview:btnLess];
    
    // 加数量
    UIButton *btnAdd = [[UIButton alloc] initWithFrame:CGRectMake(115 *SJwidth, textDevice.frame.origin.y + textDevice.frame.size.height +20, 24, 24)];
    btnAdd.backgroundColor = [UIColor colorWithRed:0.46 green:0.59 blue:1 alpha:1];
    btnAdd.layer.cornerRadius = 12;
    btnAdd.layer.masksToBounds =YES;
    [btnAdd setTitle:@"+" forState:0];
    btnAdd.tag =2;
    [btnAdd setTitleColor:[UIColor whiteColor] forState:0];
    btnAdd.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btnAdd.contentEdgeInsets = UIEdgeInsetsMake(-4,7, 0, 0);
    [btnAdd addTarget:self action:@selector(LessAddNum:) forControlEvents:UIControlEventTouchUpInside];
    btnAdd.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-bold" size:16];
    [[self view] addSubview:btnAdd];
    
    //价格总量
    UILabel *textmoney = [[UILabel alloc] initWithFrame:CGRectMake(0, textDevice.frame.origin.y + textDevice.frame.size.height +20, kscreenw - 50, 16)];
    textmoney.textColor = [UIColor colorWithRed:0.22 green:0.27 blue:0.34 alpha:1];
    textmoney.text = @"¥10";
    textmoney.textAlignment =2;
    textmoney.font = [UIFont fontWithName:@"SourceSansPro-bold" size:16];
    [[self view] addSubview:textmoney];
    
    //底部购买背景
    UILabel *layerBuyBJ = [[UILabel alloc] initWithFrame:CGRectMake(0, kscreenh- 64 -0, kscreenw, 64)];
    layerBuyBJ.layer.shadowOffset = CGSizeMake(0, 2);
    layerBuyBJ.layer.shadowColor = [[UIColor colorWithRed:0.71 green:0.71 blue:0.71 alpha:0.5] CGColor];
    layerBuyBJ.layer.shadowOpacity = 1;
    layerBuyBJ.layer.shadowRadius = 8;
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0, 0, 375, 64);
    gradient.colors = @[	(id)[[UIColor colorWithRed:0.83 green:0.68 blue:1 alpha:1] CGColor],(id)[[UIColor colorWithRed:0.41 green:0.56 blue:1 alpha:1] CGColor]];
    gradient.locations = @[@(0), @(1)];
    gradient.startPoint = CGPointMake(1, 0);
    gradient.endPoint = CGPointMake(0, 0.67);
    [[layerBuyBJ layer] addSublayer:gradient];
    [self.view addSubview:layerBuyBJ];
    
    //当前套餐
    UILabel *labelmoney = [[UILabel alloc] initWithFrame:CGRectMake(20,layerBuyBJ.frame.origin.y + 15, 300, 32)];
    labelmoney.numberOfLines = 0;
    labelmoney.font = [UIFont fontWithName:@"SourceSansPro-bold" size:36];
    labelmoney.textColor = [UIColor whiteColor];
    labelmoney.text = @"¥10";
    NSMutableAttributedString *attributedString3 = [[NSMutableAttributedString alloc]initWithString:labelmoney.text];
    [attributedString3 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"SourceSansPro-bold" size:15] range:NSMakeRange(0, 1)];
    labelmoney.attributedText = attributedString3;
    [[self view] addSubview:labelmoney];
    
    //Details按钮
    UIButton *btnDetail = [[UIButton alloc] initWithFrame:CGRectMake(133*SJwidth - 10,layerBuyBJ.frame.origin.y + 25, 100, 18)];
    [btnDetail setTitle:@"Details" forState:0];
    [btnDetail setImage:[UIImage imageNamed:@"Whitedown"] forState:0];
    btnDetail.titleLabel.font = [UIFont systemFontOfSize:18.f];
    [btnDetail setTitleColor:[UIColor whiteColor] forState:0];
    btnDetail.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
    [btnDetail layoutButtonWithEdgeInsetsStyle: MKButtonEdgeInsetsStyleRight imageTitleSpace: 5];
    [self.view addSubview:btnDetail];

    //Checkout
    UIButton *btnCheckout = [[UIButton alloc] initWithFrame:CGRectMake(227 *SJwidth, layerBuyBJ.frame.origin.y +10, 128, 44)];
    btnCheckout.backgroundColor = [UIColor whiteColor];
    btnCheckout.layer.cornerRadius = 22;
    btnCheckout.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-bold" size:20];
    [btnCheckout setTitle:@"Checkout" forState:0];
    [btnCheckout addTarget:self action:@selector(Checkout) forControlEvents:UIControlEventTouchUpInside];
    [btnCheckout setTitleColor:[UIColor colorWithRed:0.46 green:0.59 blue:1 alpha:1] forState:0];
    [[self view] addSubview:btnCheckout];
    
    //
}

//去付款
-(void)Checkout{
    
}

-(void)LessAddNum:(UIButton *)btn{
    if (btn.tag ==1) {
        int num = [lablenum.text intValue];
        if (num == 1) {
            lablenum.text  = @"1";
            return;
        }
        lablenum.text = [NSString stringWithFormat:@"%d",(-- num)];
    }
    else{
        int num = [lablenum.text intValue];
        lablenum.text = [NSString stringWithFormat:@"%d",(++ num)];
    }
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
