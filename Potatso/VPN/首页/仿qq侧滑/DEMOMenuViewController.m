//
//  DEMOMenuViewController.m
//  REFrostedViewControllerExample
//
//  Created by Roman Efimov on 9/18/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "DEMOMenuViewController.h"
#import "MyPlanViewController.h"
#import "DevicesViewController.h"
#import "CouponsViewController.h"
#import "InviteFriendsViewController.h"
#import "HelpViewController.h"
#import "AboutViewController.h"
#import "SignViewController.h"
#import "MyOrdersViewController.h"
#import "ServiceViewController.h"
@implementation DEMOMenuViewController{
    UILabel *UserExpired;
    UILabel *textUsername ;
    LYTableViewInfo *_tableViewInfo;
}


- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;//电池栏颜色白色
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"ShowShadowViewHide" object:@"0"]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"ShowShadowViewHide" object:@"1"]];
    textUsername.text =  [[NSUserDefaults standardUserDefaults] valueForKey:@"AppUsername"];
    UserExpired.text = [AppEnvironment UTCchangeDate:[[NSUserDefaults standardUserDefaults] valueForKey:@"UsernameExpired"]];;
    NSString *labeDayLeftstr = [NSString stringWithFormat:@"%@  Left",[AppEnvironment dateTimeDifferenceWithStartTime:[NSString stringWithFormat:@"%@",[AppEnvironment UserInfodic][@"data"][@"plan"][@"endDateUnixTimestamp"]]endTime:nil]];
    NSMutableString *attributedString2 = [[NSMutableString alloc]initWithString:labeDayLeftstr];
    NSRange rangeday = [labeDayLeftstr rangeOfString:@"Day"];//匹配得到的下标
    NSRange rangehrs = [labeDayLeftstr rangeOfString:@"Hrs"];
    NSRange rangeMin = [labeDayLeftstr rangeOfString:@"Min"];
    if (rangeday.location < 100 ) {
       [attributedString2 insertString:@" "atIndex:rangeday.location];
    }
    if (rangehrs.location < 100 ) {
        if (rangeday.location>100) {
            [attributedString2 insertString:@" "atIndex:rangehrs.location];
        }
        else{
            [attributedString2 insertString:@" "atIndex:rangehrs.location + 1];
        }
    }
    if (rangeMin.location < 100 ) {
        if (rangeday.location>100) {
            [attributedString2 insertString:@" "atIndex:rangeMin.location + 1];
        }
        else{
            [attributedString2 insertString:@" "atIndex:rangeMin.location + 2];
        }
    }
    
    UserExpired.text = attributedString2;
    
    if ([[AppEnvironment UserInfodic][@"data"][@"plan"][@"status"] isEqualToString:@"EXPIRED"]) {
        UserExpired.text = [AppEnvironment UserInfodic][@"data"][@"plan"][@"status"];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //清除缓存
//    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            [[SDImageCache sharedImageCache] clearMemory];
//            [[NSFileManager defaultManager] removeItemAtPath:[NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES)lastObject]error:nil];
//        }); }];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorColor = [UIColor colorWithRed:150/255.0f green:161/255.0f blue:177/255.0f alpha:1.0f];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.opaque = NO;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = ({
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,-20, kscreenw, kscreenh/667.f *144)];
        view;
    });
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,-80, kscreenw, kscreenh/667.f *144 + 60)];
    CAGradientLayer *gradientLayer1 = [CAGradientLayer layer];
    gradientLayer1.frame = view.bounds;
    gradientLayer1.colors = @[(id)[[UIColor colorWithRed:0.83 green:0.68 blue:1 alpha:1] CGColor],(id)[[UIColor colorWithRed:0.41 green:0.56 blue:1 alpha:1] CGColor]];
    gradientLayer1.locations = @[@(0), @(1)];
    gradientLayer1.startPoint = CGPointMake(1, 0);
    gradientLayer1.endPoint = CGPointMake(0, 0.67);
    [view.layer addSublayer:gradientLayer1];
    [self.view addSubview:view];
    
    //头像
    UIImageView *imageavatar = [[UIImageView alloc] initWithFrame:CGRectMake(25 *SJwidth - 5, 42*SJhight - 20, 64, 64)];
    imageavatar.image = [UIImage imageNamed:@"avatar"];
                

    imageavatar.layer.cornerRadius = imageavatar.frame.size.width/2;
    imageavatar.layer.masksToBounds = YES;
    [imageavatar sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.gravatar.com/avatar/%@?d=identicon",[AppEnvironment md5:[[NSUserDefaults standardUserDefaults] valueForKey:@"AppUsername"]]]] placeholderImage:[UIImage imageNamed:@"avatar"]];
    if ([[[AppEnvironment UserInfodic] allKeys] containsObject:@"avatar"]) {
        [imageavatar sd_setImageWithURL:[NSURL URLWithString:[AppEnvironment UserInfodic][@"data"][@"avatar"]] placeholderImage:[UIImage imageNamed:@"avatar"]];
    }
    [[self view] addSubview:imageavatar];
    
    
    //Username
    textUsername= [[UILabel alloc] initWithFrame:CGRectMake(105 *SJwidth - 5, 47 *SJhight - 20, 167 *SJhight, 20)];
    textUsername.textColor = [UIColor whiteColor];
    textUsername.text =  [[NSUserDefaults standardUserDefaults] valueForKey:@"AppUsername"];
    textUsername.font = [UIFont fontWithName:@"SourceSansPro-SemiBold" size:20];
    [[self view] addSubview:textUsername];
    
    
    //到期时间
    UserExpired = [[UILabel alloc] initWithFrame:CGRectMake(105*SJwidth - 5, 83 *SJhight - 20, 167 *SJhight, 14)];
    UserExpired.textColor = [UIColor whiteColor];
    UserExpired.alpha = 0.90;
    NSString *labeDayLeftstr = [NSString stringWithFormat:@"%@  Left",[AppEnvironment dateTimeDifferenceWithStartTime:[NSString stringWithFormat:@"%@",[AppEnvironment UserInfodic][@"data"][@"plan"][@"endDateUnixTimestamp"]]endTime:nil]];
    NSMutableString *attributedString2 = [[NSMutableString alloc]initWithString:labeDayLeftstr];
    NSRange rangeday = [labeDayLeftstr rangeOfString:@"Day"];//匹配得到的下标
    NSRange rangehrs = [labeDayLeftstr rangeOfString:@"Hrs"];
    NSRange rangeMin = [labeDayLeftstr rangeOfString:@"Min"];
    if (rangeday.location < 100 ) {
        [attributedString2 insertString:@" "atIndex:rangeday.location];
    }
    if (rangehrs.location < 100 ) {
        [attributedString2 insertString:@" "atIndex:rangehrs.location + 1];
    }
    if (rangeMin.location < 100 ) {
        [attributedString2 insertString:@" "atIndex:rangeMin.location + 2];
    }
    UserExpired.text = attributedString2;
    
    if ([[AppEnvironment UserInfodic][@"data"][@"plan"][@"status"] isEqualToString:@"EXPIRED"]) {
        UserExpired.text = [AppEnvironment UserInfodic][@"data"][@"plan"][@"status"];
    }
    UserExpired.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    [[self view] addSubview:UserExpired];

    
//    UILabel *labelWelcom1= [[UILabel alloc] initWithFrame:CGRectMake(0, 444 * SJhight + 56, kscreenw, 500)];
    UILabel *labelWelcom1= [[UILabel alloc] initWithFrame:CGRectMake(0, kscreenh*0.6, kscreenw, 25)];
    labelWelcom1.backgroundColor = makecolor(218, 218, 218);
    [self.view addSubview:labelWelcom1];
    
    //退出按钮
//    UILabel *labelExitBJ= [[UILabel alloc] initWithFrame:CGRectMake(0, 519.5 * SJhight - 16, kscreenw, 57)];
    UILabel *labelExitBJ= [[UILabel alloc] initWithFrame:CGRectMake(0, kscreenh*0.6+30, kscreenw, 57)];
    labelExitBJ.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:labelExitBJ];
    UIButton *btnExitBJ = [[UIButton alloc] initWithFrame:CGRectMake(25 *SJwidth, labelExitBJ.frame.origin.y + 10, 80, 36)];
    btnExitBJ.backgroundColor = [UIColor whiteColor];
    [btnExitBJ setTitle:@"登出" forState:0];
    [btnExitBJ addTarget:self action:@selector(LogOut) forControlEvents:UIControlEventTouchUpInside];
    [btnExitBJ setImage:[UIImage imageNamed:@"logout"] forState:0];
    btnExitBJ.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [btnExitBJ setTitleColor:[UIColor blackColor] forState:0];
    [btnExitBJ layoutButtonWithEdgeInsetsStyle: MKButtonEdgeInsetsStyleLeft imageTitleSpace: 15];
    [self.view addSubview:btnExitBJ];
    
    //backview
    UILabel *labelback2= [[UILabel alloc] initWithFrame:CGRectMake(0, btnExitBJ.frame.size.height + btnExitBJ.frame.origin.y, kscreenw, 200)];
    labelback2.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:labelback2];
    
    //版本号
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30,kscreenh*0.85, 0, 24)];
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    label.text = [NSString stringWithFormat:@"版本： %@",appVersion];
    label.font = [UIFont systemFontOfSize:14];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithRed:0.5 green:0.55 blue:0.65 alpha:1.0f];
    [label sizeToFit];
    label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [self.view addSubview:label];
    
}

