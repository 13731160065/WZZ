//
//  WZZVideoEditManager.m
//  FacePlayRash
//
//  Created by 王泽众 on 16/2/25.
//  Copyright © 2016年 wzz. All rights reserved.
//

#import "WZZVideoEditManager.h"
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#define ZHEN 20

//定义了一些简单处理32位像素的宏。为了得到红色通道的值，你需要得到前8位。为了得到其它的颜色通道值，你需要进行位移并取截取
#define Mask8(x) ( (x) & 0xFF )
#define R(x) ( Mask8(x) )
#define G(x) ( Mask8(x >> 8 ) )
#define B(x) ( Mask8(x >> 16) )

@interface WZZVideoEditManager()
{
    NSMutableArray * imagesArray;
    NSInteger currentImageNum;
    NSInteger allImageNum;
    long long _currentZhen;
}

@property (nonatomic, strong) AVAssetImageGenerator * myImageGenerator;

@end

@implementation WZZVideoEditManager
singleton_implementation(WZZVideoEditManager)


#pragma mark - 视频拆帧
- (void)video2ImagesWithURL:(NSURL *)url progress:(void(^)(NSInteger))progressBlock finishBlock:(void(^)(NSMutableArray <UIImage *>*))finishBlock {
    imagesArray = [NSMutableArray array];
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                     forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    
    AVURLAsset *Asset = [[AVURLAsset alloc] initWithURL:url options:opts];
    
    AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:Asset     presetName:AVAssetExportPresetLowQuality];
    session.outputURL = url;
    session.outputFileType = AVFileTypeMPEG4;
    
    [session exportAsynchronouslyWithCompletionHandler:^(void)
     {
         
         AVAsset * myAsset = session.asset;
         //转换结束
         //         AVURLAsset *myAsset = [[AVURLAsset alloc] initWithURL:url options:opts];
         //----------------------------------------------------------------
         float second = 0.0f;
         //    value为  总帧数，timescale为  fps
         second = myAsset.duration.value / myAsset.duration.timescale; // 获取视频总时长,单位秒
         _currentZhen = myAsset.duration.timescale;
         NSLog(@"%lld", _currentZhen);
         self.myImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:myAsset];
         
         self.myImageGenerator.appliesPreferredTrackTransform = YES;
         //解决 时间不准确问题
         self.myImageGenerator.requestedTimeToleranceBefore = kCMTimeZero;
         self.myImageGenerator.requestedTimeToleranceAfter = kCMTimeZero;
         
         
         // 获取视频总时长,单位秒
         Float64 durationSeconds = CMTimeGetSeconds([myAsset duration]);
         
         NSLog(@"%f~!~!~!~",durationSeconds);
         
         NSMutableArray * timeArr = [NSMutableArray array];
         //15*40=600
         //每秒帧数
         int32_t zhen = ZHEN;
         
         allImageNum = durationSeconds*zhen;
         currentImageNum = 0;
         
         //i是每帧的秒数
         for (int i = 0; i < allImageNum; i++) {
             CMTime time = CMTimeMake(i*10, ZHEN*10);
             [timeArr addObject:[NSValue valueWithCMTime:time]];
         }
         
         //    myImageGenertor  必须为strong
         [self.myImageGenerator generateCGImagesAsynchronouslyForTimes:timeArr
                                                     completionHandler:^(CMTime requestedTime, CGImageRef image, CMTime actualTime,
                                                                         AVAssetImageGeneratorResult result, NSError *error) {
                                                         CFBridgingRelease(CMTimeCopyDescription(NULL, requestedTime));
                                                         CFBridgingRelease(CMTimeCopyDescription(NULL, actualTime));
                                                         
                                                         if (result == AVAssetImageGeneratorSucceeded) {
                                                             // Do something interesting with the image.
                                                             
                                                             UIImage* image1 = [UIImage imageWithCGImage: image];
                                                             //                                                  UIImageWriteToSavedPhotosAlbum(image1, self, nil, nil);
                                                             [imagesArray addObject:image1];
                                                             currentImageNum++;
                                                             double aaa = (double)currentImageNum/(double)allImageNum*100.0f;
                                                             NSInteger progress = (NSInteger)aaa;
                                                             if (progressBlock) {
                                                                 progressBlock(progress);
                                                             }
                                                             if (currentImageNum == allImageNum) {
                                                                 if (finishBlock) {
                                                                     finishBlock(imagesArray);
                                                                 }
                                                             }
                                                         }
                                                         
                                                         if (result == AVAssetImageGeneratorFailed) {
                                                             NSLog(@"Failed with error: %@", [error localizedDescription]);
                                                         }
                                                         if (result == AVAssetImageGeneratorCancelled) {
                                                             NSLog(@"Canceled");
                                                         }
                                                     }];
         
         //-------------------------------------------------------
     }];
}

