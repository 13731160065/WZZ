//
//  tuikuanApplyController.h
//  dingding
//
//  Created by mac on 16/1/19.
//  Copyright © 2016年 rabbit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface tuikuanApplyController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *selectBtn1;
@property (strong, nonatomic) IBOutlet UIButton *selectBtn2;

- (IBAction)select1:(id)sender;

- (IBAction)select2:(id)sender;

- (IBAction)submit:(id)sender;

@end
