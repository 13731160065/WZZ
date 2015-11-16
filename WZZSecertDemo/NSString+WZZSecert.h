//
//  NSString+WZZSecert.h
//  WZZSecertDemo
//
//  Created by wzzsmac on 15-11-10.
//  Copyright (c) 2015年 wzz. All rights reserved.
//  使用前请导入Security.framework

#import <Foundation/Foundation.h>

@interface NSString (WZZSecert)

#pragma mark - 散列算法

//使用MD5进行加密（自动加盐）
- (NSString *)encryptUseMD5;

//使用SHA1进行加密（自动加盐）
- (NSString *)encryptUseSHA1;

//使用MD5进行加密加盐
- (NSString *)encryptUseMD5WithSalt:(NSString *)salt;

//使用SHA1进行加密加盐
- (NSString *)encryptUseSHA1WithSalt:(NSString *)salt;

@end
