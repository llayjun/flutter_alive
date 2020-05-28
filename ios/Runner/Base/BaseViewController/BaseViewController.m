//
//  BaseViewController.m
//  Runner
//
//  Created by 张智慧 on 2020/2/18.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

#import "BaseViewController.h"

NSString* const kOverlayStyleUpdateNotificationName = @"io.flutter.plugin.platform.SystemChromeOverlayNotificationName";
NSString* const kOverlayStyleUpdateNotificationKey = @"io.flutter.plugin.platform.SystemChromeOverlayNotificationKey";

@interface BaseViewController ()

@end

@implementation BaseViewController

static UIStatusBarStyle fixedStatusBarStyle = UIStatusBarStyleDefault;

+ (UIStatusBarStyle)fixedStatusBarStyle {
    return fixedStatusBarStyle;
}

- (void)setupStatusBarFix {
    [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(fixStatusBarAppearance:)
         name:kOverlayStyleUpdateNotificationName
         object:nil
    ];
}

- (void)fixStatusBarAppearance:(NSNotification *)notification {
    NSDictionary<NSString *, NSNumber *> *info = notification.userInfo;
    NSNumber *statusBarStyleKey = [info valueForKeyPath:kOverlayStyleUpdateNotificationKey];
    
    if (@available(iOS 13.0, *)) {
        fixedStatusBarStyle = statusBarStyleKey == 0 ? UIStatusBarStyleDarkContent : UIStatusBarStyleLightContent;
    } else {
        fixedStatusBarStyle = statusBarStyleKey == 0 ? UIStatusBarStyleDefault : UIStatusBarStyleLightContent;
    }
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupStatusBarFix];
    // Do any additional setup after loading the view.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
