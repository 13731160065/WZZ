//
//  WZZPlayerManager.h
//  TA艺人
//
//  Created by 王泽众 on 15/12/9.
//  Copyright © 2015年 徐恒. All rights reserved.
//
//  需要先倒入AVFoundation和MediaPlayer框架

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WZZPlayerManager : NSObject

/**
 播放视频
 */
+ (void)playMovieWithURLString:(NSString *)urlStr presentVC:(UIViewController *)presentVC;

/**
 获取图片某一帧
 */
+ (UIImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time;

@end