#pragma mark - 帧转视频
- (CVPixelBufferRef )pixelBufferFromCGImage:(CGImageRef)image size:(CGSize)size
{
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey, nil];
    CVPixelBufferRef pxbuffer = NULL;
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, size.width, size.height, kCVPixelFormatType_32ARGB, (__bridge CFDictionaryRef) options, &pxbuffer);
    
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    NSParameterAssert(pxdata != NULL);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pxdata, size.width, size.height, 8, 4*size.width, rgbColorSpace, kCGImageAlphaPremultipliedFirst);
    NSParameterAssert(context);
    
    CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(image), CGImageGetHeight(image)), image);
    
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    
    return pxbuffer;
}

//帧转视频方法
- (void)images2VideoWithImageArr:(NSMutableArray <UIImage *>*)imagesArr
{
    CGSize size = [imagesArr[0] size];//定义视频的大小
    
    NSError *error = nil;
    
    //—-initialize compression engine
    AVAssetWriter *videoWriter = [[AVAssetWriter alloc] initWithURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Documents/aaa.mp4", NSHomeDirectory()]]
                                                           fileType:AVFileTypeMPEG4
                                                              error:&error];
    NSParameterAssert(videoWriter);
    if(error)
        NSLog(@"error = %@", [error localizedDescription]);
    
    NSDictionary *videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:AVVideoCodecH264, AVVideoCodecKey,
                                   [NSNumber numberWithInt:size.width], AVVideoWidthKey,
                                   [NSNumber numberWithInt:size.height], AVVideoHeightKey, nil];
    AVAssetWriterInput *writerInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:videoSettings];
    
    NSDictionary *sourcePixelBufferAttributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kCVPixelFormatType_32ARGB], kCVPixelBufferPixelFormatTypeKey, nil];
    
    AVAssetWriterInputPixelBufferAdaptor *adaptor = [AVAssetWriterInputPixelBufferAdaptor
                                                     assetWriterInputPixelBufferAdaptorWithAssetWriterInput:writerInput sourcePixelBufferAttributes:sourcePixelBufferAttributesDictionary];
    NSParameterAssert(writerInput);
    NSParameterAssert([videoWriter canAddInput:writerInput]);
    
    if ([videoWriter canAddInput:writerInput])
        NSLog(@" ");
    else
        NSLog(@" ");
    
    [videoWriter addInput:writerInput];
    
    [videoWriter startWriting];
    [videoWriter startSessionAtSourceTime:kCMTimeZero];
    
    //合成多张图片为一个视频文件
    dispatch_queue_t dispatchQueue = dispatch_queue_create("mediaInputQueue", NULL);
    int __block frame = 0;
    
    [writerInput requestMediaDataWhenReadyOnQueue:dispatchQueue usingBlock:^{
        while ([writerInput isReadyForMoreMediaData])
        {
            if(++frame >= allImageNum)
            {
                [writerInput markAsFinished];
                [videoWriter finishWritingWithCompletionHandler:^{
                    //结束合成
                    NSLog(@"OK");
                }];
                break;
            }
            
            CVPixelBufferRef buffer = NULL;
            
            int idx = frame;
            NSLog(@"%d", frame);
            buffer = (CVPixelBufferRef)[self pixelBufferFromCGImage:[imagesArr[idx] CGImage] size:size];
            
            if (buffer)
            {
                if(![adaptor appendPixelBuffer:buffer withPresentationTime:CMTimeMake(frame*10, ZHEN*10)])
                    NSLog(@"FAIL");
                else
                    CFRelease(buffer);
            }
            
        }
    }];
}

