//
//  BKFormRegest.m
//  dingding
//
//  Created by CccDaxIN on 15/12/14.
//  Copyright © 2015年 rabbit. All rights reserved.
//

#import "BKFormRegest.h"

@implementation BKFormRegest


- (NSArray *)fields{
    
    return @[
//             @{FXFormFieldKey: @"setp", FXFormFieldType: FXFormFieldTypeImage},
             @{FXFormFieldKey: @"phone", FXFormFieldTitle: @"手机号", FXFormFieldType: FXFormFieldTypePhone},
             @{FXFormFieldTitle: @"获取", FXFormFieldAction: @"getCode"},
             @{FXFormFieldKey: @"code", FXFormFieldTitle: @"验证码"},
             @{FXFormFieldKey: @"password", FXFormFieldTitle: @"设置密码", FXFormFieldType: FXFormFieldTypePassword}
             ];
}

- (NSArray *)extraFields{
    
    return @[
             @{FXFormFieldTitle: @"下一步", FXFormFieldHeader: @"",
               FXFormFieldAction: @"submit"
//               FXFormFieldSegue: @"regest2fillInfo"
               }
             ];
}

@end
