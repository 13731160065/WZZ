//
//  EvaluateDetailController.m
//  dingdingtest
//
//  Created by mac on 16/1/20.
//  Copyright © 2016年 rabbit. All rights reserved.
//

#import "EvaluateDetailController.h"
#import "ColorModel.h"
#import "LJComplainViewController.h"

#define SWIDTH [UIScreen mainScreen].bounds.size.width
#define SHEIGHT [UIScreen mainScreen].bounds.size.height

@interface EvaluateDetailController ()

@end

@implementation EvaluateDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [ColorModel colorWithHexString:@"ecf1f2" alpha:1];
    self.title = @"评价";
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    [self createView];
    
    [self CreatTouSuButton];
    
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

//点击右上角投诉按钮跳进投诉界面
-(void)CreatTouSuButton{
    
    UIView *backView=[[UIView alloc] initWithFrame:CGRectMake(0, -15, 61, 36)];
    UIButton *touSu=[UIButton buttonWithType:UIButtonTypeCustom];
    [touSu addTarget:self action:@selector(TouSu) forControlEvents:UIControlEventTouchUpInside];
    [touSu setTitle:@"投诉" forState:UIControlStateNormal];
    [touSu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    touSu.frame = CGRectMake(0, 0, 60, 40);
    [backView addSubview:touSu];
    
    UIBarButtonItem *TouSuButton=[[UIBarButtonItem alloc] initWithCustomView:backView];
    self.navigationItem.rightBarButtonItem = TouSuButton;
}

-(void)TouSu{
    
    LJComplainViewController *complain = [[LJComplainViewController alloc]init];
    
    [self.navigationController pushViewController:complain animated:YES];
    
    
}

- (void)createView
{
    //创建第二部分视图
    UIView * bgView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 84, SWIDTH, 110)];
    bgView1.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1];
    //评价导游
    UILabel * redaolabel = [[UILabel alloc] initWithFrame:CGRectMake((SWIDTH-80)/2, 10, 80, 20)];
    redaolabel.textAlignment = NSTextAlignmentCenter;
    redaolabel.text = @"评价成功";
    redaolabel.font = [UIFont systemFontOfSize:14];
    redaolabel.textColor = [UIColor lightGrayColor];
    [bgView1 addSubview:redaolabel];
    //按钮小星星
    int starNum = [self.dataArray[1] integerValue];
    for (int i = 0; i<5; i++) {
        UIImageView * starImg= [[UIImageView alloc]initWithFrame:CGRectMake((SWIDTH - 40*5 + 5)/2+40*i, CGRectGetMaxY(redaolabel.frame) + 10, 40, 32)];
        if (starNum > i) {
            starImg.image = [UIImage imageNamed:@"star.png"];
        }else{
            starImg.image = [UIImage imageNamed:@"star1.png"];
        }
        
        starImg.tag = 1000+i;
        [bgView1 addSubview:starImg];
    }
    //评价详情
    UILabel * redelabel = [[UILabel alloc] initWithFrame:CGRectMake((SWIDTH-80)/2, CGRectGetMaxY(redaolabel.frame) + 30 + SWIDTH/15, 80, 20)];
    redelabel.text = @"评价内容";
    redelabel.textAlignment = NSTextAlignmentCenter;
    redelabel.font = [UIFont systemFontOfSize:14];
    redelabel.textColor = [UIColor lightGrayColor];
    [bgView1 addSubview:redelabel];
    
    //第二部分视图
    UILabel * detailLb = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(bgView1.frame), SWIDTH - 60, 100)];
    detailLb.backgroundColor = [UIColor clearColor];
    detailLb.numberOfLines = 0;
    detailLb.text = self.dataArray[0];
    detailLb.font = [UIFont systemFontOfSize:14];
    detailLb.textColor = [UIColor lightGrayColor];

    
    //创建第三部分视图
    UIView * bgView3 = [[UIView alloc] initWithFrame:CGRectMake(0, SHEIGHT - 50, SWIDTH, 50)];
    bgView3.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1];
    //分享
    UIButton * leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 0, 50, 50)];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"fenxiang"] forState:UIControlStateNormal];
    [leftBtn addTarget: self action:@selector(sleftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView3 addSubview:leftBtn];
    //推荐
    UIButton * rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(SWIDTH - 30 - 50, 0, 50, 50)];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"tuijian"] forState:UIControlStateNormal];
    [rightBtn addTarget: self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView3 addSubview:rightBtn];
    
    [self.view addSubview:bgView1];
    [self.view addSubview:detailLb];
    [self.view addSubview:bgView3];
    
    
}

//分享点击事件
- (void)sleftBtnClick
{
    NSLog(@"点击了分享");
    UIAlertView *alert1 = [[UIAlertView alloc]initWithTitle:@"抱歉" message:@"分享功能还在调试，正在赶工" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil ];
    [alert1 show];
}
//推荐点击事件
- (void)rightBtnClick
{
    NSLog(@"点击了推荐");
    UIAlertView *alert1 = [[UIAlertView alloc]initWithTitle:@"抱歉" message:@"推荐功能还在调试，正在赶工" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil ];
    [alert1 show];
}


@end
