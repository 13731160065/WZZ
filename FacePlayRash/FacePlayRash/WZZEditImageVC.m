//
//  WZZEditImageVC.m
//  FacePlayRash
//
//  Created by 王泽众 on 16/3/23.
//  Copyright © 2016年 wzz. All rights reserved.
//

#import "WZZEditImageVC.h"
#import "WZZVideoEditManager.h"
#import "WZZUploadAudioVC.h"

@interface WZZEditImageVC ()
{
    
    UIImage * editImage;
    UIImageView * imageView;
    UIButton * editButton;
    WZZFaceModel * editFaceM;
    WZZFaceModel * sourceFaceM;
    UIImage * topImage;
    UIView * tmpView;
    UIImageView * tmpImageView;
    UIImageView * tmpFaceImageView;
    NSInteger zhen;
    UIButton * edit10Button;
    UITextField * textField10;
    //封面图
    UIImage * currentMainImage;
}
@end

@implementation WZZEditImageVC

//视图加载
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:imageView];
    imageView.userInteractionEnabled = YES;
    
    zhen = 10;
    
    editButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:editButton];
    [editButton setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-50, 20, 50, 30)];
    [editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(editClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * playButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:playButton];
    [playButton setFrame:CGRectMake(50, 70, 100, 30)];
    [playButton setTitle:@"合成图片" forState:UIControlStateNormal];
    [playButton addTarget:self action:@selector(playButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:backButton];
    [backButton setFrame:CGRectMake(50, 70+50, 100, 30)];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self loadData];
}

//返回
- (void)backButtonClick {
    [[WZZVideoEditManager sharedWZZVideoEditManager] removeAllTmp];
    [self.navigationController popToRootViewControllerAnimated:YES];
}


//数组转json
- (NSString*)arrayToJson:(NSArray *)array {
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:0 error:nil];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

//字典转json
- (NSString *)dicToJson:(NSDictionary *)dic {
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

//合成视频
- (void)playButtonClick {
    
    NSMutableArray * uploadArr = [NSMutableArray array];
    
    NSMutableDictionary * mutiDic = [NSMutableDictionary dictionary];
    [mutiDic setObject:[NSNumber numberWithInteger:0] forKey:@"index"];
    [mutiDic setObject:[NSNumber numberWithDouble:editFaceM.frame.origin.x] forKey:@"x"];
    [mutiDic setObject:[NSNumber numberWithDouble:editFaceM.frame.origin.y] forKey:@"y"];
    [mutiDic setObject:[NSNumber numberWithDouble:editFaceM.frame.size.width] forKey:@"width"];
    [mutiDic setObject:[NSNumber numberWithDouble:editFaceM.frame.size.height] forKey:@"height"];
    [uploadArr addObject:mutiDic];
    
    NSString * uploadStr = [self dicToJson:mutiDic];
    NSLog(@"%@", uploadStr);
    
    WZZUploadAudioVC * ccc = [[WZZUploadAudioVC alloc] init];
    ccc.uploadImage = editImage;
    
    [self.navigationController pushViewController:ccc animated:YES];
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
    tmpImageView.image = [self.uploadImage copy];
    tmpImageView.userInteractionEnabled = YES;
    [tmpImageView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panImage:)]];
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
    UIImage * image = [self.uploadImage copy];
    WZZFaceModel * model = sourceFaceM;
    CGFloat piix = [UIScreen mainScreen].bounds.size.width/image.size.width;
    CGFloat w = model.frame.size.width;
    CGFloat h = w/topImage.size.width*topImage.size.height;
    WZZFaceModel * faceModel = editFaceM;
    [faceModel setFrame:CGRectMake(faceModel.frame.origin.x, faceModel.frame.origin.y, w, h)];
    
    tmpFaceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(faceModel.frame.origin.x*piix, faceModel.frame.origin.y*piix, w*piix, h*piix)];
    [tmpImageView addSubview:tmpFaceImageView];
    tmpFaceImageView.userInteractionEnabled = YES;
    tmpFaceImageView.image = topImage;
    [tmpFaceImageView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panImage:)]];
    [tmpFaceImageView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchTapGR:)]];
    [tmpFaceImageView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGR:)]];
}

//添加头像
- (void)insertFaceButtonClick:(UIButton *)btn {
    //添加
    [tmpFaceImageView removeFromSuperview];
    tmpFaceImageView = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-[UIScreen mainScreen].bounds.size.width/4/2, tmpImageView.frame.size.height/2-[UIScreen mainScreen].bounds.size.width/4/topImage.size.width*topImage.size.height/2, [UIScreen mainScreen].bounds.size.width/4, [UIScreen mainScreen].bounds.size.width/4/topImage.size.width*topImage.size.height)];

    [tmpFaceImageView setImage:topImage];
    [tmpFaceImageView setUserInteractionEnabled:YES];
    [tmpImageView addSubview:tmpFaceImageView];
    [tmpFaceImageView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panImage:)]];
    [tmpFaceImageView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchTapGR:)]];
    [tmpFaceImageView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGR:)]];
}

//长按删除
- (void)longGR:(UILongPressGestureRecognizer *)tap {
    [editFaceM setFrame:CGRectZero];
    [tmpFaceImageView removeFromSuperview];
    [tmpFaceImageView setFrame:CGRectZero];
}

//捏合
- (void)pinchTapGR:(UIPinchGestureRecognizer *)tap{
    tap.view.transform = CGAffineTransformScale(tap.view.transform, tap.scale, tap.scale);
    tap.scale = 1.0;//以上一次的缩放比例为准
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

//完成编辑
- (void)returnClick:(UIButton *)button {
    
    UIImage * tmpImage = [self.uploadImage copy];
    CGFloat piix = tmpImage.size.width/[UIScreen mainScreen].bounds.size.width;
    WZZFaceModel * faceModel = editFaceM;
    [faceModel setFrame:CGRectMake(tmpFaceImageView.frame.origin.x*piix, tmpFaceImageView.frame.origin.y*piix, tmpFaceImageView.frame.size.width*piix, tmpFaceImageView.frame.size.height*piix)];
    UIImage * image = [[WZZVideoEditManager sharedWZZVideoEditManager] remixImageWithBackImage:tmpImage image2:topImage faceRect:tmpFaceImageView.frame];
    editImage = image;
    imageView.image = image;
    [tmpView removeFromSuperview];
}


//加载数据
- (void)loadData {
    sourceFaceM = [[WZZFaceModel alloc] init];
    [sourceFaceM setFrame:CGRectZero];
    editFaceM = [[WZZFaceModel alloc] init];
    [editFaceM setFrame:CGRectZero];
    
    
    
    //初始化遮盖
    topImage = [UIImage imageNamed:@"face.png"];
    
    editImage = self.uploadImage;
    
    UIImage * image = [editImage copy];
    imageView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height/2-[UIScreen mainScreen].bounds.size.width/image.size.width*image.size.height/2, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width/image.size.width*image.size.height);
    imageView.image = image;
    
    
}


@end
