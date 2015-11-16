//
//  WZZZoomView.h
//  房买买
//
//  Created by MS on 15-9-25.
//  Copyright (c) 2015年 WZZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZZZoomView : UIView
{
    void (^_upBlock)();
    void (^_downBlock)();
}

/**
 你可以设置一个任意视图作为头视图，再设置一个其他视图以达到非常炫酷的效果;)
 */
- (instancetype)initWithFrame:(CGRect)frame headView:(UIView *)aView otherView:(UIView *)otherView;

/**
 你可以直接设置一个图片作为头视图，再设置一个其他视图以达到非常炫酷的效果，虽然不灵活，不过很方便;)
 */
- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image otherView:(UIView *)otherView;

/**
 你可以设置两个代码块，当下边的视图滚动到导航条的时候，会调用这两个代码
 */
- (void)ifCountOffsetBehandTheNavigationController_YourControllerWillUseThisBlock:(void(^)())upBlock ifNot_YourControllerWillUseThisBlock:(void(^)())downBlock;

@end