- (void)handleImageWithImage:(UIImage *)image {
    //1.把UIImage对象转换为需要被核心图形库调用的CGImage对象。同时，得到图形的宽度和高度。
    CGImageRef cgImage = [image CGImage];
    //宽
    NSInteger cgImageWidth = CGImageGetWidth(cgImage);
    //高
    NSInteger cgImageHeight = CGImageGetHeight(cgImage);
    
    //2.由于你使用的是32位RGB颜色空间模式，你需要定义一些参数bytesPerPixel（每像素大小）和bitsPerComponent（每个颜色通道大小），然后计算图像bytesPerRow（每行有大）。最后，使用一个数组来存储像素的值。
    NSInteger everyPX = 4;
    NSInteger everyTongDao = everyPX * cgImageWidth;
    NSInteger everyRow = 8;
    
    UInt32 * pixels = (UInt32 *) calloc(cgImageHeight * cgImageWidth, sizeof(UInt32));
    
    //3.创建一个RGB模式的颜色空间CGColorSpace和一个容器CGBitmapContext,将像素指针参数传递到容器中缓存进行存储。在后面的章节中将会进一步研究核图形库。
    CGColorSpaceRef colorSpace =     CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixels, cgImageWidth, cgImageHeight, everyRow, everyTongDao, colorSpace, kCGImageAlphaPremultipliedLast|kCGBitmapByteOrder32Big);
    
    //4.把缓存中的图形绘制到显示器上。像素的填充格式是由你在创建context的时候进行指定的。
    CGContextDrawImage(context, CGRectMake(0, 0, cgImageWidth, cgImageHeight), cgImage);
    
    //5.释放colorSpace和context
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    //NOTE:当你绘制图像的时候，设备的GPU会进行解码并将它显示在屏幕。为了访问本地数据，你需要一份像素的复制，就像刚才做的那样。
    
    
    //此时此刻，pixels存储着图像的所有像素信息。下面的几行代码会对pixels进行遍历，并打印：
    NSLog(@"Brightness of image:");
    
    //2.定义一个指向第一个像素的指针，并使用2个for循环来遍历像素。其实也可以使用一个for循环从0遍历到width*height，但是这样写更容易理解图形是二维的。
    UInt32 * currentPixel = pixels;
    for (NSUInteger j = 0; j < cgImageHeight; j++) {
        for (NSUInteger i = 0; i < cgImageWidth; i++) {
            // 3.得到当前像素的值赋值给currentPixel并把它的亮度值打印出来
            UInt32 color = *currentPixel;
            printf("%3.0f ",     (R(color)+G(color)+B(color))/3.0);
            // 4.增加currentPixel的值，使它指向下一个像素。如果你对指针的运算比较生疏，记住这个：currentPixel是一个指向UInt32的变量，当你把它加1后，它就会向前移动4字节（32位），然后指向了下一个像素的值。
            currentPixel++;
        }
        printf("\n\n");
    }
    
    //此时此刻，这个程序只是打印出了原图的像素信息，但并没有进行任何修改！下面将会教你如何进行修改。
    
}

//- (void)processImage:(UIImage*)inputImage finish:(void(^)(UIImage *))finishBlock {
//
//    UIImage * outputImage = [self processUsingPixels:inputImage];
//    if (finishBlock) {
//        finishBlock(outputImage);
//    }
//
//}

#pragma mark - Public

