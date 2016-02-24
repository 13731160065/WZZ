//
//  BKBindPayViewController.m
//  dingding
//
//  Created by CccDaxIN on 15/12/14.
//  Copyright © 2015年 rabbit. All rights reserved.
//

#import "BKBindPayViewController.h"
#import "AppDelegate.h"
#import "BKBindPayForm.h"


@interface BKBindPayViewController ()

@end

@implementation BKBindPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.formController.form = [[BKBindPayForm alloc] init];
    
    
    
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

- (void) submit{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"完成注册";
    hud.mode = MBProgressHUDModeText;
    [hud hide:YES afterDelay:1];
    
    /*注册方法没有实现！！！*/
    
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