-(void)LogOut{
    [LCProgressHUD showLoading:nil];
    
    //已连接变成未连接
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"UB判断连接"] isEqualToString:@"1"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Alreadygettheline" object:nil];
    }
    
    [NetworkApi UserLogOut:nil anddic:@{@"ARYATOKEN":[[NSUserDefaults standardUserDefaults] valueForKey:@"aryaToken"]} block:^(NSDictionary *responseObject) {
        [LCProgressHUD hide];
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"aryaToken"];
        dispatch_async(dispatch_get_main_queue(), ^{
            //当我们push成功之后，关闭我们的抽屉
            [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
                //设置打开抽屉模式为MMOpenDrawerGestureModeNone，也就是没有任何效果。
                [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
                RigistViewController *sign = [[RigistViewController alloc]init];
                [self presentViewController:sign animated:YES completion:nil];
            }];
        });
    } block:^(NSError *error) {
        [AppEnvironment ShowErrorLoading:error];
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"aryaToken"];
        dispatch_async(dispatch_get_main_queue(), ^{
            //当我们push成功之后，关闭我们的抽屉
            [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
                //设置打开抽屉模式为MMOpenDrawerGestureModeNone，也就是没有任何效果。
                [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
                RigistViewController *sign = [[RigistViewController alloc]init];
                [self presentViewController:sign animated:YES completion:nil];
            }];
        });
         }];
}

