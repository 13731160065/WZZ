//
//  WZZEditVideoVC.m
//  FacePlayRash
//
//  Created by 王泽众 on 16/3/4.
//  Copyright © 2016年 wzz. All rights reserved.
//

#import "WZZEditVideoVC.h"
#import "WZZVideoEditManager.h"
#import "WZZMutableArray.h"

#define sourceImageArr @"sourceImageArr"
#define editImageArr @"editImageArr"

@interface WZZEditVideoVC ()<UITextFieldDelegate>
{
//    NSMutableArray <UIImage *>* sourceImageArr;
//    NSMutableArray <UIImage *>* editImageArr;
    NSMutableArray * sourceFaceArr;
    NSMutableArray * editFaceArr;
    UIImageView * imageView;
    UISlider * slider;
    UIButton * editButton;
    NSInteger currentImageIdx;
    UIImage * topImage;
    UIView * tmpView;
    UIImageView * tmpImageView;
    UIImageView * tmpFaceImageView;
    NSInteger zhen;
    UIButton * edit10Button;
    UITextField * textField10;
}

@end

@implementation WZZEditVideoVC

//视图加载
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:imageView];
    imageView.userInteractionEnabled = YES;
    
    zhen = 10;
    
    slider = [[UISlider alloc] initWithFrame:CGRectMake(50, [UIScreen mainScreen].bounds.size.height-50, [UIScreen mainScreen].bounds.size.width-100, 10)];
    [self.view addSubview:slider];
    [slider addTarget:self action:@selector(sliderClick:) forControlEvents:UIControlEventValueChanged];

    editButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:editButton];
    [editButton setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-50, 20, 50, 30)];
    [editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(editClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * lastButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:lastButton];
    [lastButton setFrame:CGRectMake(50, 20, 50, 30)];
    [lastButton setTitle:@"上一帧" forState:UIControlStateNormal];
    [lastButton addTarget:self action:@selector(lastButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * nextButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:nextButton];
    [nextButton setFrame:CGRectMake(CGRectGetMaxX(lastButton.frame)+50, 20, 50, 30)];
    [nextButton setTitle:@"下一帧" forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * playButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:playButton];
    [playButton setFrame:CGRectMake(50, 70, 100, 30)];
    [playButton setTitle:@"合成视频" forState:UIControlStateNormal];
    [playButton addTarget:self action:@selector(playButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    edit10Button = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:edit10Button];
    [edit10Button setFrame:CGRectMake(CGRectGetMaxX(nextButton.frame), 70, 100, 30)];
    [edit10Button setTitle:@"编辑10帧" forState:UIControlStateNormal];
    [edit10Button addTarget:self action:@selector(edit10ButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    textField10 = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nextButton.frame), 70+50, 100, 30)];
    [self.view addSubview:textField10];
    textField10.delegate = self;
    [textField10 setBackgroundColor:[UIColor cyanColor]];
    
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:backButton];
    [backButton setFrame:CGRectMake(50, 70+50, 100, 30)];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self loadData];
}

//输入框代理
- (void)textFieldDidEndEditing:(UITextField *)textField {
    zhen = [textField10.text integerValue];
    [edit10Button setTitle:[NSString stringWithFormat:@"编辑%ld帧", zhen] forState:UIControlStateNormal];
}

//输入框结束
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [textField10 resignFirstResponder];
}

