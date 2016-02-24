//
//  BKFillInfoForm.h
//  dingding
//
//  Created by CccDaxIN on 15/12/14.
//  Copyright © 2015年 rabbit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXForms.h"

@interface BKFillInfoForm : NSObject <FXForm>

@property (nonatomic, strong) UIImage * icon;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * sex;
@property (nonatomic, copy) NSString * birthday;
@property (nonatomic, copy) NSString * degree;

@end
