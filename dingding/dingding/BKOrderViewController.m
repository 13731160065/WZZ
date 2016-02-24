//
//  BKOrderViewController.m
//  dingding
//
//  Created by CccDaxIN on 15/12/20.
//  Copyright © 2015年 rabbit. All rights reserved.
//

#import "BKOrderViewController.h"
#import "EvaluateViewController.h"
#import "LJComplainViewController.h"
#import "cancleOrderViewController.h"
#import "ColorModel.h"
#import "OrderModel.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <UIImageView+WebCache.h>


#define SWIDTH [UIScreen mainScreen].bounds.size.width
#define SHEIGHT [UIScreen mainScreen].bounds.size.height


@interface BKOrderViewController ()<UIAlertViewDelegate>

@property (nonatomic ,strong)NSString *Gtele;

@end

@implementation BKOrderViewController

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor whiteColor];
    [super viewDidLoad];
    self.title = @"订单详情";
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    [self getGuideInfo];
    [self backBUTTON];
    
    //取消行程按钮
    UIButton * cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancleButton addTarget:self action:@selector(cancleOrder) forControlEvents:UIControlEventTouchUpInside];
    [cancleButton setTitle:@"取消行程" forState:UIControlStateNormal];
    cancleButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancleButton.frame = CGRectMake(0, 0, 70, 30);
    UIBarButtonItem *cancleBut = [[UIBarButtonItem alloc]initWithCustomView:cancleButton];
    self.navigationItem.rightBarButtonItem = cancleBut;
    
    
}
-(void)getGuideInfo{
    //获取导游的详尽信息
    [[OrderModel currentOrderModel] getGuideInfomation:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            NSMutableArray *dataARRAY = responseObject;
            NSLog(@"%@",dataARRAY);
        }else if([responseObject isKindOfClass:[NSDictionary class]]){
        
            NSMutableDictionary *datadic = [NSMutableDictionary dictionary];
            [datadic addEntriesFromDictionary:responseObject];
            NSLog(@"%@",datadic);
//            @property (weak, nonatomic) IBOutlet UIImageView *headImage;
//            @property (weak, nonatomic) IBOutlet UIImageView *isSure;
            self.guideName.text = [datadic objectForKey:@"gname"];
            self.lvxingsheName.text = [datadic objectForKey:@"company"];
            self.orderNum.text = [NSString stringWithFormat:@"%@单",[datadic objectForKey:@"total_orders"]];
            self.Gtele = [datadic objectForKey:@"mobile"];
//            [self.headImage sd_setImageWithURL:<#(NSURL *)#>];
            
            
        }
    } gid:[OrderModel currentOrderModel].navID];
    
}

-(void)cancleOrder{
    
    //取消订单
    cancleOrderViewController *cancel = [[cancleOrderViewController alloc]init];
    
    [self.navigationController pushViewController:cancel animated:YES];
    
    
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

-(void)viewWillAppear:(BOOL)animated{
    
    //如果是
    if (self.isFinisedOrder) { //支付完成
        
        UIView *finishView = [[UIView alloc]initWithFrame:CGRectMake(0, 84, SWIDTH, SHEIGHT-84-100)];
        //finishView.backgroundColor = [UIColor cyanColor];
        finishView.tag = 100;
        
        UIImageView *successImage = [[UIImageView alloc]initWithFrame:CGRectMake(SWIDTH/2-35, 0, 70, 70)];
        successImage.image = [UIImage imageNamed:@"yycg"];
        [finishView addSubview:successImage];
        
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(SWIDTH/2-50, 100, 100, 30)];
        label1.text = @"支付成功";
        label1.font = [UIFont systemFontOfSize:22];
        label1.textAlignment =  NSTextAlignmentCenter;
        label1.textColor = [ColorModel colorWithHexString:@"fb912a" alpha:1];
        [finishView addSubview:label1];
        
        UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(SWIDTH/2-100, 180, 200, 20)];
        label2.text = @"行程完成后请点击确定";
        label2.textAlignment =  NSTextAlignmentCenter;
        label2.textColor = [ColorModel colorWithHexString:@"#a7a9aa" alpha:1];
        [finishView addSubview:label2];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(SWIDTH/2-100, 250, 200, 50);
        [button addTarget:self action:@selector(orderFinished) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [ColorModel colorWithHexString:@"43b4ea" alpha:1];
        [button setTitle:@"确定" forState:UIControlStateNormal];
        [finishView addSubview:button];
        
        //推荐分享按钮
        
        
        
        
        [self.view addSubview:finishView];
    }

}

