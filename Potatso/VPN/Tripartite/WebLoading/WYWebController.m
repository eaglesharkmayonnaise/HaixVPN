//
//  WLWebController.m
//  WangliBank
//
//  Created by 王启镰 on 16/6/21.
//  Copyright © 2016年 iSoftstone infomation Technology (Group) Co.,Ltd. All rights reserved.
//

#import "WYWebController.h"
#import "WYWebProgressLayer.h"
#import "UIView+Frame.h"
#import "WLWebProgressLayer.h"

@interface WYWebController ()<UIWebViewDelegate>

@end

@implementation WYWebController
{
    UIWebView *_webView;
    WYWebProgressLayer *_progressLayer; ///< 网页加载进度条
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
}

- (void)setupUI {
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 94 - 60/2, kscreenw, kscreenh - 94 + 60/2)];
    _webView.delegate = self;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [_webView loadRequest:request];
    
    _webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_webView];
    
    // 自定义导航栏左侧按钮
    UIButton * leftBtn = [[UIButton alloc]init];
    leftBtn.frame = CGRectMake(18, 34, 20, 34);
    [leftBtn setImage:[UIImage imageNamed:@"Black_back_icon"]  forState:0];
    [leftBtn addTarget:self action:@selector(closeview) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftBtn];
}


-(void)closeview{
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    _progressLayer = [WYWebProgressLayer layerWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 2)];
    [self.view.layer addSublayer:_progressLayer];
    [_progressLayer startLoad];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [_progressLayer finishedLoad];
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [_progressLayer finishedLoad];
}

- (void)dealloc {
    NSLog(@"i am dealloc");
}

@end
