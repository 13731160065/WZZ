//
//  tuikuanApplyController.m
//  dingding
//
//  Created by mac on 16/1/19.
//  Copyright © 2016年 rabbit. All rights reserved.
//

#import "tuikuanApplyController.h"
#import "OrderModel.h"
#import "tuikuanSuccessViewController.h"

@interface tuikuanApplyController ()
{
    //选中1
    BOOL select1;
    //选中2
    BOOL select2;
    
}

@end

@implementation tuikuanApplyController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

- (IBAction)select1:(id)sender {
    if(select1){
        
        UIButton * btn = (UIButton *)sender;
        [btn setImage:[UIImage imageNamed:@"gou.png"] forState:UIControlStateNormal];
        select1 = NO;
        
    }else
    {
        UIButton * btn = (UIButton *)sender;
        [btn setImage:[UIImage imageNamed:@"gou_xz.png"] forState:UIControlStateNormal];
        select1 = YES;
        
    }
    
}

- (IBAction)select2:(id)sender {
    if(select2){
        
        UIButton * btn = (UIButton *)sender;
        [btn setImage:[UIImage imageNamed:@"gou.png"] forState:UIControlStateNormal];
        select2 = NO;
        
    }else
    {
        UIButton * btn = (UIButton *)sender;
        [btn setImage:[UIImage imageNamed:@"gou_xz.png"] forState:UIControlStateNormal];
        select2 = YES;
        
    }
}

- (IBAction)submit:(id)sender {
    [self showAlertView];
    
}

- (void)showAlertView
{
    UIAlertController * alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定提交吗?" preferredStyle:UIAlertControllerStyleAlert];
    
    //添加按钮
    UIAlertAction * cancelBtn = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"点击了取消按钮");
    }];
    UIAlertAction * defaultBtn = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"点击了确定按钮");
        //传递
//        select1
//        select2
        //的值
        OrderModel * curOrderModel = [OrderModel currentOrderModel];
        if (curOrderModel.state != 0) { //没付款
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText =@"您没付款";
            [hud hide:YES afterDelay:2];
            return;
        }
        
        [curOrderModel refund:^(NSError *error) {
            //跳转
            tuikuanSuccessViewController * success = [[tuikuanSuccessViewController alloc] initWithNibName:@"tuikuanSuccessViewController" bundle:nil];
            [self.navigationController pushViewController:success animated:YES];
        } why:@"reason"];
    }];

        
        
   
    
    //将按钮添加到弹框上
    [alertC addAction:cancelBtn];
    [alertC addAction:defaultBtn];
    //显示到屏幕上
    [self presentViewController:alertC animated:YES completion:nil];
}
@end
