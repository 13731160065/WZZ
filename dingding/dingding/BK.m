//
//  BK.m
//  dingding
//
//  Created by CccDaxIN on 15/10/15.
//  Copyright © 2015年 rabbit. All rights reserved.
//

#import "BK.h"


@implementation BK

+ (void) registeringNotificationTypes{
   
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeNone;
    
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
//    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

+ (void) initLog:(DDFileLogger *) fileLogger{
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
//    DDFileLogger * fileLogger;
    if (fileLogger) {
        fileLogger = [[DDFileLogger alloc] init];
        fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    
        [DDLog addLogger:fileLogger];
    }
}

+ (AFHTTPSessionManager *) httpSessioManager {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    return manager;
}

+ (AFHTTPRequestOperation *)POST:(NSString *)URLString
                               parameters:(id)parameters
                                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {


    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    
//    AFHTTPRequestOperation *operation = [manager POST:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        
//        success(task, responseObject);
//        
//    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
//        
//        failure(task, error);
//    }];
    return NULL ;
    

}

+ (void) payOrder:(NSNumber *) totalFee // 订单价格
          orderId:(NSNumber*) gid             // 订单编号
         callback:(CompletionBlock) completionBlock {

//    NSString * const partner = @"2088121335243864";
//    NSString * const seller = @"shark_bro@qq.com";
//    NSString * const PAY_DONOTIFY = @"http://carcrm.gotoip1.com/alipay/do_notify";

    NSString * const privateKey = @"MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBAKM4ISykhN4QBf67l/WEzhlJNSWtmbFwenaddFtNdOzlqDrmrMhh+f+lZwscpbSNjBXvKGPPkKmX9ZfWimOB4x4l1E3KRQTjSMBkE6TQRdx6MhPg4ZO/1avESygx+rFnDwxCvd/Jhx3U/cTYKjdhC1TCPUdPUvg6FG5dYw/Aqa6/AgMBAAECgYAFRl0cGj0JCC+JafqhPqeCfbEwBIpBB8eNac1G3hv3Q/zJ2oae+zufHXNVEpnwWdq7Ir2FbEHamUSgoZhbWulCFO7lKa4MTu5fsE/Tuei3EXj608XjarzBnWAFktMWYsfxCRIzGlkGH01RSYFNZPo4mkLDW44qGEmWdHdT77igsQJBANiMPMzgGFf77le7bwYUxO9rdWNzAlCywgc1ChuvtTY2cYAbttUMMQ7i9CJVYILYqNZm64Vw/RmXs0AoAJ/+ygUCQQDA9KfDtt/a/bKKG0mk6S2EfCCyC0/Y/xflBFsk9YFncHAXk2SZFowKGcbw/GAkG0YXbT+1ZI+9p6ui8BJil/zzAkEAgGefweh75ugna3RkIBn+sO1qXT8cN1fYP8fOp54n+O6NnOZSIsCo8mfXVeiEYvIwI3pB3A2ktyFCFB/kRvshNQJBAIO3/7Yo5pOV0AVbL2C2FO511dP0yOM28FbULGwEc/vq03okke23aI2Unyvu/KppO+XOHEl1hnJPPWmTPNm1K2UCQQCP/FZ5jIdDRlpBtOE55bcOPRaomJYhCKSOUqI4sFV7eQ/KuLgJEA8nA+4/T1oTW2IH52+1r2/ACcs0GtQApxli";
    

    NSString * subject = @"滴滴导游";
    NSString * body = @"滴滴导游付款";

    
    NSString *orderBaseString = [NSString stringWithFormat:@"partner=\"2088121335243864\"&seller_id=\"shark_bro@qq.com\"&out_trade_no=\"%@\"&subject=\"%@\"&body=\"%@\"&total_fee=\"%0.2f\"&notify_url=\"http://carcrm.gotoip1.com/alipay/do_notify\"&service=\"mobile.securitypay.pay\"&payment_type=\"1\"&_input_charset=\"utf-8\"&it_b_pay=\"30m\"&show_url=\"m.alipay.com\"", gid, subject,body, [totalFee floatValue]];

//测试用
    //NSString *orderBaseString = [NSString stringWithFormat:@"partner=\"2088121335243864\"&seller_id=\"shark_bro@qq.com\"&out_trade_no=\"%@\"&subject=\"%@\"&body=\"%@\"&total_fee=\"%0.2f\"&notify_url=\"http://carcrm.gotoip1.com/alipay/do_notify\"&service=\"mobile.securitypay.pay\"&payment_type=\"1\"&_input_charset=\"utf-8\"&it_b_pay=\"30m\"&show_url=\"m.alipay.com\"", gid, subject,body, 0.01];
    
    
    NSString *appScheme = @"didinav";
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderBaseString];
    if (signedString) {
        NSString * orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"", orderBaseString, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            
            NSLog(@"%s[INFO], %@", __func__,resultDic);
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付结束"
//                                                            message:nil
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"好"
//                                                  otherButtonTitles:nil];
//            [alert show]; // 线程安全？
            
            completionBlock(resultDic);
        }];
    }

    
}

+ (UIAlertView *) alert:(NSString *)msg{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"滴滴导游" message:msg delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
    [alertView show];
    return alertView;
}

+ (NSString *) getStringFromObject:(id) obj byName:(NSString *) name{
    @try {
        // TODO 切出 key 链
        return [obj valueForKey:name];
    }
    @catch (NSException *exception) {
        return nil;
    }
}

@end
