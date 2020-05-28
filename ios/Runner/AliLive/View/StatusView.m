//
//  StatusView.m
//  Runner
//
//  Created by 张智慧 on 2020/3/26.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

#import "StatusView.h"

@implementation StatusView


- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.statusLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.width, 20)];
        self.statusLab.backgroundColor = COLOR_F63825;
        self.statusLab.layer.cornerRadius = 2.0f;
        self.statusLab.layer.masksToBounds = YES;
        self.statusLab.text = @"未开始";
        self.statusLab.textColor = COLOR_FFFFFF;
        self.statusLab.font = [UIFont systemFontOfSize:12];
        self.statusLab.textAlignment = NSTextAlignmentCenter;
        self.favnumLab = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.statusLab.frame)+5, 100, 20)];
        self.favnumLab.text = @"0个赞";
        self.favnumLab.hidden = YES;
        self.favnumLab.textColor = COLOR_FFFFFF;
        self.favnumLab.layer.cornerRadius = 2.0f;
        self.favnumLab.layer.masksToBounds = YES;
        self.favnumLab.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        self.favnumLab.font = [UIFont systemFontOfSize:12];
        self.favnumLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.statusLab];
        [self addSubview:self.favnumLab];
    }
    return self;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