//返回
- (void)backButtonClick {
    [[WZZMutableArray shareWZZMutableArray] releaseAllArr];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//编辑十帧
- (void)edit10ButtonClick {
    tmpView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:tmpView];
    [tmpView setBackgroundColor:[UIColor whiteColor]];
    
    //编辑10帧
    tmpImageView = [[UIImageView alloc] initWithFrame:imageView.frame];
    [tmpView addSubview:tmpImageView];
    //    tmpImageView.image = sourceImageArr[currentImageIdx];
    tmpImageView.image = [[WZZMutableArray shareWZZMutableArray] imageWithIndex:currentImageIdx arrName:sourceImageArr];
    tmpImageView.userInteractionEnabled = YES;
    [tmpImageView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panImage:)]];
    [tmpImageView addGestureRecognizer:[[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationTapGR:)]];
    [tmpImageView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchTapGR:)]];
    
    //退出
    UIButton * returnButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [tmpView addSubview:returnButton];
    [returnButton setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-50, 20, 50, 30)];
    [returnButton setTitle:@"完成" forState:UIControlStateNormal];
    [returnButton addTarget:self action:@selector(returnClick:) forControlEvents:UIControlEventTouchUpInside];
    returnButton.tag = 1000;
    
    //插入头像
    UIButton * insertFaceButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [tmpView addSubview:insertFaceButton];
    [insertFaceButton setFrame:CGRectMake(0, 20, 50, 30)];
    [insertFaceButton setTitle:@"添加" forState:UIControlStateNormal];
    [insertFaceButton addTarget:self action:@selector(insertFaceButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //    UIImage * image = sourceImageArr[currentImageIdx];
    UIImage * image = [[WZZMutableArray shareWZZMutableArray] imageWithIndex:currentImageIdx arrName:sourceImageArr];
    WZZFaceModel * model = (WZZFaceModel *)sourceFaceArr[currentImageIdx];
    CGFloat piix = [UIScreen mainScreen].bounds.size.width/image.size.width;
    CGFloat w = model.frame.size.width;
    CGFloat h = w/topImage.size.width*topImage.size.height;
    CGRect rect = CGRectMake(model.frame.origin.x*piix, model.frame.origin.y*piix, w*piix, h*piix);
    
    tmpFaceImageView = [[UIImageView alloc] initWithFrame:rect];
    [tmpImageView addSubview:tmpFaceImageView];
    tmpFaceImageView.userInteractionEnabled = YES;
    tmpFaceImageView.image = topImage;
    [tmpFaceImageView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panImage:)]];
    [tmpFaceImageView addGestureRecognizer:[[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationTapGR:)]];
    [tmpFaceImageView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchTapGR:)]];
}

//合成视频
- (void)playButtonClick {
    //预览
    [[WZZVideoEditManager sharedWZZVideoEditManager] images2VideoWithImageArrName:editImageArr complete:^(NSURL *okURL) {
        
        [[WZZVideoEditManager sharedWZZVideoEditManager] remixVideoAndAudioWithVideoURL:okURL audioURL:_videoUrl fileName:@"aaa" complete:^(NSURL *okURL) {
            [[WZZMutableArray shareWZZMutableArray] releaseArrWithName:editImageArr success:nil failed:nil];
        }];
        
    }];
}

//编辑
- (void)editClick:(UIButton *)button {
    tmpView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:tmpView];
    [tmpView setBackgroundColor:[UIColor whiteColor]];
    
    //编辑
    tmpImageView = [[UIImageView alloc] initWithFrame:imageView.frame];
    [tmpView addSubview:tmpImageView];
    //    tmpImageView.image = sourceImageArr[currentImageIdx];
    tmpImageView.image = [[WZZMutableArray shareWZZMutableArray] imageWithIndex:currentImageIdx arrName:sourceImageArr];
    tmpImageView.userInteractionEnabled = YES;
    [tmpImageView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panImage:)]];
    [tmpImageView addGestureRecognizer:[[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationTapGR:)]];
    [tmpImageView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchTapGR:)]];
    
    //退出
    UIButton * returnButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [tmpView addSubview:returnButton];
    [returnButton setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-50, 20, 50, 30)];
    [returnButton setTitle:@"完成" forState:UIControlStateNormal];
    [returnButton addTarget:self action:@selector(returnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //插入头像
    UIButton * insertFaceButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [tmpView addSubview:insertFaceButton];
    [insertFaceButton setFrame:CGRectMake(0, 20, 50, 30)];
    [insertFaceButton setTitle:@"添加" forState:UIControlStateNormal];
    [insertFaceButton addTarget:self action:@selector(insertFaceButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
//    UIImage * image = sourceImageArr[currentImageIdx];
    UIImage * image = [[WZZMutableArray shareWZZMutableArray] imageWithIndex:currentImageIdx arrName:sourceImageArr];
    WZZFaceModel * model = (WZZFaceModel *)sourceFaceArr[currentImageIdx];
    CGFloat piix = [UIScreen mainScreen].bounds.size.width/image.size.width;
    CGFloat w = model.frame.size.width;
    CGFloat h = w/topImage.size.width*topImage.size.height;
    CGRect rect = CGRectMake(model.frame.origin.x*piix, model.frame.origin.y*piix, w*piix, h*piix);
    
    tmpFaceImageView = [[UIImageView alloc] initWithFrame:rect];
    [tmpImageView addSubview:tmpFaceImageView];
    tmpFaceImageView.userInteractionEnabled = YES;
    tmpFaceImageView.image = topImage;
    [tmpFaceImageView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panImage:)]];
    [tmpFaceImageView addGestureRecognizer:[[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationTapGR:)]];
    [tmpFaceImageView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchTapGR:)]];
    [tmpFaceImageView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGR:)]];
}

