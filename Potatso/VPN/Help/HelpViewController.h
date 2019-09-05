//
//  HelpViewController.h
//  Potatso
//
//  Created by txb on 2017/10/20.
//  Copyright © 2017年 TouchingApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SJBBaseTreeListViewController.h"
@interface HelpViewController : SJBBaseTreeListViewController
///创建自己的tableView和resultArray
@property (strong, nonatomic) UITableView *myTableView;
@property (strong, nonatomic) NSMutableArray *myResultArray;

@end
