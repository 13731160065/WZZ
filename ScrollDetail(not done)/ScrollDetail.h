//
//  ScrollDetail.h
//  witchHome
//
//  Created by MS on 15-10-20.
//  Copyright (c) 2015年 home. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrollDetail : UIView

/**
 传入一个数组来设置下边的view，类似tabbarController
 */
@property (strong, nonatomic) NSArray * views;

/**
 !!!使用前先把当前控制器的导航栏隐藏掉
 设置当前视图控制器的: [self setAutomaticallyAdjustsScrollViewInsets:NO];
 并在push的时候设置: [要push的视图控制器 setHiddenBottomBarWhenPushed:YES];
 此视图默认全屏大小
 */
- (instancetype)init;

/**
 !!!使用前先把当前控制器的导航栏隐藏掉
 设置当前视图控制器的: [self setAutomaticallyAdjustsScrollViewInsets:NO];
 并在push的时候设置: [要push的视图控制器 setHiddenBottomBarWhenPushed:YES];
 此视图固定全屏大小
 */
- (instancetype)initWithFrame:(CGRect)frame;

- (void)setBackButtonClick:(void(^)())backButtonClickBlock;


@end
