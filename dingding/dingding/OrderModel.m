//
//  OrderModel.m
//  dingding
//
//  Created by CccDaxIN on 15/12/20.
//  Copyright © 2015年 rabbit. All rights reserved.
//

#import "OrderModel.h"




@implementation OrderModel

+ (OrderModel *)currentOrderModel{
    static OrderModel * shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    
    return shared;
}

- (instancetype)initById:(NSNumber *)ID
                complete:(void (^)(NSError *error))complete{
    self = [super init];
    if (self) {
        self.ID = ID;
        [self syncRemoteStatus:complete];
    }
    return self;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRemoteStateChange) name:BKOrderModelRemoteStatusChanage object:nil];
    }
    return self;
}

- (void)onRemoteStateChange{
    [self syncRemoteStatus:^(NSError *error) {
        [MobClick event:@"oreder_sync_remote"];
    }];
}

- (void)syncRemoteStatus:(void (^)(NSError *))complete{
    DDLogInfo(@"更新状态");
    [MobClick event:@"sync_order"];
    
    if (!self.userModel || self.userModel.token == nil || [self.userModel.token length] == 0 ) {
        
        [BK alert:@"用户未登录，请登录后重试"];
        NSError * err = [[NSError alloc] initWithDomain:@"" code:1 userInfo:@{@"message" : @"用户未登录"}];
        
        complete(err);
        
        return;
    }
    
    if (!self.bookingID && !self.ID) {
        NSError *err = [[NSError alloc] initWithDomain:@"OrderModel" code:1 userInfo:@{@"message": @"未发起预约"}];
        complete(err);
        return;
    }
    if (self.state == 0) {
        
        NSString * urlString = @"http://carcrm.gotoip1.com/api_tourists/get_guide_for_order";
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:self.userModel.ID forKey:@"tid"];
        [params setValue:self.ID forKey:@"trade_no"];
        [params setValue:self.userModel.token forKey:@"token"];
        [self POST:urlString parameters:params success:^(id responseObject) {
            NSNumber *gid = [responseObject objectForKey:@"gid"];
            if (gid && ![gid isKindOfClass:[NSNull class]]) {
                self.navID = gid;
                self.state = 1; // 待支付
                
                [self netReqComplete:complete];
            } else {
                complete(nil);
            }
        } failure:^(NSError *error) {
            complete(error);
        }];
        
        
    } else {
        NSString *urlString = @"http://carcrm.gotoip1.com/api_common/get_order";
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
        [params setValue:self.ID forKey:@"id"];
        [self POST:urlString parameters:params success:^(id responseObject) {
            
            self.state = [[responseObject objectForKey:@"state"] intValue];
            // TODO 分解数据
            
            [self netReqComplete:complete];
        } failure:^(NSError *error) {
            complete(error);
        }];
    }
}

- (void)createBooking:(void (^)(NSError *))complete
               filter:(NSDictionary *)filter{
    DDLogInfo(@"发起预约, %@",filter.debugDescription);
    [MobClick event:@"create_book"];
    
    if (!self.userModel || self.userModel.token == nil || [self.userModel.token length] == 0 ) {
        
        [BK alert:@"用户未登录，请登录后重试"];
        NSError * err = [[NSError alloc] initWithDomain:@"" code:1 userInfo:@{@"message" : @"用户未登录"}];
        
        complete(err);
        
        return;
    }
    
    NSString *urlString = @"http://carcrm.gotoip1.com/api_tourists/book";
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:filter];
    
    [params setValue:self.userModel.token forKey:@"token"];
    [params setValue:self.userModel.ID forKey:@"tid"];
    [params setValue:self.userModel.phone forKey:@"tmobile"];
    [params setValue:self.userModel.username forKey:@"tname"];
    
    
    
    [self POST:urlString parameters:params success:^(id responseObject) {
        
        // TODO 拆解
        self.ID = [responseObject objectForKey:@"trade_no"];
        self.bookingID = [responseObject objectForKey:@"book_id"];
        self.bookingNavNum = [responseObject objectForKey:@"result"];
        self.state = 0;

        
        
        [self netReqComplete:complete];

    } failure:^(NSError *error) {
        complete(error);
    }];
}

