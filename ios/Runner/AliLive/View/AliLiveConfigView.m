//
//  AliLiveConfigView.m
//  ocflutter
//
//  Created by 张智慧 on 2020/2/19.
//  Copyright © 2020 张智慧. All rights reserved.
//

#import "AliLiveConfigView.h"

@implementation AliLiveConfigView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
- (IBAction)configClick:(UIButton *)sender {
    if(sender.tag == 103) {
        UIButton *flashBtn = (UIButton *)[self viewWithTag:102];
        flashBtn.enabled = !flashBtn.enabled;
    }
    if([self.delegate respondsToSelector:@selector(didClickView:typeWith:)]) {
        [self.delegate didClickView:self typeWith:sender.tag == 100?ConfigType_skin:(sender.tag == 101)?ConfigType_music:(sender.tag == 102)?ConfigType_flash:(sender.tag == 103)?ConfigType_camera:ConfigType_setting];
    }
}

- (void)setPushConfig:(AlivcLivePushConfig *)pushConfig {
    /// 美颜
    UIButton *beautyBtn = (UIButton *)[self viewWithTag:100];
    beautyBtn.selected = pushConfig.beautyOn;
    /// 闪关灯
    UIButton *flashBtn = (UIButton *)[self viewWithTag:102];
    flashBtn.selected = pushConfig.flash;
    
}

- (void)initConfigWith:(AlivcLivePushConfig *)config {
    UIButton *flashBtn = (UIButton *)[self viewWithTag:102];
    if(config.cameraType == AlivcLivePushCameraTypeBack) {
        flashBtn.enabled = YES;
    }else {
        flashBtn.enabled = NO;
    }
    
    UIButton *beautyBtn = (UIButton *)[self viewWithTag:100];
    beautyBtn.selected = config.beautyOn;
}


@end
