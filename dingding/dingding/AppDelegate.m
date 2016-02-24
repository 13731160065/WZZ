//
//  AppDelegate.m
//  dingding
//
//  Created by CccDaxIN on 15/10/15.
//  Copyright © 2015年 rabbit. All rights reserved.
//

#import "AppDelegate.h"
#import "BKRootViewController.h"
#import "Prefix.pch"

NSString *const BKOrderModelLocalStatusChanage = @"BKOrderModelLocalStatusChanage";
NSString *const BKOrderModelRemoteStatusChanage = @"BKOrderModelRemoteStatusChanage";
NSString *const BKNavStatusChanage = @"BKNavStatusChanage";



@interface AppDelegate ()<CLLocationManagerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [UMSocialData setAppKey:@"567636e467e58e3761003370"];
    [MobClick startWithAppkey:@"567636e467e58e3761003370" reportPolicy:BATCH channelId:@""];
    
    
    
    if (!self.locManager) {
        self.locManager = [[CLLocationManager alloc] init];
        self.locManager.delegate = self;
    }
    
    
    DDFileLogger *logger = [[DDFileLogger alloc] init];
    self.logFileManagerDefault = logger.logFileManager;
    [BK initLog:logger];
    
    // 查看启动方式
    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedAlways) {
        [self.locManager requestAlwaysAuthorization];
        DDLogInfo(@"%s:请示用户准许位置服务", __func__);
    }
    [BK registeringNotificationTypes];
    
    
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    self.window.backgroundColor = [UIColor whiteColor];
//    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[BKRootViewController alloc] init]];
//    [self.window makeKeyAndVisible];
//    return YES;
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    DDLogInfo(@"%s", __func__);
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/** 接收远程通知 **/
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    // iOS 8
    NSLog(@"%s[INFO], %@ : %@", __func__, url, sourceApplication);
    // iOS 9
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        NSLog(@"%s[INFO], %@", __func__, resultDic.debugDescription);
    }];
    

    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    NSLog(@"%s[INFO], %@ : %@", __func__, url, options.debugDescription);
    // iOS 9
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        NSLog(@"%s[INFO], %@", __func__, resultDic.debugDescription);
    }];
    
    return YES;
}

@end
