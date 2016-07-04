//
//  WZZShareView.m
//  测试中心
//
//  Created by 王泽众 on 16/7/4.
//  Copyright © 2016年 徐义恒. All rights reserved.
//

#import "WZZShareView.h"

NSArray * WSVSnsArrMake(int argCount, ...) {
    NSMutableArray * arr = [NSMutableArray array];
    va_list aList;//初始化一个栈式列表
    va_start(aList, argCount);//初始化栈顶指针
    
    while (argCount--) {
        SHARESNS arg = va_arg(aList, SHARESNS);
        [arr addObject:@(arg)];
    }
    
    va_end(aList);//将指针无效化
    return arr;
}

static WZZShareView * shareVVV;

@implementation WZZShareView
{
    UIView * backVVV;
    UIView * ssVVV;
    void(^_buttonCLickBlock)(int index);
}

+ (instancetype)showWithFrame:(CGRect)frame snsName:(NSArray<NSString *> *)namesArr snsIcon:(NSArray<NSString *> *)iconsArr lie:(int)lie shareType:(NSArray<NSNumber *> *)shareType edge:(UIEdgeInsets)edge space:(CGFloat)space animation:(BOOL)animation shareBlock:(void(^)(int idx))shareBlock {
    
    CGSize screenWH = [UIScreen mainScreen].bounds.size;
    CGFloat hhh = 100;
    CGFloat bor = 8;
    if (frame.origin.x == 0 && frame.origin.y == 0 && frame.size.width == 0 && frame.size.height == 0) {
        frame = CGRectMake(0, screenWH.height-hhh, screenWH.width, hhh);
    }
    
    if (edge.left == 0 && edge.top == 0 && edge.right == 0 && edge.bottom == 0) {
        edge = UIEdgeInsetsMake(bor, bor, bor, bor);
    }

    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{//单利
        shareVVV = [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];//主视图
        [[UIApplication sharedApplication].keyWindow addSubview:shareVVV];
        
        shareVVV->backVVV = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];//创建背景视图
        [shareVVV->backVVV setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.3f]];
        [shareVVV->ssVVV setBackgroundColor:[UIColor whiteColor]];
        
        shareVVV->ssVVV = [[self alloc] init];//创建弹出框
        [shareVVV addSubview:shareVVV->backVVV];
        [shareVVV addSubview:shareVVV->ssVVV];
        [shareVVV->backVVV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:shareVVV action:@selector(hidShareVVV:)]];
    });

    if (shareVVV->_buttonCLickBlock != shareBlock) {
        shareVVV->_buttonCLickBlock = shareBlock;
    }
    shareVVV.hidden = NO;
    [shareVVV->ssVVV setFrame:frame];
    NSUInteger hang = (shareType.count%lie)?(shareType.count/lie+1):(shareType.count/lie);
    CGFloat hangH = (frame.size.height-space-edge.top-edge.bottom)/hang;
    CGFloat lieW = (frame.size.width-edge.left-edge.right-(lie-1)*space)/lie;
    
    //刨除edge的view
    UIView * edgeView = [[UIView alloc] initWithFrame:CGRectMake(edge.left, edge.top, frame.size.width-edge.left-edge.right, frame.size.height-edge.top-edge.bottom)];
    [shareVVV->ssVVV addSubview:edgeView];
    [shareVVV->ssVVV setBackgroundColor:[UIColor whiteColor]];
    
    [shareType enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        //一堆view
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake((space+lieW)*idx, edgeView.frame.size.height-hangH*(idx%hang+1), lieW, hangH)];
        [edgeView addSubview:view];
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, view.frame.size.height-20, view.frame.size.width, 20)];
        [view addSubview:label];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setTextColor:[UIColor blackColor]];
        if (idx < namesArr.count) {
            [label setText:namesArr[idx]];
        }
        [label setFont:[UIFont systemFontOfSize:15]];
        [label setAdjustsFontSizeToFitWidth:YES];
        
        UIImageView * imgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height-label.frame.size.height-bor)];
        [view addSubview:imgv];
        if (idx < iconsArr.count) {
            [imgv setImage:[UIImage imageNamed:iconsArr[idx]]];
        }
        [imgv setContentMode:UIViewContentModeScaleAspectFit];
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:view.bounds];
        [view addSubview:button];
        [button addTarget:shareVVV action:@selector(buttonBeClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 3000+idx;
    }];
    
    return shareVVV;
}

+ (instancetype)showDefaultViewWithShareType:(NSArray<NSNumber *> *)shareType lie:(int)lie snsName:(NSArray<NSString *> *)namesArr snsIcon:(NSArray<NSString *> *)iconsArr shareBlock:(void(^)(int idx))shareBlock {
    
    CGFloat bor = 8;
    return [self showWithFrame:CGRectZero snsName:namesArr snsIcon:iconsArr lie:lie shareType:shareType edge:UIEdgeInsetsZero space:bor/2 animation:YES shareBlock:shareBlock];
}

- (void)hidShareVVV:(UITapGestureRecognizer *)tap {
    shareVVV.hidden = YES;
}

- (void)buttonBeClick:(UIButton *)button {
    if (_buttonCLickBlock) {
        _buttonCLickBlock((int)(button.tag-3000));
    }
}

@end
