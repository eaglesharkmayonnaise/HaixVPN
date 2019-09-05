//
//  SJBBaseTreeListViewController.m
//  SJBTreeListTableView
//
//  Created by Buddy on 29/4/14.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "SJBBaseTreeListViewController.h"
#define kSectionHeaderHeight 50.0f
@interface SJBBaseTreeListViewController ()

@end

@implementation SJBBaseTreeListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.treeOpenArray = [NSMutableArray array];
        self.sectionListName = [NSString stringWithFormat:@"name"];
        self.rowListTitle = [NSString stringWithFormat:@"country"];
        self.rowListName = [NSString stringWithFormat:@"cityName"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    ///下面是所需要的数据结构。
    ///一个国家放两个城市。
    NSMutableDictionary *cityDict1 = [NSMutableDictionary dictionary];
    [cityDict1 setObject:@"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco." forKey:self.rowListName];
//    NSMutableDictionary *cityDict2 = [NSMutableDictionary dictionary];
//    [cityDict2 setObject:@"上海" forKey:self.rowListName];
//    NSMutableDictionary *cityDict3 = [NSMutableDictionary dictionary];
//    [cityDict3 setObject:@"广州" forKey:self.rowListName];
//    NSMutableDictionary *cityDict4 = [NSMutableDictionary dictionary];
//    [cityDict4 setObject:@"郑州" forKey:self.rowListName];
    
    NSMutableArray *country1 = [NSMutableArray arrayWithObjects:cityDict1, nil];
    NSMutableDictionary *countryDict1 = [NSMutableDictionary dictionaryWithObject:country1 forKey:self.rowListTitle];
    [countryDict1 setObject:@"Why cann’t connect？" forKey:self.sectionListName];
    
    ///另一个国家放令两个城市。
    NSMutableDictionary *cityDict21 = [NSMutableDictionary dictionary];
    [cityDict21 setObject:@"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco." forKey:self.rowListName];
    NSMutableArray *country2 = [NSMutableArray arrayWithObjects:cityDict21, nil];
    NSMutableDictionary *countryDict2 = [NSMutableDictionary dictionaryWithObject:country2 forKey:self.rowListTitle];
    [countryDict2 setObject:@"Lorem ipsum dolor sit amet？" forKey:self.sectionListName];
    
    //解释3
    NSMutableDictionary *info3 = [NSMutableDictionary dictionary];
    [info3 setObject:@"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco." forKey:self.rowListName];
    NSMutableArray *infoBT3 = [NSMutableArray arrayWithObjects:info3, nil];
    NSMutableDictionary *infoTitledic3 = [NSMutableDictionary dictionaryWithObject:infoBT3 forKey:self.rowListTitle];
    [infoTitledic3 setObject:@"Lorem ipsum dolor sit amet consectetur adipisicing elit, sed do ？" forKey:self.sectionListName];
    
    //解释4
    NSMutableDictionary *info4 = [NSMutableDictionary dictionary];
    [info4 setObject:@"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco." forKey:self.rowListName];
    NSMutableArray *infoBT4 = [NSMutableArray arrayWithObjects:info4, nil];
    NSMutableDictionary *infoTitledic4 = [NSMutableDictionary dictionaryWithObject:infoBT4 forKey:self.rowListTitle];
    [infoTitledic4 setObject:@"Quis nostrud exercitation ut aliquip ex ea commodo？" forKey:self.sectionListName];
    
    //解释5
    NSMutableDictionary *info5 = [NSMutableDictionary dictionary];
    [info5 setObject:@"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco." forKey:self.rowListName];
    NSMutableArray *infoBT5 = [NSMutableArray arrayWithObjects:info5, nil];
    NSMutableDictionary *infoTitledic5 = [NSMutableDictionary dictionaryWithObject:infoBT5 forKey:self.rowListTitle];
    [infoTitledic5 setObject:@"Quis nostrud exercitation ut aliquip ex ea commodo？" forKey:self.sectionListName];
    
    self.treeResultArray = [NSMutableArray arrayWithObjects:countryDict1,countryDict2,infoTitledic3,infoTitledic4, infoTitledic5,nil];
    
    ///原来下面几句都在viewDidLoad 里面，所以很卡。。。
    if (self.treeTableView==nil||self.treeTableView==NULL) {
        self.treeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-64) style:UITableViewStylePlain];
        self.treeTableView.delegate = self;
        self.treeTableView.dataSource = self;
        self.treeTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [self.view addSubview:self.treeTableView];
        if ([self.treeTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [self.treeTableView setSeparatorInset:UIEdgeInsetsZero];
        }
    }
}

