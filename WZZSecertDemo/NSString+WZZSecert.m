//
//  NSString+WZZSecert.m
//  WZZSecertDemo
//
//  Created by wzzsmac on 15-11-10.
//  Copyright (c) 2015年 wzz. All rights reserved.
//

#import "NSString+WZZSecert.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (WZZSecert)

#pragma mark - 加密

- (NSString *)encryptUseMD5
{
    NSString * salt = [NSString stringWithFormat:@"`1234567890-=qwertyuop[]\asdfghjkl;'zxcvbnm,./%d%d%d%d", arc4random(), arc4random(), arc4random(), arc4random()];
    return [self encryptUseMD5WithSalt:salt];
}

- (NSString *)encryptUseSHA1 {
    NSString * salt = [NSString stringWithFormat:@"`1234567890-=qwertyuop[]\asdfghjkl;'zxcvbnm,./%d%d%d%d", arc4random(), arc4random(), arc4random(), arc4random()];
    return [self encryptUseSHA1WithSalt:salt];
}

- (NSString *)encryptUseMD5WithSalt:(NSString *)salt {
    const char *cStr = [[self stringByAppendingString:salt] UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest );
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

- (NSString *)encryptUseSHA1WithSalt:(NSString *)salt {
    const char *cstr = [[self stringByAppendingString:salt] cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

@end
