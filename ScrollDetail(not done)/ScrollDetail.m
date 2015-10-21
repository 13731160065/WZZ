//
//  ScrollDetail.m
//  witchHome
//
//  Created by MS on 15-10-20.
//  Copyright (c) 2015年 home. All rights reserved.
//

#import "ScrollDetail.h"

@interface ScrollDetail()
{
    void (^_backButtonClickBlock)();
}

@property (weak, nonatomic) IBOutlet UIScrollView *topScroll;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;


@end

@implementation ScrollDetail


- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        const CGSize windowSize = [UIScreen mainScreen].bounds.size;
        [self setFrame:[UIScreen mainScreen].bounds];
        [_views enumerateObjectsUsingBlock:^(UIView * obj, NSUInteger idx, BOOL *stop) {
            [obj setFrame:CGRectMake(idx*windowSize.width, 0, windowSize.width, windowSize.height-64)];
            [_scroll addSubview:obj];
        }];
        [_scroll setContentSize:CGSizeMake(windowSize.width*_views.count, 0)];
    }
    return self;
}

- (void)setBackButtonClick:(void (^)())backButtonClickBlock {
    if (_backButtonClickBlock != backButtonClickBlock) {
        _backButtonClickBlock = backButtonClickBlock;
    }
}

- (IBAction)backButtonClick:(id)sender {
    if (_backButtonClickBlock) {
        _backButtonClickBlock();
    }
}
@end
