//
//  OrderPayViewController.h
//  dingding
//
//  Created by mac on 16/1/9.
//  Copyright © 2016年 rabbit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderPayViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *priceNUM;   //输入的价钱

- (IBAction)toPay:(id)sender;   //支付



@end
