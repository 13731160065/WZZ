//
//  WZZMutableArray.h
//  FacePlayRash
//
//  Created by 王泽众 on 16/3/7.
//  Copyright © 2016年 wzz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FMDatabase.h"

@interface WZZMutableArray : NSObject

@property (strong, nonatomic) FMDatabase * fmdb;

/**
 初始化
 */
+ (instancetype)setup;

/**
 初始化
 */
+ (instancetype)shareWZZMutableArray;

/**
 创建数组，记得用release释放
 */
- (void)arrayWithName:(NSString *)name success:(void(^)())successBlock failed:(void(^)())failedBlock;

/**
 复制数组
 */
- (void)copyArrayWithSourceArrayName:(NSString *)sourceName arrayName:(NSString *)name success:(void(^)())successBlock failed:(void(^)())failedBlock;

/**
 添加图片
 */
- (void)addImage:(UIImage *)image arrName:(NSString *)name success:(void(^)())successBlock failed:(void(^)())failedBlock;

/**
 添加元素❌
 */
- (void)addObject:(id)obj arrName:(NSString *)name;


/**
 添加图片从数组遍历
 */
- (void)addImages:(NSMutableArray <UIImage *>*)arr arrName:(NSString *)name;

/**
 添加元素从数组遍历❌
 */
- (void)addObjects:(NSMutableArray *)arr arrName:(NSString *)name;


/**
 修改图片
 */
- (void)replacementImage:(UIImage *)image atIndex:(NSInteger)index arrName:(NSString *)name success:(void(^)())successBlock failed:(void(^)())failedBlock;

/**
 修改元素❌
 */
- (void)replacementObject:(UIImage *)obj atIndex:(NSInteger)index arrName:(NSString *)name;

/**
 取出图片
 */
- (UIImage *)imageWithIndex:(NSInteger)index arrName:(NSString *)name;

/**
 取出元素❌
 */
- (id)objectWithIndex:(NSInteger)index arrName:(NSString *)name;

/**
 删除所有元素
 */
- (void)removeAllObjectsWithName:(NSString *)name success:(void(^)())successBlock failed:(void(^)())failedBlock;

/**
 释放数组
 */
- (void)releaseArrWithName:(NSString *)name success:(void(^)())successBlock failed:(void(^)())failedBlock;

/**
 数组元素数量
 */
- (NSInteger)countWithName:(NSString *)name;

@end
