//
//  AppDelegate.m
//  VPN
//
//  Created by Apple on 16/9/20.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "SAMKeychain.h"
#import "DEMOMenuViewController.h"
#import "MMDrawerController.h"
#import "PurchaseViewController.h"
#import "SystemPurchaseViewController.h"
@interface AppDelegate ()
/**
 *  属性
 */
@property(nonatomic,strong) MMDrawerController * drawerController;
@end

@implementation AppDelegate
#define Wscreen [UIScreen mainScreen].bounds.size.width
#define Hscreen [UIScreen mainScreen].bounds.size.height

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    //download proxylist
    [EncryptAndEcode downFileFromServerblock:nil errorblock:nil];
    
    //下载国家地址
    [NetworkApi DownLoadCountryMapjson];
    
    //去掉导航栏黑线
//    [[UINavigationBar appearance]  setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
//    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
//    [UINavigationBar appearance].barTintColor = [UIColor whiteColor];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.window.backgroundColor = [UIColor whiteColor];
    
    //1、初始化控制器
    UIViewController *centerVC = [[ViewController alloc]init];
    UIViewController *leftVC = [[DEMOMenuViewController alloc]init];
    UIViewController *rightVC = [[SystemPurchaseViewController alloc]init];
    
    //2、初始化导航控制器
    UINavigationController *centerNvaVC = [[UINavigationController alloc]initWithRootViewController:centerVC];
    UINavigationController *leftNvaVC = [[UINavigationController alloc]initWithRootViewController:leftVC];
    UINavigationController *rightNvaVC = [[UINavigationController alloc]initWithRootViewController:rightVC];
    
    //3、使用MMDrawerController
    self.drawerController = [[MMDrawerController alloc]initWithCenterViewController:centerNvaVC leftDrawerViewController:leftNvaVC rightDrawerViewController:nil];
    
    //设置抽屉视图VC阴影效果
    self.drawerController.showsShadow = NO;
    
    //4、设置打开/关闭抽屉的手势
    self.drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
    self.drawerController.closeDrawerGestureModeMask =MMCloseDrawerGestureModeAll;
    
    //5、设置左右两边抽屉显示的多少
    self.drawerController.maximumLeftDrawerWidth = 300.0;
    self.drawerController.maximumRightDrawerWidth = 300.0;
  
    //6、初始化窗口、设置根控制器、显示窗口
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.window setRootViewController:self.drawerController];
    [self.window makeKeyAndVisible];
    //设置按钮没有字体
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];

    
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    [[PWCoreSDK sharedInstance] handlePingbackURL:url];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
    [SAMKeychain setPassword:@"NO" forService:@"设置不可连" account:@"设置不可连"];
    // 保存
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.unblockmy.ios"];
    [shared setObject:@"不可连" forKey:@"设置可连or不可连"];
    [shared synchronize];
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    [SAMKeychain setPassword:@"NO" forService:@"设置不可连" account:@"设置不可连"];
    // 保存
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.unblockmy.ios"];
    [shared setObject:@"不可连" forKey:@"设置可连or不可连"];
    [shared synchronize];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    [SAMKeychain setPassword:@"NO" forService:@"设置不可连" account:@"设置不可连"];
    // 保存
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.unblockmy.ios"];
    [shared setObject:@"不可连" forKey:@"设置可连or不可连"];
    [shared synchronize];
    
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [SAMKeychain setPassword:@"NO" forService:@"设置不可连" account:@"设置不可连"];
    // 保存
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.unblockmy.ios"];
    [shared setObject:@"不可连" forKey:@"设置可连or不可连"];
    [shared synchronize];
    
    
}

@end