//添加头像
- (void)insertFaceButtonClick:(UIButton *)btn {
    //添加
    [tmpFaceImageView removeFromSuperview];
    tmpFaceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width/4, [UIScreen mainScreen].bounds.size.width/4/topImage.size.width*topImage.size.height)];
    [tmpFaceImageView setCenter:tmpImageView.center];
    [tmpFaceImageView setImage:topImage];
    [tmpFaceImageView setUserInteractionEnabled:YES];
    [tmpImageView addSubview:tmpFaceImageView];
    [tmpFaceImageView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panImage:)]];
    [tmpFaceImageView addGestureRecognizer:[[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationTapGR:)]];
    [tmpFaceImageView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchTapGR:)]];
    [tmpFaceImageView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGR:)]];
}

//长按删除
- (void)longGR:(UILongPressGestureRecognizer *)tap {
    [tmpFaceImageView removeFromSuperview];
}

//捏合
- (void)pinchTapGR:(UIPinchGestureRecognizer *)tap{
    tap.view.transform = CGAffineTransformScale(tap.view.transform, tap.scale, tap.scale);
    tap.scale = 1.0;//以上一次的缩放比例为准
}

//旋转
- (void)rotationTapGR:(UIRotationGestureRecognizer *)tap{
    tap.view.transform = CGAffineTransformRotate(tap.view.transform, tap.rotation);
    tap.rotation = 0;//清空上次旋转的角度
}

//拖拽
- (void)panImage:(UIPanGestureRecognizer *)pan {
    CGPoint point = [pan translationInView:pan.view];
    CGPoint tempCenter = pan.view.center;
    tempCenter.x += point.x;
    tempCenter.y += point.y;
    pan.view.center = tempCenter;
    [pan setTranslation:CGPointMake(0, 0) inView:pan.view];
}

//进度条事件
- (void)sliderClick:(UISlider *)aSlider {
    currentImageIdx = (NSInteger)aSlider.value;
//    imageView.image = editImageArr[currentImageIdx];
    imageView.image = [[WZZMutableArray shareWZZMutableArray] imageWithIndex:currentImageIdx arrName:editImageArr];
}

//完成编辑
- (void)returnClick:(UIButton *)button {
    if (button.tag == 1000) {
        UIImage * image = [[WZZVideoEditManager sharedWZZVideoEditManager] remixImageWithBackImage:[[WZZMutableArray shareWZZMutableArray] imageWithIndex:currentImageIdx arrName:sourceImageArr] image2:topImage faceRect:tmpFaceImageView.frame];
        [[WZZMutableArray shareWZZMutableArray] replacementImage:image atIndex:currentImageIdx arrName:editImageArr success:nil failed:nil];
        imageView.image = image;
        
        for (int i = 1; i < zhen; i++) {
            if (currentImageIdx+i >= [[WZZMutableArray shareWZZMutableArray] countWithName:sourceImageArr]) {
                return;
            }
            UIImage * image = [[WZZVideoEditManager sharedWZZVideoEditManager] remixImageWithBackImage:[[WZZMutableArray shareWZZMutableArray] imageWithIndex:currentImageIdx+i arrName:sourceImageArr] image2:topImage faceRect:tmpFaceImageView.frame];
            [[WZZMutableArray shareWZZMutableArray] replacementImage:image atIndex:currentImageIdx+i arrName:editImageArr success:nil failed:nil];
        }
        [tmpView removeFromSuperview];
        
        return;
    }
//    UIImage * image = [[WZZVideoEditManager sharedWZZVideoEditManager] remixImageWithBackImage:sourceImageArr[currentImageIdx] image2:topImage faceRect:tmpFaceImageView.frame];
//    [editImageArr replaceObjectAtIndex:currentImageIdx withObject:image];
    UIImage * image = [[WZZVideoEditManager sharedWZZVideoEditManager] remixImageWithBackImage:[[WZZMutableArray shareWZZMutableArray] imageWithIndex:currentImageIdx arrName:sourceImageArr] image2:topImage faceRect:tmpFaceImageView.frame];
    [[WZZMutableArray shareWZZMutableArray] replacementImage:image atIndex:currentImageIdx arrName:editImageArr success:nil failed:nil];
    imageView.image = image;
    [tmpView removeFromSuperview];
}

//下一页
- (void)lastButtonClick {
    if (currentImageIdx > 0) {
        --currentImageIdx;
        slider.value = currentImageIdx;
        [self sliderClick:slider];
    }
}

