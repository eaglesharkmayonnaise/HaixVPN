//
//  SSRLinesViewController.m
//  Potatso
//
//  Created by txb on 2017/10/27.
//  Copyright © 2017年 TouchingApp. All rights reserved.
//

#import "SSRLinesViewController.h"
#import "SSRLinesTableViewCell.h"
#import "UIImage+SVGManager.h"
#import "SVGKImage.h"

@interface SSRLinesViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIImageView *shadowImage;
@property(nonatomic,strong)NSIndexPath *lastPath;
@end

@implementation SSRLinesViewController{
    UITableView *tabelviewALL;
    NSDictionary *tabelviewALLdic;
    NSDictionary *Countrydic;
    NSArray  *stringArrayIP;
    HXHUD * hxhud;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.shadowImage.hidden = NO;
}

NSArray *allSubviews3(UIView *aView) {
    NSArray *results = [aView subviews];
    for (UIView *eachView in aView.subviews)
    {
        NSArray *subviews = allSubviews3(eachView);
        if (subviews)
            results = [results arrayByAddingObjectsFromArray:subviews];
    }
    return results;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //去掉导航栏黑线
    NSArray *subViews = allSubviews3(self.navigationController.navigationBar);
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
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.view.backgroundColor = ViewBackColor;
    
    UILabel *labeback = [[UILabel alloc]initWithFrame:CGRectMake(0,0 , kscreenw, 48)];
    labeback.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:labeback];
    
    //标题
    UILabel *labeBT = [[UILabel alloc]initWithFrame:CGRectMake(0,34*SJhight -10 , kscreenw, 48)];
    labeBT.text =@"Select Location";
    labeBT.textAlignment =1;
    labeBT.backgroundColor = [UIColor whiteColor];
    labeBT.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    [self.view addSubview:labeBT];
    
    // 自定义导航栏左侧按钮
    UIButton * leftBtn = [[UIButton alloc]init];
    leftBtn.frame = CGRectMake(18, 16 + 22, 20, 34);
    [leftBtn setImage:[UIImage imageNamed:@"Black_back_icon"]  forState:0];
    [leftBtn addTarget:self action:@selector(closeview) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftBtn];
    
    //背景
    UIView *labeBK = [[UIView alloc] initWithFrame:CGRectMake(0, 83.5 *SJhight, kscreenw, 57)];
    labeBK.backgroundColor = [UIColor whiteColor];
    [[self view] addSubview:labeBK];
    
    //Global-mode
    UILabel *textGlobal = [[UILabel alloc] initWithFrame:CGRectMake(20, 103*SJhight, 199, 18)];
    textGlobal.textColor = [UIColor colorWithRed:0.22 green:0.27 blue:0.34 alpha:1];
    textGlobal.text = @"Global-mode";
    textGlobal.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
    [[self view] addSubview:textGlobal];
    
    //开关选择
    UISwitch *switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(kscreenw/375 * 304,kscreenh/667 *96.5, 51, 30)];
    [switchButton setOn:YES];
    [switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:switchButton];
    
    //Global-mode info
    UILabel *Globalinfo = [[UILabel alloc] initWithFrame:CGRectMake(20 , 150 *SJhight, kscreenw - 40, 80*SJhight)];
    Globalinfo.textColor = [UIColor colorWithRed:0.5 green:0.55 blue:0.65 alpha:1];
    Globalinfo.numberOfLines = 0;
    Globalinfo.text = @"Global-mode is when you’re using both apps prohibited  and allowed in China will go through proxy mode, normally it is not recommended, because it will slow those allowed apps down.  ";
    Globalinfo.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    [[self view] addSubview:Globalinfo];
    
    //SELECT LOCATION
    UILabel *textSELECT = [[UILabel alloc] initWithFrame:CGRectMake(20, 254 *SJhight, 250, 18)];
    textSELECT.textColor = [UIColor colorWithRed:0.22 green:0.27 blue:0.34 alpha:1];
    textSELECT.text = @"SELECT LOCATION";
    textSELECT.font= [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    [[self view] addSubview:textSELECT];
    
    //RetestUILabel
    UIButton * buttonRetest = [[UIButton alloc]initWithFrame:CGRectMake(312 *SJwidth, 254 *SJhight, 50, 20)];
    [buttonRetest setTitle:@"Retest" forState:0];
    [buttonRetest setTitleColor:[UIColor colorWithRed:0.46 green:0.59 blue:1 alpha:1] forState:0];
    [buttonRetest addTarget:self action:@selector(Retest) forControlEvents:UIControlEventTouchUpInside];
    buttonRetest.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    [[self view] addSubview:buttonRetest];
    
    
    //Package套餐
    tabelviewALL  = [[UITableView alloc]initWithFrame:CGRectMake(0,textSELECT.frame.size.height + textSELECT.frame.origin.y + 15, kscreenw,kscreenh - 260 *SJhight)];
    tabelviewALL.delegate =self;
    tabelviewALL.dataSource = self;
    tabelviewALL.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tabelviewALL.separatorColor = ViewBackColor;
    [self.view addSubview:tabelviewALL];
    tabelviewALL.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tabelviewALL.separatorColor = [UIColor colorWithRed:0.89 green:0.93 blue:0.96 alpha:1];
    [self setExtraCellLineHidden:tabelviewALL];
    
    //默认选第一行
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"当前选择的线路"] == nil){
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"当前选择的线路"];
    }
    
    //获取ss配置
    [NetworkApi Getusernodes:nil anddic:nil block:^(NSDictionary *responseObject) {
        [LCProgressHUD hide];
        
        Countrydic =  [[NSUserDefaults standardUserDefaults] valueForKey:@"CountryMap.json"][@"country"];
        if (Countrydic == nil) {
            //下载国家地址
            [NetworkApi DownLoadCountryMapjson];
            return ;
        }
        tabelviewALLdic = responseObject;
        [tabelviewALL reloadData];
        
        if (![[tabelviewALLdic allKeys]  containsObject: @"hostname"]){
            return;
        }
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSMutableArray * arrip = [[NSMutableArray alloc]init];
            for (NSDictionary * dicip in responseObject[@"data"][@"nodes"]) {
                [arrip addObject:[NSString stringWithFormat:@"%@",dicip[@"hostname"]]];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                //回调或者说是通知主线程刷新，
                [JFPingManager getFastestAddressWithAddressList:[arrip copy] finished:^(NSString * addresses) {
                    stringArrayIP = [addresses componentsSeparatedByString:@"-"];
                    NSLog(@"address:%@",stringArrayIP);
                     [tabelviewALL reloadData];
                }];
            });
        });
        
    } block:^(NSError *error) {
        [AppEnvironment ShowErrorLoading:error];
    }];
    
    
    // Do any additional setup after loading the view.
}

