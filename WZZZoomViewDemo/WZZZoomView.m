//
//  WZZZoomView.m
//  房买买
//
//  Created by MS on 15-9-25.
//  Copyright (c) 2015年 WZZ. All rights reserved.
//

#import "WZZZoomView.h"

@interface WZZZoomView()<UIScrollViewDelegate>
{
    //原始宽高
    CGFloat viewH;
    CGFloat viewW;
    //被缩放的宽高
    CGFloat zoomViewW;
    CGFloat zoomViewH;
    //将要被缩放的视图
    UIView * zoomView;
}
@property (strong, nonatomic) UIScrollView * scroll;
@property (strong, nonatomic) UIView * headView;

@end

@implementation WZZZoomView

- (instancetype)initWithFrame:(CGRect)frame headView:(UIView *)aView otherView:(UIView *)otherView{
    self = [super initWithFrame:frame];
    if (self) {
        //初始化将要被缩放的视图
        zoomView = aView;
        
        //记录一下原始宽高
        viewW = frame.size.width;
        viewH = viewW*(aView.frame.size.height/aView.frame.size.width);
        
        //初始化被缩放的宽高
        zoomViewH = viewH;
        zoomViewW = viewW;
        
        //从新设置头部视图的frame
        aView.frame = CGRectMake(0, 0, viewW, viewH);
        
        //设置下部视图的滚动范围(otherView会放在下部视图的位置)
        [self.scroll setContentSize:CGSizeMake(0, otherView.frame.size.height+aView.frame.size.height)];//注意，这里设置滚动范围的时候要加上头部被缩放视图的高度
        
        
//        [self creatButton:self.scroll];
        
        [self addSubview:aView];
        [self addSubview:self.scroll];
        [self.scroll addSubview:otherView];
    }
    return self;
}

/*
//创建点击事件
- (void)creatButton:(UIView *)other {
    CGFloat W = [UIScreen mainScreen].bounds.size.width;
    UIView * view1 = [[UIView alloc] initWithFrame:CGRectMake(0, -80, W/2, 80)];
    UIView * view2 = [[UIView alloc] initWithFrame:CGRectMake(W/2, -80, W/2, 80)];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick2:)];
    [view1 addGestureRecognizer:tap];
    [view2 addGestureRecognizer:tap2];
    [other addSubview:view1];
    [other addSubview:view2];
}

- (void)tapClick:(UITapGestureRecognizer *)tap {
    NSLog(@"a");//此处可使用回调函数调用触发事件
}

- (void)tapClick2:(UITapGestureRecognizer *)tap {
    NSLog(@"b");//此处可使用回调函数调用触发事件
}
 */


- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image otherView:(UIView *)otherView{
    UIImageView * headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width*(image.size.height/image.size.width))];
    [headImageView setImage:image];
    return [self initWithFrame:frame headView:headImageView otherView:(UIView *)otherView];
}

//初始化scrollView
- (UIScrollView *)scroll {
    if (!_scroll) {
        _scroll = [[UIScrollView alloc] initWithFrame:self.frame];
        _scroll.delegate = self;
        //这里设置了scrollView头部位置需要空出来的距离（距离是头部缩放视图的高度）
        [_scroll setContentInset:UIEdgeInsetsMake(viewH, 0, 0, 0)];
        [_scroll setShowsHorizontalScrollIndicator:NO];
        [_scroll setShowsVerticalScrollIndicator:NO];
        //这里设置了scrollView的背景颜色为透明色以便让用户能看到头部缩放视图
        [_scroll setBackgroundColor:[UIColor clearColor]];
    }
    return _scroll;
}


#pragma mark 核心代码
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint currentOffset = scrollView.contentOffset;//获取当前坐标
    zoomViewH = -currentOffset.y;//缩放后的高
    zoomViewW = zoomViewH*(viewW/viewH);//缩放后的宽
    if (currentOffset.y <= -viewH) {//如果当前坐标小于等于view的高（说明是下拉到了不能再拉的位置）
        //设置头部缩放视图的大小为缩放后的大小，并且调整头部视图的水平位置保持居中
        zoomView.frame = CGRectMake(-(zoomViewW-viewW)/2, 0, zoomViewW, zoomViewH);
    } else {//否则说明是在可以自由拉动的位置
        //判断如果上拉到导航栏的位置的时候将会执行_upBlock代码块，否则执行_downBlock代码块
#warning 这里在拉动的同时一直在执行这两个代码块中的一个，感觉性能不太好，但又想不到更好的方法
        if (currentOffset.y > -64) {
            if (_upBlock) {
                _upBlock();
            }
        } else {
            if (_downBlock) {
                _downBlock();
            }
        }
        //根据下部视图滚动的位移的一半位移设置头部视图的位置，看起来更好看些
        zoomView.frame = CGRectMake(zoomView.frame.origin.x, -scrollView.contentOffset.y/2-viewH/2, zoomView.frame.size.width, zoomView.frame.size.height);
    }
}

- (void)ifCountOffsetBehandTheNavigationController_YourControllerWillUseThisBlock:(void (^)())upBlock ifNot_YourControllerWillUseThisBlock:(void (^)())downBlock {
    if (_upBlock != upBlock) {
        _upBlock = upBlock;
    }
    if (_downBlock != downBlock) {
        _downBlock = downBlock;
    }
}

@end
