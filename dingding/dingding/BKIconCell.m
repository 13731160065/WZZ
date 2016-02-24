//
//  BKIconCell.m
//  dingding
//
//  Created by CccDaxIN on 15/10/15.
//  Copyright © 2015年 rabbit. All rights reserved.
//

#import "BKIconCell.h"
#import <Masonry/Masonry.h>

@implementation BKIconCell
- (void) setUp{
// 设置宽高
}

- (void)update{
    NSString *imageName = self.field.title;
//    if (!imageName) {
        imageName = @"icon";
//    }
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [self addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@60);
        make.height.equalTo(@60);
        make.topMargin.greaterThanOrEqualTo(@20);
        make.bottomMargin.greaterThanOrEqualTo(@30);
    }];
    
}

+ (CGFloat)heightForField:(FXFormField *)field width:(CGFloat)width{
    return 100.0;
}

@end
