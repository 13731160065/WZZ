//
//  ViewController.m
//  FacePlayRash
//
//  Created by 王泽众 on 16/2/25.
//  Copyright © 2016年 wzz. All rights reserved.
//

#import "ViewController.h"
#import "WZZVideoEditManager.h"

@interface ViewController (){
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
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
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
            [imagesArr replaceObjectAtIndex:idx withObject:[[WZZVideoEditManager sharedWZZVideoEditManager] processImage:obj faceModel:[[WZZVideoEditManager sharedWZZVideoEditManager] getOriginWithImage:obj]]];
        }];
        [imgv startAnimating];
        [[WZZVideoEditManager sharedWZZVideoEditManager] images2VideoWithImageArr:imagesArr];
    }];
#else//图像处理
    [[WZZVideoEditManager sharedWZZVideoEditManager] getOriginWithImage:[UIImage imageNamed:@"me"]];
#endif
}

@end
