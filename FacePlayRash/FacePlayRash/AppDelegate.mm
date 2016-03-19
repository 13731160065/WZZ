//
//  AppDelegate.m
//  FacePlayRash
//
//  Created by 王泽众 on 16/2/25.
//  Copyright © 2016年 wzz. All rights reserved.
//

#import "AppDelegate.h"
#import "WZZMutableArray.h"
#import "WZZVideoEditManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [WZZMutableArray setup];
    
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    //程序即将结束
    [[WZZVideoEditManager sharedWZZVideoEditManager] removeAllTmp];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    NSLog(@"bang!");
}

@end
