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

@interface ViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    NSMutableArray * arr;
    UIImageView * imgv;
}

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    arr = [NSMutableArray array];
    NSLog(@"%@", NSHomeDirectory());
    
    imgv = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [self.view addSubview:imgv];
    [imgv setBackgroundColor:[UIColor yellowColor]];
    imgv.animationDuration = 6;
    imgv.animationRepeatCount = 0;
    [imgv setUserInteractionEnabled:YES];
    [imgv addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgvClick)]];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:button];
    [button setTitle:@"相机" forState:UIControlStateNormal];
    [button setFrame:CGRectMake(100, 200, 100, 100)];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:button2];
    [button2 setTitle:@"相册" forState:UIControlStateNormal];
    [button2 setFrame:CGRectMake(100, 300, 100, 100)];
    [button2 addTarget:self action:@selector(buttonClick2:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)imgvClick {
    [self run];
}

- (void)buttonClick:(UIButton *)button {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    //相机
    //设定sourceType为相机
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    //然后判断相机是否可用
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        NSLog(@"您的相机不可用");
        return;
    }
    imagePicker.sourceType = sourceType;
    [self presentViewController:imagePicker animated:YES completion:nil];//进入照相界面
    
}

- (void)buttonClick2:(UIButton *)button {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    //相册
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:imagePicker.sourceType];
    }
    imagePicker.mediaTypes = @[@"public.image"];
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}

- (void)run {
#if 1//视频拆分和合并
    NSString *urlAsString = [NSString stringWithFormat:@"%@/Documents/asdf.m4v", NSHomeDirectory()];
    NSURL    *url = [NSURL fileURLWithPath:urlAsString];
    //调用方法
    [[WZZVideoEditManager sharedWZZVideoEditManager] video2ImagesWithURL:url progress:^(NSInteger progress) {
        NSLog(@"%ld%%", (long)progress);
    } finishBlock:^(NSMutableArray <UIImage *>* imagesArr) {
        NSLog(@"%@", imagesArr);
        imgv.animationImages = imagesArr;
        [imagesArr enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [imagesArr replaceObjectAtIndex:idx withObject:[[WZZVideoEditManager sharedWZZVideoEditManager] remixImageWithBackImage:obj image2:[UIImage imageNamed:@"dog.gif"]]];
//            [imagesArr replaceObjectAtIndex:idx withObject:[[WZZVideoEditManager sharedWZZVideoEditManager] processImage:obj faceModel:[[WZZVideoEditManager sharedWZZVideoEditManager] getOriginWithImage:obj]]];
        }];
        [imgv startAnimating];
        [[WZZVideoEditManager sharedWZZVideoEditManager] images2VideoWithImageArr:imagesArr];
    }];
#else//图像处理
    [[WZZVideoEditManager sharedWZZVideoEditManager] getOriginWithImage:[UIImage imageNamed:@"me"]];
#endif
}

#pragma mark - 图片选择器代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:^{
        WZZShowVC * show = [[WZZShowVC alloc] init];
        show.image = image;
        [self presentViewController:show animated:YES completion:nil];
    }];
}

@end
