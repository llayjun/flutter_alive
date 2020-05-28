//
//  BoardCastURL.m
//  Runner
//
//  Created by 张智慧 on 2020/3/5.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

#import "BoardCastURL.h"

@implementation BoardCastURL

#ifdef DEBUG
///测试环境或者预生产环境
//NSString *const BaseURL = @"http://tv.api.9daye.cn";
//NSString *const BaseURL = @"http://tvp.api.9daye.cn";
NSString *const BaseURL = @"http://tv.api.9daye.com.cn";

#else

//NSString *const BaseURL = @"http://tv.api.9daye.cn";
//NSString *const BaseURL = @"http://tvp.api.9daye.cn";
NSString *const BaseURL = @"http://tv.api.9daye.com.cn";

#endif

//NSString *const SocketURL  = @"https://chat.9daye.cn/";
//NSString *const SocketURL  = @"http://chat2.9daye.cn/";
NSString *const SocketURL  = @"https://chat.9daye.com.cn/";

NSString *const GetLiveBroadcastURL = @"/admin/api/live-broadcasts";

@end
