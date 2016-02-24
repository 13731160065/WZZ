//
//  notBuildViewController.m
//  dingding
//
//  Created by mac on 16/1/26.
//  Copyright © 2016年 rabbit. All rights reserved.
//

#import "notBuildViewController.h"


#define SHEIGHT [UIScreen mainScreen].bounds.size.height
#define SWIDTH [UIScreen mainScreen].bounds.size.width

@interface notBuildViewController ()

@end

@implementation notBuildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"敬请关注";
    UIColor * color = [UIColor whiteColor];
    
    NSDictionary * dict = [NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
    
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    [self CreatUI];
    [self backBUTTON];
}
-(void)CreatUI{

    //添加头部图片
    UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake((SWIDTH - 60)/2, 120, 60, 60)];
    image.layer.cornerRadius = 25;
    image.image = [UIImage imageNamed:@"dengdai.png"];
    image.clipsToBounds = YES;
    [self.view addSubview:image];
    
    //
    UILabel * label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(image.frame) + 10, SWIDTH, 20)];
    label1.text = @"系统功能升级中";
    label1.textAlignment = NSTextAlignmentCenter;
    label1.font = [UIFont systemFontOfSize:14];
    label1.textColor = [UIColor darkGrayColor];
    [self.view addSubview:label1];
    
    UILabel * label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label1.frame), SWIDTH, 20)];
    label2.text = @"近期开放  敬请期待";
    label2.textAlignment = NSTextAlignmentCenter;
    label2.font = [UIFont systemFontOfSize:14];
    label2.textColor = [UIColor darkGrayColor];
    [self.view addSubview:label2];
    
    

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

@end
