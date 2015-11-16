//
//  ViewController.m
//  WZZSecertDemo
//
//  Created by wzzsmac on 15-11-10.
//  Copyright (c) 2015年 wzz. All rights reserved.
//

#import "ViewController.h"
#import "NSString+WZZSecert.h"
#import "NSData+WZZAESEncrypt.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString * a = @"hello";
    NSLog(@"%@", [a encryptUseMD5]);
    
    NSData * data = [a dataUsingEncoding:NSUTF8StringEncoding];
    data = [data AES256EncryptWithKey:@"key"];
    data = [data AES256DecryptWithKey:@"key"];
    NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
