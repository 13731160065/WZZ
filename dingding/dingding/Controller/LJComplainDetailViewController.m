//
//  LJComplainDetailViewController.m
//  dingdingtest
//
//  Created by mac on 16/1/20.
//  Copyright © 2016年 rabbit. All rights reserved.
//

#import "LJComplainDetailViewController.h"
#import "ColorModel.h"

#define SHEIGHT [UIScreen mainScreen].bounds.size.height
#define SWIDTH [UIScreen mainScreen].bounds.size.width

@interface LJComplainDetailViewController ()

@end

@implementation LJComplainDetailViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.subArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [ColorModel colorWithHexString:@"ecf1f2" alpha:1];
    
    self.title = @"投诉";
   
    UIColor * color = [UIColor whiteColor];
    
    NSDictionary * dict = [NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
    
    self.navigationController.navigationBar.titleTextAttributes = dict;
    //背景颜色
    self.view.backgroundColor = [ColorModel colorWithHexString:@"#ecf1f2" alpha:1];
    
    //创建视图
    [self createBackView];
    //右上角退出按钮
    [self CreatQuit];
    
    [self backBUTTON];
}

-(void)backBUTTON{
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0, 0, 30, 30);
    [back setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backpop) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithCustomView:back];
    self.navigationItem.leftBarButtonItem = backButton;
    
}
-(void)backpop{
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)CreatQuit{
    UIView *quitView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    UIButton *quitButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [quitButton addTarget:self action:@selector(backToRoot) forControlEvents:UIControlEventTouchUpInside];
    [quitButton setImage:[UIImage imageNamed:@"cha"] forState:UIControlStateNormal];
    quitButton.frame = CGRectMake(0, 0, 30, 30);
    [quitView addSubview:quitButton];
    
    UIBarButtonItem *TouSuButton=[[UIBarButtonItem alloc] initWithCustomView:quitView];
    self.navigationItem.rightBarButtonItem = TouSuButton;


}
-(void)backToRoot{
    [self.navigationController popToRootViewControllerAnimated:YES];


}

//创建视图
- (void)createBackView
{
    //添加头部图片
    UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake((SWIDTH - 60)/2, 120, 60, 60)];
    image.layer.cornerRadius = 25;
    image.image = [UIImage imageNamed:@"tousu.png"];
    image.clipsToBounds = YES;
    [self.view addSubview:image];
    
    //
    UILabel * label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(image.frame) + 10, SWIDTH, 20)];
    label1.text = @"已收到您的投诉";
    label1.textAlignment = NSTextAlignmentCenter;
    label1.font = [UIFont systemFontOfSize:14];
    label1.textColor = [UIColor darkGrayColor];
    [self.view addSubview:label1];
    
    UILabel * label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label1.frame), SWIDTH, 20)];
    label2.text = @"给您带来不便深表歉意";
    label2.textAlignment = NSTextAlignmentCenter;
    label2.font = [UIFont systemFontOfSize:14];
    label2.textColor = [UIColor darkGrayColor];
    [self.view addSubview:label2];
    
    int num = 0;
    for (int i = 0 ; i<self.subArray.count; i++) {
        if (![self.subArray[i] isEqual:@NO]&&![self.subArray[i] isEqualToString:@""]) {
            UILabel * detailLb = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label2.frame) + 30 + num*20, SWIDTH, 20)];
            detailLb.textAlignment = NSTextAlignmentCenter;
            detailLb.text = [NSString stringWithFormat:@"\"%@\"",self.subArray[i]];
            detailLb.font = [UIFont systemFontOfSize:14];
            detailLb.textColor = [UIColor lightGrayColor];
            [self.view addSubview:detailLb];
            num ++ ;
        }
    }
    
}
@end
