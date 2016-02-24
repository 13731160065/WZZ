//
//  tripViewController.m
//  dingdingtest
//
//  Created by mac on 16/1/19.
//  Copyright © 2016年 rabbit. All rights reserved.
//

#import "tripViewController.h"

#import "finishViewController.h"
#import "unfinishViewController.h"

#define SWIDTH [UIScreen mainScreen].bounds.size.width
#define SHEIGHT [UIScreen mainScreen].bounds.size.height

@interface tripViewController ()<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    UISegmentedControl *_segmentC;  //
    
    finishViewController * finish;
    unfinishViewController * unfinish;
}

@end

@implementation tripViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self initUI];

}
#pragma mark - 生成导航栏编辑按钮
- (void)createNavigationItem
{
    //在导航栏右侧添加编辑按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(editClick:)];
    
}

-(void)initUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"我的行程";
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    
    // nav
    _segmentC = [[UISegmentedControl alloc] initWithItems:@[@"已完成订单", @"未完成订单"]];
    _segmentC.frame = CGRectMake(60, 64, SWIDTH - 120, 30);
    _segmentC.selectedSegmentIndex = 0;
    [_segmentC addTarget:self action:@selector(segmentedControlAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_segmentC];

    //
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64+30, SWIDTH, SHEIGHT - 49)];
    // 到达边界  取消滑动
    _scrollView.bounces = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    // 分页
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(SWIDTH * 2, SHEIGHT - 49);
    
    [self.view addSubview:_scrollView];
    
    // 添加子控制器
    [self addControllers];
}

-(void)addControllers
{
    for(NSInteger i = 0; i < 2; i++){
        
        
        if(i == 0){
            finish = [[finishViewController alloc] init];
            finish.view.frame = CGRectMake(i * SWIDTH, 0, SWIDTH, SHEIGHT-49);
            finish.view.backgroundColor = [UIColor greenColor];
            [_scrollView addSubview:finish.view];
        }
        else{
            unfinish = [[unfinishViewController alloc] init];
            unfinish.view.frame = CGRectMake(i * SWIDTH, 0, SWIDTH, SHEIGHT - 49);
            unfinish.view.backgroundColor = [UIColor yellowColor];
            [_scrollView addSubview:unfinish.view];
        }
        
      
        
    }
}

- (void)editClick:(UIBarButtonItem *)btn
{
    [unfinish editClick:btn];
}

-(void)segmentedControlAction:(UISegmentedControl *)sgc
{
    // sgc.selectedSegmentIndex  0  1
    if (sgc.selectedSegmentIndex == 0) {
        self.navigationItem.rightBarButtonItem = nil;
    }else {
        [self createNavigationItem];
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        _scrollView.contentOffset = CGPointMake(sgc.selectedSegmentIndex * SWIDTH, 0);
    }];
}

// 结束减速
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / SWIDTH;
    if (index == 0) {
        self.navigationItem.rightBarButtonItem = nil;
    }else {
        [self createNavigationItem];
    }
    _segmentC.selectedSegmentIndex = index;
}



@end
