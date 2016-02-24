//
//  BKRootViewController.m
//  dingding
//
//  Created by CccDaxIN on 15/10/15.
//  Copyright © 2015年 rabbit. All rights reserved.
//

#import "BKRootViewController.h"
#import "BKRegestViewController.h"
#import "BKLoginViewController.h"

#import <Masonry/Masonry.h>
#import "LLSlideMenu.h"
#import "OrderModel.h"                   //当前订单
#import "UserModel.h"

@interface BKRootViewController (){
    UIView * _slideView;
    LLSlideMenu * _slideMenu;
    OrderModel * _orderModel;
}
@end

@implementation BKRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationController.navigationBarHidden = YES;
    
    UIButton *iconButton = [UIButton buttonWithType:UIButtonTypeSystem];
    iconButton.frame = CGRectMake(40, 104, 40, 40);
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    icon.image = [UIImage imageNamed:@"huiyuan"];
    
    
    [iconButton addSubview:icon];
    [self.view addSubview:iconButton];
    [iconButton addTarget:self action:@selector(iconOnClickHandler:) forControlEvents:UIControlEventTouchUpInside];
    
    self.title = @"滴滴导游";
    
    
    

    

    _slideView = [[UIView alloc] init];
    _slideView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_slideView];
    [_slideView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
//    _slideMenu = [[LLSlideMenu alloc] init];
//    [self.view addSubview:_slideMenu];
    
    _slideView.userInteractionEnabled = YES;
    UIGestureRecognizer *tapGesture = [[UIGestureRecognizer alloc] initWithTarget:self action:@selector(slideViewHideHandler)];
    [_slideView addGestureRecognizer:tapGesture];
    [self initOrderModelView];
}

- (void) initOrderModelView {
    UserModel *userModel = [UserModel sharedModel];
    if (!userModel.token) {
        // 未登录，进入 登录界面
        BKLoginViewController *loginV = [[BKLoginViewController alloc]init];
      [self.navigationController pushViewController:loginV animated:YES];
        
    }
    
}

- (void) slideViewHideHandler{
    [_slideView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_left);
    }];
}

- (void) iconOnClickHandler:(UIButton *) logoButton {
    
    BOOL userLoginEd = false;
    
    if (userLoginEd) {  // 用户未登录
        [self.navigationController pushViewController:[[BKLoginViewController alloc] init] animated:YES];
    } else {
        
    }
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
