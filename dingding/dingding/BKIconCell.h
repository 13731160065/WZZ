//
//  BKIconCell.h
//  dingding
//
//  Created by CccDaxIN on 15/10/15.
//  Copyright © 2015年 rabbit. All rights reserved.
//

#import "FXForms.h"

UIKIT_EXTERN NSString *const FXFormFieldImageName;
@interface FXFormField ()

@property (nonatomic, copy) NSString *imageName;

@end

@interface BKIconCell : FXFormBaseCell

- (void) setUp;
- (void) update;


@end
