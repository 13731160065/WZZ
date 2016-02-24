//
//  OrderPayViewController.m
//  dingding
//
//  Created by mac on 16/1/9.
//  Copyright © 2016年 rabbit. All rights reserved.
//  订单支付界面

#import "OrderPayViewController.h"
#import "BKOrderViewController.h"
#import "OrderModel.h"

@interface OrderPayViewController ()

@end

@implementation OrderPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)toPay:(id)sender {
    //点击支付按钮
    
    [[OrderModel currentOrderModel] payOrder:^(NSError *error) {
        NSLog(@"这里是回调？？");
        
        
        //订单支付结束跳转方法 暂时写在这里 应该写在导游结束的位置
        BKOrderViewController * OrderVC = [[BKOrderViewController alloc]init];
        OrderVC.isFinisedOrder = YES;
        OrderVC.navigationController.title = @"订单详情";
        [self.navigationController pushViewController:OrderVC animated:YES];
        
        
    } price:@([self.priceNUM.text floatValue])];
    
    
    
}
@end
