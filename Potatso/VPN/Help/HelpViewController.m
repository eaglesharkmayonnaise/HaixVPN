//
//  HelpViewController.m
//  Potatso
//
//  Created by txb on 2017/10/20.
//  Copyright © 2017年 TouchingApp. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()
@property (nonatomic, strong) UIImageView *shadowImage;
@end

@implementation HelpViewController

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.shadowImage.hidden = NO;
}

NSArray *allSubviews(UIView *aView) {
    NSArray *results = [aView subviews];
    for (UIView *eachView in aView.subviews)
    {
        NSArray *subviews = allSubviews(eachView);
        if (subviews)
            results = [results arrayByAddingObjectsFromArray:subviews];
    }
    return results;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //去掉导航栏黑线
    NSArray *subViews = allSubviews(self.navigationController.navigationBar);
    for (UIView *view in subViews) {
        if ([view isKindOfClass:[UIImageView class]] && view.bounds.size.height<1){
            //实践后发现系统的横线高度为0.333
            self.shadowImage =  (UIImageView *)view;
        }
    }
    self.shadowImage.hidden = YES;
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"幫助";
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

    //标题
    CGFloat statusBarH = [[UIApplication sharedApplication] statusBarFrame].size.height;
    UILabel *labeBT = [[UILabel alloc]initWithFrame:CGRectMake(25, statusBarH+50, 250, 48)];
    labeBT.text =@"FAQ";
    labeBT.font = [UIFont fontWithName:@"SourceSansPro-bold" size:24];
    [self.view addSubview:labeBT];
    
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, labeBT.frame.origin.y+55, kscreenw-50, 0)];
    [self.view addSubview:descLabel];
    
    descLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:17];
    descLabel.numberOfLines = 0;
    descLabel.text = @"1.若無法連接VPN：\n請試著將 app 手動關閉再重新開啟，在開啟畫面等待VPN載入完畢後再行操作；或是先登出帳號，再重新登入嘗試。\n\n2. 若遇上VPN已連接，但無法連上網路的狀況：\n連接VPN後，有時需要等待三至五分鐘才能正常連上網際網路；如果仍連不上，請關閉VPN連線，等待一分鐘再重新連接；若狀況持續的話，請將 app 手動關閉後再重新開啟，再進行連接。\n\n3. 購買後請等待收到確認信，並等候片刻即可繼續使用；若仍顯示尚未購買，請嘗試重新登入，或重新啟動 app。";
    [descLabel sizeToFit];
    
    ///这里的resultArray可以根据需求自己定义。
//    self.myResultArray = [NSMutableArray arrayWithArray:self.treeResultArray];
//    ///这里的tableView可以根据需求自己定义。
//    self.myTableView = self.treeTableView;
//    self.myTableView.frame = CGRectMake(0, labeBT.frame.size.height + labeBT.frame.origin.y , kscreenw, kscreenh - (labeBT.frame.size.height + labeBT.frame.origin.y-64) - 64);
//    [self setExtraCellLineHidden:self.myTableView];
    
    //联系我们
    UILabel *labeNT = [[UILabel alloc]initWithFrame:CGRectMake(0,kscreenh - 64, kscreenw, 48)];
    labeNT.text =@"Still need help? Contact us at\nsupport@aryaline.com ";
    labeNT.numberOfLines =0;
    labeNT.textAlignment = 1;
    labeNT.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
//    [self.view addSubview:labeNT];
}

//-(void)setExtraCellLineHidden: (UITableView *)tableView
//{
//    UIView *view = [UIView new];
//    view.backgroundColor = [UIColor clearColor];
//    [tableView setTableFooterView:view];
//}


#pragma mark - =================自己写的tableView================================
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return self.myResultArray.count;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    ///这里需要根据自己的resulArray数据结构重写父类了。
//    return [super tableView:tableView numberOfRowsInSection:section];
//}
//
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    return [super tableView:tableView viewForHeaderInSection:section];
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return [super tableView:tableView heightForHeaderInSection:section];
//}
//
//-(void)tapAction:(UIButton *)sender{
//
//    [super tapAction:sender];
//    [self.myTableView reloadSections:[NSIndexSet indexSetWithIndex:sender.tag] withRowAnimation:UITableViewRowAnimationFade];
//}
//
/////这个都没有执行。。。
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
//}
//
//
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)closeview
{
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
