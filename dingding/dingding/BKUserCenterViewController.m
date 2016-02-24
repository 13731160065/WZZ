//
//  BKUserCenterViewController.m
//  dingding
//
//  Created by CccDaxIN on 15/12/14.
//  Copyright © 2015年 rabbit. All rights reserved.
//

#import "BKUserCenterViewController.h"
#import "UserModel.h"
#import <MBProgressHUD/MBProgressHUD.h>

#import <AFNetworking/AFNetworking.h>


@interface BKUserCenterViewController () {
    
    UserCenterForm * _form;
}

@end

@implementation BKUserCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人中心";
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    UserCenterForm * form = [[UserCenterForm alloc] init];
    _form = form;
    self.formController.form = form;

    UserModel *userModel = [UserModel sharedModel];
    form.phone = userModel.phone;
    form.name = userModel.username;
    form.sex = userModel.sex;
    
    form.alipay = userModel.alipay;
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

- (void) logout{
    [[UserModel sharedModel] clearInfo];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void) submit{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *HOST = @"http://carcrm.gotoip1.com";
    NSString *PATH = @"/api_tourists/form";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    // TODO 获取并验证用户新信息
    [params setObject:[[UserModel sharedModel] token] forKey:@"token"];
    [params setObject:[[UserModel sharedModel] ID] forKey:@"id"];
    [params setObject:@"新的姓名" forKey:@"tname"];
    
    NSData *imageData = UIImageJPEGRepresentation(_form.icon, 0.001);
    
    AFHTTPRequestOperationManager *managre = [AFHTTPRequestOperationManager manager];
    
    managre.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *stringUrl = [NSString stringWithFormat:@"%@%@", HOST, PATH];
    
    [managre POST:stringUrl parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        
        [formData appendPartWithFileData:imageData name:@"userfile" fileName:fileName mimeType:@"image/png"];
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        // TODO
        NSLog(@"[INFO] %@", responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        // TODO
        NSLog(@"[INFO] %@", error.debugDescription);
        
    }];
    
    
    
    [hud hide:YES afterDelay:1];
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

@implementation UserCenterForm

- (NSArray *)fields{
    return @[
             @{FXFormFieldKey: @"icon", FXFormFieldTitle: @"头像", FXFormFieldType: FXFormFieldTypeImage},
             @{FXFormFieldKey: @"name", FXFormFieldTitle: @"姓名"},
             @{FXFormFieldKey: @"sex", FXFormFieldTitle: @"姓别", FXFormFieldOptions: [UserModel sexOptions], FXFormFieldCell: [FXFormOptionPickerCell class]},
             @{FXFormFieldKey: @"birthday", FXFormFieldTitle: @"出生年月", FXFormFieldType: FXFormFieldTypeDate},
             @{FXFormFieldKey: @"degree", FXFormFieldTitle: @"教育程度", FXFormFieldOptions: [UserModel degreeOptions], FXFormFieldCell: [FXFormOptionPickerCell class]},
             @{FXFormFieldKey: @"phone", FXFormFieldTitle: @"手机号", FXFormFieldType: FXFormFieldTypeLabel},
             @{FXFormFieldKey: @"password", FXFormFieldTitle: @"登录密码"},
             @{FXFormFieldKey: @"alipay", FXFormFieldTitle: @"支付宝账号"}
             ];
    
}

- (NSArray *)extraFields{
    return @[
             @{FXFormFieldTitle: @"保存修改",
               FXFormFieldAction: @"submit",
               FXFormFieldHeader: @""},
             @{FXFormFieldTitle: @"退出",
               FXFormFieldAction: @"logout",
               FXFormFieldHeader: @""}
             ];
}


@end