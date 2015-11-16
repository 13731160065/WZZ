//
//  NSData+WZZAESEncrypt.h
//  WZZSecertDemo
//
//  Created by wzzsmac on 15-11-10.
//  Copyright (c) 2015年 wzz. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NSString;

@interface NSData (WZZAESEncrypt)

/**
 加密
 */
- (NSData *)AES256EncryptWithKey:(NSString *)key;

/**
 解密
 */
- (NSData *)AES256DecryptWithKey:(NSString *)key;

/**
 追加64位编码
 */
- (NSString *)newStringInBase64FromData;

/**
 追加自定义64位编码
 */
+ (NSString*)base64encode:(NSString*)str;

@end


