//
//  EvaluateViewController.m
//  dingding
//
//  Created by mac on 16/1/9.
//  Copyright © 2016年 rabbit. All rights reserved.
//   评价界面

#import "EvaluateViewController.h"
#import "ColorModel.h"
#import "LJComplainViewController.h"    //投诉界面
#import "OrderModel.h"
#import "EvaluateDetailController.h"

#define SWIDTH [UIScreen mainScreen].bounds.size.width
#define SHEIGHT [UIScreen mainScreen].bounds.size.height
@interface EvaluateViewController ()<UIAlertViewDelegate,UITextViewDelegate>

{
    //
    UITextView * _reTextView;
    
    UILabel * _holderLb;
    
    //星星数量
    NSInteger _starNum;
    
}
@end

@implementation EvaluateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.view.backgroundColor = [ColorModel colorWithHexString:@"ecf1f2" alpha:1];
    self.title = @"评价";
    UIColor * color = [UIColor whiteColor];
    
    NSDictionary * dict = [NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
    
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    
    self.view.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1];
    
    [self createView];
    
    [self getInfomation];
    
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

- (void)createView
{
    UIScrollView * bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, SHEIGHT)];
    [self.view addSubview:bgScrollView];
    int bgView1H = 150;
    int bgView2H = 110;
    int bgView3H = 200;
    int bgView4H = 40;
    
    bgScrollView.contentSize = CGSizeMake(SWIDTH, bgView1H + bgView2H + bgView3H + bgView4H);
    
    
    //创建第一部分视图
    UIView * bgView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0,SWIDTH , bgView1H)];
    bgView1.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1];
    //头像
    UIImageView * headView = [[UIImageView alloc] initWithFrame:CGRectMake(SWIDTH/4-10, 30, SWIDTH/4, SWIDTH/4)];
    headView.image = [UIImage imageNamed:@"th_Lightsaber2"];
    [bgView1 addSubview:headView];
    
    //姓名
    UILabel * nameLb = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headView.frame) + 15, 40, SWIDTH/4, 20)];
    
    nameLb.text = [OrderModel currentOrderModel].navName;
    [bgView1 addSubview:nameLb];
    
    //旅行社
    UILabel * lvLb = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headView.frame) + 15, CGRectGetMaxY(nameLb.frame), SWIDTH/3, 25)];
    lvLb.font = [UIFont systemFontOfSize:14];
    lvLb.text = [OrderModel currentOrderModel].navCompany;
    [bgView1 addSubview:lvLb];
    
    //评价的星数
    UIImageView * starImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headView.frame) + 20, CGRectGetMaxY(lvLb.frame), 80, 20)];
    starImage.backgroundColor = [UIColor orangeColor];
    [bgView1 addSubview:starImage];
    
    //单数
    UILabel * numLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(starImage.frame) + 5, CGRectGetMaxY(lvLb.frame), 50, 25)];
    numLabel.font = [UIFont systemFontOfSize:12];
    numLabel.text = [OrderModel currentOrderModel].guideOrderNum;
    [bgView1 addSubview:numLabel];
    
    //创建第二部分视图
    UIView * bgView2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(bgView1.frame), SWIDTH, bgView2H)];
    bgView2.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1];
    //评价导游
    UILabel * redaolabel = [[UILabel alloc] initWithFrame:CGRectMake((SWIDTH-80)/2, 10, 80, 20)];
    redaolabel.textAlignment = NSTextAlignmentCenter;
    redaolabel.text = @"评价导游";
    redaolabel.font = [UIFont systemFontOfSize:14];
    redaolabel.textColor = [UIColor lightGrayColor];
    [bgView2 addSubview:redaolabel];
    //按钮小星星
    for (int i = 0; i<5; i++) {
        UIButton * starBtn = [[UIButton alloc]initWithFrame:CGRectMake((SWIDTH - 40*5 + 5)/2 +40*i, CGRectGetMaxY(redaolabel.frame) + 10, 40, 32)];
        [starBtn setImage:[UIImage imageNamed:@"star1"] forState:UIControlStateNormal];
        [starBtn addTarget:self action:@selector(starClick:) forControlEvents:UIControlEventTouchUpInside];
        starBtn.tag = 1000+i;
        [bgView2 addSubview:starBtn];
    }
    //评价详情
    UILabel * redelabel = [[UILabel alloc] initWithFrame:CGRectMake((SWIDTH-80)/2, CGRectGetMaxY(redaolabel.frame) + 30 + SWIDTH/15, 80, 20)];
    redelabel.text = @"评价详情";
    redelabel.textAlignment = NSTextAlignmentCenter;
    redelabel.font = [UIFont systemFontOfSize:14];
    redelabel.textColor = [UIColor lightGrayColor];
    [bgView2 addSubview:redelabel];
    
    //创建第三部分视图
    UIView * bgView3 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(bgView2.frame), SWIDTH, bgView3H)];
    bgView3.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1];
    //评价内容
    _reTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, 20, SWIDTH - 40, 100)];
    _reTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _reTextView.layer.borderWidth = 1;
    _reTextView.tag = 1006;
    _reTextView.delegate = self;
    [bgView3 addSubview:_reTextView];
    
    _holderLb = [[UILabel alloc] initWithFrame:CGRectMake(25, 25, SWIDTH - 40, 20)];
    _holderLb.text = @"请输入评价内容";
    _holderLb.textColor = [UIColor lightGrayColor];
    _holderLb.font = [UIFont systemFontOfSize:15];
    [bgView3 addSubview:_holderLb];
    
    //提交按钮
    UIButton * submit = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_reTextView.frame)+20, SWIDTH - 40, 40)];
    submit.backgroundColor = [ColorModel colorWithHexString:@"#43b4ea" alpha:1];
    [submit setTitle:@"提交" forState:UIControlStateNormal];
    [submit addTarget: self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView3 addSubview:submit];
    
    //创建第四部分视图
    UIView * bgView4 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(bgView3.frame), SWIDTH, bgView4H)];
    bgView4.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1];
    //分享
    UIButton * leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 0, 50, 50)];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"fenxiang"] forState:UIControlStateNormal];
    [leftBtn addTarget: self action:@selector(sleftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView4 addSubview:leftBtn];
    //推荐
    UIButton * rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(SWIDTH - 30 - 50, 0, 50, 50)];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"tuijian"] forState:UIControlStateNormal];
    [rightBtn addTarget: self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView4 addSubview:rightBtn];
    
    [bgScrollView addSubview:bgView1];
    [bgScrollView addSubview:bgView2];
    [bgScrollView addSubview:bgView3];
    [bgScrollView addSubview:bgView4];
    
}
- (void)starClick:(UIButton *)btn;
{
    switch (btn.tag) {
        case 1000:
            [self starChange:btn.tag num1:1];
            break;
        case 1001:
            [self starChange:btn.tag num1:2];
            break;
        case 1002:
            [self starChange:btn.tag num1:3];
            break;
        case 1003:
            [self starChange:btn.tag num1:4];
            break;
        case 1004:
            [self starChange:btn.tag num1:5];
            break;
            
        default:
            break;
    }
    
}

