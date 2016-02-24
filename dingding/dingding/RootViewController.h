//
//  RootViewController.h
//  dingding
//
//  Created by CccDaxIN on 15/12/14.
//  Copyright © 2015年 rabbit. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BKCreateOrderDelegate <NSObject>

- (void) createOrder; // 发起订单

@end

@interface RootViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *orderStateView;

@property (weak, nonatomic) IBOutlet UIView *contextView;

@property (weak, nonatomic) IBOutlet UITextField *destinationAddress;
@property (weak, nonatomic) IBOutlet UIView *bottomVIew;



@end
