//
//  WZZCacheTheImage.h
//  TA艺人
//
//  Created by 王泽众 on 15/12/1.
//  Copyright © 2015年 徐恒. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Singleton.h"
@interface WZZCacheTheImage : NSObject
singleton_interface(WZZCacheTheImage);

+ (void)cacheTheImageWithImageURLStringArray:(NSArray *)stringArr complete:(void(^)(NSArray * imageArr))returnBlock;
+ (void)cacheTheImageWithImageURLString:(NSString *)string complete:(void(^)(UIImage * image))returnBlock;


@end