- (void)starChange:(NSInteger)tag num1:(NSInteger)num
{
    for (int i = 0; i<num; i++) {
        UIButton * btn = (UIButton *)[self.view viewWithTag:1000+i];
        [btn setImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
        _starNum = num;
    }
    for (int i = 5-num; i>0; i--) {
        UIButton * btn = (UIButton *)[self.view viewWithTag:tag+i];
        [btn setImage:[UIImage imageNamed:@"star1.png"] forState:UIControlStateNormal];
    }
}

- (void)submitClick
{
    [self showAlertView];
}
//分享
- (void)sleftBtnClick
{
    UIAlertView *alert1 = [[UIAlertView alloc]initWithTitle:@"抱歉" message:@"分享功能还在调试，正在赶工" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil ];
    [alert1 show];
}
//推荐
- (void)rightBtnClick
{
    
    [[OrderModel currentOrderModel] tuijianGuide:^(id responseObject) {
        if (!responseObject) {
            NSLog(@"%@",responseObject);
//            if (responseObject) {
                    UIAlertView *alert1 = [[UIAlertView alloc]initWithTitle:@"推荐成功" message:@"您已成功推荐该导游" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil ];
            [alert1 show];
//            }
        }
        
    }];
    

    
    
    
    
    
}

//提示框
- (void)showAlertView
{
    UIAlertController * alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定提交评价吗?" preferredStyle:UIAlertControllerStyleAlert];
    
    //添加按钮
    UIAlertAction * cancelBtn = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"点击了取消按钮");
    }];
    
    UIAlertAction * defaultBtn = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        if (_reTextView.text==nil||[_reTextView.text isEqualToString:@""]) {
            _reTextView.text = @"好评[系统自动]";
        }
        //获取输入框的内容
        NSArray * array = @[_reTextView.text,[NSString stringWithFormat:@"%ld",(long)_starNum]];
        
        [[OrderModel currentOrderModel] evalute:^(NSError *error) {
            EvaluateDetailController * detail = [[EvaluateDetailController alloc] init];
                    detail.dataArray = array;
                    [self.navigationController pushViewController:detail animated:YES];
        } comment:_reTextView.text star:@(_starNum)];
        
        
