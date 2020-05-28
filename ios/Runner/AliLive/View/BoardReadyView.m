//
//  BoardReadyView.m
//  Runner
//
//  Created by 张智慧 on 2020/3/17.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

#import "BoardReadyView.h"

@interface BoardReadyView()
@property (weak, nonatomic) IBOutlet UILabel *centerLab;

@end

@implementation BoardReadyView

- (void)awakeFromNib {
    [super awakeFromNib];
    @WeakSelf(self);
    __block NSInteger second = 3;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    __block dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.centerLab.text = [NSString stringWithFormat:@"%ld",second];
            second--;
            if(second == 0) {
                dispatch_source_cancel(_timer);
                _timer = nil;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UIView animateWithDuration:1 animations:^{
                        weakSelf.alpha = 0;
                    } completion:^(BOOL finished) {
                        if(weakSelf.successBlock) {
                            weakSelf.successBlock();
                        }
                        [weakSelf removeFromSuperview];
                    }];
                });
                
            }
        });
    });
    dispatch_resume(_timer);
}

+ (void)showWith:(SuccessBlock)completeBlock {
    BoardReadyView *readyView = [[NSBundle mainBundle]loadNibNamed:@"BoardReadyView" owner:self options:nil].lastObject;
    readyView.successBlock = completeBlock;
    readyView.frame = CGRectMake(0, 0, WIDE, HIGHT);
    [[UIApplication sharedApplication].keyWindow addSubview:readyView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
