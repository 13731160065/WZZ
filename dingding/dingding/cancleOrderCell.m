//
//  cancleOrderCell.m
//  dingding
//
//  Created by mac on 16/1/19.
//  Copyright © 2016年 rabbit. All rights reserved.
//

#import "cancleOrderCell.h"
#import "ColorModel.h"
#define SWIDTH [UIScreen mainScreen].bounds.size.width
#define SHEIGHT [UIScreen mainScreen].bounds.size.height

@implementation cancleOrderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
//
    return self;
}

- (void)createUI
{
    self.bgLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, SWIDTH-20, 40)];
    self.bgLabel.backgroundColor = [UIColor clearColor];
    self.bgLabel.layer.borderWidth = 1;
    self.bgLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.contentView addSubview:self.bgLabel];
    
    self.LeftIcon = [[UIImageView alloc] initWithFrame:CGRectMake(20, 15, 10, 10)];
    self.LeftIcon.backgroundColor = [ColorModel colorWithHexString:@"#43b4ea" alpha:1];
    [self.bgLabel addSubview:self.LeftIcon];
    
    self.titleLb = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.LeftIcon.frame)+5, 10, SWIDTH - 100, 20)];
    
    
    [self.bgLabel addSubview:self.titleLb];
    
}

@end
