//
//  WZZEditVideoVC.m
//  FacePlayRash
//
//  Created by 王泽众 on 16/3/4.
//  Copyright © 2016年 wzz. All rights reserved.
//

#import "WZZEditVideoVC.h"
#import "WZZVideoEditManager.h"

@interface WZZEditVideoVC ()
{
    NSMutableArray <UIImage *>* sourceImageArr;
    NSMutableArray <UIImage *>* editImageArr;
    NSMutableArray * sourceFaceArr;
    NSMutableArray * editFaceArr;
    UIImageView * imageView;
    UISlider * slider;
    UIButton * editButton;
    NSInteger currentImageIdx;
    UIImage * topImage;
    UIImageView * tmpImageView;
    UIImageView * tmpFaceImageView;
}

@end

@implementation WZZEditVideoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:imageView];
    imageView.userInteractionEnabled = YES;
    
    slider = [[UISlider alloc] initWithFrame:CGRectMake(50, [UIScreen mainScreen].bounds.size.height-50, [UIScreen mainScreen].bounds.size.width-100, 10)];
    [imageView addSubview:slider];
    [slider addTarget:self action:@selector(sliderClick:) forControlEvents:UIControlEventValueChanged];

    editButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [imageView addSubview:editButton];
    [editButton setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-50, 20, 50, 30)];
    [editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(editClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * lastButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [imageView addSubview:lastButton];
    [lastButton setFrame:CGRectMake(50, 20, 50, 30)];
    [lastButton setTitle:@"上一帧" forState:UIControlStateNormal];
    [lastButton addTarget:self action:@selector(lastButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * nextButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [imageView addSubview:nextButton];
    [nextButton setFrame:CGRectMake(CGRectGetMaxX(lastButton.frame)+50, 20, 50, 30)];
    [nextButton setTitle:@"下一帧" forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self loadData];
}

- (void)editClick:(UIButton *)button {
    tmpImageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:tmpImageView];
    tmpImageView.image = sourceImageArr[currentImageIdx];
    tmpImageView.userInteractionEnabled = YES;
    
    //退出
    UIButton * returnButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [tmpImageView addSubview:returnButton];
    [returnButton setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-50, 20, 50, 30)];
    [returnButton setTitle:@"完成" forState:UIControlStateNormal];
    [returnButton addTarget:self action:@selector(returnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage * image = sourceImageArr[currentImageIdx];
    WZZFaceModel * model = (WZZFaceModel *)sourceFaceArr[currentImageIdx];
    CGFloat piix = [UIScreen mainScreen].bounds.size.width/image.size.width;
    CGRect rect = CGRectMake(model.frame.origin.x*piix, model.frame.origin.y*piix, model.frame.size.width*piix, model.frame.size.height*piix);
    
    tmpFaceImageView = [[UIImageView alloc] initWithFrame:rect];
    [tmpImageView addSubview:tmpFaceImageView];
    tmpFaceImageView.userInteractionEnabled = YES;
    tmpFaceImageView.image = topImage;
    [tmpFaceImageView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panImage:)]];
    [tmpFaceImageView addGestureRecognizer:[[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationTapGR:)]];
    [tmpFaceImageView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchTapGR:)]];
}

- (void)pinchTapGR:(UIPinchGestureRecognizer *)tap{
    tap.view.transform = CGAffineTransformScale(tap.view.transform, tap.scale, tap.scale);
    tap.scale = 1.0;//以上一次的缩放比例为准
}

- (void)rotationTapGR:(UIRotationGestureRecognizer *)tap{
    tap.view.transform = CGAffineTransformRotate(tap.view.transform, tap.rotation);
    tap.rotation = 0;//清空上次旋转的角度
}

- (void)panImage:(UIPanGestureRecognizer *)pan {
    CGPoint point = [pan translationInView:pan.view];
    CGPoint tempCenter = pan.view.center;
    tempCenter.x += point.x;
    tempCenter.y += point.y;
    pan.view.center = tempCenter;
    [pan setTranslation:CGPointMake(0, 0) inView:pan.view];
}

- (void)sliderClick:(UISlider *)aSlider {
    currentImageIdx = (NSInteger)aSlider.value;
    imageView.image = editImageArr[currentImageIdx];
}

- (void)returnClick:(UIButton *)button {
    UIImage * image = [[WZZVideoEditManager sharedWZZVideoEditManager] remixImageWithBackImage:sourceImageArr[currentImageIdx] image2:topImage faceRect:tmpFaceImageView.frame];
    [editImageArr replaceObjectAtIndex:currentImageIdx withObject:image];
    imageView.image = image;
    [tmpImageView removeFromSuperview];
}

- (void)lastButtonClick {
    if (currentImageIdx > 0) {
        imageView.image = editImageArr[--currentImageIdx];
    }
}

- (void)nextButtonClick {
    if (currentImageIdx < editImageArr.count-1) {
        imageView.image = editImageArr[++currentImageIdx];
    }
}

- (void)loadData {
    sourceImageArr = [NSMutableArray array];
    editImageArr = [NSMutableArray array];
    sourceFaceArr = [NSMutableArray array];
    editFaceArr = [NSMutableArray array];
    
    NSLog(@"开始拆分视频");
    //初始化源图片数组
    NSString *urlAsString = [NSString stringWithFormat:@"%@/Documents/asdf.m4v", NSHomeDirectory()];
    NSURL    *url = [NSURL fileURLWithPath:urlAsString];
    [[WZZVideoEditManager sharedWZZVideoEditManager] video2ImagesWithURL:url progress:^(NSInteger progress) {
        NSLog(@"%ld", progress);
    } finishBlock:^(NSMutableArray<UIImage *> *imagesArr) {
        [sourceImageArr addObjectsFromArray:imagesArr];
        //初始化遮盖
        topImage = [UIImage imageNamed:@"dog.gif"];
        
        NSLog(@"开始识别人脸");
        //初始化识别后图片数组
        [sourceImageArr enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            double aaa = (double)editImageArr.count/(double)sourceImageArr.count*100.0f;
            NSLog(@"%lf", aaa);
            UIImage * image = [[WZZVideoEditManager sharedWZZVideoEditManager] remixImageWithBackImage:obj image2:topImage returnFaceModelBlock:^(WZZFaceModel *faceModel) {
                if (!faceModel) {
                    faceModel = [[WZZFaceModel alloc] init];
                }
                [sourceFaceArr addObject:faceModel];
            }];
            if (!image) {
                image = sourceImageArr[idx];
            }
            [editImageArr addObject:image];
        }];
        NSLog(@"处理完成");
        dispatch_async(dispatch_get_main_queue(), ^{
            imageView.image = editImageArr[0];
            slider.maximumValue = editImageArr.count-1;
        });
    }];
    
    
}


@end
