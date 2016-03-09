//
//  WZZVideoEditManager.h
//  FacePlayRash
//
//  Created by 王泽众 on 16/2/25.
//  Copyright © 2016年 wzz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Singleton.h"
@class WZZFaceModel;

#define IMAGESARRAY @"wzz"

@interface WZZVideoEditManager : NSObject
singleton_interface(WZZVideoEditManager)

/**
 视频转图片
 */
- (void)video2ImagesWithURL:(NSURL *)url progress:(void(^)(NSInteger progress))progressBlock finishBlock:(void(^)())finishBlock;

/**
 图片转视频
 */
- (void)images2VideoWithImageArr:(NSMutableArray <UIImage *>*)imagesArr;

/**
 本地图片转视频
 */
- (void)images2VideoWithImageArrName:(NSString *)imageArrName complete:(void(^)())completeBlock ;

/**
 !!!处理图片转为8进制打印，这个方法一般不用
 */
- (UIImage *)handleImageWithImage:(UIImage *)image;

/**
 !!!合成图像，这个方法一般不用
 */
- (UIImage *)processImage:(UIImage *)inputImage faceModel:(WZZFaceModel *)faceModel;

/**
 获取脸的位置
 */
- (WZZFaceModel *)getOriginWithImage:(UIImage *)aImage;

/**
 组合图片自动遮脸
 */
- (UIImage *)remixImageWithBackImage:(UIImage *)backImage image2:(UIImage *)image2;

/**
 组合图片自动遮脸-反脸位置
 */
- (UIImage *)remixImageWithBackImage:(UIImage *)backImage image2:(UIImage *)image2 returnFaceModelBlock:(void(^)(WZZFaceModel * faceModel))faceModelBlock;

/**
 根据固定坐标组合图片
 */
- (UIImage *)remixImageWithBackImage:(UIImage *)backImage image2:(UIImage *)image2 faceRect:(CGRect)rect;

@end

@interface WZZFaceModel : NSObject

/**
 左眼坐标
 */
@property (assign, nonatomic) CGPoint leftEye;

/**
 右眼坐标
 */
@property (assign, nonatomic) CGPoint rightEye;

/**
 👄坐标
 */
@property (assign, nonatomic) CGPoint mouth;

/**
 脸区域
 */
@property (assign, nonatomic) CGRect frame;


//@property (strong, nonatomic) UIWindow * window;

@end
