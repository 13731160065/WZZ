//
//  tuikuanSuccessCell.m
//  dingding
//
//  Created by mac on 16/1/19.
//  Copyright © 2016年 rabbit. All rights reserved.
//

#import "tuikuanSuccessCell.h"

#define SWIDTH [UIScreen mainScreen].bounds.size.width
#define SHEIGHT [UIScreen mainScreen].bounds.size.height

@implementation tuikuanSuccessCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self) {
        [self createUI];
    }
    

    return self;
}

- (void)createUI
{
    //左侧图片
    self.leftIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 30, 50)];
    [self.contentView addSubview:self.leftIcon];
    
    //头部标题
    self.titleLb = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, SWIDTH - 100, 20)];
    [self.contentView addSubview:self.titleLb];
    
    //下部时间
    self.dateLb = [[UILabel alloc] initWithFrame:CGRectMake(50, CGRectGetMaxY(self.titleLb.frame), SWIDTH - 100, 20)];
    self.dateLb.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.titleLb];
    
    
}

@end
