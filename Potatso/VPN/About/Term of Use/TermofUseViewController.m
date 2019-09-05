//
//  TermofUseViewController.m
//  Potatso
//
//  Created by txb on 2017/10/25.
//  Copyright © 2017年 TouchingApp. All rights reserved.
//

#import "TermofUseViewController.h"

@interface TermofUseViewController ()
@property (nonatomic, strong) UIImageView *shadowImage;
@end

@implementation TermofUseViewController

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.shadowImage.hidden = NO;
}

NSArray *allSubviews2(UIView *aView) {
    NSArray *results = [aView subviews];
    for (UIView *eachView in aView.subviews)
    {
        NSArray *subviews = allSubviews2(eachView);
        if (subviews)
            results = [results arrayByAddingObjectsFromArray:subviews];
    }
    return results;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //去掉导航栏黑线
    NSArray *subViews = allSubviews2(self.navigationController.navigationBar);
    for (UIView *view in subViews) {
        if ([view isKindOfClass:[UIImageView class]] && view.bounds.size.height<1){
            //实践后发现系统的横线高度为0.333
            self.shadowImage =  (UIImageView *)view;
        }
    }
    self.shadowImage.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ViewBackColor;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    // 自定义导航栏左侧按钮
    UIButton * leftBtn = [[UIButton alloc]init];
    leftBtn.frame = CGRectMake(18, 16 + 22, 20, 34);
    [leftBtn setImage:[UIImage imageNamed:@"Black_back_icon"]  forState:0];
    [leftBtn addTarget:self action:@selector(closeview) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftBtn];
    
    //标题
    UILabel *labeBT = [[UILabel alloc]initWithFrame:CGRectMake(25,94*SJhight, 250, 48)];
    labeBT.text =@"My Plan";
    labeBT.font = [UIFont fontWithName:@"SourceSansPro-bold" size:34];
    [self.view addSubview:labeBT];

    UILabel *textinfo = [[UILabel alloc] initWithFrame:CGRectMake(20, 140 *SJhight + 10, kscreenw - 40, 420 *SJhight)];
    textinfo.numberOfLines = 0;
    textinfo.textColor = [UIColor colorWithRed:0.22 green:0.27 blue:0.34 alpha:1];
    NSString *textContent = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ";
    NSRange textRange = NSMakeRange(0, textContent.length);
    NSMutableAttributedString *textString = [[NSMutableAttributedString alloc] initWithString:textContent];
    UIFont *font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    [textString addAttribute:NSFontAttributeName value:font range:textRange];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 1.25;
    [textString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:textRange];
    textinfo.attributedText = textString;
    [textinfo sizeToFit];
    [[self view] addSubview:textinfo];
    // Do any additional setup after loading the view.
}

-(void)closeview
{
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
