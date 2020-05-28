//
//  ChannelTool.m
//  Runner
//
//  Created by 张智慧 on 2019/11/15.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import "ChannelTool.h"
#import "AliLiveViewController.h"
#import "AliLivePlayerViewController.h"



typedef void(^MethodChannelBlock)(FlutterMethodCall *methodCall, FlutterResult methodResult);

@interface ChannelTool ()


@end

@implementation ChannelTool

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static ChannelTool *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}


- (void)flutterBridgeOC {
    @WeakSelf(self);
    [self initMethodChannelWithName:ChannelName blockWith:^(FlutterMethodCall *methodCall, FlutterResult methodResult) {
        if([methodCall.method isEqualToString:@"jumpToBoard"]) { /// 直播
            [RequestManager shareInstance].token = [methodCall.arguments valueForKey:@"token"];
            AliLiveViewController *vc = [[AliLiveViewController alloc]init];
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
            vc.boardcastId = [methodCall.arguments valueForKey:@"id"];
            vc.flutterResult = methodResult;
            [[UIViewController currentViewController]presentViewController:vc animated:YES completion:nil];
        }
        if([methodCall.method isEqualToString:@"jumpToLivePlay"]) { /// 观看直播
            AliLivePlayerViewController *vc = [[AliLivePlayerViewController alloc]init];
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
            vc.playerURL = methodCall.arguments;
            [[UIViewController currentViewController]presentViewController:vc animated:YES completion:nil];
        }
        
        if([methodCall.method isEqualToString:@"getPrimaryLanguage"]) {
            methodResult(weakSelf.primaryLanguageStr);
        }
     
    }];
    
}
#pragma mark -- flutter->原生
- (void)initMethodChannelWithName:(NSString *)channelName blockWith:(MethodChannelBlock)channelBlock {
    FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:(FlutterViewController *)[UIViewController currentViewController]];
    [channel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        if(channelBlock) {
            channelBlock(call,result);
        }
    }];

}

@end
