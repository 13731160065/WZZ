//
//  WZZMutableArray.m
//  FacePlayRash
//
//  Created by 王泽众 on 16/3/7.
//  Copyright © 2016年 wzz. All rights reserved.
//

#import "WZZMutableArray.h"

@implementation WZZMutableArray

static WZZMutableArray *_instance;
+ (id)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    
    return _instance;
}

+ (instancetype)array
{
    if (_instance == nil) {
        _instance = [[WZZMutableArray alloc] init];
        _instance.fmdb = [[FMDatabase alloc] initWithPath:[NSHomeDirectory() stringByAppendingString:@"/Documents/wzzmutablearr.db"]];
    }
    
    return _instance;
}



@end
