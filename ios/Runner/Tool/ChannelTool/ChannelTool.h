//
//  ChannelTool.h
//  Runner
//
//  Created by 张智慧 on 2019/11/15.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface ChannelTool : NSObject

+ (instancetype)sharedManager;

- (void)flutterBridgeOC;

@property (nonatomic, copy) NSString *primaryLanguageStr;


@end

NS_ASSUME_NONNULL_END
