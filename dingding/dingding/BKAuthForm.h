//
//  BKAuthForm.h
//  dingding
//
//  Created by CccDaxIN on 15/10/15.
//  Copyright © 2015年 rabbit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXForms/FXForms.h"
#import "BKLoginForm.h"
#import "BKRegistrationForm.h"

@interface BKAuthForm : NSObject <FXForm>

@property (nonatomic, strong) BKLoginForm *login;
@property (nonatomic, strong) BKRegistrationForm *registration;

@end
