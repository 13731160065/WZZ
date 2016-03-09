//
//  WZZMutableArray.m
//  FacePlayRash
//
//  Created by 王泽众 on 16/3/7.
//  Copyright © 2016年 wzz. All rights reserved.
//

#import "WZZMutableArray.h"

@implementation WZZMutableArray

#pragma mark - 单利
static WZZMutableArray *_instance;
+ (id)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    
    return _instance;
}

#pragma mark - 初始化
//初始化
+ (instancetype)setup
{
    if (_instance == nil) {
        _instance = [[WZZMutableArray alloc] init];
        _instance.fmdb = [FMDatabase databaseWithPath:[NSHomeDirectory() stringByAppendingString:@"/Documents/wzzmutablearr.db"]];
        [_instance.fmdb open];
    }
    return _instance;
}

//初始化
+ (instancetype)shareWZZMutableArray {
    return [self setup];
}

#pragma mark - 操作数据
//添加一个图片
- (void)addImage:(UIImage *)image arrName:(NSString *)name success:(void(^)())successBlock failed:(void(^)())failedBlock {
    NSData * data = UIImagePNGRepresentation(image);
    if ([_fmdb executeUpdate:[NSString stringWithFormat:@"insert into %@(obj) values(?);", name], data]) {
        //成功
        NSLog(@"插入成功");
        if (successBlock) {
            successBlock();
        }
    } else {
        //失败
        NSLog(@"插入失败");
        if (failedBlock) {
            failedBlock();
        }
    }
}

//删除所有数据
- (void)removeAllObjectsWithName:(NSString *)name success:(void(^)())successBlock failed:(void(^)())failedBlock {
    if ([_fmdb executeUpdate:[NSString stringWithFormat:@"delete from %@;", name]]) {
        if (successBlock) {
            successBlock();
        }
    } else {
        if (failedBlock) {
            failedBlock();
        }
    }
}

//修改某张图
- (void)replacementImage:(UIImage *)image atIndex:(NSInteger)index arrName:(NSString *)name success:(void(^)())successBlock failed:(void(^)())failedBlock {
    if ([_fmdb executeUpdate:[NSString stringWithFormat:@"update %@ set obj=? where idx=?", name], UIImagePNGRepresentation(image), [NSString stringWithFormat:@"%ld", index+1]]) {
        //成功
        if (successBlock) {
            successBlock();
        }
    } else {
        //失败
        if (failedBlock) {
            failedBlock();
        }
    }
}

#pragma mark - 查询表
//查找某项
- (UIImage *)imageWithIndex:(NSInteger)index arrName:(NSString *)name {
    FMResultSet * result = [_fmdb executeQuery:[NSString stringWithFormat:@"select * from %@ where idx=?;", name], [NSString stringWithFormat:@"%ld", index+1]];
    if ([result next]) {
        //找到
        return [UIImage imageWithData:[result dataForColumn:@"obj"]];
    } else {
        //没找到
        return nil;
    }
}

//查询数量
- (NSInteger)countWithName:(NSString *)name {
    FMResultSet * result = [_fmdb executeQuery:[NSString stringWithFormat:@"select count(*) as countNum from %@;", name]];
    if ([result next]) {
        return [result intForColumn:@"countNum"];
    }
    return 0;
}

#pragma mark - 操作表
//创建表
- (void)arrayWithName:(NSString *)name success:(void(^)())successBlock failed:(void(^)())failedBlock {
    if ([_fmdb executeUpdate:[NSString stringWithFormat:@"create table if not exists %@(idx integer primary key, obj blob);", name]]) {
        //成功
        NSLog(@"创建表成功");
        if (successBlock) {
            successBlock();
        }
        
    } else {
        //失败
        NSLog(@"创建表失败");
        if (failedBlock) {
            failedBlock();
        }
    }
}

//删除表
- (void)releaseArrWithName:(NSString *)name success:(void(^)())successBlock failed:(void(^)())failedBlock {
    if ([_fmdb executeUpdate:[NSString stringWithFormat:@"drop table %@", name]]) {
        if (successBlock) {
            successBlock();
        }
    } else {
        if (failedBlock) {
            failedBlock();
        }
    }
}

@end