- (void)cancelBooking:(NSString *)why complete:(void (^)(NSError *))complete{
    DDLogInfo(@"取消预约, %@", why);
    [MobClick event:@"cancel_book"];
    
    if (!self.userModel || self.userModel.token == nil || [self.userModel.token length] == 0 ) {
        
        [BK alert:@"用户未登录，请登录后重试"];
        NSError * err = [[NSError alloc] initWithDomain:@"" code:1 userInfo:@{@"message" : @"用户未登录"}];
        
        complete(err);
        
        return;
    }
    
    NSString *url = @"http://carcrm.gotoip1.com/api_tourists/cancel_booking";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    

    [params setValue:[[UserModel sharedModel] token] forKey:@"token"];
    [params setValue:[[UserModel sharedModel] ID] forKey:@"id"];
    [params setValue:self.navID forKey:@"gid"];
    [params setValue:self.ID forKey:@"trade_no"];
    [params setValue:self.bookingID forKey:@"book_id"];
    [params setValue:why forKey:@"rt_cancel"];
    
    [self POST:url parameters:params success:^(id responseObject) {
        
        [self netReqComplete:complete];
    } failure:^(NSError *error) {
        complete(error);
    }];
}

// 获取导游信息
- (void) getGuideInfomation:(void(^)(id responseObject))returnBlock gid:(NSNumber *) gid{

    DDLogInfo(@"获取导游信息, %@", gid);
    [MobClick event:@"get_gidInfo"];
    
    NSString *url = @"http://carcrm.gotoip1.com//api_tguides/get_tguide/";
    
    
    NSString *finalURL = [NSString stringWithFormat:@"%@%@",url,gid];
    
    [self GET:finalURL parameters:nil success:^(id responseObject) {
        if(responseObject) {
            self.navPhone = [responseObject objectForKey:@"mobile"];
            self.navCompany = [responseObject objectForKey:@"company"];
            self.guideOrderNum = [responseObject objectForKey:@"total_orders"];
            self.navName = [responseObject objectForKey:@"gname"];
            self.starNum = [responseObject objectForKey:@"star_grade"];
            self.guideOrderNum = [responseObject objectForKey:@"total_orders"];
            
            
            returnBlock(responseObject);
           // NSLog(@"%@",responseObject);
            
        }
    } failure:^(NSError *error) {
        
    }];
    

}

- (void)payOrder:(void (^)(NSError *))complete price:(NSNumber *)price{
    [MobClick event:@"oreder_pay"];
    // TODO 验证状态
    
    
    [BK payOrder:price orderId:self.ID callback:^(NSDictionary *resultDic) {
        
        DDLogInfo(@"Alipay: %@", resultDic.debugDescription);
        [self netReqComplete:complete];
    }];
}

-(void) getOrderState:(void(^)(id responseObject))returnBlock{
    DDLogInfo(@"获取订单状态");
    [MobClick event:@"get_booking_status"];
    
    NSString *url = @"http://carcrm.gotoip1.com/api_tourists/get_booking_status/";
    
    
    NSString *finalURL = [NSString stringWithFormat:@"%@%@",url,self.bookingID];
    
    [self GET:finalURL parameters:nil success:^(id responseObject) {
        if(responseObject) {

            
            returnBlock(responseObject);
            // NSLog(@"%@",responseObject);
            
        }
    } failure:^(NSError *error) {
        
    }];


}

- (void) confirmPayGuide:(void(^)(NSError *error)) complete
{
    DDLogInfo(@"确认付款");
    [MobClick event:@"confirm_payment"];
    
    if (!self.userModel || self.userModel.token == nil || [self.userModel.token length] == 0 ) {
        
        [BK alert:@"用户未登录，请登录后重试"];
        NSError * err = [[NSError alloc] initWithDomain:@"" code:1 userInfo:@{@"message" : @"用户未登录"}];
        
        complete(err);
        
        return;
    }
    
    NSString *url = @"http://carcrm.gotoip1.com/api_tourists/confirm_payment";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setValue:[[UserModel sharedModel] ID] forKey:@"tid"];
    [params setValue:[[UserModel sharedModel] token] forKey:@"token"];
    [params setValue:self.navID forKey:@"gid"];
    [params setValue:self.bookingID forKey:@"book_id"];
    [params setValue:self.navPhone forKey:@"gmobile"];

    
    [self POST:url parameters:params success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        //[self netReqComplete:complete];
    } failure:^(NSError *error) {
        complete(error);
    }];


}


- (void)refund:(void (^)(NSError *))complete why:(NSString *)why{
    DDLogInfo(@"申请退款, %@", why);
    [MobClick event:@"refund_order"];
    
    if (!self.userModel || self.userModel.token == nil || [self.userModel.token length] == 0 ) {
        
        [BK alert:@"用户未登录，请登录后重试"];
        NSError * err = [[NSError alloc] initWithDomain:@"" code:1 userInfo:@{@"message" : @"用户未登录"}];
        
        complete(err);
        
        return;
    }
    
    NSString *url = @"http://carcrm.gotoip1.com/api_tourists/apply_refund";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    
    [params setValue:[[UserModel sharedModel] token] forKey:@"token"];
    [params setValue:[[UserModel sharedModel] ID] forKey:@"tid"];
    [params setValue:self.bookingID forKey:@"book_id"];
    
    [self POST:url parameters:params success:^(id responseObject) {
        
        [self netReqComplete:complete];
    } failure:^(NSError *error) {
        complete(error);
    }];

}