#pragma mark - =================自己写的tableView================================

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.treeResultArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int tempNum = (int)[[self.treeResultArray[section]valueForKey:self.rowListTitle] count];
    NSString *tempSectionString = [NSString stringWithFormat:@"%ld",(long)section];
    if ([self.treeOpenArray containsObject:tempSectionString]) {
        return tempNum;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *tempV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 50)];
    tempV.backgroundColor = [UIColor whiteColor];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(16, 12, kscreenw - 60, 30)];
    if (section == 0 || section == 1) {
        tempV.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 50);
        label1.frame = CGRectMake(16, 12, kscreenw - 60, 30);
    }
    else{
        tempV.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 100);
        label1.frame = CGRectMake(16, tempV.frame.origin.y +12, kscreenw - 60, 100-24);
    }
    label1.textColor = [UIColor colorWithRed:0.22 green:0.27 blue:0.34 alpha:1];;
    label1.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
    label1.text = [self.treeResultArray[section] valueForKey:self.sectionListName];
    label1.numberOfLines =0;
    UIImageView *tempImageV = [[UIImageView alloc]initWithFrame:CGRectMake(341*SJwidth, 20, 20, 11)];
    
    NSString *tempSectionString = [NSString stringWithFormat:@"%ld",(long)section];
    if ([self.treeOpenArray containsObject:tempSectionString]) {
        tempImageV.image = [UIImage imageNamed:@"down"];
        
    }else{
        tempImageV.image = [UIImage imageNamed:@"up"];
    }
    ///给section加一条线。
    CALayer *_separatorL = [CALayer layer];
    _separatorL.frame = CGRectMake(0.0f, 49.0f, [UIScreen mainScreen].bounds.size.width, 1.0f);
    if (section == 0 || section == 1) {
      _separatorL.frame = CGRectMake(0.0f, 49.0f, [UIScreen mainScreen].bounds.size.width, 1.0f);
    }
    else{
        _separatorL.frame = CGRectMake(0.0f, 99.0f, [UIScreen mainScreen].bounds.size.width, 1.0f);
    }
    _separatorL.backgroundColor  = [[UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:0.5] CGColor];
    [tempV addSubview:label1];
    [tempV addSubview:tempImageV];
    [tempV.layer addSublayer:_separatorL];
    
    UIButton *tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tempBtn.frame = CGRectMake(0, 0, kscreenw, 50);
    if (section == 0 || section == 1) {
        tempBtn.frame = CGRectMake(0, 0, kscreenw, 50);
    }
    else{
        tempBtn.frame = CGRectMake(0, 0, kscreenw, 100);
    }
    [tempBtn addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
    tempBtn.tag = section;
    [tempV addSubview:tempBtn];
    return tempV;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0 || section ==1) {
         return kSectionHeaderHeight;
    }
    else{
         return 100;
    }
}

-(void)tapAction:(UIButton *)sender{
    self.treeOpenString = [NSString stringWithFormat:@"%ld",(long)sender.tag];
    if ([self.treeOpenArray containsObject:self.treeOpenString]) {
        [self.treeOpenArray removeObject:self.treeOpenString];
    }else{
        [self.treeOpenArray addObject:self.treeOpenString];
    }
    ///下面一句是用的时候刷新的。
    //    [self.treeTableView reloadSections:[NSIndexSet indexSetWithIndex:sender.tag] withRowAnimation:UITableViewRowAnimationFade];
}

///这个都没有执行。。。
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ///下面这是类似section里面的就是国家。。。。
    static NSString *CellIdentifier = @"UITableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.textLabel.text = [[[self.treeResultArray[indexPath.section]valueForKey:self.rowListTitle] objectAtIndex:indexPath.row] valueForKey:self.rowListName];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.textColor = [UIColor colorWithRed:0.5 green:0.55 blue:0.65 alpha:1];
    cell.textLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //方法3代码
//    TableViewModel *model =  self.modelArray[indexPath.row];
//    return model.cellHeight;
    
    return  140;
}

//方法3代码
//- (CGFloat)cellHeight{
//    // 文字的最大尺寸(设置内容label的最大size，这样才可以计算label的实际高度，需要设置最大宽度，但是最大高度不需要设置，只需要设置为最大浮点值即可)，53为内容label到cell左边的距离
//    CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 53, MAXFLOAT);
//    
//    // 计算内容label的高度
//    CGFloat textH = [self.userContentString boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.height;
//    
//    /*
//     昵称label和cell的顶部为0
//     17为昵称label的高度
//     8.5为昵称label和内容label的间距
//     textH为内容label的高度
//     304为内容image的高度
//     */
//    _cellHeight = 0 + 17 + 8.5 + 8 +textH + 304;
//    
//    return _cellHeight;
//}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
