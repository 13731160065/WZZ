//
//  ViewController.m
//  WZZPlayerManagerDemo
//
//  Created by 王泽众 on 15/12/23.
//  Copyright © 2015年 wzz. All rights reserved.
//

#import "ViewController.h"
#import "WZZPlayerManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (IBAction)playVideo:(id)sender {
    [WZZPlayerManager playMovieWithURLString:@"http://api.tayiren.com/Uploads/Video/2015-12-14/566ecd7b89e8d.mp4" presentVC:self];
}

@end
