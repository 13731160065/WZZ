//
//  BKFormRegest.h
//  dingding
//
//  Created by CccDaxIN on 15/12/14.
//  Copyright © 2015年 rabbit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXForms.h"

@interface BKFormRegest : NSObject <FXForm>

@property (nonatomic, copy) UIImage *step; // 显示步骤

@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *password;


@end
