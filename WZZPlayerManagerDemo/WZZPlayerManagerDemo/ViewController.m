//
//  ViewController.m
//  WZZPlayerManagerDemo
//
//  Created by 王泽众 on 15/12/23.
//  Copyright © 2015年 wzz. All rights reserved.
//

#import "ViewController.h"
#import "WZZPlayerManager.h"
#import "WZZCacheTheImage.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgV;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [WZZCacheTheImage cacheTheImageWithImageURLString:@"http://api.tayiren.com/Public/Mobile/images/td_img.png" complete:^(UIImage *image) {
        _imgV.image = image;
    }];
}
- (IBAction)playVideo:(id)sender {
    [WZZPlayerManager playMovieWithURLString:@"http://api.tayiren.com/Uploads/Video/2015-12-14/566ecd7b89e8d.mp4" presentVC:self];
}

@end
