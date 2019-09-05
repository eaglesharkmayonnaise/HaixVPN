//
//  AboutViewController.m
//  Potatso
//
//  Created by txb on 2017/10/20.
//  Copyright © 2017年 TouchingApp. All rights reserved.
//

#import "AboutViewController.h"
#import "TermofUseViewController.h"

@interface AboutViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIImageView *shadowImage;
@end

@implementation AboutViewController
{
    UITableView *tabelviewAbout;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.shadowImage.hidden = NO;
}

NSArray *allSubviews1(UIView *aView) {
    NSArray *results = [aView subviews];
    for (UIView *eachView in aView.subviews)
    {
        NSArray *subviews = allSubviews1(eachView);
        if (subviews)
            results = [results arrayByAddingObjectsFromArray:subviews];
    }
    return results;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //去掉导航栏黑线
    NSArray *subViews = allSubviews1(self.navigationController.navigationBar);
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
    labeBT.text =@"About";
    labeBT.font = [UIFont fontWithName:@"SourceSansPro-bold" size:34];
    [self.view addSubview:labeBT];
    
    //Package套餐
    tabelviewAbout  = [[UITableView alloc]initWithFrame:CGRectMake(20,labeBT.frame.size.height + labeBT.frame.origin.y + 20, kscreenw - 40,kscreenh - 130)];
    tabelviewAbout.delegate =self;
    tabelviewAbout.dataSource = self;
    tabelviewAbout.backgroundColor = ViewBackColor;
    [self.view addSubview:tabelviewAbout];
    tabelviewAbout.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self setExtraCellLineHidden:tabelviewAbout];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}


//分区之间的颜色
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = ViewBackColor;
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        WYWebController *Devices = [WYWebController new];
        Devices.url = @"http://help.aryamask.com/help";
        [self.navigationController pushViewController:Devices animated:YES];
    }
    if (indexPath.row == 1) {
        TermofUseViewController * termo = [TermofUseViewController new];
        [self.navigationController pushViewController:termo animated:YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger row = indexPath.row;
    static NSString *identifier = @"Cell";
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    NSArray *arr = @[@"Privacy Policy",@"Term of Use",@"Version 1.0.0"];
    cell.textLabel.text = arr[row];
    cell.textLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
    cell.textLabel.textColor = [UIColor colorWithRed:0.22 green:0.27 blue:0.34 alpha:1];
    if (row == 2) {
         NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        cell.textLabel.text = [NSString stringWithFormat:@"Version %@",[infoDic objectForKey:@"CFBundleShortVersionString"]];
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 4;
    cell.backgroundColor = ViewBackColor;
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;//设置cell点击效果（无显示）
    return cell;
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
