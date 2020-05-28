//
//  BoardLiveDataView.m
//  Runner
//
//  Created by 张智慧 on 2020/3/17.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

#import "BoardLiveDataView.h"

@interface BoardLiveDataView ()
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UILabel *viewLab;
@property (weak, nonatomic) IBOutlet UILabel *onlineLab;
@property (weak, nonatomic) IBOutlet UILabel *interactionLab;
@property (weak, nonatomic) IBOutlet UILabel *productLab;

@end

@implementation BoardLiveDataView

- (void)awakeFromNib {
    [super awakeFromNib];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, WIDE, 275) byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(10,10)].CGPath;
    self.layer.mask = maskLayer;
    
}

- (void)requestDataWith:(NSString *)lbId {
    /// 获取直播统计
    NSString *url = [NSString stringWithFormat:@"%@/%@/statistics",GetLiveBroadcastURL,lbId];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:lbId forKey:@"lbId"];
    [[RequestManager shareInstance]requestWithMethod:GET url:url dict:dic finished:^(id request) {
        StatisticsModel *subModel = [StatisticsModel mj_objectWithKeyValues:request];
        self.viewLab.text = subModel.view;
        self.onlineLab.text = subModel.online;
        self.interactionLab.text = subModel.interaction;
        self.productLab.text = subModel.productView;
    } failed:^(NSError *error) {
        
    }];
}


+ (void)showWithBoardId:(NSString *)boardId {
    BoardLiveDataView *dataView = [BoardLiveDataView createViewFromNib];
    [dataView requestDataWith:boardId];
    TYAlertController *alertVC = [TYAlertController alertControllerWithAlertView:dataView preferredStyle:TYAlertControllerStyleActionSheet];
    [[dataView.closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        [[UIViewController currentViewController] dismissViewControllerAnimated:YES completion:nil];
    }];
    [[UIViewController currentViewController] presentViewController:alertVC animated:YES completion:nil];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