//        EvaluateDetailController * detail = [[EvaluateDetailController alloc] init];
//        detail.dataArray = array;
//        [self.navigationController pushViewController:detail animated:YES];
        
    }];
    
    //将按钮添加到弹框上
    [alertC addAction:cancelBtn];
    [alertC addAction:defaultBtn];
    //显示到屏幕上
    [self presentViewController:alertC animated:YES completion:nil];
}

#pragma mark - UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView
{
    _reTextView.text =  textView.text;
    if (_reTextView.text.length == 0) {
        _holderLb.text = @"请输入评价内容...";
    }else{
        _holderLb.text = @"";
    }
}

#pragma mark - 投诉相关
//点击右上角投诉按钮跳进投诉界面
-(void)CreatTouSuButton{

    UIView *backView=[[UIView alloc] initWithFrame:CGRectMake(-10, 0, 61, 36)];
    UIButton *sure=[[UIButton alloc] init];
    [sure addTarget:self action:@selector(TouSu) forControlEvents:UIControlEventTouchUpInside];
    [sure setTitle:@"投诉" forState:UIControlStateNormal];
    [backView addSubview:sure];

    UIBarButtonItem *TouSuButton=[[UIBarButtonItem alloc] initWithCustomView:backView];
    self.navigationItem.rightBarButtonItem = TouSuButton;
}
-(void)TouSu{
    
    LJComplainViewController *complain = [[LJComplainViewController alloc]init];

    [self.navigationController pushViewController:complain animated:YES];
    
    
}
/*准备显示的数据*/
-(void)getInfomation{


}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - 提交评价
//
//- (IBAction)submit:(id)sender {
//    if (![self.pingJiaDetail.text isEqualToString:@""]) {//还没有判断星星
//
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
//                                                    message:@"确定提交评价吗？"
//                                                   delegate:self
//                                          cancelButtonTitle:@"取消"
//                                          otherButtonTitles:@"确定",nil];
//    [alert show];
//    /*将评价上传至服务器*/
//    
//    //页面显示切换
//    
//    self.judgeView.hidden = NO;
//        
//        
//    }
//    
//    
//    
//
//}


-(void)alertViewCancel:(UIAlertView *)alertView
{
    NSLog(@"评价取消");
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {//点击的是确定按钮
        /*调用提交评价的方法*/
        
        
        
        
        
    }
}

@end
