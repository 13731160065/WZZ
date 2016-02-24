//
//  BKRegestViewController.m
//  dingding
//
//  Created by CccDaxIN on 15/12/14.
//  Copyright © 2015年 rabbit. All rights reserved.
//

#import "BKRegestViewController.h"
#import "BKFormRegest.h"
#import "UserModel.h"

#import "OrderModel.h"


@interface BKRegestViewController ()

@end

@implementation BKRegestViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.formController.form = [[BKFormRegest alloc] init];
    
    
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





/** 获取验证码 **/
- (void) getCode{
    
    BKFormRegest *  form = (BKFormRegest*) self.formController.form;
    
    double phoneNum = [form.phone doubleValue];
    
    NSLog(@"%f,===%@",phoneNum,@(phoneNum));
    
    NSNumber *NUB = [NSNumber numberWithDouble:phoneNum];
    [[OrderModel currentOrderModel]  get_vcode:^(id responseObject) {
    
        NSLog(@"%@",responseObject);
        
    } phoneNumber:NUB];
    
//    [[OrderModel currentOrderModel] get_vcode:^(NSError *error) {
//        
//        NSLog(@"zou A");
//    } phoneNumber:@(phoneNum) returnBlock:^(id responseObject) {
//        NSLog(@"zou B");
//    }];
    
    
    
}

/** 注册 **/
- (void) submit{
    UserModel *userModel = [UserModel sharedModel];
    
    [self performSegueWithIdentifier:@"regest2fillInfo" sender:nil];
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

@end
