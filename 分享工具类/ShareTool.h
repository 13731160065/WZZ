//
//  ShareTool.h
//  电商
//
//  Created by 王泽众 on 15/11/25.
//  Copyright © 2015年 徐恒. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SHARE_UMENGAPPKEY UMengAppkey
#define SHARE_SINAAPPKEY sinaAppKey
#define SHARE_WEIXINAPPID weixinAppID
#define SHARE_QQAPPID qqAppId

#define SHARE_WEIXINAPPSECRET weixinAppSecret
#define SHARE_QQAPPKEY qqAppKey

typedef enum {
    LOGINSNS_TENCENT,
    LOGINSNS_WEICHAT,
    LOGINSNS_SINA
}LOGINSNS;

typedef enum {
    SHARESNS_TENCENT, // QQ
    SHARESNS_WECHATFRIEND, // 微信
    SHARESNS_WECHATZONE, // 微信朋友圈
    SHARESNS_SINA, // 新浪
    SHARESNS_QZONE // 空间
}SHARESNS;

@interface ShareTool : NSObject
singleton_interface(ShareTool);

/**
 直接分享方法
 */
- (void)shareWithTitle:(NSString *)title controller:(UIViewController *)controller;

/**
 分离分享方法
 */
-  (void)shareWithTarget:(UIViewController *)VC toSns:(SHARESNS)loginSns shareTitle:(NSString *)titleText shareMessage:(NSString *)shareMessage image:(UIImage *)image url:(NSString *)url;

/**
 第三方登陆方法
 */
- (void)loginWithTarget:(UIViewController *)VC sns:(LOGINSNS)loginSns returnInfoBlock:(void(^)(NSString * userName, NSString * userID, NSString * userToken, NSString * userHeaderImageURLString))returnInfoBlock;

@end
