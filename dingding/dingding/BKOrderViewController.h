//
//  BKOrderViewController.h
//  dingding
//
//  Created by CccDaxIN on 15/12/20.
//  Copyright © 2015年 rabbit. All rights reserved.
//  订单详情页面

#import <UIKit/UIKit.h>

@interface BKOrderViewController : UIViewController


- (IBAction)cancleOrder:(id)sender;

@property (nonatomic,assign) BOOL isFinisedOrder;

@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *guideName;
@property (weak, nonatomic) IBOutlet UILabel *lvxingsheName;
@property (weak, nonatomic) IBOutlet UILabel *orderNum;
@property (weak, nonatomic) IBOutlet UIImageView *isSure;
- (IBAction)callGuide:(id)sender;


@end