//上一页
- (void)nextButtonClick {
//    if (currentImageIdx < editImageArr.count-1) {
    if (currentImageIdx < [[WZZMutableArray shareWZZMutableArray] countWithName:editImageArr]-1) {
        ++currentImageIdx;
        slider.value = currentImageIdx;
        [self sliderClick:slider];
    }
}

//加载数据
- (void)loadData {
//    sourceImageArr = [NSMutableArray array];
//    editImageArr = [NSMutableArray array];
    sourceFaceArr = [NSMutableArray array];
    editFaceArr = [NSMutableArray array];
    
    [[WZZMutableArray shareWZZMutableArray] arrayWithName:sourceImageArr success:nil failed:nil];
    [[WZZMutableArray shareWZZMutableArray] arrayWithName:editImageArr success:nil failed:nil];
    
    NSLog(@"开始拆分视频");
    //初始化源图片数组
    NSString *urlAsString = [NSString stringWithFormat:@"%@/Documents/asdf.m4v", NSHomeDirectory()];
    NSURL    *url = [NSURL fileURLWithPath:urlAsString];
    
    [[WZZVideoEditManager sharedWZZVideoEditManager] video2ImagesWithURL:_videoUrl progress:^(NSInteger progress) {
        NSLog(@"%ld", progress);
    } finishBlock:^() {
//        [sourceImageArr addObjectsFromArray:imagesArr];
        NSInteger inte = [[WZZMutableArray shareWZZMutableArray] countWithName:IMAGESARRAY];
        for (NSInteger i = 0; i < inte; i++) {
            @autoreleasepool {
                [[WZZMutableArray shareWZZMutableArray] addImage:[[WZZMutableArray shareWZZMutableArray] imageWithIndex:i arrName:IMAGESARRAY] arrName:sourceImageArr success:nil failed:nil];
            }
        }
        
        [[WZZMutableArray shareWZZMutableArray] copyArrayWithSourceArrayName:IMAGESARRAY arrayName:sourceImageArr success:nil failed:nil];
        //初始化遮盖
        topImage = [UIImage imageNamed:@"face.png"];
        
        NSLog(@"开始识别人脸");
        //初始化识别后图片数组
        for (NSInteger i = 0; i < inte; i++) {
            @autoreleasepool {
                double aaa = (double)[[WZZMutableArray shareWZZMutableArray] countWithName:editImageArr]/(double)inte*100.0f;
                NSLog(@"%lf", aaa);
                UIImage * image = [[WZZVideoEditManager sharedWZZVideoEditManager] remixImageWithBackImage:[[WZZMutableArray shareWZZMutableArray] imageWithIndex:i arrName:sourceImageArr] image2:topImage returnFaceModelBlock:^(WZZFaceModel *faceModel) {
                    if (!faceModel) {
                        faceModel = [[WZZFaceModel alloc] init];
                    }
                    [sourceFaceArr addObject:faceModel];
                }];
                if (!image) {
                    image = [[WZZMutableArray shareWZZMutableArray] imageWithIndex:i arrName:sourceImageArr];
                }
                [[WZZMutableArray shareWZZMutableArray] addImage:image arrName:editImageArr success:nil failed:nil];
            }
        }
        //        [sourceImageArr enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //            double aaa = (double)editImageArr.count/(double)sourceImageArr.count*100.0f;
        //            NSLog(@"%lf", aaa);
        //            UIImage * image = [[WZZVideoEditManager sharedWZZVideoEditManager] remixImageWithBackImage:obj image2:topImage returnFaceModelBlock:^(WZZFaceModel *faceModel) {
        //                if (!faceModel) {
        //                    faceModel = [[WZZFaceModel alloc] init];
        //                }
        //                [sourceFaceArr addObject:faceModel];
        //            }];
        //            if (!image) {
        //                image = sourceImageArr[idx];
        //            }
        //            [editImageArr addObject:image];
        //        }];
        NSLog(@"处理完成");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //            imageView.image = editImageArr[0];
            //            slider.maximumValue = editImageArr.count-1;
            UIImage * image = [[WZZMutableArray shareWZZMutableArray] imageWithIndex:0 arrName:editImageArr];
            imageView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height/2-[UIScreen mainScreen].bounds.size.width/image.size.width*image.size.height/2, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width/image.size.width*image.size.height);
            imageView.image = image;
            slider.maximumValue = [[WZZMutableArray shareWZZMutableArray] countWithName:editImageArr]-1;
        });
    }];
    
}


@end
