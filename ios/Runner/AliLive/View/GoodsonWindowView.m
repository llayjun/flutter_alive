//
//  GoodsonWindowView.m
//  Runner
//
//  Created by 张智慧 on 2020/3/18.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

#import "GoodsonWindowView.h"

@implementation GoodsonWindowView

- (void)layoutSubviews {
    [super layoutSubviews];
    self.width = 100;
    self.height =  240*WIDES + 80;
    [self layoutIfNeeded];
}
- (IBAction)close:(id)sender {
    CGPoint animationPoint = CGPointMake(self.x, 0);
    CGFloat offsetY = animationPoint.y + self.height / 2;
    self.transform = CGAffineTransformMake(1, 0, 0, 1, 0, 0);
    [UIView animateWithDuration:0.25 animations:^{
       self.transform = CGAffineTransformMake(0.01, 0, 0, 0.01, self.x, offsetY);
    } completion:^(BOOL finished) {
       self.transform = CGAffineTransformIdentity;
       self.hidden = YES;
    }];
}


- (void)show {
    self.hidden = NO;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