-(void)SignIn{
}


#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
//{
//    if (sectionIndex == 0)
//        return nil;
//    
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 34)];
//    view.backgroundColor = [UIColor colorWithRed:167/255.0f green:167/255.0f blue:167/255.0f alpha:0.6f];
//    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 0, 0)];
//    label.text = @"Friends Online";
//    label.font = [UIFont systemFontOfSize:15];
//    label.textColor = [UIColor whiteColor];
//    label.backgroundColor = [UIColor clearColor];
//    [label sizeToFit];
//    [view addSubview:label];
//    
//    return view;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex{
//    if (sectionIndex == 0)
        return 0;
    
    return 34;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ( indexPath.row == 0) {
        MyPlanViewController *MyPlanView = [[MyPlanViewController alloc] init];

        //拿到我们的LitterLCenterViewController，让它去push
        UINavigationController* nav = (UINavigationController*)self.mm_drawerController.centerViewController;
        [nav pushViewController:MyPlanView animated:NO];
        //当我们push成功之后，关闭我们的抽屉
        [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
            //设置打开抽屉模式为MMOpenDrawerGestureModeNone，也就是没有任何效果。
            [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
        }];
    }
    else if (indexPath.row == 1)
    {
        DevicesViewController * Devices = [DevicesViewController new];
        //拿到我们的LitterLCenterViewController，让它去push
        UINavigationController* nav = (UINavigationController*)self.mm_drawerController.centerViewController;
        [nav pushViewController:Devices animated:NO];
        //当我们push成功之后，关闭我们的抽屉
        [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
            //设置打开抽屉模式为MMOpenDrawerGestureModeNone，也就是没有任何效果。
            [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
        }];
    }
