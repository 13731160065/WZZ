//
//  AppDelegate.m
//  FacePlayRash
//
//  Created by 王泽众 on 16/2/25.
//  Copyright © 2016年 wzz. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "WZZMutableArray.h"
#import "WZZVideoEditManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    
    ViewController * vcc = [[ViewController alloc] init];
    
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:vcc];
    
    [self.window setRootViewController:nav];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    
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