- (void)evalute:(void (^)(NSError *))complete comment:(NSString *)comment star:(NSNumber *)star{
    DDLogInfo(@"游客评价, %@", comment);
    [MobClick event:@"user_evalute"];
    
    if (!self.userModel || self.userModel.token == nil || [self.userModel.token length] == 0 ) {
        
        [BK alert:@"用户未登录，请登录后重试"];
        NSError * err = [[NSError alloc] initWithDomain:@"" code:1 userInfo:@{@"message" : @"用户未登录"}];
        
        complete(err);
        
        return;
    }
    
    NSString *url = @"http://carcrm.gotoip1.com/api_tourists/evaluate";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    
    [params setValue:[[UserModel sharedModel] token] forKey:@"t_token"];
    [params setValue:[[UserModel sharedModel] phone] forKey:@"tmobile"];
    [params setValue:[[UserModel sharedModel] ID] forKey:@"id"];
    [params setValue:self.bookingID forKey:@"book_id"];
    [params setValue:self.navID forKey:@"gid"];
    [params setValue:[[UserModel sharedModel] username] forKey:@"gname"];
    [params setValue:comment forKey:@"eval_text"];
    [params setValue:star forKey:@"eval_star"];
    
    [self POST:url parameters:params success:^(id responseObject) {
        
        [self netReqComplete:complete];
    } failure:^(NSError *error) {
        complete(error);
    }];
}

-(void) complain:(void (^)(NSError *error)) complete
   complain_text:(NSString *) complain_text{
    DDLogInfo(@"游客投诉, %@", complain_text);
    [MobClick event:@"user_complain"];
    
    if (!self.userModel || self.userModel.token == nil || [self.userModel.token length] == 0 ) {
        
        [BK alert:@"用户未登录，请登录后重试"];
        NSError * err = [[NSError alloc] initWithDomain:@"" code:1 userInfo:@{@"message" : @"用户未登录"}];
        
        complete(err);
        
        return;
    }
    
    NSString *url = @"http://carcrm.gotoip1.com/api_tourists/complain";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    
    [params setValue:[[UserModel sharedModel] token] forKey:@"t_token"];
    [params setValue:[[UserModel sharedModel] phone] forKey:@"tmobile"];
    [params setValue:[[UserModel sharedModel] ID] forKey:@"id"];
    [params setValue:self.bookingID forKey:@"book_id"];
    [params setValue:self.navID forKey:@"gid"];
    [params setValue:[[UserModel sharedModel] username] forKey:@"gname"];
    [params setValue:complain_text forKey:@"complain_text"];
    
    
    [self POST:url parameters:params success:^(id responseObject) {
        
        [self netReqComplete:complete];
    } failure:^(NSError *error) {
        complete(error);
    }];
    
    
}

-(void)getUserTrips:(void (^)(NSError *error)) complete
              state:(NSNumber *) state
        page_number:(NSNumber *) page_number{

    DDLogInfo(@"获取行程, %@", state);
    [MobClick event:@"my_trips"];
    
    if (!self.userModel || self.userModel.token == nil || [self.userModel.token length] == 0 ) {
        
        [BK alert:@"用户未登录，请登录后重试"];
        NSError * err = [[NSError alloc] initWithDomain:@"" code:1 userInfo:@{@"message" : @"用户未登录"}];
        
        complete(err);
        
        return;
    }
    
    NSString *url = @"http://carcrm.gotoip1.com/api_tourists/my_trips";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    
    [params setValue:[[UserModel sharedModel] token] forKey:@"token"];
    [params setValue:[[UserModel sharedModel] ID] forKey:@"tid"];

    [params setValue:state forKey:@"state"];
    [params setValue:page_number forKey:@"page_number"];
    
    [self POST:url parameters:params success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        [self netReqComplete:complete];
        
    } failure:^(NSError *error) {
        complete(error);
        NSLog(@"%@",error);
    }];


}

