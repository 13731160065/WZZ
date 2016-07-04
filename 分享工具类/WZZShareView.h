//
//  WZZShareView.h
//  测试中心
//
//  Created by 王泽众 on 16/7/4.
//  Copyright © 2016年 徐义恒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareTool.h"

/**
 创建分享平台数组
 */
NSArray * WSVSnsArrMake(int argCount, ...);

@interface WZZShareView : UIView

/**
 创建默认格式的分享视图
 */
+ (instancetype)showDefaultViewWithShareType:(NSArray<NSNumber *> *)shareType lie:(int)lie snsName:(NSArray<NSString *> *)namesArr snsIcon:(NSArray<NSString *> *)iconsArr shareBlock:(void(^)(int idx))shareBlock;

/**
 快速创建分享视图
 */
+ (instancetype)showWithFrame:(CGRect)frame snsName:(NSArray <NSString *>*)namesArr snsIcon:(NSArray <NSString *>*)iconsArr lie:(int)lie shareType:(NSArray <NSNumber *>*)shareType edge:(UIEdgeInsets)edge space:(CGFloat)space animation:(BOOL)animation shareBlock:(void(^)(int idx))shareBlock;

@end
