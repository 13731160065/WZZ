//
//  WZZUploadVideoVC.m
//  FacePlayRash
//
//  Created by 王泽众 on 16/3/19.
//  Copyright © 2016年 wzz. All rights reserved.
//

#import "WZZUploadVideoVC.h"
#import "WZZPlayerManager.h"

@interface WZZUploadVideoVC ()<UITextFieldDelegate>
{
    NSMutableArray * tfArr;
    UIScrollView * scroll;
    UISwitch * switchBtn;
}
@end

@implementation WZZUploadVideoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor lightGrayColor]];

    scroll = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:scroll];
    [scroll setContentSize:CGSizeMake(0, 0)];
    
    //返回
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:backButton];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton setFrame:CGRectMake(8, 20, 100, 44)];
    [backButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [backButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [backButton addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //预览视频
    UIButton * playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:playButton];
    [playButton setTitle:@"预览视频" forState:UIControlStateNormal];
    [playButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [playButton setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-8-100, 20, 100, 44)];
    [playButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [playButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [playButton addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
    
    
    tfArr = [NSMutableArray array];
    NSArray * nameArr = @[@"模版名称", @"模版描述", @"购买价格"];
    NSArray * holdArr = @[@"在此填写视频模版名称", @"在此填写视频模版描述", @"关闭右边按钮为免费->"];
    [nameArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView * view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 64+idx*51, [UIScreen mainScreen].bounds.size.width, 50)];
        [self.view addSubview:view1];
        [view1 setBackgroundColor:[UIColor whiteColor]];
        UITextField * tf = [self creatTFWithView:view1 titleText:nameArr[idx] placeHolderText:holdArr[idx]];
        [tfArr addObject:tf];
        [tf setDelegate:self];
        if (idx == 2) {
            [tf setKeyboardType:UIKeyboardTypeDecimalPad];
        }
    }];
    
    UITextField * tff = (UITextField *)tfArr[2];
    switchBtn = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [switchBtn setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-switchBtn.frame.size.width-8, tff.frame.size.height/2-switchBtn.frame.size.height/2, 0, 0)];
    [tff.superview addSubview:switchBtn];
    [switchBtn addTarget:self action:@selector(feeChange:) forControlEvents:UIControlEventValueChanged];
    switchBtn.on = YES;
    
    
    //上传模版
    UIButton * uploadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:uploadBtn];
    [uploadBtn setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-200/2, [UIScreen mainScreen].bounds.size.height-60, 200, 40)];
    [uploadBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [uploadBtn setTitle:@"上传模版" forState:UIControlStateNormal];
    [uploadBtn addTarget:self action:@selector(uploadVideo) forControlEvents:UIControlEventTouchUpInside];
    [uploadBtn setBackgroundColor:[UIColor whiteColor]];
    [uploadBtn.layer setMasksToBounds:YES];
    [uploadBtn.layer setCornerRadius:5];
    
}

- (void)feeChange:(UISwitch *)swb {
    UITextField * tff = (UITextField *)tfArr[2];
    tff.enabled = swb.on;
    if (!swb.on) {
        [tff setText:@""];
    }
}

- (void)playVideo {
    [WZZPlayerManager playMovieWithURLString:[NSString stringWithFormat:@"%@", self.uploadURL] presentVC:self];
}

#define UPLOAD_FEE @"price"//价格
#define UPLOAD_NAME @"title"//名称
#define UPLOAD_DES @"videoDesc"//描述
#define UPLOAD_HAVEFEE @"freeOrpay"//是否付费
#define UPLOAD_HAVEFEEYES @"1"//是
#define UPLOAD_HAVEFEENO @"0"//否
#define UPLOAD_IMAGEURL @"picUrl"//图片
#define UPLOAD_IMAGEKEY @"headImg"//图片建
#define UPLOAD_VIDEOKEY @"video"//视频建
//上传模版
- (void)uploadVideo {
    NSMutableDictionary * uploadDic = [NSMutableDictionary dictionary];
    UITextField * nametf = (UITextField *)tfArr[0];
    UITextField * desf = (UITextField *)tfArr[1];
    UITextField * feetf = (UITextField *)tfArr[2];
    if ([nametf.text isEqualToString:@""] || [desf.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"信息不全"];
        return;
    }
    if (!self.mainImage) {
        [MBProgressHUD showError:@"没有封面图"];
        return;
    }
    if (!self.uploadURL) {
        [MBProgressHUD showError:@"没有视频"];
        return;
    }
    if (switchBtn.on) {
        //付费
        if ([feetf.text isEqualToString:@""]) {
            [MBProgressHUD showError:@"请输入价格或选择免费"];
            return;
        }
        [uploadDic setObject:nametf.text forKey:UPLOAD_NAME];
        [uploadDic setObject:UPLOAD_HAVEFEEYES forKey:UPLOAD_HAVEFEE];
        [uploadDic setObject:feetf.text forKey:UPLOAD_FEE];
    } else {
        //免费
        [uploadDic setObject:UPLOAD_HAVEFEENO forKey:UPLOAD_HAVEFEE];
    }
    [uploadDic setObject:@"1" forKey:@"userId"];
    [uploadDic setObject:desf.text forKey:UPLOAD_DES];
    //坐标
    [uploadDic setObject:self.uploadDicDataStr forKey:@"pictures"];
    MBProgressHUD * hud = [MBProgressHUD showMessage:@"正在提交"];
    [HttpTool POST:[YuMing stringByAppendingString:@"/faceplayapp/imgupload.action"] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImageJPEGRepresentation(self.mainImage, 0.3f) name:UPLOAD_IMAGEKEY fileName:@"mainImage.jpg" mimeType:@"image/jpeg"];
    } success:^(id responseObject) {
        //上传成功
        if ([responseObject[@"code"] integerValue] == 0) {
            //成功
            NSString * imagePath = responseObject[@"rows"][@"imgurl"];
            [uploadDic setObject:imagePath forKey:UPLOAD_IMAGEURL];
            NSLog(@"%@", self.uploadURL);

            [HttpTool POST:[YuMing stringByAppendingString:@"/faceplayapp/uploadMyVideo.action"] parameters:uploadDic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                [formData appendPartWithFileURL:self.uploadURL name:UPLOAD_VIDEOKEY fileName:@"vvv.mp4" mimeType:@"video/mp4" error:nil];
                
            } success:^(id responseObject) {
                //视频上传成功
                [hud hide:YES];
                [MBProgressHUD showSuccess:@"上传成功"];
            } failure:^(NSError *error) {
                [hud hide:YES];
                [MBProgressHUD showError:FaildLoad];
            }];
        } else {
            [hud hide:YES];
            [MBProgressHUD showError:@"封面上传失败"];
        }
    } failure:^(NSError *error) {
        [hud hide:YES];
        [MBProgressHUD showError:FaildLoad];
    }];
}

//返回
- (void)backBtnClick {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - 快速创建tf
- (UITextField *)creatTFWithView:(UIView *)view titleText:(NSString *)title placeHolderText:(NSString *)placeHolder{
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, view.frame.size.height)];
    [view addSubview:titleLabel];
    [titleLabel setFont:[UIFont systemFontOfSize:15]];
    [titleLabel setText:title];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    UITextField * TFView = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame), 0, view.frame.size.width-CGRectGetMaxX(titleLabel.frame), view.frame.size.height)];
    [view addSubview:TFView];
    [TFView setPlaceholder:placeHolder];
    [TFView setFont:[UIFont systemFontOfSize:15]];
    
    return TFView;
}

@end
