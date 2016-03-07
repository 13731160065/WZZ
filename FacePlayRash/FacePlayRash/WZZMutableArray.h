//
//  WZZMutableArray.h
//  FacePlayRash
//
//  Created by 王泽众 on 16/3/7.
//  Copyright © 2016年 wzz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface WZZMutableArray : NSObject

@property (strong, nonatomic) FMDatabase * fmdb;

+ (instancetype)array;



@end
