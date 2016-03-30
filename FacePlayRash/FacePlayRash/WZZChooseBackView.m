//
//  WZZChooseBackView.m
//  BackViewDemo
//
//  Created by wzzsmac on 15-11-3.
//  Copyright (c) 2015年 wzz. All rights reserved.
//

#import "WZZChooseBackView.h"

@interface WZZChooseBackView()<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray * dataArr;
    CGRect chooseViewFrameEnd;
    CGRect chooseViewFrameStart;
}

@end

@implementation WZZChooseBackView

- (instancetype)initWithChooseViewFrame:(CGRect)frame dataArr:(NSArray *)arr selectBlock:(void (^)(NSString *, NSInteger))aSelectBlock
{
    self = [super init];
    if (self) {
        //设置取消view的背景色
        [self setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.5f]];
        
        //设置取消view的背景的大小为全屏
        [self setFrame:[UIScreen mainScreen].bounds];
        
        //初始化弹出框内容数组
        dataArr = [[NSMutableArray alloc] initWithCapacity:0];
        
        //设置弹出框的内容
        [dataArr addObjectsFromArray:arr];
        
        //记录弹出框开始动画和结束动画的frame
        chooseViewFrameEnd = frame;
        chooseViewFrameStart = CGRectMake(chooseViewFrameEnd.origin.x, chooseViewFrameEnd.origin.y, chooseViewFrameEnd.size.width, 0);
        
        //创建弹出框设置frame为传进来的frame
        self.table = [[UITableView alloc] initWithFrame:chooseViewFrameStart];
        
        //设置弹出框弹出的动画
        [UIView animateWithDuration:0.3f animations:^{
            [self.table setFrame:chooseViewFrameEnd];
        }];
        
        //设置弹出框的基本属性
        [self.table setBackgroundColor:[UIColor colorWithWhite:0.9f alpha:1.0f]];
        [self.table setDelegate:self];
        [self.table setDataSource:self];
        [self.table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [self addSubview:self.table];
        
        //给弹出框切圆角
        [self.table.layer setMasksToBounds:YES];
        [self.table.layer setCornerRadius:10];
        
        //设置返回字符串的回调block
        if (selectBlock != aSelectBlock) {
            selectBlock = aSelectBlock;
        }
        
    }
    return self;
}

#pragma mark - tableView代理方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArr.count;
}

//不喜欢系统自带的cell可以自定制
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell.textLabel setText:dataArr[indexPath.row][@"tabdesc"]];
    [cell setBackgroundColor:[UIColor colorWithWhite:0.9f alpha:1.0f]];
    
    return cell;
}

//用户点击了一个cell，cell被点击的时候会调用之前设置好的selectBlock代码块，并且将被点击那一行的文字传给调用这个View的ViewController
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //判断selectBlock代码块是否已初始化，如果初始化才调用它传值
    if (selectBlock) {
        selectBlock(dataArr[indexPath.row][@"tabdesc"], [dataArr[indexPath.row][@"tabId"] integerValue]);
    }
    
    //设置弹出款收回的动画，并在弹出框收回后将该view从父视图移除掉
    [UIView animateWithDuration:0.3f animations:^{
        [self.table setFrame:chooseViewFrameStart];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - 点击其他地方执行方法

//用户点击了其他地方，取消选择
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    //设置弹出款收回的动画，并在弹出框收回后将该view从父视图移除掉
    [UIView animateWithDuration:0.3f animations:^{
        [self.table setFrame:chooseViewFrameStart];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


@end
