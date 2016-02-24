//
//  BKMoreInfoViewController.m
//  dingding
//
//  Created by CccDaxIN on 15/12/14.
//  Copyright © 2015年 rabbit. All rights reserved.
//

#import "BKMoreInfoViewController.h"
#import "AppDelegate.h"
#import "BKMoreInfoForm.h"

@interface BKMoreInfoViewController (){
    BKMoreInfoForm *_form;
}

@end

@implementation BKMoreInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _form = [[BKMoreInfoForm alloc]init];
    
    self.formController.form = _form;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) beginOrder {

    [self dismissViewControllerAnimated:YES completion:^{
        // TODO 整理数据，保存数据
        [self.delegate createOrder];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"startCheckState" object:nil];
        
    }];
    
}



















/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
