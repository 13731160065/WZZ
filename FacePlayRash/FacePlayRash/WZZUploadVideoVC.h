//
//  WZZUploadVideoVC.h
//  FacePlayRash
//
//  Created by 王泽众 on 16/3/19.
//  Copyright © 2016年 wzz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZZUploadVideoVC : UIViewController

/**
 视频url
 */
@property (strong, nonatomic) NSURL * uploadURL;

/**
 封面图
 */
@property (strong, nonatomic) UIImage * mainImage;

/**
 视频位置数据
 */
@property (strong, nonatomic) NSString * uploadDicDataStr;

@end
