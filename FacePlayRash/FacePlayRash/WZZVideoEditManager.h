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

@interface WZZVideoEditManager : NSObject
singleton_interface(WZZVideoEditManager)

/**
 视频转图片
 */
- (void)video2ImagesWithURL:(NSURL *)url progress:(void(^)(NSInteger progress))progressBlock finishBlock:(void(^)(NSMutableArray <UIImage *>* imagesArr))finishBlock;

/**
 图片转视频
 */
- (void)images2VideoWithImageArr:(NSMutableArray <UIImage *>*)imagesArr;

/**
 处理图片转为8进制打印
 */
- (void)handleImageWithImage:(UIImage *)image;

/**
 处理图像
 */
- (UIImage *)processImage:(UIImage *)inputImage faceModel:(WZZFaceModel *)faceModel;

/**
 获取脸的位置
 */
- (WZZFaceModel *)getOriginWithImage:(UIImage *)aImage;

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
