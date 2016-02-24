//
//  BKBindPayForm.m
//  dingding
//
//  Created by CccDaxIN on 15/12/15.
//  Copyright © 2015年 rabbit. All rights reserved.
//

#import "BKBindPayForm.h"

@implementation BKBindPayForm

- (NSArray *)fields{
    
    return @[
             @{FXFormFieldKey: @"alipay", FXFormFieldTitle: @"支付宝账号"}
             ];
    
}

- (NSArray *)extraFields{
    return @[
             @{FXFormFieldTitle: @"完成", FXFormFieldHeader: @"", FXFormFieldAction: @"submit"}
             ];
}


@end
