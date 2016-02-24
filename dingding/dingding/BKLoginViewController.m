//
//  BKLoginViewController.m
//  dingding
//
//  Created by CccDaxIN on 15/10/15.
//  Copyright © 2015年 rabbit. All rights reserved.
//

#import "BKLoginViewController.h"
#import "BKLoginForm.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <AFNetworking/AFNetworking.h>
#import "UserModel.h"
#import "Prefix.pch"

@interface BKLoginViewController (){
    BKLoginForm *_form;
}
@end

@implementation BKLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _form = [[BKLoginForm alloc] init];
    self.formController.form = _form;
    _form.phone = @"18612345671";
    _form.password = @"123456";
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
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.formController.tableView reloadData];
}

- (void) requestPassword{
    [self performSegueWithIdentifier:@"login2requestPassword" sender:nil];
}

- (void) submitLoginForm {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.mode = MBProgressHUDModeText;
    
    BOOL isCheck = true;
    
    if (!_form.password || _form.password.length < 4) {
        hud.labelText = @"请输入正确的密码";
        isCheck = false;
    }
    
    if (!_form.phone || _form.phone.length < 10) {
        hud.labelText = @"请输入正确的手机号";
        isCheck = false;
    }
    
    if (!isCheck) {
        [hud hide:YES afterDelay:1];
        return;
    }
    
    NSDictionary * params = @{
                              @"mobile": _form.phone,
                              @"password": _form.password
                              };
    
    
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.labelText = @"正在登录";
    
    NSString *HOST = @"http://carcrm.gotoip1.com";
    NSString *PATH = @"/api_tourists/login";
    
    NSString *url = [NSString stringWithFormat:@"%@%@", HOST, PATH];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [MobClick profileSignInWithPUID:_form.phone];
    
    [manager POST:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"%s %@", __func__, [responseObject debugDescription]);
        
        if ([[responseObject objectForKey:@"code"] intValue] == 1000) {
            @try {
                UserModel * userModel = [UserModel sharedModel];
                [userModel syncWithResponse:responseObject];
                
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setValue:[responseObject objectForKey:@"tname"] forKey:@"tname"];
                [dic setValue:[responseObject objectForKey:@"mobile"] forKey:@"mobile"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"updateUser" object:dic];
                
            }
            @catch (NSException *exception) {
                hud.labelText = @"登录失败，请稍后重试";
                [hud hide:YES afterDelay:1];
            }
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else {
            hud.labelText = [responseObject objectForKey:@"message"];
            [hud hide:YES afterDelay:1];
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        hud.labelText = @"网络错误，请稍后重试";
        [hud hide:YES afterDelay:1];
    }];
}

- (void) regestForm{
    [self performSegueWithIdentifier:@"login2regest" sender:nil];
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
