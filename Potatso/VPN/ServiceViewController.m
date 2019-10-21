//
//  ServiceViewController.m
//  Potatso
//
//  Created by yilong wu on 2019/10/19.
//  Copyright © 2019 TouchingApp. All rights reserved.
//

#import "ServiceViewController.h"

@interface ServiceViewController ()

@end


#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

@implementation ServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"客服";
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.view.backgroundColor = makecolor(218, 218, 218);
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.22 green:0.27 blue:0.34 alpha:1],NSFontAttributeName:[UIFont fontWithName:@"SourceSansPro-bold" size:16]}];
    
    // 自定义导航栏左侧按钮
    UIButton * leftBtn = [[UIButton alloc]init];
    leftBtn.frame = CGRectMake(18, 16 + 22, 20, 34);
    [leftBtn setImage:[UIImage imageNamed:@"Black_back_icon"]  forState:0];
    [leftBtn addTarget:self action:@selector(closeview) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    CGFloat statusBarH = [[UIApplication sharedApplication] statusBarFrame].size.height;
    
    self.qrcodeImg = [UIImage imageNamed:@"img_download_qrcode"];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, statusBarH+60, SCREEN_WIDTH-40, SCREEN_WIDTH/10)];
    titleLabel.text = @"如需聯絡客服人員，請用wechat掃描下方QRCode或點擊圖片進行儲存再用wechat開啟喔!";
    titleLabel.numberOfLines = 0;
    titleLabel.font = [UIFont fontWithName:@"SourceSansPro-bold" size:14];
    [self.view addSubview:titleLabel];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, statusBarH+120, SCREEN_WIDTH-40, SCREEN_WIDTH-40)];
    [self.view addSubview:imgView];
    
    [imgView setImage:self.qrcodeImg];
    
    imgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(saveImg)];
    [imgView addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)saveImg {
    
    UIImageWriteToSavedPhotosAlbum(self.qrcodeImg, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    NSString *msg = @"";
    
    if (error) {
        msg = @"儲存出錯";
    }else{
        msg = @"儲存成功";
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"系統提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"確認",nil) style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)closeview{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
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
