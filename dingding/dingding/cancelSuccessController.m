//
//  cancelSuccessController.m
//  dingding
//
//  Created by mac on 16/1/19.
//  Copyright © 2016年 rabbit. All rights reserved.
//

#import "cancelSuccessController.h"
#import "tuikuanApplyController.h"
#import "OrderModel.h"

#define SWIDTH [UIScreen mainScreen].bounds.size.width
#define SHEIGHT [UIScreen mainScreen].bounds.size.height

@interface cancelSuccessController ()
{
    NSTimer * _timer;
}
@end

@implementation cancelSuccessController

- (void)dealloc
{
    [_timer invalidate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    //    创建定时器
    @synchronized(self) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(createTimer) userInfo:nil repeats:YES];
    };
    
    [_timer fire];
    
    NSString * string = self.reason;
    [self createUI:string];
    
    
    
    [self backBUTTON];
    [self CreatQuit];
}
-(void)CreatQuit{
    UIView *quitView=[[UIView alloc] initWithFrame:CGRectMake(0, 10, 30, 30)];
    UIButton *quitButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [quitButton addTarget:self action:@selector(backToRoot) forControlEvents:UIControlEventTouchUpInside];
    [quitButton setImage:[UIImage imageNamed:@"cha"] forState:UIControlStateNormal];
    quitButton.frame = CGRectMake(0, 5, 25, 25);
    [quitView addSubview:quitButton];
    
    UIBarButtonItem *TouSuButton=[[UIBarButtonItem alloc] initWithCustomView:quitView];
    self.navigationItem.rightBarButtonItem = TouSuButton;
    
    
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

//创建定时器用于实时反馈退款结果
- (void)createTimer
{
    
}

//创建视图
- (void)createUI:(NSString *)dao
{
    //定义头部图片尺寸
    NSInteger imageW = 60;
    //头部图片
    UIImageView * headImage = [[UIImageView alloc] initWithFrame:CGRectMake((SWIDTH - imageW)/2, 100, imageW, imageW)];
    
    headImage.image = [UIImage imageNamed:@"quxiao.png"];
    [self.view addSubview:headImage];
    //中部标题
    UILabel * titleLB = [[UILabel alloc] initWithFrame:CGRectMake(50, CGRectGetMaxY(headImage.frame) + 20, SWIDTH - 100, 30)];
    titleLB.text = @"行程已取消";
    titleLB.backgroundColor = [UIColor clearColor];
    titleLB.textColor = [UIColor blackColor];
    titleLB.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLB];
    
    //左侧进度图片
    UIImageView * leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(50, CGRectGetMaxY(titleLB.frame) + 25, 10, 50)];
    leftImage.image = [UIImage imageNamed:@"dian_line1.png"];
    [self.view addSubview:leftImage];
    
    //下部详情
    UILabel * detail1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftImage.frame)+10, CGRectGetMaxY(titleLB.frame) + 20, SWIDTH - 100, 20)];
    detail1.textColor = [UIColor lightGrayColor];
    detail1.font = [UIFont systemFontOfSize:14];
    detail1.backgroundColor = [UIColor clearColor];
    detail1.text = [NSString stringWithFormat:@"您的原因:%@",self.reason];
    [self.view addSubview:detail1];
    //下部详情2
    UILabel * detail2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftImage.frame)+10, CGRectGetMaxY(detail1.frame) + 20, SWIDTH - 100, 20)];
    detail2.textColor = [UIColor lightGrayColor];
    detail2.font = [UIFont systemFontOfSize:14];
    detail2.backgroundColor = [UIColor clearColor];
    detail2.text = dao;
    [self.view addSubview:detail2];

 
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
    OrderModel *curModel = [OrderModel currentOrderModel];
    if (curModel.state == 2) {  //已付款
        
        UILabel * dolabel = [[UILabel alloc] initWithFrame:CGRectMake(50, self.view.frame.size.height-70, SWIDTH - 100, 20)];
        dolabel.text = @"如已付款";
        dolabel.textAlignment = NSTextAlignmentCenter;
        dolabel.font = [UIFont systemFontOfSize:14];
        dolabel.backgroundColor = [UIColor clearColor];
        dolabel.textColor = [UIColor lightGrayColor];
        [self.view addSubview:dolabel];
        
        //定义中部提交按钮
        UIButton * submit = [[UIButton alloc] initWithFrame:CGRectMake(40, CGRectGetMaxY(dolabel.frame) + 20, SWIDTH - 80, 40)];
        submit.backgroundColor = [UIColor blueColor];
        [submit setTitle:@"申请退款" forState:UIControlStateNormal];
        [submit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [submit addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:submit];
        

    } else {
        return;
    }
    
    
    
    
  
    
}
- (void)btnClick:(UIButton *)btn
{
    /*
    /api_tourists/apply_refund
    post{
        tid：游客id
        token：游客token
        book_id：预约id
    }
    
    服务端返回{
    code: 1000 //OK
    code: 1001 //err
        message：对应的消息提示
    }
     */
    //退款请求


    tuikuanApplyController * tuikuan = [[tuikuanApplyController alloc] initWithNibName:@"tuikuanApplyController" bundle:nil];
    [self.navigationController pushViewController:tuikuan animated:YES];
    
}
+ (MBProgressHUD *) toastShow: (UIView *) view message:(NSString *) message{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    [hud hide:YES afterDelay:2];
    return hud;
}
@end
