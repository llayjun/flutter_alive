//
//  ShareBoardView.m
//  Runner
//
//  Created by 张智慧 on 2020/3/23.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

#import "ShareBoardView.h"

@implementation ShareBoardView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.shareBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:10];
    [self.savePicBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:10];
}

//- (void)layoutSubviews {
//    [super layoutSubviews];
//    self.width = WIDE;
//    self.height = 245;
//    [self layoutIfNeeded];
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
