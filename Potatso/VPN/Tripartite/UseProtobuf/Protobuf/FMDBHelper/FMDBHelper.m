////
////  FMDBHelper.m
////  Lesson_FMDB
////
////  Created by xalo on 16/4/26.
////  Copyright © 2016年 Carson. All rights reserved.
////
//
//#import "FMDBHelper.h"
//#import <FMDB/FMDB.h>
//
//@interface FMDBHelper ()
//
//// 数据库文件路径
//@property (nonatomic,strong) NSString *fileName;
//@property (nonatomic,strong) FMDatabase *dataBase;// 数据库对象
//
//@end
//
//@implementation FMDBHelper
//
//
//+ (instancetype)sharedFMDBHelper {
//    static FMDBHelper *helper = nil;
//
//
////    @synchronized(self) {
////        if (!helper) {
////            helper = [[FMDBHelper alloc] init];
////        }
////    }
//
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        helper = [[FMDBHelper alloc] init];
//    });
//    return helper;
//
//
//}
//
//
//
//// 让用户自己命名数据库名称
//- (void)createDataBaseWithName:(NSString *)dbName {
//
//    // 防止用户直接传值为nil 或者 NULL
//    if (!dbName.length) {
//        self.fileName = nil;
//    } else {
//        // 判断用户是否为数据库添加后缀名
//        if ([dbName hasSuffix:@".sqlite"]) {
//            self.fileName = dbName;
//        } else {
//            self.fileName = [dbName stringByAppendingString:@".sqlite"];
//        }
//    }
//}
//
//// 根据名称创建沙盒路径用来保存数据库文件
//- (NSString *)dbPath {
//    // 判断self.fileName是否为空
//    if (self.fileName.length) { // 判断字符串是否有值
//        // 沙盒Caches文件路径
//        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
//        // 完整路径
//        NSString *savePath = [docPath stringByAppendingPathComponent:self.fileName];
//        return savePath;
//    } else {
//        return nil;
//    }
//}
//
//// 创建数据库对象
//- (FMDatabase *)dataBase {
//    if (!_dataBase) {
//        _dataBase = [FMDatabase databaseWithPath:[self dbPath]];
//    }
//    return _dataBase;
//}
//
//// 打开或者创建数据库
//- (BOOL)openOrCreateDB {
//    BOOL isOpen = [self.dataBase open];
//    if (isOpen) {
//        NSLog(@"数据库打开成功!");
//        return YES;
//    } else {
//        NSLog(@"数据库打开失败!");
//        return NO;
//    }
//}
//
//// 无反返回结果集的操作
//- (BOOL)noResultSetWithSql:(NSString *)sql {
//    // open数据库
//    BOOL isOpen = [self openOrCreateDB];
//    if (isOpen) {
//        NSLog(@"数据库打开成功!");
//        BOOL isUpdate = [self.dataBase executeUpdate:sql];
//        // 关闭数据库
////        [self.dataBase close];
//        [self closeDB];
//        return isUpdate;
//    } else {
//        NSLog(@"数据库打开失败!");
//        return NO;
//    }
//}
//
//// 通用的查询方法
//- (NSMutableArray *)qureyWithSql:(NSString *)sql {
//    // 打开数据库
//    BOOL isOpen = [self openOrCreateDB];
//    if (isOpen) {
//        // 得到所有记录的结果集
//        FMResultSet *resultSet = [self.dataBase executeQuery:sql];
//        // 声明可变数组,用来存放所有的记录
//        NSMutableArray *resultArray = [[NSMutableArray alloc] init];
//        // 遍历每一条记录,将每条记录转换为字典,存储在数组中
//        while ([resultSet next]) {
//            // 直接将一条记录转换成为字典类型
//            NSDictionary *dict = [resultSet resultDictionary];
//            [resultArray addObject:dict];
//        }
//        // 释放结果集
//        [resultSet close];
//        // 关闭数据库
//        [self closeDB];
//
//        return resultArray;
//    } else {
//        return nil;
//    }
//}
//
//// 关闭数据库的方法
//- (void)closeDB {
//    BOOL isClose = [self.dataBase close];
//    NSLog(@"%@",isClose ? @"关闭成功!":@"关闭失败!");
//}
//
//@end
