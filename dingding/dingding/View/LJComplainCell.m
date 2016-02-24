//
//  LJComplainCell.m
//  dingdingtest
//
//  Created by qianfeng on 16/1/20.
//  Copyright © 2016年 lingfeng. All rights reserved.
//

#import "LJComplainCell.h"

#define SWIDTH [UIScreen mainScreen].bounds.size.width
#define SHEIGHT [UIScreen mainScreen].bounds.size.height

@implementation LJComplainCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
         self.contentView.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1];
    }
    //
    return self;
}

- (void)createUI
{
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(15, 5, SWIDTH-30, 40)];
    self.bgView.backgroundColor = [UIColor whiteColor];
    
    [self.contentView addSubview:self.bgView];
    
    self.LeftIcon = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 20, 20)];

    self.LeftIcon.image = [UIImage imageNamed:@"tousu_dot.png"];
    [self.bgView addSubview:self.LeftIcon];
    
    self.titleLb = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.LeftIcon.frame), 10, SWIDTH - 100, 20)];

    [self.bgView addSubview:self.titleLb];
    
}


@end
