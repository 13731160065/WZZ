//
//  BKLSideView.m
//  dingding
//
//  Created by CccDaxIN on 16/1/13.
//  Copyright © 2016年 rabbit. All rights reserved.
//

#import "BKLSideView.h"

#import "BKLoginViewController.h"

//#import "<AFNetworking/UIImageView+AFNetwoking.h>"

@implementation BKLSideView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"init left side");
        [self.lastImageView setImageWithURL:[NSURL URLWithString:@"http://192.168.1.107:3000/img/home_top.png"]];
        self.contextView.backgroundColor  =[UIColor  redColor];
    }
    return self;
}

- (void)show:(BOOL)animated{
    self.hidden = NO;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    self.contextView.frame = CGRectMake(0, 0, self.contextView.frame.size.width, self.contextView.frame.size.height);
    
    [UIView commitAnimations];
}

- (IBAction)backgroudTap:(id)sender {
    [self close:YES];
}


- (void) close:(BOOL)animated{
    if (animated) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationDelegate:self];
        
        [UIView setAnimationDidStopSelector:@selector(closeOnAnimated)];
        self.contextView.frame = CGRectMake(-self.contextView.frame.size.width, 0, self.contextView.frame.size.width, self.contextView.frame.size.height);
        
        [UIView commitAnimations];
    }
    
    
//    self.hidden = YES;
}
- (void) closeOnAnimated{
    self.hidden = YES;
}

/**
 * 改变用户名和手机号的显示
 */
- (void) refreshUserInfoWithName:(NSString *)name telePhone:(NSString *)telephone{
    
    self.realUserName.text = name;
    self.userName.text = telephone;
    

}


//- (IBAction)logOut:(id)sender {
////    UIAlertView *alertt = [[UIAlertView alloc]initWithTitle:@"抱歉" message:@"这个页面还需要修改，正在赶工" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
////    [alertt show];
//
//    
//}
@end
