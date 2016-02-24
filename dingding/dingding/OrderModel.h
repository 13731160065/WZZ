//
//  OrderModel.h
//  dingding
//
//  Created by CccDaxIN on 15/12/20.
//  Copyright © 2015年 rabbit. All rights reserved.
//

#import "Prefix.pch"
#import "UserModel.h"


typedef NS_ENUM(NSInteger, OrderModelState) {
    OrderModelStateBooking = 0, // booking
    OrderModelStatePaying, // 待付款
    OrderModelStateGoing, // 进行中
    OrderModelStateConfiming, // 待确认， 确认什么？
    OrderModelStateFinish, // 已完成
    OrderModelStateCancel,
    OrderModelStateClose,
    OrderModelStateRefund,  // 已审核退款
    OrderModelStateRefunding, // 导游同意退款
    OrderModelStateRefundFinish, // 退款完成
    OrderModelStateRefundRefuse  // 拒绝退款
};

//typedef void(^NetworkCompletion)(AFHTTPRequestOperation *requestOperation,NetWorkResponse *netWorkResponse,BOOL success,NSError *error);

@interface OrderModel : NSObject

@property (nonatomic, copy) UserModel *userModel;

/** 筛选条件 **/
@property (nonatomic, copy) NSNumber * filterSex;
@property (nonatomic, copy) NSString * filterNum;
@property (nonatomic, copy) NSString * filterStar; // 级别

/** 状态 **/
@property int state; // 状态
@property (nonatomic, copy) NSNumber * hasPay; // 付款状态

@property (nonatomic, copy) NSString * cancelWhy; // 取消原因
@property (nonatomic, copy) NSString * navCancelWhy; // 导游确认取消原因

/** 预约信息 **/
@property (nonatomic, copy) NSString * bookingCreatedTime; // 发布时间
@property (nonatomic, copy) NSString * bookingID; // 预约单号
@property (nonatomic, copy) NSNumber * bookingNavNum; // 发布时周围导游数量
@property (nonatomic, copy) NSNumber * longiture; // booking 经度
@property (nonatomic, copy) NSNumber * latiture; // booking 纬度

/** 接单导游信息 **/
@property (nonatomic, copy) NSNumber * navID;
@property (nonatomic, copy) NSString * navPhone;
@property (nonatomic, copy) NSString * navName;
@property (nonatomic, copy) NSString * navCompany;
@property (nonatomic, copy) NSString * guideOrderNum;
@property (nonatomic, copy) NSString * starNum;

/** 订单信息 **/
@property (nonatomic, copy) NSNumber * ID; // 订单编号
@property (nonatomic, copy) NSNumber * price; // 价格
@property (nonatomic, copy) NSString * refundCreatedTime; // 申请退款时间
@property (nonatomic, copy) NSString * payCreateTime; // 付款时间

/** 评价信息 **/
@property (nonatomic, copy) NSString * evalText;
@property (nonatomic, copy) NSNumber * evalStar;
@property (nonatomic, copy) NSString * navEvalText;


/** 返回当前订单 **/
+ (OrderModel *) currentOrderModel;

- (void) syncRemoteStatus:(void (^)(NSError * error)) complete ; // 更新订单状态

// 发起
- (void) createBooking:(void (^)(NSError * error)) complete
                filter:(NSDictionary *) filter;
// 取消
- (void) cancelBooking:(NSString *)why
              complete:(void (^)(NSError * error)) complete;

// 获取导游信息
- (void) getGuideInfomation:(void(^)(id responseObject))returnBlock gid:(NSNumber *) gid;

// 支付到平台
- (void) payOrder:(void(^)(NSError *error)) complete
            price:(NSNumber *) price;
//获取订单状态
-(void) getOrderState:(void(^)(id responseObject))returnBlock;

//游客确定付款给导游
- (void) confirmPayGuide:(void(^)(NSError *error)) complete
                   ;

// 退款
- (void) refund:(void(^)(NSError *error)) complete
            why:(NSString *)why;

// 评价
- (void) evalute:(void (^)(NSError *error)) complete
         comment:(NSString *) comment
            star:(NSNumber *) star;


//投诉
-(void) complain:(void (^)(NSError *error)) complete
   complain_text:(NSString *) complain_text;

//获取行程
-(void)getUserTrips:(void (^)(NSError *error)) complete
state:(NSNumber *) state
page_number:(NSNumber *) page_number;

// 获取手机验证码
- (void) get_vcode:(void(^)(NSError *error)) complete
            phoneNumber:(NSNumber *) number returnBlock:(void(^)(id responseObject))returnBlock;

- (void) get_vcode:(void(^)(id responseObject))returnBlock phoneNumber:(NSNumber *) number ;
////获取短信验证码
//- (AFHTTPRequestOperation *) verifyCode:(NSDictionary *) parameters completion:(NetworkCompletion) completion;

//推荐导游
- (void) tuijianGuide:(void(^)(id responseObject))returnBlock ;


@end
