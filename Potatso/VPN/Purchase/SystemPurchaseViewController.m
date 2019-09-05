//
//  PurchaseViewController.m
//  Potatso
//
//  Created by txb on 2017/10/10.
//  Copyright © 2017年 TouchingApp. All rights reserved.
//
#import "SystemPurchaseViewController.h"
#import "PurchaseTableViewCell.h"
#import "MyOrdersViewController.h"
#import "HeaderView.h"
#import "NewCouponViewController.h"
#import "DetailOrderViewController.h"
@interface SystemPurchaseViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableArray *sectionStatus;//开关状态
@property UITableView *tabelviewPackage;
@end

@implementation SystemPurchaseViewController{
    ZJAnimationPopView *popView;
    UIView *layerxian;//线
    UILabel *lablenum;
    UIActivityIndicatorView *LoadingWording;
    NSArray *MyplanArr;
    UILabel *labelmoney;
    UILabel *labeDiscountM;
    UILabel *labeTotalM ;
    UIImageView *imageLoading;
    UITextField *textcode;
    UILabel *labeTotalMoney;
}

-(void)viewWillAppear:(BOOL)animated{
    //    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ViewBackColor;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.22 green:0.27 blue:0.34 alpha:1],NSFontAttributeName:[UIFont fontWithName:@"SourceSansPro-bold" size:16]}];
    self.title= @"Purchase";
    
    // 自定义导航栏左侧按钮
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 40, 40);
    [leftBtn setImage:[UIImage imageNamed:@"Black_back_icon"]  forState:0];
    [leftBtn addTarget:self action:@selector(closeview) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    //My Orders
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Invoice" style:UIBarButtonItemStylePlain target:self action:@selector(MyOrders)];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    //UIScrollView背景
    UIScrollView * scrollView = [[UIScrollView alloc] init];
    scrollView.frame = CGRectMake(0, 0, kscreenw, kscreenh);//UIScrollView大小
    scrollView.backgroundColor = ViewBackColor;
    [self.view addSubview:scrollView];
    //自动调整宽高
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    
    //线
    layerxian = [[UIView alloc] initWithFrame:CGRectMake(20, 168.5 *SJhight -0 , kscreenw -40, 1)];
    layerxian.layer.borderWidth = 1;
    layerxian.layer.borderColor = [[UIColor colorWithRed:0.89 green:0.93 blue:0.96 alpha:1] CGColor];
    [scrollView addSubview:layerxian];
    
    //初始化tableview
    self.tabelviewPackage  = [[UITableView alloc]initWithFrame:CGRectMake(20,0, kscreenw - 40,85 * 3 + 40)];
    self.tabelviewPackage.delegate =self;
    self.tabelviewPackage.dataSource = self;
    self.tabelviewPackage.backgroundColor = ViewBackColor;
    self.tabelviewPackage.scrollEnabled = NO;
    [scrollView addSubview:self.tabelviewPackage];
    self.tabelviewPackage.separatorStyle = UITableViewCellSeparatorStyleNone;
    [AppEnvironment setExtraCellLineHidden:self.tabelviewPackage];
    [self tableView:self.tabelviewPackage didSelectRowAtIndexPath:[NSIndexPath indexPathForItem:ImageStr inSection:0]];
    
    //获取套餐详情
    [LCProgressHUD showLoading:@""];
    [NetworkApi Oderplans:nil anddic:nil block:^(NSDictionary *responseObject) {
    [LCProgressHUD hide];
        
    MyplanArr = responseObject[@"data"][@"planTypes"];
    self.tabelviewPackage.frame = CGRectMake(20,0, kscreenw - 40,85 * (MyplanArr.count) + 40 * (MyplanArr.count - 1));
    if (MyplanArr.count == 1) {
        self.tabelviewPackage.frame = CGRectMake(20,0, kscreenw - 40,85 * (MyplanArr.count) + 40 * (MyplanArr.count - 1) + 40);
    }
    [self.tabelviewPackage reloadData];
    
    //Subtital
    UILabel *labelSubtital =  [[UILabel alloc]initWithFrame:CGRectMake(0,self.tabelviewPackage.frame.origin.x + self.tabelviewPackage.frame.size.height - 10, 375 *SJwidth, 44)];
    labelSubtital.textColor = [UIColor colorWithRed:0.22 green:0.27 blue:0.34 alpha:1];
    labelSubtital.backgroundColor = [UIColor whiteColor];
    labelSubtital.text = @"        Subtital";
    labelSubtital.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:16];
    [scrollView addSubview:labelSubtital];
    
    //Subtital money
    labelmoney =  [[UILabel alloc]initWithFrame:CGRectMake(0,labelSubtital.frame.origin.y, 375 *SJwidth - 20, 44 )];
    labelmoney.textColor = [UIColor colorWithRed:0.22 green:0.27 blue:0.34 alpha:1];
    labelmoney.textAlignment = 2;
    labelmoney.text = [NSString stringWithFormat:@"%@ %@",MyplanArr[0][@"currencySymbol"],MyplanArr[0][@"price"]];//subtital价格
    labelmoney.backgroundColor = [UIColor clearColor];
    labelmoney.font = [UIFont fontWithName:@"SourceSansPro-Bold" size:16];
    [scrollView addSubview:labelmoney];
    
    //invitation code
    UILabel *labecode =  [[UILabel alloc]initWithFrame:CGRectMake(0,labelSubtital.frame.origin.y + labelSubtital.frame.size.height, 375 *SJwidth, 44)];
    labecode.textColor = [UIColor colorWithRed:0.22 green:0.27 blue:0.34 alpha:1];
    labecode.text = @"        invitation code";
    labecode.backgroundColor = [UIColor whiteColor];
    labecode.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:16];
    [scrollView addSubview:labecode];
    
    //invitation codetext
    textcode =  [[UITextField alloc]initWithFrame:CGRectMake(288 * SJwidth,labelSubtital.frame.origin.y + labelSubtital.frame.size.height + 5, 90, 20)];
    textcode.textColor = [UIColor colorWithRed:0.22 green:0.27 blue:0.34 alpha:1];
    textcode.backgroundColor = [UIColor whiteColor];
    textcode.clearButtonMode = UITextFieldViewModeAlways;
    textcode.delegate = self;
    textcode.font = [UIFont fontWithName:@"SourceSansPro-Bold" size:15];
    [textcode addTarget:self action:@selector(textFieldDidEditing:) forControlEvents:UIControlEventEditingChanged];
    [scrollView addSubview:textcode];
    
    //菊花转圈
    LoadingWording = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    LoadingWording.center = CGPointMake(100.0f, 100.0f);
    [LoadingWording setFrame:CGRectMake(288 * SJwidth - 20,labelSubtital.frame.origin.y + labelSubtital.frame.size.height + 15, 0, 0)];
    [scrollView addSubview:LoadingWording];
    LoadingWording.color = [UIColor colorWithRed:0.46 green:0.59 blue:1 alpha:1];
    [LoadingWording setHidesWhenStopped:YES]; //当旋转结束时隐藏
    
    //订单成功/失败
    imageLoading = [[UIImageView alloc]initWithFrame:CGRectMake(261 * SJwidth ,labelSubtital.frame.origin.y + labelSubtital.frame.size.height + 7, 18, 18)];
    imageLoading.hidden = YES;
    [scrollView addSubview:imageLoading];
    
    //黑色线
    UIView *layer = [[UIView alloc] initWithFrame:CGRectMake(285*SJwidth, textcode.frame.origin.y + textcode.frame.size.height, 70, 1)];
    layer.backgroundColor = [UIColor colorWithRed:0.22 green:0.27 blue:0.34 alpha:1];
    [scrollView addSubview:layer];
    
    //Discount
    UILabel *Discount =  [[UILabel alloc]initWithFrame:CGRectMake(0,labecode.frame.origin.y + labecode.frame.size.height, 375 *SJwidth, 44)];
    Discount.textColor = [UIColor colorWithRed:1 green:0.48 blue:0.52 alpha:1];
    Discount.text = @"        Discount";
    Discount.backgroundColor = [UIColor whiteColor];
    Discount.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:16];
    [scrollView addSubview:Discount];
    
    //Discount money
    labeDiscountM =  [[UILabel alloc]initWithFrame:CGRectMake(0,Discount.frame.origin.y, 375 *SJwidth - 20, 44 )];
    labeDiscountM.textColor = [UIColor colorWithRed:1 green:0.48 blue:0.52 alpha:1];
    labeDiscountM.text = [NSString stringWithFormat:@"- $ %@",MyplanArr[0][@"discount"]];;
    labeDiscountM.textAlignment = 2;
    labeDiscountM.backgroundColor = [UIColor clearColor];
    labeDiscountM.font = [UIFont fontWithName:@"SourceSansPro-Bold" size:16];
    [scrollView addSubview:labeDiscountM];
        
        
    //Discount
    UILabel *labelTotal =  [[UILabel alloc]initWithFrame:CGRectMake(0,Discount.frame.origin.y + Discount.frame.size.height, 375 *SJwidth, 44)];
    labelTotal.textColor = [UIColor colorWithRed:0.22 green:0.27 blue:0.34 alpha:1];
    labelTotal.text = @"        Total ";
    labelTotal.backgroundColor = [UIColor whiteColor];
    labelTotal.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:16];
    [scrollView addSubview:labelTotal];
    
    //Discount total money
    labeTotalM =  [[UILabel alloc]initWithFrame:CGRectMake(0,labelTotal.frame.origin.y, 375 *SJwidth - 20, 44 )];
    labeTotalM.textColor = [UIColor colorWithRed:0.22 green:0.27 blue:0.34 alpha:1];
    labeTotalM.text = [NSString stringWithFormat:@"$ %@",MyplanArr[0][@"total"]];
    labeTotalM.textAlignment = 2;
    labeTotalM.backgroundColor = [UIColor clearColor];
    labeTotalM.font = [UIFont fontWithName:@"SourceSansPro-Bold" size:16];
    [scrollView addSubview:labeTotalM];
    
    //Package info
    UILabel *textPackageinfo = [[UILabel alloc] initWithFrame:CGRectMake(20, labelTotal.frame.origin.y + labelTotal.frame.size.height + 50, 335 *SJwidth, 50)];
    textPackageinfo.numberOfLines = 0;
    textPackageinfo.textColor = [UIColor colorWithRed:0.5 green:0.55 blue:0.65 alpha:1];
    textPackageinfo.text = @"Each plan comes with unlimited bandwidth and 3 free devices for simultaneous use of a single account. You can purchase more devices if you need.";textPackageinfo.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:13];
    [scrollView addSubview:textPackageinfo];
    
    //底部背景
    UIView *bottomBK = [[UIView alloc] initWithFrame:CGRectMake(0, kscreenh - 64, kscreenw, 80)];
    bottomBK.layer.shadowOffset = CGSizeMake(0, 2);
    bottomBK.layer.shadowColor = [[UIColor colorWithRed:0.71 green:0.71 blue:0.71 alpha:0.5] CGColor];
    bottomBK.layer.shadowOpacity = 1;
    bottomBK.layer.shadowRadius = 8;
    CAGradientLayer *gradientbottomBK = [CAGradientLayer layer];
    gradientbottomBK.frame = CGRectMake(0, 0, kscreenh - 64, 80);
    gradientbottomBK.colors = @[(id)[[UIColor colorWithRed:0.83 green:0.68 blue:1 alpha:1] CGColor],(id)[[UIColor colorWithRed:0.41 green:0.56 blue:1 alpha:1] CGColor]];
    gradientbottomBK.locations = @[@(0), @(1)];
    gradientbottomBK.startPoint = CGPointMake(1, 0);
    gradientbottomBK.endPoint = CGPointMake(0, 0.67);
    [[bottomBK layer] addSublayer:gradientbottomBK];
    [[self view] addSubview:bottomBK];
    
    //付款总额
    labeTotalMoney = [[UILabel alloc] initWithFrame:CGRectMake(20, kscreenh - 64 + (64 - 32)/2, 300, 32)];
    labeTotalMoney.textColor = [UIColor whiteColor];
    labeTotalMoney.text = [NSString stringWithFormat:@"$ %@",MyplanArr[0][@"total"]];
    labeTotalMoney.font = [UIFont fontWithName:@"SourceSansPro-Bold" size:32];
    NSMutableAttributedString *attributedlabeTotalMoney = [[NSMutableAttributedString alloc]initWithString:labeTotalMoney.text];
    [attributedlabeTotalMoney addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"SourceSansPro-Bold" size:18] range:NSMakeRange(0, 1)];
    labeTotalMoney.attributedText = attributedlabeTotalMoney;
    [[self view] addSubview:labeTotalMoney];
    
    //付款按钮
    UIButton *PayBtn = [[UIButton alloc] initWithFrame:CGRectMake(227 *SJwidth, kscreenh - 64 + 10, 128, 44)];
    [PayBtn setTitle:@"Buy" forState:0];
    PayBtn.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-SemiBold" size:20];
    [PayBtn addTarget:self action:@selector(PayBuy) forControlEvents:UIControlEventTouchUpInside];
    [PayBtn setTitleColor:[UIColor colorWithRed:0.46 green:0.59 blue:1 alpha:1] forState:0];
    PayBtn.backgroundColor = [UIColor whiteColor];
    PayBtn.layer.masksToBounds = YES;
    PayBtn.layer.cornerRadius = 22;
    [[self view] addSubview:PayBtn];

     //滚动的大小
    scrollView.contentSize = CGSizeMake(kscreenw,textPackageinfo.frame.size.height +textPackageinfo.frame.origin.y + 120);
        
    } block:^(NSError *error) {
        [AppEnvironment ShowErrorLoading:error];
    }];

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textFieldShouldReturn:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到view上view可以换成任意一个控件的
    [scrollView addGestureRecognizer:tapGestureRecognizer];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textcode resignFirstResponder];
}

