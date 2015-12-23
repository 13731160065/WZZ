//
//  WZZPlayerManager.m
//  TA艺人
//
//  Created by 王泽众 on 15/12/9.
//  Copyright © 2015年 徐恒. All rights reserved.
//

#import "WZZPlayerManager.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@implementation WZZPlayerManager

+ (void)playMovieWithURLString:(NSString *)urlStr presentVC:(UIViewController *)presentVC{
    NSURL *videoURL = [NSURL URLWithString:urlStr];
    MPMoviePlayerViewController *moviePlayerController = [[MPMoviePlayerViewController alloc] initWithContentURL:videoURL];
    
    moviePlayerController.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
    
    moviePlayerController.moviePlayer.shouldAutoplay = YES;
    
    [moviePlayerController.moviePlayer prepareToPlay];
    
    [moviePlayerController.moviePlayer play];
    
    [presentVC presentMoviePlayerViewControllerAnimated:moviePlayerController];
}

+ (UIImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    if (!time) {
        time = 0.1f;
    }
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60) actualTime:NULL error:&thumbnailImageGenerationError];
    if (!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@", thumbnailImageGenerationError);
    UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc] initWithCGImage:thumbnailImageRef] : nil;
    return thumbnailImage;
}

@end
