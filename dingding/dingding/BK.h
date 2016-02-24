//
//  BK.h
//  dingding
//  写一些帮助方法
//  Created by Breaker on 15/10/15.
//  Copyright © 2015年 rabbit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CocoaLumberjack/CocoaLumberjack.h>
#import <AFNetworking/AFNetworking.h>
#import <AlipaySDK/AlipaySDK.h>
#import "DataSigner.h"

@interface BK : NSObject



//@property (strong, nonatomic) 

+ (void) registeringNotificationTypes;

+ (void) initLog:(DDFileLogger *) fileLogger;

/**  支付，默认使用alipay  **/
+ (void) payOrder:(NSNumber *) totalFee // 订单价格
          orderId:(NSNumber *) gid             // 订单编号
         callback:(CompletionBlock) completionBlock;


+ (AFHTTPSessionManager *) httpSessioManager;

+ (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(id)parameters
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+ (UIAlertView *) alert:(NSString *) msg;

+ (NSString *) getStringFromObject:(id) obj byName:(NSString *) name;


@end
