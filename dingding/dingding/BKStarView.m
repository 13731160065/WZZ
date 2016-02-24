//
//  BKStarView.m
//  dingding
//
//  Created by CccDaxIN on 15/12/20.
//  Copyright © 2015年 rabbit. All rights reserved.
//

#import "BKStarView.h"

@implementation BKStarView

- (void)awakeFromNib{
    NSLog(@"[INFO]");
//    self.backgroundColor = [UIColor blueColor];
    
    int starNum = 3;
    for (int i = 0; i<5; i++) {
        UIImageView * starImg= [[UIImageView alloc]init];
        if (starNum > i) {
            starImg.image = [UIImage imageNamed:@"star.png"];
        }else{
            starImg.image = [UIImage imageNamed:@"star1.png"];
        }
        
//       
//        [BKStarView addSubview:starImg];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