-(void)orderFinished{
    UIAlertView *alertPAY = [[UIAlertView alloc]initWithTitle:nil message:@"确定行程结束了？如果确定钱将转给导游" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertPAY show];
    
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {  //点击确定 行程结束
        BOOL guideIsSure;
        guideIsSure = YES;
        [[OrderModel currentOrderModel] getOrderState:^(id responseObject) {
            NSLog(@"%@",responseObject);
            if ([[responseObject objectForKey:@"result"]isEqualToString:@"3"]) {   //接下来的操作需要得到导游的回应 条件不明确
                
                [[OrderModel currentOrderModel] confirmPayGuide:^(NSError *error) {
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    hud.labelText = @"请稍后再点击确定";
                    hud.mode = MBProgressHUDModeText;
                    [hud hide:YES afterDelay:2];
                }];
                
                
            }else if ([[responseObject objectForKey:@"result"]isEqualToString:@"4"]){
                UIView *fView = (UIView *)[self.view viewWithTag:100];
                [fView removeFromSuperview];
                
                UIView *completeV = [[UIView alloc]initWithFrame:CGRectMake(0, 84, self.view.frame.size.width, self.view.frame.size.height-84-100)];
                //completeV.backgroundColor = [UIColor cyanColor];
                completeV.tag = 200;
                
                UIImageView *successImage = [[UIImageView alloc]initWithFrame:CGRectMake(SWIDTH/2-35, 0, 70, 70)];
                successImage.image = [UIImage imageNamed:@"yycg"];
                [completeV addSubview:successImage];
                
                UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(SWIDTH/2-50, 100, 100, 30)];
                label1.text = @"行程结束";
                label1.font = [UIFont systemFontOfSize:22];
                label1.textAlignment =  NSTextAlignmentCenter;
                label1.textColor = [ColorModel colorWithHexString:@"fb912a" alpha:1];
                [completeV addSubview:label1];
                
                UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(SWIDTH/2-100, 180, 200, 20)];
                label2.text = @"请给为您服务的导游及时给予评价";
                label2.font = [UIFont systemFontOfSize:12];
                label2.textAlignment =  NSTextAlignmentCenter;
                label2.textColor = [ColorModel colorWithHexString:@"#a7a9aa" alpha:1];
                [completeV addSubview:label2];
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake(SWIDTH/2-100, 250, 200, 50);
                [button addTarget:self action:@selector(judgement) forControlEvents:UIControlEventTouchUpInside];
                button.backgroundColor = [ColorModel colorWithHexString:@"43b4ea" alpha:1];
                [button setTitle:@"评价" forState:UIControlStateNormal];
                
                [completeV addSubview:button];
                [self.view addSubview:completeV];
            }else{  //导游未作出回应 提示
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.labelText = @"请等待导游确认再点击确定";
                hud.mode = MBProgressHUDModeText;
                [hud hide:YES afterDelay:2];
                
                
                
            }
        }];
        
        
        
    }
}


//跳转到评价页面
-(void)judgement{
    
    EvaluateViewController *Evalu = [[EvaluateViewController alloc]init];
    
    [self.navigationController pushViewController:Evalu animated:YES];
    self.isFinisedOrder = NO;
    

//
    //取消订单
//    cancleOrderViewController *cancel = [[cancleOrderViewController alloc]init];
//    
//    [self.navigationController pushViewController:cancel animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


- (IBAction)cancleOrder:(id)sender {
    cancleOrderViewController *cancleC = [[cancleOrderViewController alloc]init];
    [self.navigationController pushViewController:cancleC animated:YES];
    
    
}
- (IBAction)callGuide:(id)sender {
    NSLog(@"按了电话按键");
    NSString * PhoneNUM = self.Gtele;
    NSString * telephone = [NSString stringWithFormat:@"tel://%@",PhoneNUM];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telephone]];
    
}
@end
