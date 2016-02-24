//
//  UserModel.h
//  dingding
//
//  Created by CccDaxIN on 15/12/15.
//  Copyright © 2015年 rabbit. All rights reserved.
//

#import "Prefix.pch"

@interface UserModel : NSObject

@property(nonatomic, copy) NSString *username;
@property(nonatomic, copy) NSString *password;
@property(nonatomic, copy) NSString *iconUrl;
@property(nonatomic, copy) NSString *isLogin;
@property(nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString * ID;
@property(nonatomic, copy) NSString *sex;
@property(nonatomic, copy) NSString *degree; // 学历、教育
@property(nonatomic, copy) NSString *phone;

@property(nonatomic, copy) NSString *birthday;
@property(nonatomic, copy) NSString *alipay;
@property(nonatomic, copy) NSString *balance;



+(id) sharedModel;

+ (NSArray *) sexOptions;

+ (NSArray *) degreeOptions;

- (id) syncWithResponse:(id )responseObject;
- (void) clearInfo;


@end
