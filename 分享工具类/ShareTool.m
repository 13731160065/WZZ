//
//  ShareTool.m
//  电商
//
//  Created by 王泽众 on 15/11/25.
//  Copyright © 2015年 徐恒. All rights reserved.
//

#import "ShareTool.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocial.h"
#import "UMSocialQQHandler.h"

@interface ShareTool()<UMSocialUIDelegate>

@end

@implementation ShareTool
singleton_implementation(ShareTool);

//直接分享方法
- (void)shareWithTitle:(NSString *)title controller:(UIViewController *)controller{
    [UMSocialSnsService presentSnsIconSheetView:controller
                                         appKey:SHARE_UMENGAPPKEY
                                      shareText:title
                                     shareImage:[UIImage imageNamed:@"sy_logo"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToQQ, UMShareToQzone, UMShareToWechatTimeline,nil]
                                       delegate:self];
}

//分离分享方法
-  (void)shareWithTarget:(UIViewController *)VC toSns:(SHARESNS)loginSns shareTitle:(NSString *)titleText shareMessage:(NSString *)shareMessage image:(UIImage *)image url:(NSString *)url{
    NSString * str = @"";
    [UMSocialConfig setFinishToastIsHidden:YES  position:UMSocialiToastPositionCenter];
    if (!shareMessage) {
        shareMessage = @"我发现了一个好玩的应用:测试中心";
    }
    
    if (!titleText) {
        titleText = @"测试中心";
    }
    
    if (!image) {
        image = [UIImage imageNamed:@"sy_logo"];
    }
    
    if (!url) {
        url = @"http://www.baidu.com";
    }
    
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:SHARE_WEIXINAPPID appSecret:SHARE_WEIXINAPPSECRET url:url];
    //设置手机QQ 的AppId，Appkey，和分享URL
    [UMSocialQQHandler setQQWithAppId:SHARE_QQAPPID appKey:SHARE_QQAPPKEY url:url];
    
    switch (loginSns) {
        case SHARESNS_TENCENT:
        {
            str = UMShareToQQ;
            [UMSocialData defaultData].extConfig.qqData.url = url;
            [UMSocialData defaultData].extConfig.qqData.title = titleText;
        }
            break;
        case SHARESNS_WECHATFRIEND:
        {
            str = UMShareToWechatSession;
            [UMSocialData defaultData].extConfig.wechatSessionData.url = url;
            [UMSocialData defaultData].extConfig.wechatSessionData.title = titleText;
        }
            break;
        case SHARESNS_WECHATZONE:
        {
            str = UMShareToWechatTimeline;
            [UMSocialData defaultData].extConfig.wechatTimelineData.url = url;
            [UMSocialData defaultData].extConfig.wechatTimelineData.title = titleText;
        }
            break;
        case SHARESNS_SINA:
        {
            str = UMShareToSina;
        }
            break;
        case SHARESNS_QZONE:
        {
            str = UMShareToQzone;
        }
            break;
            
        default:
            break;
            
    }
    if ([str isEqualToString:UMShareToSina]) {
        
        //删除微博授权
        [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToSina  completion:^(UMSocialResponseEntity *response){
            NSLog(@"删除微博授权:response is %@",response);
        }];
        
        //分享微博
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
        
        snsPlatform.loginClickHandler(VC,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
            
            //          获取微博用户名、uid、token等
            
            if (response.responseCode == UMSResponseCodeSuccess) {
                [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[str] content:shareMessage image:image location:nil urlResource:nil presentedController:VC completion:^(UMSocialResponseEntity *shareResponse){
                    if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                        [MBProgressHUD showSuccess:@"分享成功"];
                    }
                }];
            }});
        
        return;
    }
    //直接分享
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[str] content:shareMessage image:image location:nil urlResource:nil presentedController:VC completion:^(UMSocialResponseEntity *shareResponse){
        if (shareResponse.responseCode == UMSResponseCodeSuccess) {
            [MBProgressHUD showSuccess:@"分享成功"];
        }
    }];
}


//登陆方法
- (void)loginWithTarget:(UIViewController *)VC sns:(LOGINSNS)loginSns returnInfoBlock:(void(^)(NSString * userName, NSString * userID, NSString * userToken, NSString * userHeaderImageURLString))returnInfoBlock{
    switch (loginSns) {
        case LOGINSNS_TENCENT:
        {
            //腾讯
            UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
            
            snsPlatform.loginClickHandler(VC,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
                
                //          获取微博用户名、uid、token等
                
                if (response.responseCode == UMSResponseCodeSuccess) {
                    
                    UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
                    
                    NSLog(@"qq用户名:%@, 用户ID:%@, 用户token:%@ 头像url:%@, openid:%@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL, snsAccount.openId);
                    
                    if (returnInfoBlock) {
                        returnInfoBlock(snsAccount.userName, snsAccount.openId, snsAccount.accessToken, snsAccount.iconURL);
                    }
                    
                }});
        }
            break;
        case LOGINSNS_WEICHAT:
        {
            //微信
            UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
            
            snsPlatform.loginClickHandler(VC,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
                
                if (response.responseCode == UMSResponseCodeSuccess) {
                    
                    UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
                    
                    NSLog(@"微信用户名:%@, 用户ID:%@, 用户token:%@ 头像url:%@, unionID:%@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL, snsAccount.unionId);
                    if (returnInfoBlock) {
                        returnInfoBlock(snsAccount.userName, snsAccount.unionId, snsAccount.accessToken, snsAccount.iconURL);
                    }
                }
                
            });
        }
            break;
        case LOGINSNS_SINA:
        {
            //删除微博授权
            [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToSina  completion:^(UMSocialResponseEntity *response){
                NSLog(@"删除微博授权:response is %@",response);
            }];
            
            //新浪
            UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
            
            snsPlatform.loginClickHandler(VC,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
                //获取微博信息
                if (response.responseCode == UMSResponseCodeSuccess) {
                    
                    UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
                    
                    NSLog(@"微博用户名:%@, 用户ID:%@, 用户token:%@ 头像url:%@, openID:%@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL, snsAccount.openId);
                    if (returnInfoBlock) {
                        returnInfoBlock(snsAccount.userName, snsAccount.usid, snsAccount.accessToken, snsAccount.iconURL);
                    }
                    
                }});
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 友盟代理方法
//是否直接分享
-(BOOL)isDirectShareInIconActionSheet
{
    return NO;
}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"分享到的平台名称:%@",[[response.data allKeys] objectAtIndex:0]);

    }
}



@end
