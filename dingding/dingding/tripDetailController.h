//
//  tripDetailController.h
//  dingdingtest
//
//  Created by mac on 16/1/19.
//  Copyright © 2016年 rabbit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface tripDetailController : UIViewController

//头像
@property (strong, nonatomic) IBOutlet UIImageView *headImage;
//用户名
@property (strong, nonatomic) IBOutlet UILabel *UserName;
//旅行社
@property (strong, nonatomic) IBOutlet UILabel *tripName;
//星星数量
@property (strong, nonatomic) IBOutlet UILabel *starNum;
//星星图片
@property (strong, nonatomic) IBOutlet UIImageView *starImg;
//详情1
@property (strong, nonatomic) IBOutlet UILabel *detailLb1;
//详情2
@property (strong, nonatomic) IBOutlet UILabel *detailLb2;

@property (nonatomic, assign)BOOL isFinish;

@end
