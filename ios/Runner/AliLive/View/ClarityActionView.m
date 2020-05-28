//
//  ClarityActionView.m
//  Runner
//
//  Created by 张智慧 on 2020/3/16.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

#import "ClarityActionView.h"

@implementation ClarityActionView

- (void)awakeFromNib {
    [super awakeFromNib];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, WIDE, 100) byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(10,10)].CGPath;
    self.layer.mask = maskLayer;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.width = WIDE;
    self.height = 100;
    [self layoutIfNeeded];
}
- (IBAction)clarityChange:(UIButton *)sender {
    for (UIView *subView in self.subviews) {
        if([subView isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)subView;
            if(btn.tag == sender.tag) {
                btn.selected = YES;
            }else {
                btn.selected = NO;
            }
        }
    }
    if(self.clarityBlock) {
        self.clarityBlock(sender.tag);
    }
}

- (void)setIs540:(BOOL)is540 {
    UIButton *fristBtn = [self viewWithTag:1];
    fristBtn.selected = is540;
    UIButton *lastBtn = [self viewWithTag:2];
    lastBtn.selected = !is540;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
