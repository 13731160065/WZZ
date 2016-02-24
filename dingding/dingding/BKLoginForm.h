//
//  BKLoginForm.h
//  dingding
//
//  Created by CccDaxIN on 15/10/15.
//  Copyright © 2015年 rabbit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXForms/FXForms.h"
#import "BKIconCell.h"
#import "BKRegistrationForm.h"

@interface BKLoginForm : NSObject <FXForm>

//@property (nonatomic, copy) BKIconCell *icon;

@property (nonatomic, copy) NSString *phone;

@property (nonatomic, copy) NSString *password;



@end
