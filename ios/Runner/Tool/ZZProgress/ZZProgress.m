//
//  ZZProgress.m
//  Mend
//
//  Created by GOOT on 2017/8/26.
//  Copyright © 2017年 wisdom. All rights reserved.
//

#import "ZZProgress.h"
#import <MBProgressHUD.h>
#define CurrentLastView  [UIApplication sharedApplication].keyWindow

/// 显示多久关闭
static const NSTimeInterval kShowingTime = 1.5;
/// 优雅时间
static const NSTimeInterval kGraceTime = 0.75;

@implementation ZZProgress

+ (void)show{
    MBProgressHUD *hud =  [self createDefaultHUD];
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kShowingTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
    });
}

+ (void)showWithStatus:(NSString *)status{
    MBProgressHUD *hud = [self createDefaultHUD];
    hud.square = YES;
    if ([status rangeOfString:@"\n"].location != NSNotFound) {
        NSArray *arry = [status componentsSeparatedByString:@"\n"];
        if ([[arry firstObject] isKindOfClass:[NSString class]]) {
            hud.label.text = [arry firstObject];
        }
        if ([[arry lastObject] isKindOfClass:[NSString class]]) {
            hud.detailsLabel.text = [arry lastObject];
        }
    }else{
        if ([status isKindOfClass:[NSString class]]) {
            hud.label.text = status;
        }
    }
}


+(void)showError{
    [self showErrorWithStatus:nil];
}

+ (void)showErrorWithStatus:(NSString *)status{
    
    MBProgressHUD *hud = [self createDefaultHUD];
    if ([status rangeOfString:@"\n"].location != NSNotFound) {
        NSArray *arry = [status componentsSeparatedByString:@"\n"];
        if ([[arry firstObject] isKindOfClass:[NSString class]]) {
            hud.label.text = [arry firstObject];
        }
        if ([[arry lastObject] isKindOfClass:[NSString class]]) {
            hud.detailsLabel.text = [arry lastObject];
        }
    }else{
        if ([status isKindOfClass:[NSString class]]) {
            hud.label.text = status;
        }
        
    }
    
    hud.mode = MBProgressHUDModeText;
    hud.graceTime = 0;
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kShowingTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
    });
}

+ (void)showSuccess{
    [self showSuccessWithStatus:nil];
}

+ (void)showSuccessWithStatus:(NSString *)status{
    MBProgressHUD *hud = [self createDefaultHUD];
    hud.mode = MBProgressHUDModeText;
    if ([status rangeOfString:@"\n"].location != NSNotFound) {
        NSArray *arry = [status componentsSeparatedByString:@"\n"];
        if ([[arry firstObject] isKindOfClass:[NSString class]]) {
            hud.label.text = [arry firstObject];
        }
        if ([[arry lastObject] isKindOfClass:[NSString class]]) {
            hud.detailsLabel.text = [arry lastObject];
        }
    }else{
        if ([status isKindOfClass:[NSString class]]) {
            hud.label.text = status;
        }
        
    }
    hud.graceTime = 0;
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kShowingTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
    });
}

+ (MBProgressHUD *)createDefaultHUD{
    // 取消之前的loading
    while([MBProgressHUD HUDForView:CurrentLastView] != nil){
        [MBProgressHUD hideHUDForView:CurrentLastView animated:NO];
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:CurrentLastView animated:YES];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
//    hud.bezelView.color = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    hud.graceTime = kGraceTime;
//    hud.contentColor = [UIColor whiteColor];
    hud.margin = 10.0;
    return  hud;
}

+(void)dismiss{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:CurrentLastView];
    if (hud) {
        [hud hideAnimated:YES];
    }
}



@end
