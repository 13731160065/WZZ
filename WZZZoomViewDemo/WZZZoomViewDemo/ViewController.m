//
//  ViewController.m
//  WZZZoomViewDemo
//
//  Created by wzzsmac on 15-10-9.
//  Copyright (c) 2015年 wzz. All rights reserved.
//

#import "ViewController.h"
#import "WZZZoomView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //创建一个下部分视图
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 1000)];
    [view setBackgroundColor:[UIColor lightGrayColor]];
    
    //创建头部能缩放的滚动视图
    WZZZoomView * zoomView = [[WZZZoomView alloc] initWithFrame:[UIScreen mainScreen].bounds image:[UIImage imageNamed:@"bj.jpg"] otherView:view];
    
    [self.view addSubview:zoomView];
    
    
    //设置一个假的导航栏（模拟导航栏）
    UIView * navigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    [navigationBar setBackgroundColor:[UIColor colorWithWhite:1.0f alpha:0.7f]];
    [self.view addSubview:navigationBar];
    [navigationBar setHidden:YES];
    
    //这个函数的作用是当滚动视图滚动到导航栏上边的时候会显示导航栏，滚动到下边的时候会隐藏导航栏
    [zoomView ifCountOffsetBehandTheNavigationController_YourControllerWillUseThisBlock:^{
        [navigationBar setHidden:NO];
    } ifNot_YourControllerWillUseThisBlock:^{
        [navigationBar setHidden:YES];
    }];
}

@end