#pragma mark - 区视图

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return MyplanArr.count;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section{
    return 1;
}

//cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85;
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

static NSInteger ImageStr = 0;
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *const WYTableViewIdentifier = @"tableViewCell";
    PurchaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WYTableViewIdentifier];
    if (!cell) {
        cell = [[PurchaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:WYTableViewIdentifier];
    }
    ImageStr = indexPath.section; 

    labeTotalM.text = [NSString stringWithFormat:@"$ %@",MyplanArr[ImageStr][@"total"]];
    labelmoney.text = [NSString stringWithFormat:@"$ %@",MyplanArr[ImageStr][@"price"]];;
    labeDiscountM.text = [NSString stringWithFormat:@"- $ %@",MyplanArr[ImageStr][@"discount"]];;
    labeTotalMoney.text = labeTotalM.text ;//底部总价
    if (labeTotalMoney.text != nil) {
        NSMutableAttributedString *attributedlabeTotalMoney = [[NSMutableAttributedString alloc]initWithString:labeTotalMoney.text];
        [attributedlabeTotalMoney addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"SourceSansPro-Bold" size:18] range:NSMakeRange(0, 1)];
        labeTotalMoney.attributedText = attributedlabeTotalMoney;
    }
    textcode.text = @"";
    [tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *const WYTableViewIdentifier = @"tableViewCell";
    PurchaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WYTableViewIdentifier];
    if (!cell) {
        cell = [[PurchaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:WYTableViewIdentifier];
    }
    
    if (indexPath.section == 0) {
        cell.layer.borderColor = [UIColor colorWithRed:0.46 green:0.59 blue:1 alpha:1].CGColor;
        cell.layer.masksToBounds =YES;
        cell.layer.borderWidth = 1;
        cell.image$.hidden = NO;
        cell.lablRecommend.textColor = [UIColor whiteColor];
        if (ImageStr == 1 || ImageStr == 2 || ImageStr == 3 || ImageStr == 4) {
            cell.layer.borderWidth = 0;
            cell.image$.hidden = YES;
        }
    }else if (indexPath.section == 1) {
        cell.lablRecommend.hidden =YES;
        cell.lablRecommend.textColor = [UIColor whiteColor];
        cell.layerview.hidden = YES;
        cell.image$.hidden = YES;
        cell.layer.borderWidth = 0;
        if (ImageStr == 1) {
            cell.layer.borderColor = [UIColor colorWithRed:0.46 green:0.59 blue:1 alpha:1].CGColor;
            cell.layer.masksToBounds =YES;
            cell.layer.borderWidth = 1;
            cell.image$.hidden = NO;
        }
    }
    else if (indexPath.section == 2) {
        cell.lablRecommend.hidden =YES;
        cell.lablRecommend.textColor = [UIColor whiteColor];
        cell.layerview.hidden = YES;
        cell.image$.hidden = YES;
        cell.layer.borderWidth = 0;
        if (ImageStr == 2) {
            cell.layer.borderColor = [UIColor colorWithRed:0.46 green:0.59 blue:1 alpha:1].CGColor;
            cell.layer.masksToBounds =YES;
            cell.layer.borderWidth = 1;
            cell.image$.hidden = NO;
        }
    }
    else if (indexPath.section == 3) {
        cell.lablRecommend.hidden =YES;
        cell.lablRecommend.textColor = [UIColor whiteColor];
        cell.layerview.hidden = YES;
        cell.image$.hidden = YES;
        cell.layer.borderWidth = 0;
        if (ImageStr == 3) {
            cell.layer.borderColor = [UIColor colorWithRed:0.46 green:0.59 blue:1 alpha:1].CGColor;
            cell.layer.masksToBounds =YES;
            cell.layer.borderWidth = 1;
            cell.image$.hidden = NO;
        }
    }

    
    cell.labelYear.text = MyplanArr[indexPath.section][@"planName"];
    cell.lablePackage.text = MyplanArr[indexPath.section][@"priceEachDay"];
    cell.lableMoney.text = [NSString stringWithFormat:@"%@ %@",MyplanArr[indexPath.section][@"currencySymbol"],MyplanArr[indexPath.section][@"price"]];//tableview展示的价格
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc]initWithString:cell.lableMoney.text];
    [attributedString2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"SourceSansPro-Bold" size:16] range:NSMakeRange(0, 1)];
    cell.lableMoney.attributedText = attributedString2;
    
    cell.layer.cornerRadius = 5;
    cell.layer.masksToBounds = YES;
  
    return cell;
}