//获取验证码
- (void) get_vcode:(void(^)(NSError *error)) complete
       phoneNumber:(NSNumber *) number returnBlock:(void(^)(id responseObject))returnBlock{

    DDLogInfo(@"获取验证码, %@", number);
    [MobClick event:@"get_vode"];
    
    NSString *url = @"http://carcrm.gotoip1.com/api_tourists/get_vcode";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setValue:number forKey:@"mobile"];
    
    [self GET:url parameters:params success:^(id responseObject) {
        if(returnBlock) {
            returnBlock(responseObject);
        }
        [self netReqComplete:complete];
    } failure:^(NSError *error) {
        complete(error);
    }];

    
    
}

- (void) get_vcode:(void(^)(id responseObject))returnBlock phoneNumber:(NSNumber *) number {
    
    DDLogInfo(@"获取验证码, %@", number);
    [MobClick event:@"get_vode"];
    
    NSString *url = @"http://carcrm.gotoip1.com/api_tourists/get_vcode";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setValue:number forKey:@"mobile"];
    
    [self GET:url parameters:params success:^(id responseObject) {
        if(responseObject) {
            returnBlock(responseObject);
            NSLog(@"%@",responseObject);
            
        }
        [self netReqComplete:responseObject];
    } failure:^(NSError *error) {
        
    }];
    
    
    
}

//推荐导游
- (void) tuijianGuide:(void(^)(id responseObject))returnBlock {
    DDLogInfo(@"tuijianGuide");
    [MobClick event:@"recommend_guide"];
    
    NSString *url = @"http://carcrm.gotoip1.com/api_tourists/recommend";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:[[UserModel sharedModel] token] forKey:@"token"];
    [params setValue:[[UserModel sharedModel] ID] forKey:@"tid"];
    [params setValue:self.navID forKey:@"gid"];
    

    
    [self POST:url parameters:params success:^(id responseObject) {
        if(responseObject) {
            returnBlock(responseObject);
            NSLog(@"%@",responseObject);
            
        }
        [self netReqComplete:responseObject];
    } failure:^(NSError *error) {
        
    }];

    


}

//- (AFHTTPRequestOperation *) verifyCode:(NSDictionary *) parameters completion:(NetworkCompletion) completion{
//    NetWorkManager *manager=[NetWorkManager shareNetWorkManager];
//    
//    NSString *url = @"http://carcrm.gotoip1.com/api_tourists/get_vcode";
//    
//    return [manager getUrl:url parameters:parameters completion:completion];
//
//}


/** 请求结束发通知与回调 **/
- (void) netReqComplete:(void (^)(NSError *error)) complete{
    NSNotificationCenter *notifCenter = [NSNotificationCenter defaultCenter] ;
    [notifCenter postNotificationName:BKOrderModelLocalStatusChanage object:self];
    complete(nil);
}



- (UserModel *)userModel{
    return [UserModel sharedModel];
}

- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(nullable id)parameters
                                success:(nullable void (^)(id responseObject))success
                                failure:(nullable void (^)(NSError *error))failure{
    
    AFHTTPSessionManager *manager = [BK httpSessioManager];
    return [manager POST:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        DDLogInfo(@"URLString: %@ \n\tparameters: %@\n\t%@", URLString, ((NSDictionary *) parameters).debugDescription, ((NSDictionary *) responseObject).debugDescription);
        
        if ([[BK getStringFromObject:responseObject byName:@"code"] intValue] == 1000) {
            success(responseObject);
            
        } else {
            NSError *err = [[NSError alloc] initWithDomain:@"" code:[[BK getStringFromObject:responseObject byName:@"code"] integerValue] userInfo:responseObject];
            
            failure(err);
        }
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        DDLogInfo(@"URLString: %@ \n\t\n\tError\n\tparameters: %@", URLString, ((NSDictionary *) parameters).debugDescription);
        

        failure(error);
    }];
    
}

- (nullable NSURLSessionDataTask *)GET:(NSString *)URLString
                             parameters:(nullable id)parameters
                                success:(nullable void (^)(id responseObject))success
                                failure:(nullable void (^)(NSError *error))failure{
    
    AFHTTPSessionManager *manager = [BK httpSessioManager];

    return [manager GET:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        DDLogInfo(@"URLString: %@ \n\tparameters: %@\n\t%@", URLString, ((NSDictionary *) parameters).debugDescription, ((NSDictionary *) responseObject).debugDescription);
        
        if ([[BK getStringFromObject:responseObject byName:@"code"] intValue] == 1000) {
            success(responseObject);
            
        } else {
            NSError *err = [[NSError alloc] initWithDomain:@"" code:[[BK getStringFromObject:responseObject byName:@"code"] integerValue] userInfo:responseObject];
            
            failure(err);
        }
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        DDLogInfo(@"URLString: %@ \n\t\n\tError\n\tparameters: %@", URLString, ((NSDictionary *) parameters).debugDescription);
        
        
        failure(error);
    }];
    
}


@end
