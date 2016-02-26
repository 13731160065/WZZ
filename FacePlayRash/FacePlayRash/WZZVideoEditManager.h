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

@interface WZZVideoEditManager : NSObject
singleton_interface(WZZVideoEditManager)

/**
 视频转图片
 */
- (void)video2ImagesWithURL:(NSURL *)url progress:(void(^)(NSInteger progress))progressBlock finishBlock:(void(^)(NSMutableArray * imagesArr))finishBlock;

/**
 图片转视频
 */
- (void)images2VideoWithImageArr:(NSMutableArray <UIImage *>*)imagesArr;

/**
 处理图片
 */
- (void)handleImageWithImage:(UIImage *)image;

@end
