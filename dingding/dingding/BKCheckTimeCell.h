//
//  BKCheckTimeCell.h
//  dingding
//
//  Created by CccDaxIN on 15/10/15.
//  Copyright © 2015年 rabbit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXForms/FXForms.h"

@interface BKCheckTimeCell : FXFormBaseCell

@property (strong, readonly) UIButton *sendButton;
- (void) setUp;
- (void)update;

@end
