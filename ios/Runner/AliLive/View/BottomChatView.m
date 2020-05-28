//
//  BottomChatView.m
//  Runner
//
//  Created by 张智慧 on 2020/3/12.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

#import "BottomChatView.h"

@interface BottomChatView ()

@property (weak, nonatomic) IBOutlet UIButton *dataBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

@end

@implementation BottomChatView

- (void)awakeFromNib {
    [super awakeFromNib];

    [self.dataBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:3];
    [self.shareBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:3];
}

- (IBAction)didClick:(UIButton *)sender {
    if([self.delegate respondsToSelector:@selector(didClickInteractionView:typeWith:)]) {
        if(sender.tag == 100) {
//            sender.selected = !sender.selected;
            [self.delegate didClickInteractionView:self typeWith:InteractionType_board];
            sender.selected = YES;
            if(sender.selected) {
                sender.backgroundColor = COLOR_FFFFFF;
            }else {
//                sender.backgroundColor = COLOR_F95259;
            }
            
        }else if(sender.tag == 300) {
            [self.delegate didClickInteractionView:self typeWith:InteractionType_data];
        }else if(sender.tag == 200) {
            [self.delegate didClickInteractionView:self typeWith:InteractionType_share];
        }else {
            [self.delegate didClickInteractionView:self typeWith:InteractionType_goodlist];
        }
        
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];
    self.width = WIDE;
    self.height = 60 + Indicator_H;
    [self layoutIfNeeded];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
