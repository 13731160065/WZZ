//
//  WZZShowVC.m
//  FacePlayRash
//
//  Created by 王泽众 on 16/3/2.
//  Copyright © 2016年 wzz. All rights reserved.
//

#import "WZZShowVC.h"
#import "WZZVideoEditManager.h"

@interface WZZShowVC ()
{
    UIImageView * imageView;
}

@end

@implementation WZZShowVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    imageView = [[UIImageView alloc] init];
    [self.view addSubview:imageView];
    imageView.image = self.image;
    imageView.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width/self.image.size.width*self.image.size.height);
    [imageView setUserInteractionEnabled:YES];
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleImage)]];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:button];
    [button setFrame:CGRectMake(0, 20, 100, 64)];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside
     ];
}

- (void)backClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)handleImage {
    imageView.image = [[WZZVideoEditManager sharedWZZVideoEditManager] handleImageWithImage:self.image];
    imageView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height/2-[UIScreen mainScreen].bounds.size.width/imageView.image.size.width*imageView.image.size.height/2, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width/imageView.image.size.width*imageView.image.size.height);
}


@end
