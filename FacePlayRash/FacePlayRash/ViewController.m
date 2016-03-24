//
//  ViewController.m
//  FacePlayRash
//
//  Created by 王泽众 on 16/2/25.
//  Copyright © 2016年 wzz. All rights reserved.
//

#import "ViewController.h"
#import "WZZVideoEditManager.h"
#import "WZZShowVC.h"
#import "WZZEditVideoVC.h"
#import "WZZEditImageVC.h"

@interface ViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    NSMutableArray * arr;
    UIImageView * imgv;
    BOOL isVideo;
}

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar removeFromSuperview];
    
    arr = [NSMutableArray array];
    NSLog(@"%@", NSHomeDirectory());
    
    imgv = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-50, 100, 100, 100)];
    [self.view addSubview:imgv];
    [imgv setImage:[UIImage imageNamed:@"videog"]];
    [imgv setUserInteractionEnabled:YES];
    [imgv addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgvClick)]];
    
    UIImageView * button2 = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-50, CGRectGetMaxY(imgv.frame)+100, 100, 100)];
    [self.view addSubview:button2];
    [button2 setImage:[UIImage imageNamed:@"imageg"]];
    [button2 setUserInteractionEnabled:YES];
    [button2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonClick2)]];
}

- (void)imgvClick {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    //相册
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:imagePicker.sourceType];
    }
    imagePicker.mediaTypes = @[@"public.movie"];
    isVideo = YES;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)buttonClick2 {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    //相册
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:imagePicker.sourceType];
    }
    imagePicker.mediaTypes = @[@"public.image"];
    isVideo = NO;
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}


#pragma mark - 图片选择器代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissViewControllerAnimated:YES completion:^{
        if (isVideo) {
            WZZEditVideoVC  * edit = [[WZZEditVideoVC alloc] init];
            edit.videoUrl = info[UIImagePickerControllerMediaURL];
            [self.navigationController pushViewController:edit animated:YES];
        } else {
            WZZEditImageVC * edit = [[WZZEditImageVC alloc] init];
            edit.uploadImage = info[UIImagePickerControllerOriginalImage];
            [self.navigationController pushViewController:edit animated:YES];
        }
    }];
}

@end
