//
//  BKFillInfoForm.m
//  dingding
//
//  Created by CccDaxIN on 15/12/14.
//  Copyright © 2015年 rabbit. All rights reserved.
//

#import "BKFillInfoForm.h"
#import "UserModel.h"
@implementation BKFillInfoForm

- (NSArray *)fields{
    
    return @[
             @{FXFormFieldKey: @"icon", FXFormFieldTitle: @"头像", FXFormFieldType: FXFormFieldTypeImage},
             @{FXFormFieldKey: @"sex", FXFormFieldTitle: @"性别", FXFormFieldOptions: [UserModel sexOptions]},
             @{FXFormFieldKey: @"birthday", FXFormFieldTitle: @"出生日期", FXFormFieldType: FXFormFieldTypeDate},
             @{FXFormFieldKey: @"degree", FXFormFieldTitle: @"教育程度", FXFormFieldOptions: [UserModel degreeOptions], FXFormFieldCell: [FXFormOptionPickerCell class]}
             ];
}

- (NSArray *)extraFields {
    
    return @[
             @{FXFormFieldTitle: @"下一步",FXFormFieldHeader: @"",
               FXFormFieldAction: @"submit"
//               FXFormFieldSegue: @"fillInfo2bindPay"
               }
             ];
}

@end
