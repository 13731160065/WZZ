//
//  cancelSuccessController.h
//  dingding
//
//  Created by mac on 16/1/19.
//  Copyright © 2016年 rabbit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface cancelSuccessController : UIViewController

//判断是否已经支付
@property (nonatomic, assign)BOOL isPay;

@property (nonatomic,strong)NSString *reason;

@end
