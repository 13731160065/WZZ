
//
//  BKLSideView.h
//  dingding
//
//  Created by CccDaxIN on 16/1/13.
//  Copyright © 2016年 rabbit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface BKLSideView : UIView

@property (weak, nonatomic) IBOutlet UIView *contextView;
@property (weak, nonatomic) IBOutlet UIImageView *lastImageView;
//- (IBAction)logOut:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *logOut;
@property (weak, nonatomic) IBOutlet UILabel *myTrip;
@property (weak, nonatomic) IBOutlet UILabel *myPurse;
@property (weak, nonatomic) IBOutlet UILabel *messageCenter;
@property (weak, nonatomic) IBOutlet UILabel *tuijianSight;
@property (weak, nonatomic) IBOutlet UILabel *tuijianGuide;
@property (weak, nonatomic) IBOutlet UILabel *myCardWallet;
@property (weak, nonatomic) IBOutlet UILabel *settings;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *realUserName;



@property (weak, nonatomic) IBOutlet UIButton *serviceCall;

@property (weak, nonatomic) IBOutlet UIView *userCenterView;



/**
 * 显示侧边栏
 */
- (void) show:(BOOL) animated;

/**
 * 关闭侧国栏
 */
- (void) close:(BOOL) animated;

/**
 * 改变用户名和手机号的显示
 */
- (void) refreshUserInfoWithName:(NSString *)name telePhone:(NSString *)telephone;

@end
