//
//  AppDelegate.h
//  dingding
//
//  Created by CccDaxIN on 15/10/15.
//  Copyright © 2015年 rabbit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BK.h"
@import CoreLocation;
#import <CocoaLumberjack/CocoaLumberjack.h>
#import <MBProgressHUD/MBProgressHUD.h>

UIKIT_EXTERN NSString *const BKOrderModelLocalStatusChanage; // 状态变化
UIKIT_EXTERN NSString *const BKOrderModelRemoteStatusChanage;
UIKIT_EXTERN NSString *const BKNavStatusChanage; // 导游状态变化


static const int ddLogLevel = DDLogLevelDebug;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) BK *bk;

@property (strong, nonatomic) CLLocationManager *locManager;
@property (strong, nonatomic) DDLogFileManagerDefault  *logFileManagerDefault ;



@end

