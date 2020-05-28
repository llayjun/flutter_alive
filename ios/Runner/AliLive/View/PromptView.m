//
//  PromptView.m
//  Runner
//
//  Created by 张智慧 on 2020/4/7.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

#import "PromptView.h"
#import <pthread/pthread.h>

@interface PromptView ()
{
    pthread_mutex_t _mutex; // 互斥锁
}
@property (nonatomic, strong) UILabel *titleLab;

@end

@implementation PromptView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.backgroundColor = COLOR_F56043;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 2.0f;
        self.titleLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, self.width-20, self.height)];
        self.titleLab.textColor = COLOR_FFFFFF;
        self.titleLab.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.titleLab];
    }
    return self;
}

- (void)showWith:(NSString *)text {
    pthread_mutex_lock(&_mutex);
    self.hidden = NO;
    self.x = -140;
    self.alpha = 0;
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        [self.superview bringSubviewToFront:self];
        self.x = 12;
        self.alpha = 1;
        self.titleLab.text = text;
    } completion:^(BOOL finished) {
        
        /// 延迟三秒消失
        [self dismiss];
    }];
    
}

- (void)dismiss {
    @WeakSelf(self);
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakSelf.hidden = YES;
            pthread_mutex_unlock(&_mutex);
        });
    });
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