#define Mask8(x) ( (x) & 0xFF )
#define R(x) ( Mask8(x) )
#define G(x) ( Mask8(x >> 8 ) )
#define B(x) ( Mask8(x >> 16) )
#define A(x) ( Mask8(x >> 24) )
#define RGBAMake(r, g, b, a) ( Mask8(r) | Mask8(g) << 8 | Mask8(b) << 16 | Mask8(a) << 24 )

#pragma mark - 处理图像
- (UIImage *)processImage:(UIImage *)inputImage faceModel:(WZZFaceModel *)faceModel {
    
    // 1. Get the raw pixels of the image
    UInt32 * inputPixels;
    
    CGImageRef inputCGImage = [inputImage CGImage];
    NSUInteger inputWidth = CGImageGetWidth(inputCGImage);
    NSUInteger inputHeight = CGImageGetHeight(inputCGImage);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    NSUInteger bytesPerPixel = 4;
    NSUInteger bitsPerComponent = 8;
    
    NSUInteger inputBytesPerRow = bytesPerPixel * inputWidth;
    
    inputPixels = (UInt32 *)calloc(inputHeight * inputWidth, sizeof(UInt32));
    
    CGContextRef context = CGBitmapContextCreate(inputPixels, inputWidth, inputHeight,
                                                 bitsPerComponent, inputBytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    CGContextDrawImage(context, CGRectMake(0, 0, inputWidth, inputHeight), inputCGImage);
    
    
    //--------------------------------------------------------------------------------
    //在processUsingPixels的返回语句前，添加如下代码，创建一个幽灵的CGImageRef对象
    UIImage * ghostImage = [UIImage imageNamed:@"dog.gif"];
    CGImageRef ghostCGImage = [ghostImage CGImage];
    
    //现在，做一些数学运算来确定幽灵图像放在原图的什么位置, 以下代码会把幽灵的图像宽度缩小25%，并把它的原点设定在点ghostOrigin
    CGFloat ghostImageAspectRatio = ghostImage.size.width/ghostImage.size.height;
    
    NSInteger targetGhostWidth = faceModel.frame.size.width*1.5;
//    NSInteger targetGhostWidth = inputWidth;
    CGSize ghostSize = CGSizeMake(targetGhostWidth, targetGhostWidth/ghostImageAspectRatio);
    CGPoint ghostOrigin = CGPointMake(faceModel.leftEye.x-(faceModel.rightEye.x-faceModel.leftEye.x)/2, 250);
//    CGPoint ghostOrigin = CGPointMake(inputWidth*0.5, inputHeight*0.2);
    
    //下一步是创建一张幽灵图像的缓存图
    NSUInteger ghostBytesPerRow = bytesPerPixel * ghostSize.width;
    UInt32 * ghostPixels = (UInt32 *)calloc(ghostSize.width * ghostSize.height, sizeof(UInt32));
    CGContextRef ghostContext = CGBitmapContextCreate(ghostPixels, ghostSize.width, ghostSize.height, bitsPerComponent, ghostBytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGContextDrawImage(ghostContext, CGRectMake(0, 0, ghostSize.width, ghostSize.height),ghostCGImage);
    /*
     上面的代码和你从inputImage中获得像素信息一样。不同的地方是，图像会被缩小尺寸，变得更小了。
     现在已经到了把幽灵图像合并到你的照片中的最佳时间了。
     合并：像前面提到的，每一个颜色都有一个透明通道来标识透明度。并且，你每创建一张图像，每一个像素都会有一个颜色值。
     所以，如果遇到有透明度和半透明的颜色值该如何处理呢？
     答案是，对透明度进行混合。在最顶层的颜色会使用一个公式与它后面的颜色进行混合。公式如下：
     */
    //NewColor = TopColor * TopColor.Alpha + BottomColor * (1 - TopColor.Alpha);
    NSUInteger offsetPixelCountForInput = ghostOrigin.y * inputWidth + ghostOrigin.x;
    for (NSUInteger j = 0; j < ghostSize.height; j++) {
        for (NSUInteger i = 0; i < ghostSize.width; i++) {
            if (ghostSize.width+ghostOrigin.x < inputWidth) {
                continue;
            }
            UInt32 * inputPixel = inputPixels+j*inputWidth+i+offsetPixelCountForInput;
            UInt32 inputColor = *inputPixel;
            
            UInt32 * ghostPixel = ghostPixels + j * (int)ghostSize.width + i;
            UInt32 ghostColor = *ghostPixel;
            //通过对幽灵图像像素数的循环和offsetPixelCountForInput获得输入的图像。记住，虽然你使用的是2维数据存储图像，但在内存他它实际上是一维的。
            //下一步，添加下面的代码到注释语句 Do some processing here的下面来进行混合：
            
            //你将幽灵图像的每一个像素的透明通道都乘以了0.5，使它成为半透明状态。然后将它混合到图像中像之前讨论的那样
//            CGFloat ghostAlpha = 0.5f * (A(ghostColor)     / 255.0);
            CGFloat ghostAlpha = 1.0f * (A(ghostColor) / 255.0);
            UInt32 newR = R(inputColor) * (1 - ghostAlpha) + R(ghostColor) * ghostAlpha;
            UInt32 newG = G(inputColor) * (1 - ghostAlpha) + G(ghostColor) * ghostAlpha;
            UInt32 newB = B(inputColor) * (1 - ghostAlpha) + B(ghostColor) * ghostAlpha;
            
            //clamping部分将每个颜色的值范围进行限定到0到255之间，虽然一般情况下值不会越界。但是，大多数情况下需要进行这种限定防止发生意外的错误输出
            newR = MAX(0,MIN(255, newR));
            newG = MAX(0,MIN(255, newG));
            newB = MAX(0,MIN(255, newB));
            
            *inputPixel = RGBAMake(newR, newG, newB, A(inputColor));
        }
    }

    CGImageRef newCGImage = CGBitmapContextCreateImage(context);
    UIImage * processedImage = [UIImage imageWithCGImage:newCGImage];
    //--------------------------------------------------------------------------------
    
    return processedImage;
}

#pragma mark 获取人脸位置
- (WZZFaceModel *)getOriginWithImage:(UIImage *)aImage {
    CIImage* image = [CIImage imageWithCGImage:aImage.CGImage];
    
    NSDictionary  *opts = [NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh
                                                      forKey:CIDetectorAccuracy];
    CIDetector* detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                              context:nil
                                              options:opts];
    
    //得到面部数据
    NSArray* features = [detector featuresInImage:image];
    

    NSMutableArray * faceModelArr = [NSMutableArray array];
    //最后的features中就是检测到的全部脸部数据，可以用如下方式计算位置：
    
    for (CIFaceFeature *f in features)
    {
        CGRect aRect = f.bounds;
        NSLog(@"%f, %f, %f, %f", aRect.origin.x, aRect.origin.y, aRect.size.width, aRect.size.height);
        WZZFaceModel * model = [[WZZFaceModel alloc] init];
        model.frame = aRect;
        
        //眼睛和嘴的位置
        if(f.hasLeftEyePosition) {
            model.leftEye = f.leftEyePosition;
            NSLog(@"Left eye %g %g\n", f.leftEyePosition.x, f.leftEyePosition.y);
        }
        if(f.hasRightEyePosition) {
            model.rightEye = f.rightEyePosition;
            NSLog(@"Right eye %g %g\n", f.rightEyePosition.x, f.rightEyePosition.y);
        }
        if(f.hasMouthPosition) {
            model.mouth = f.mouthPosition;
            NSLog(@"Mouth %g %g\n", f.mouthPosition.x, f.mouthPosition.y);
        }
        
        [faceModelArr addObject:model];
    }
    
    return [faceModelArr firstObject];
}

@end

@implementation WZZFaceModel
@end
