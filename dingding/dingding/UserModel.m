//
//  UserModel.m
//  dingding
//
//  Created by CccDaxIN on 15/12/15.
//  Copyright © 2015年 rabbit. All rights reserved.
//

#import "UserModel.h"
#import <objc/runtime.h>



@implementation UserModel

- (id)syncWithResponse:(id)responseObject{
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        self.username = [responseObject objectForKey:@"tname"];
        self.token = [responseObject objectForKey:@"token"];
        
        self.ID = [responseObject objectForKey:@"id"];
        
        if ([[responseObject objectForKey:@"sex"] intValue] == 1) {
            self.sex = @"男";
        } else {
            self.sex = @"女";
        }
        
        self.degree = [responseObject objectForKey:@""];
        self.phone = [responseObject objectForKey:@"mobile"];
        self.iconUrl = [responseObject objectForKey:@"avatar"];
        
        self.birthday = [responseObject objectForKey:@"dob"];
        
        self.alipay = [responseObject objectForKey:@"alipay_no"];
        self.balance = [responseObject objectForKey:@"a_balance"];
        
        // 保存数据
        [self syncInfo];
    }
    return self;
}

- (void) syncInfo{
    unsigned int outCount, i;
    objc_property_t * propertes = class_copyPropertyList([self class], &outCount);
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    for (i = 0; i < outCount; i ++) {
        objc_property_t property = propertes[i];
        NSString *defKey = [NSString stringWithFormat:@"userModel.%s", property_getName(property )];
        NSString *name = [NSString stringWithFormat:@"%s", property_getName(property)];
        
        // 获取类型
        id value = [self valueForKey:name];
        
        [userDef setObject:value forKey:defKey];
        
    }
}

- (void) clearInfo{
    unsigned int outCount, i;
    objc_property_t * propertes = class_copyPropertyList([self class], &outCount);
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    for (i = 0; i < outCount; i ++) {
        objc_property_t property = propertes[i];
        NSString *defKey = [NSString stringWithFormat:@"userModel.%s", property_getName(property )];
        NSString *name = [NSString stringWithFormat:@"%s", property_getName(property)];
        
        // 获取类型
        [self setValue:nil forKey:name];
        
        [userDef setObject:nil forKey:defKey];
        
    }
}

- (id) initFromDefault{
    self = [super init];
    if (self) {
        unsigned int outCount, i;
        objc_property_t *propertes = class_copyPropertyList([self class], &outCount);
        
        NSUserDefaults * userDef = [NSUserDefaults standardUserDefaults];
        
        for (i = 0; i < outCount; i++ ){
            objc_property_t property = propertes[i];
            NSString *key = [NSString stringWithFormat:@"userModel.%s",property_getName(property) ];
            NSString *k = [NSString stringWithFormat:@"%s", property_getName(property)];
            id value = [userDef objectForKey:key];
            [self setValue:value forKey:k];
        }
        NSLog(@">> [INFO] init user model : %@", self.debugDescription);
    }
    return self;
}

+ (id)sharedModel{
    
    static UserModel * shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] initFromDefault];
    });
    
    return shared;
}

+ (NSArray *)sexOptions{
    return @[@"男", @"女", @"其它"];
}

+ (NSArray *)degreeOptions{
    return @[@"初中", @"高中", @"大专", @"本科", @"硕士", @"博士", @"其它"];
}


@end
