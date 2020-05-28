//
//  SettingView.m
//  Runner
//
//  Created by 张智慧 on 2020/3/16.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

#import "SettingView.h"

@implementation SettingView


- (instancetype)initWithFrame:(CGRect)frame beautyOnWith:(BOOL)beautyOn{
    if(self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 4.0f;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.9];
        NSArray *arr = @[beautyOn?@"关闭美颜":@"开启美颜",@"清晰度"];
        for(int i = 0;i<arr.count;i++) {
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, self.height/2*i, self.width, self.height/2)];
            btn.tag = i;
            [btn setTitle:arr[i] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn addTarget:self action:@selector(didClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
        }
    }
    return self;
}

- (void)didClick:(UIButton *)button {
    if(self.settingBlock) {
        self.settingBlock(button.tag == 0?SettingType_beauty:SettingType_clarity);
        [self removeFromSuperview];
    }
}

+ (void)showWith:(BOOL)isBeautyOn blockWith:(ChooseSettingBlock)setBlock {
    if([[UIApplication sharedApplication].keyWindow viewWithTag:2222]) {
        [[[UIApplication sharedApplication].keyWindow viewWithTag:2222] removeFromSuperview];
    }
    SettingView *settingView = [[SettingView alloc]initWithFrame:CGRectMake(WIDE - 110, NAV_H, 100, 80) beautyOnWith:isBeautyOn];
    settingView.tag = 2222;
    settingView.settingBlock = setBlock;
    [[UIApplication sharedApplication].keyWindow addSubview:settingView];
    [UIView animateWithDuration:0.5 animations:^{
        settingView.alpha = 0.9f;
    } completion:^(BOOL finished) {
        
    }];
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