//    else if (indexPath.row == 2)
//    {
//        MyOrdersViewController *Devices = [MyOrdersViewController new];
//        [self.navigationController pushViewController:Devices animated:YES];
//
////        CouponsViewController * Devices = [CouponsViewController new]; // 邀请卡的页面
//        //拿到我们的LitterLCenterViewController，让它去push
//        UINavigationController* nav = (UINavigationController*)self.mm_drawerController.centerViewController;
//        [nav pushViewController:Devices animated:NO];
//        //当我们push成功之后，关闭我们的抽屉
//        [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
//            //设置打开抽屉模式为MMOpenDrawerGestureModeNone，也就是没有任何效果。
//            [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
//        }];
//    }
//    else if (indexPath.row == 3)
//    {
//        InviteFriendsViewController * Devices = [InviteFriendsViewController new];
//        //拿到我们的LitterLCenterViewController，让它去push
//        UINavigationController* nav = (UINavigationController*)self.mm_drawerController.centerViewController;
//        [nav pushViewController:Devices animated:NO];
//        //当我们push成功之后，关闭我们的抽屉
//        [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
//            //设置打开抽屉模式为MMOpenDrawerGestureModeNone，也就是没有任何效果。
//            [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
//        }];
//    }
    else if (indexPath.row == 2)
    {
        //加载网页
//        WYWebController *Devices = [WYWebController new];
//        Devices.url = @"https://www.haixvpn.com";
//        [self.navigationController pushViewController:Devices animated:YES];
        
//        NewHelpViewController *Devices = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NewHelpViewController"];
        
        HelpViewController * Devices = [HelpViewController new];
        //拿到我们的LitterLCenterViewController，让它去push
        UINavigationController* nav = (UINavigationController*)self.mm_drawerController.centerViewController;
        [nav pushViewController:Devices animated:NO];
        //当我们push成功之后，关闭我们的抽屉
        [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
            //设置打开抽屉模式为MMOpenDrawerGestureModeNone，也就是没有任何效果。
            [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
        }];
    }else if (indexPath.row == 3) {
        
        ServiceViewController *service = [ServiceViewController new];
        
        UINavigationController* nav = (UINavigationController*)self.mm_drawerController.centerViewController;
        [nav pushViewController:service animated:NO];
        
        [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
            [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
        }];
    }
//    else
//    {
//        WYWebController *Devices = [WYWebController new];
//        Devices.url = @"https://www.haixvpn.com/help";
//        [self.navigationController pushViewController:Devices animated:YES];
//
////        AboutViewController * Devices = [AboutViewController new];
//        //拿到我们的LitterLCenterViewController，让它去push
//        UINavigationController* nav = (UINavigationController*)self.mm_drawerController.centerViewController;
//        [nav pushViewController:Devices animated:NO];
//        //当我们push成功之后，关闭我们的抽屉
//        [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
//            //设置打开抽屉模式为MMOpenDrawerGestureModeNone，也就是没有任何效果。
//            [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
//        }];
//    }

}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 56;
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 2;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex{
    
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    NSArray *titles = @[@"我的方案", @"裝置", @"幫助", @"客服"];
//    cell.imageView.image = [UIImage imageNamed:titles[indexPath.row]];
    UIImage*icon = [UIImage imageNamed:titles[indexPath.row]];
    CGSize itemSize = CGSizeMake(24, 24);
    UIGraphicsBeginImageContextWithOptions(itemSize,NO,0.0);
    CGRect
    imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [icon drawInRect:imageRect];
    cell.imageView.image  = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    cell.textLabel.text = titles[indexPath.row];
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

@end
