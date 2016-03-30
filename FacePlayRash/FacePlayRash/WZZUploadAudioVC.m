//
//  WZZUploadAudioVC.m
//  FacePlayRash
//
//  Created by 王泽众 on 16/3/19.
//  Copyright © 2016年 wzz. All rights reserved.
//

#import "WZZUploadAudioVC.h"
#import "WZZShowVC.h"
#import "WZZChooseBackView.h"

@interface WZZUploadAudioVC ()<UITextFieldDelegate>
{
    UISwitch * switchBtn;
    UIScrollView * scroll;
    NSInteger currentPicTypel;
    NSString * currentPicName;
    UIButton * selectButton;
}
@end

@implementation WZZUploadAudioVC

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
    
    //预览图像
    UIButton * playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:playButton];
    [playButton setTitle:@"预览图像" forState:UIControlStateNormal];
    [playButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [playButton setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-8-100, 20, 100, 44)];
    [playButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [playButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [playButton addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
    
    selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:selectButton];
    [selectButton addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    [selectButton setFrame:CGRectMake(0, 64+51, [UIScreen mainScreen].bounds.size.width, 50)];
    [selectButton setTitle:@"点击选择标签所属组" forState:UIControlStateNormal];
    [selectButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [selectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [selectButton setBackgroundColor:[UIColor whiteColor]];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 64+2*51, [UIScreen mainScreen].bounds.size.width, 50)];
    [self.view addSubview:label];
    [label setText:@"是否人物标签->"];
    [label setUserInteractionEnabled:YES];
    [label setBackgroundColor:[UIColor whiteColor]];
    
    switchBtn = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [switchBtn setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-switchBtn.frame.size.width-8, 64+2*51+label.frame.size.height/2-switchBtn.frame.size.height/2, 0, 0)];
    [self.view addSubview:switchBtn];
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

- (void)selectBtn:(UIButton *)button {
    [HttpTool GET:[YuMing stringByAppendingString:@"/faceplayapp/getAllTagGpic.action"] parameters:nil success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            //成功
            WZZChooseBackView * choose = [[WZZChooseBackView alloc] initWithChooseViewFrame:CGRectMake(button.frame.origin.x, CGRectGetMaxY(button.frame), button.frame.size.width, 200) dataArr:responseObject[@"rows"] selectBlock:^(NSString *selectName, NSInteger idx) {
                currentPicTypel = idx;
                currentPicName = selectName;
                [selectButton setTitle:selectName forState:UIControlStateNormal];
            }];
            [self.view addSubview:choose];
        } else {
            //失败
            [MBProgressHUD showError:@"获取标签失败"];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络连接失败"];
    }];
}

- (void)playVideo {
    WZZShowVC * showvc = [[WZZShowVC alloc] init];
    showvc.image = self.uploadImage;
    [self.navigationController pushViewController:showvc animated:YES];
}

//上传模版
- (void)uploadVideo {
    NSMutableDictionary * uploadDic = [NSMutableDictionary dictionary];
    if (!self.uploadImage) {
        [MBProgressHUD showError:@"没有图片"];
        return;
    }
    if (switchBtn.on) {
        //人物
        [uploadDic setObject:@"0" forKey:@"state"];
    } else {
        //非人物
        [uploadDic setObject:@"1" forKey:@"state"];
    }
    if ([selectButton.titleLabel.text isEqualToString:@"点击选择标签所属组"]) {
        [MBProgressHUD showError:@"请选择标签所属组"];
    }
    [uploadDic setObject:@"0" forKey:@"picType"];
    [uploadDic setObject:[NSString stringWithFormat:@"%lf", self.uploadModel.frame.size.height] forKey:@"height"];
    [uploadDic setObject:[NSString stringWithFormat:@"%lf", self.uploadModel.frame.size.width] forKey:@"width"];
    [uploadDic setObject:[NSString stringWithFormat:@"%lf", self.uploadModel.frame.origin.x] forKey:@"x"];
    [uploadDic setObject:[NSString stringWithFormat:@"%lf", self.uploadModel.frame.origin.y] forKey:@"y"];
    //坐标
//    [uploadDic setObject:self.uploadDicStr forKey:@"pictures"];
    MBProgressHUD * hud = [MBProgressHUD showMessage:@"正在上传"];
    [HttpTool POST:[YuMing stringByAppendingString:@"/faceplayapp/uploadSysPeoplePic.action"] parameters:uploadDic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImageJPEGRepresentation(self.uploadImage, 1.0f) name:@"picture" fileName:@"vvv.jpg" mimeType:@"image/jpeg"];
    } success:^(id responseObject) {
        //视频上传成功
        [hud hide:YES];
        [MBProgressHUD showSuccess:@"上传成功"];
    } failure:^(NSError *error) {
        [hud hide:YES];
        [MBProgressHUD showError:FaildLoad];
    }];
}

//返回
- (void)backBtnClick {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
