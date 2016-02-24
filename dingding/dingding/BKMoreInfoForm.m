//
//  BKMoreInfoForm.m
//  dingding
//
//  Created by CccDaxIN on 15/12/14.
//  Copyright © 2015年 rabbit. All rights reserved.
//

#import "BKMoreInfoForm.h"

@implementation BKMoreInfoForm


- (NSArray *)fields{
    return @[
             @{FXFormFieldKey: @"sex",
               FXFormFieldHeader: @"      导游要求  ",FXFormFieldTitle: @"性别", FXFormFieldOptions: @[@"请选择",@"男", @"女"], FXFormFieldCell: [FXFormOptionPickerCell class]},
             @{FXFormFieldKey: @"age", FXFormFieldTitle: @"年龄", FXFormFieldOptions: @[@"请选择",@"70后", @"80后", @"90后", @"不限"], FXFormFieldCell: [FXFormOptionPickerCell class]},
             @{FXFormFieldKey: @"rated", FXFormFieldTitle: @"评级", FXFormFieldOptions: @[@"请选择",@"5星以上", @"4星以上", @"3星以上", @"不限"], FXFormFieldCell: [FXFormOptionPickerCell class]}
             ];
    
    // 70, 80, 90, 取消
    // 达到5星
    
}

- (NSArray *)extraFields{
    return @[
             @{FXFormFieldTitle: @"开始预约",FXFormFieldHeader: @"",  FXFormFieldAction: @"beginOrder"}
             ];
    
}

@end
