//
//  BKUserCenterViewController.h
//  dingding
//
//  Created by CccDaxIN on 15/12/14.
//  Copyright © 2015年 rabbit. All rights reserved.
//

#import "FXForms.h"

@interface BKUserCenterViewController : FXFormViewController

@end

@interface UserCenterForm : NSObject <FXForm>

@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString * birthday;
@property (nonatomic, copy) NSString * degree;
@property (nonatomic, copy) NSString * alipay;


@end