-(void)MyOrders{
    MyOrdersViewController *myorder = [MyOrdersViewController new];
    [self.navigationController pushViewController:myorder animated:YES];
}

-(void)closeview{
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Checkout
-(void)PayBuy{
    
    [LCProgressHUD showLoading:nil];
    
    [NetworkApi Createorder:nil anddic:@{@"planTypeID":MyplanArr[ImageStr][@"_id"],@"total":[NSString removeSpaceAndNewlinemoney:labeTotalM.text],@"invitedCode":textcode.text} block:^(NSDictionary *responseObject) {
        [LCProgressHUD hide];
        
        //去付款
        DetailOrderViewController *detailorder = [DetailOrderViewController new];
        detailorder.orderdic = responseObject;
        [self.navigationController pushViewController:detailorder animated:YES];
        
    } block:^(NSError *error) {
        [AppEnvironment ShowErrorLoading:error];
    }];
    
    return;
}


-(void)GotIt{
    [popView dismiss];
}


//输入折扣码
-(void)textFieldDidEditing:(UITextField *)textField{
    if( textField.text.length == 6){
        
        [LoadingWording startAnimating]; // 开始旋转
        [NetworkApi ValidinvitedCode:nil anddic:@{@"planTypeID":MyplanArr[ImageStr][@"_id"],@"invitedCode":textField.text} block:^(NSDictionary *responseObject) {
            
            [LoadingWording stopAnimating]; // 结束旋转
            textcode.text = textField.text;
            
            labelmoney.text = [NSString stringWithFormat:@"$ %@",MyplanArr[ImageStr][@"price"]];;
            labeDiscountM.text = [NSString stringWithFormat:@"- $ %@",responseObject[@"data"][@"order"][@"discount"]];
            labeTotalM.text = [NSString stringWithFormat:@"$ %@",responseObject[@"data"][@"order"][@"total"]];
            labeTotalMoney.text = labeTotalM.text;
            
            imageLoading.image = [UIImage imageNamed:@"订单成功"];
            imageLoading.hidden = NO;

        } block:^(NSError *error) {
            [AppEnvironment ShowErrorLoading:error];
            [LoadingWording stopAnimating];
            imageLoading.image = [UIImage imageNamed:@"订单失败"];
            imageLoading.hidden = NO;
        }];
    }
    if( textField.text.length == 0){
        [LoadingWording stopAnimating]; // 结束旋转
        imageLoading.image = [UIImage imageNamed:@""];
        imageLoading.hidden = YES;
    }
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
