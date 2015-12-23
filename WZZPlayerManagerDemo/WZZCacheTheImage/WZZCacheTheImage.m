//
//  WZZCacheTheImage.m
//  TA艺人
//
//  Created by 王泽众 on 15/12/1.
//  Copyright © 2015年 徐恒. All rights reserved.
//

#import "WZZCacheTheImage.h"

@implementation WZZCacheTheImage
singleton_implementation(WZZCacheTheImage);

+ (void)cacheTheImageWithImageURLString:(NSString *)string complete:(void (^)(UIImage *))returnBlock{
    __block UIImage * image;
    dispatch_queue_t queue = dispatch_queue_create("q", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        //加载图片
        dispatch_async(queue, ^{
            image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:string]]];
        });
        //加载完成
        dispatch_async(queue, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"图片缓存ok");
                returnBlock(image);
            });
        });
    });
}

+ (void)cacheTheImageWithImageURLStringArray:(NSArray *)stringArr complete:(void (^)(NSArray *))returnBlock{
    __block NSMutableArray * imageArr = [[NSMutableArray alloc] initWithCapacity:0];
    dispatch_queue_t queue = dispatch_queue_create("q", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        //加载图片
        dispatch_async(queue, ^{
            for (NSString * str in stringArr) {
                UIImage * image;
                image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:str]]];
                [imageArr addObject:image];
            }
        });
        //加载完成
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"图片数组缓存ok");
            returnBlock(imageArr);
        });
    });
}

@end
