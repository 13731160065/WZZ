//
//  ViewController.m
//  BackViewDemo
//
//  Created by wzzsmac on 15-11-3.
//  Copyright (c) 2015年 wzz. All rights reserved.
//

#import "ViewController.h"
//1.包含头文件
#import "WZZChooseBackView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *TF;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)buttonClick:(id)sender {
//2.初始化view添加到self.view上，注意调用initWithFrame:dataArr:selectBlock:方法，可以直接设置弹出框的位置，通过设置dataArr来设置弹出框显示的内容，设置selectBlock来设置用户点击后得到的字符串要做的操作
    WZZChooseBackView  * view = [[WZZChooseBackView alloc] initWithChooseViewFrame:CGRectMake(_TF.frame.origin.x, _TF.frame.origin.y+44, _TF.frame.size.width+46+8, 100) dataArr:@[@"1", @"2", @"3", @"4", @"5", @"6", @"7"] selectBlock:^(NSString *selectName) {
        _TF.text = selectName;
    }];
    
    [self.view addSubview:view];
}

@end
