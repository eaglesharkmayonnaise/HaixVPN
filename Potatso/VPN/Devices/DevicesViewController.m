//
//  DevicesViewController.m
//  Potatso
//
//  Created by txb on 2017/9/29.
//  Copyright © 2017年 TouchingApp. All rights reserved.
//

#import "DevicesViewController.h"
#import "WYTableViewCell.h"
#import "MGSwipeTableCell.h"
#import "SystemPurchaseViewController.h"
@interface DevicesViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation DevicesViewController{
    UITableView *tabelviewdevices;
    NSMutableArray *devicesarr;
}

//-(void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
//}

-(void)viewWillAppear:(BOOL)animated{
//   self.navigationController.navigationBar.translucent = NO;
   [self.navigationController setNavigationBarHidden:NO animated:YES];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"裝置";
    self.view.backgroundColor = makecolor(218, 218, 218);
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.22 green:0.27 blue:0.34 alpha:1],NSFontAttributeName:[UIFont fontWithName:@"SourceSansPro-bold" size:16]}];

    // 自定义导航栏左侧按钮
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 40, 40);;
    [leftBtn setImage:[UIImage imageNamed:@"Black_back_icon"]  forState:0];
    [leftBtn addTarget:self action:@selector(closeview) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
   
    //Auto switch
    UILabel *Autolabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 83.5 *SJhight -0, kscreenw, 57)];
    Autolabel.backgroundColor = [UIColor whiteColor];
    [[self view] addSubview:Autolabel];
    UILabel *Autoswitch = [[UILabel alloc] initWithFrame:CGRectMake(20, 104 *SJhight -0, 182, 16)];
    Autoswitch.text= @"Auto switch ";
    Autoswitch.textColor = [UIColor colorWithRed:0.22 green:0.27 blue:0.34 alpha:1];
    Autoswitch.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    [[self view] addSubview:Autoswitch];
    UISwitch *switchAuto = [[UISwitch alloc] initWithFrame:CGRectMake(304 *SJwidth, 96.5 *SJhight -0, 51, 31)];
    switchAuto.onTintColor = [UIColor colorWithRed:0.46 green:0.59 blue:1 alpha:1];
    switchAuto.tintColor = [UIColor whiteColor];
    [switchAuto setOn:YES];
    [switchAuto addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [[self view] addSubview:switchAuto];
    
    //devicesinfo
    UILabel *devicesinfolabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 150*SJhight -0, kscreenw -40, 80)];
    devicesinfolabel.text= @"Only 3 devices  are allowed online the same time for your current plan. Auto switch nables your devices switch automatically. ";
    devicesinfolabel.numberOfLines =0;
    devicesinfolabel.textColor = [UIColor colorWithRed:0.5 green:0.55 blue:0.65 alpha:1];;
    devicesinfolabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    [[self view] addSubview:devicesinfolabel];
    
    //devices(2/3)
    UILabel *deviceslabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 218*SJhight -0 +30, kscreenw -40, 20)];
    deviceslabel.text= @"DEVICES (2/3)";
    deviceslabel.numberOfLines =0;
    deviceslabel.textColor = [UIColor colorWithRed:0.22 green:0.27 blue:0.34 alpha:1];
    deviceslabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    [[self view] addSubview:deviceslabel];
    
    //devicestableview 暂时不要上面的部分
    tabelviewdevices  = [[UITableView alloc]initWithFrame:CGRectMake(0,20, kscreenw,kscreenh - 20)];
    tabelviewdevices.separatorColor = [UIColor colorWithRed:0.89 green:0.93 blue:0.96 alpha:1];;
    tabelviewdevices.delegate =self;
    tabelviewdevices.dataSource = self;
    tabelviewdevices.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tabelviewdevices.backgroundColor= makecolor(218, 218, 218);
    tabelviewdevices.tableFooterView=[[UIView alloc]init];
//    tabelviewdevices.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    [self.view addSubview:tabelviewdevices];
//    tabelviewdevices.separatorStyle = UITableViewCellSeparatorStyleNone;
    devicesarr = [[NSMutableArray alloc]init];
    [self loadNewData];
}


#pragma mark 下拉列表数刷新
-(void)loadNewData
{
    [LCProgressHUD showLoading:@""];
    [self HQInfo];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // 折叠中返回0 需要展示的行数
    return devicesarr.count;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"%@",[NSString stringWithFormat:@"第%ld组的第%ld个cell",(long)indexPath.section,(long)indexPath.row]);
}

//cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *const WYTableViewIdentifier = @"tableViewCell";
    WYTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WYTableViewIdentifier];
    if (!cell) {
        cell = [[WYTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:WYTableViewIdentifier];
    }
    cell.labeldevidesname.text = devicesarr[indexPath.row][@"deviceName"];
    cell.labeldevidesinfo.text = [NSString stringWithFormat:@"%@     %@",devicesarr[indexPath.row][@"netStatus"],[AppEnvironment UTCchangeDate: devicesarr[indexPath.row][@"lastLogin"]] ];
    if (indexPath.row == 1) {
        cell.labelpoint.backgroundColor =  [UIColor colorWithRed:0.5 green:0.55 blue:0.65 alpha:1];
    }
    cell.switchdevides.selected =YES;
    cell.switchdevides.hidden = YES;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone]; //（这种是没有点击后的阴影效果)
  
    //左滑垃圾桶
//#if !TEST_USE_MG_DELEGATE
//    cell.rightSwipeSettings.transition = MGSwipeTransition3D;
//    cell.rightButtons =@[ [MGSwipeButton buttonWithTitle:@"" icon:[UIImage imageNamed:@"垃圾桶"] backgroundColor:[UIColor colorWithRed:0.46 green:0.59 blue:1 alpha:1] padding:30 callback:^BOOL(MGSwipeTableCell * sender){
//        NSLog(@"Convenience callback received (left).");
//        return YES;
//    }]];
//#endif
    return cell;
}


//分区之间的距离
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20.0;//分区之间的距离
}

//分区之间的颜色
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = ViewBackColor;
    return headerView;
}




#pragma mark 获取设备列表
-(void)HQInfo{
    
    [NetworkApi UserGetDevice:nil anddic:nil block:^(NSDictionary *responseObject) {
        devicesarr = [[NSMutableArray alloc]initWithArray:responseObject[@"data"][@"devices"]];
        
        //Purchase
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"%ld/%@",devicesarr.count,responseObject[@"data"][@"maxDeviceQuantity"]] style:UIBarButtonItemStylePlain target:self action:nil]; //暂时没有动作
        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
        
        [tabelviewdevices reloadData];
        [LCProgressHUD hide];
        
    } block:^(NSError *error) {
        if(error == nil){
            [LCProgressHUD  hide];
            return ;
        }
        //获取错误信息
        NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        if(errorData != nil){
            NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
            [LCProgressHUD showFailure:[NSString stringWithFormat:@"%@",serializedData[@"msg"]]];
        }
        else{
            [LCProgressHUD  hide];
        }
    }];
}


//Auto switch处理
-(void)switchAction:(id)sender{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
    }else {
    }
}


//设备购买
-(void)Purchase{
    SystemPurchaseViewController * purchase = [SystemPurchaseViewController new];
    [self.navigationController pushViewController:purchase animated:YES];
}


-(void)closeview
{
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    //关闭抽屉模式
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    
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
