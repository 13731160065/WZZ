//
//  BKLoginForm.m
//  dingding
//
//  Created by CccDaxIN on 15/10/15.
//  Copyright © 2015年 rabbit. All rights reserved.
//

#import "BKLoginForm.h"
#import "BKCheckTimeCell.h"
#import "BKIconTitleCell.h"
@implementation BKLoginForm


- (NSArray *) fields {
    return @[
             @{FXFormFieldKey: @"icon", FXFormFieldCell: [BKIconCell class]},
             @{FXFormFieldKey: @"phone", FXFormFieldTitle: @"手机号"},
             @{FXFormFieldKey: @"password", FXFormFieldTitle: @"密码"}
             
             ];
    
}
- (NSArray *) extraFields{
    return @[
            @{FXFormFieldTitle: @"忘记密码？", FXFormFieldAction: @"requestPassword"},
            @{FXFormFieldTitle: @"登录", FXFormFieldHeader: @"", FXFormFieldAction: @"submitLoginForm"},
            @{FXFormFieldTitle: @"马上注册", FXFormFieldHeader: @"还没有账号？", FXFormFieldAction: @"regestForm"}
             ];
}

@end
