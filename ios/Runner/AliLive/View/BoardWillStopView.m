//
//  BoardWillStopView.m
//  Runner
//
//  Created by 张智慧 on 2020/3/17.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

#import "BoardWillStopView.h"

@interface BoardWillStopView ()
@property (weak, nonatomic) IBOutlet UILabel *seeNumLab;
@property (weak, nonatomic) IBOutlet UILabel *favNumLab;

@end

@implementation BoardWillStopView

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)requestDataWith:(NSString *)lbId {
    /// 获取直播统计
    NSString *url = [NSString stringWithFormat:@"%@/%@/statistics",GetLiveBroadcastURL,lbId];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:lbId forKey:@"lbId"];
    [[RequestManager shareInstance]requestWithMethod:GET url:url dict:dic finished:^(id request) {
        StatisticsModel *subModel = [StatisticsModel mj_objectWithKeyValues:request];
        self.seeNumLab.text = subModel.view;
    } failed:^(NSError *error) {
        
    }];
}

+ (void)showIdWith:(NSString *)boardId favWith:(NSString *)favNum resultWith:(BoardWillStopBlock)stopBlock {
    BoardWillStopView *subView = [[NSBundle mainBundle]loadNibNamed:@"BoardWillStopView" owner:self options:nil].lastObject;
    [subView requestDataWith:boardId];
    subView.favNumLab.text = favNum.length!=0?favNum:@"0";
    subView.willStopBlock = stopBlock;
    subView.frame = CGRectMake(0, 0, WIDE, HIGHT);
    subView.alpha = 0;
//    subView.transform = CGAffineTransformScale(subView.transform,0.1,0.1);
    [UIView animateWithDuration:0.5 animations:^{
//        subView.transform = CGAffineTransformIdentity;
        subView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
    
    [UIApplication.sharedApplication.keyWindow addSubview:subView];
}

- (IBAction)boardClick:(UIButton *)sender {
    if(sender.tag == 1){
        if(self.willStopBlock) {
            self.willStopBlock();
        }
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
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
