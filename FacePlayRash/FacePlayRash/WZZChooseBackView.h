//
//  WZZChooseBackView.h
//  BackViewDemo
//
//  Created by wzzsmac on 15-11-3.
//  Copyright (c) 2015年 wzz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZZChooseBackView : UIView
{
    void(^selectBlock)(NSString *, NSInteger);
}
@property (strong, nonatomic) UITableView * table;

/**
 请使用initWithChooseViewFrame:dataArr:selectBlock:方法初始化
 */
- (instancetype)init;

/**
 请使用initWithChooseViewFrame:dataArr:selectBlock:方法初始化
 */
- (id)initWithCoder:(NSCoder *)aDecoder;

/**
 请使用initWithChooseViewFrame:dataArr:selectBlock:方法初始化
 */
- (instancetype)initWithFrame:(CGRect)frame;

/**
 这个方法可以设置弹出框的frame，弹出框显示内容的数组，用户选择以后获取到返回字符串要做的操作
 */
- (instancetype)initWithChooseViewFrame:(CGRect)frame dataArr:(NSArray *)arr selectBlock:(void(^)(NSString * selectName, NSInteger idx))aSelectBlock;

@end