-(void)switchAction:(UISwitch *)sender{
    sender.selected = !sender.selected;
}

-(void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [tabelviewALLdic[@"data"][@"nodes"] count] + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //这里最好不要声明int类型的，个人建议
    NSInteger newRow = [indexPath row];
    static NSString *identifier = @"Cell";
    SSRLinesTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[SSRLinesTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
//    NSInteger oldRow = (self .lastPath !=nil)?[self .lastPath row]:-1;
//    if (newRow != oldRow) {
//        SSRLinesTableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
//        newCell.CountrySelcet.image = [UIImage imageNamed:@"tick"];
//        SSRLinesTableViewCell *oldCell = [tableView cellForRowAtIndexPath:_lastPath];
//        oldCell.CountrySelcet.image = [UIImage imageNamed:@""];
//        self .lastPath = indexPath;
//    }
    
    //已到期
    if ([[AppEnvironment UserInfodic][@"data"][@"plan"][@"remain"] intValue] == 0) {
        [self closeview];
        [AppEnvironment ShowInfosView:@"过期"];
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",newRow] forKey:@"当前选择的线路"];
    [tabelviewALL reloadData];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        for (NSDictionary * dicip in tabelviewALLdic[@"data"][@"nodes"]) {
            if ([dicip[@"hostname"] isEqualToString:stringArrayIP[0]]) {
                 [[NSUserDefaults standardUserDefaults] setObject:dicip forKey:@"AryaLineConfiguration"];
            }
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:@"Automatic" forKey:@"当前用户选择的国家"];
    }
    else{
        //点击获取线路配置
        [[NSUserDefaults standardUserDefaults] setObject:tabelviewALLdic[@"data"][@"nodes"][indexPath.row - 1] forKey:@"AryaLineConfiguration"];
        [[NSUserDefaults standardUserDefaults] setObject:cell.Country.text forKey:@"当前用户选择的国家"];
    }
    
     [self closeview];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger row = indexPath.row;
    static NSString *identifier = @"Cell";
     SSRLinesTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[SSRLinesTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    //用户选择线路
    NSInteger oldRow = [_lastPath row];
    NSInteger m = [[[NSUserDefaults standardUserDefaults] valueForKey:@"当前选择的线路"] integerValue];
    if (row == oldRow && _lastPath!=nil) {
        //这个是系统中对勾的那种选择框
        cell.CountrySelcet.image = [UIImage imageNamed:@"tick"];
    }else{
        cell.CountrySelcet.image = [UIImage imageNamed:@""];
        if(row == m){
            cell.CountrySelcet.image = [UIImage imageNamed:@"tick"];
        }
    }
    
    [cell.CountryDelay setHidden: YES];
    
    if (row == 0) {
        cell.CountryImage.image = [UIImage imageNamed:@"CountryMap"];
        cell.CountryImage.height = 18;
        cell.CountryImage.width = 26;
        cell.CountryImage.y = 16;
        cell.CountryImage.x = 49.3;
        cell.Country.text = @"Automatic";
        // 测速
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSMutableArray * arrip = [[NSMutableArray alloc]init];
            for (NSDictionary * dicip in tabelviewALLdic[@"data"][@"nodes"]) {
                [arrip addObject:[NSString stringWithFormat:@"%@",dicip[@"hostname"]]];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                //回调或者说是通知主线程刷新，
                [JFPingManager getFastestAddressWithAddressList:[arrip copy] finished:^(NSString * addresses) {
                    stringArrayIP = [addresses componentsSeparatedByString:@"-"];
                    [cell.CountryDelay setHidden: NO];
                    cell.CountryDelay.text = stringArrayIP[1];
                    [cell.LoadingWording stopAnimating];
                    
                    //已连接
                    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"UB判断连接"] isEqualToString:@"1"]) {
                        [cell.CountryDelay setHidden: NO];
                        [cell.LoadingWording stopAnimating];
                        int x = arc4random() % 100;
                        cell.CountryDelay.text = [NSString stringWithFormat:@"%dms",x];
                    }
                }];
            });
        });

    }else{
          for (NSString *dic in Countrydic) { // 要判断是否包
                if ([tabelviewALLdic[@"data"][@"nodes"][row - 1][@"country"] isEqualToString:dic]) {  // containsObject
                    cell.Country.text = [NSString stringWithFormat:@"%@ - %@",Countrydic[dic][@"name"],tabelviewALLdic[@"data"][@"nodes"][row - 1][@"region"]];
            }
        }
        if ([cell.Country.text hasPrefix:@"America"]) {
            cell.CountryImage.image = [UIImage imageNamed:@"America"];
        } else if ([cell.Country.text hasPrefix:@"Canada"]) {
            cell.CountryImage.image = [UIImage imageNamed:@"Canada"];
        } else if ([cell.Country.text hasPrefix:@"China"]) {
            cell.CountryImage.image = [UIImage imageNamed:@"China"];
        } else if ([cell.Country.text hasPrefix:@"HongKong"]) {
            cell.CountryImage.image = [UIImage imageNamed:@"HongKong"];
        } else if ([cell.Country.text hasPrefix:@"Japan"]) {
            cell.CountryImage.image = [UIImage imageNamed:@"Japan"];
        } else if ([cell.Country.text hasPrefix:@"Korea"]) {
            cell.CountryImage.image = [UIImage imageNamed:@"Korea"];
        } else if ([cell.Country.text hasPrefix:@"Philippines"]) {
            cell.CountryImage.image = [UIImage imageNamed:@"Philippines"];
        } else if ([cell.Country.text hasPrefix:@"Russian Federation"]) {
            cell.CountryImage.image = [UIImage imageNamed:@"Russian Federation"];
        } else if ([cell.Country.text hasPrefix:@"Singapore"]) {
            cell.CountryImage.image = [UIImage imageNamed:@"Singapore"];
        } else if ([cell.Country.text hasPrefix:@"United Kingdom"]) {
            cell.CountryImage.image = [UIImage imageNamed:@"United Kingdom"];
        }
        else{
            for (NSString *dic in Countrydic) { // 要判断是否包
                if ([tabelviewALLdic[@"data"][@"nodes"][row - 1][@"country"] isEqualToString:dic]) {  // containsObject
                    if (cell.CountryImage.image == nil) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            cell.CountryImage.image = [SVGKImage imageWithContentsOfURL:[NSURL URLWithString:[NSString removeSpaceAndNewline:Countrydic[dic][@"flagUrl"]]]].UIImage;
                        });
                    }
                }
            }
        }
    
        
        if ([[tabelviewALLdic[@"data"][@"nodes"][row-1] allKeys]  containsObject: @"hostname"]){
            [JFPingManager getFastestAddressWithAddressList: @[tabelviewALLdic[@"data"][@"nodes"][row-1][@"hostname"]] finished:^(NSString * addresses) {
                stringArrayIP = [addresses componentsSeparatedByString:@"-"];
                cell.CountryDelay.text = stringArrayIP[1];
                [cell.CountryDelay setHidden: NO];
                [cell.LoadingWording stopAnimating];
                
                //已连接
                if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"UB判断连接"] isEqualToString:@"1"]) {
                    [cell.CountryDelay setHidden: NO];
                    [cell.LoadingWording stopAnimating];
                    int x = arc4random() % 100;
                    cell.CountryDelay.text = [NSString stringWithFormat:@"%dms",x];
                }
            }];
        }
    }
    
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 4;
    cell.accessoryType=UITableViewCellAccessoryNone;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;//设置cell点击效果（无显示）
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//重新测试线路
-(void)Retest{
    [tabelviewALL reloadData];
}


-(void)closeview{
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
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
