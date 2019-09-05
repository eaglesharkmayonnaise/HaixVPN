//
//  MyOrdersViewController.m
//  Potatso
//
//  Created by txb on 2017/10/11.
//  Copyright © 2017年 TouchingApp. All rights reserved.
//

#import "MyOrdersViewController.h"
#import "MyOrdersTableViewCell.h"
#import "MDMultipleSegmentView.h"
#import "MDFlipCollectionView.h"
#import "MyOrdersAllViewController.h"
#import "MyOrderCompletedViewController.h"
#import "MyOrdersPendingViewController.h"
#import "DetailOrderViewController.h"
@interface MyOrdersViewController ()<MDMultipleSegmentViewDeletegate,
MDFlipCollectionViewDelegate>
{
    MDMultipleSegmentView *_segView;
    MDFlipCollectionView *_collectView;
    MyOrdersAllViewController *MyOrdersAll;
}

@end

@implementation MyOrdersViewController{
    
    UITableView *tabelviewPackage;
    UIButton *couponbtn;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title= @"Invoice";
    self.view.backgroundColor = ViewBackColor;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.22 green:0.27 blue:0.34 alpha:1],NSFontAttributeName:[UIFont fontWithName:@"SourceSansPro-bold" size:16]}];
    
    // 自定义导航栏左侧按钮
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 40, 40);;
    [leftBtn setImage:[UIImage imageNamed:@"Black_back_icon"]  forState:0];
    [leftBtn addTarget:self action:@selector(closeview) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
//   
//    //创建返回按钮
//    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//    leftBtn.frame = CGRectMake(0, 0, 25,25);
//    [leftBtn setBackgroundImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
//    [leftBtn addTarget:self action:@selector(closeview) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem * leftBarBtn = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];;
//    //创建UIBarButtonSystemItemFixedSpace
//    UIBarButtonItem * spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//    //将宽度设为负值
//    spaceItem.width = 15;
//    //将两个BarButtonItem都返回给NavigationItem
//    self.navigationItem.leftBarButtonItems = @[spaceItem,leftBarBtn];
    

    //My Orders
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _segView = [[MDMultipleSegmentView alloc] init];
    _segView.delegate =  self;
    _segView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 44);
    _segView.items = @[@"ALL",@"Paid", @"Unpaid"];
    [self.view addSubview:_segView];
    
    NSArray *arr = @[[self MyOrders], [self MyOrderCompleted],[self MyOrdersPending]];//设计师更换，把MyOrderCompleted改为unpaid  MyOrdersPending改为paid
    
    _collectView = [[MDFlipCollectionView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(_segView.frame), CGRectGetWidth(_segView.frame), CGRectGetHeight(self.view.bounds) - CGRectGetMaxY(_segView.frame)) withArray:arr];
    _collectView.delegate = self;
    [self.view addSubview:_collectView];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DetailOrder:) name:@"pushtoMYorderdetail" object:nil];
}

-(void)DetailOrder:(NSNotification *)notification{
    DetailOrderViewController *other=[[DetailOrderViewController alloc]init];
    other.orderdic = [notification object];
    [self.navigationController pushViewController:other animated:YES];
}

-(void)MyOrdersView{
    DetailOrderViewController *detail = [DetailOrderViewController new];
    [self.navigationController pushViewController:detail animated:YES];
}

- (UIView *)MyOrders
{
    MyOrdersAllViewController *vc = [[MyOrdersAllViewController alloc] init];
    return vc;
}

- (UIView *)MyOrderCompleted
{
    MyOrderCompletedViewController *vc = [[MyOrderCompletedViewController alloc] init];
    return vc;
}

- (UIView *)MyOrdersPending
{
    MyOrdersPendingViewController *vc = [[MyOrdersPendingViewController alloc] init];
    return vc;
}

- (void)changeSegmentAtIndex:(NSInteger)index
{
    [_collectView selectIndex:index];
}


- (void)flipToIndex:(NSInteger)index
{
    [_segView selectIndex:index];
}


-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}


-(void)closeview{
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
