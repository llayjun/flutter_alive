//
//  AliLiveViewController.h
//  Runner
//
//  Created by 张智慧 on 2020/2/18.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AliLiveViewController : UIViewController


/// 直播id
@property (nonatomic, copy) NSString *boardcastId;
@property (nonatomic, copy) FlutterResult flutterResult;


@end

NS_ASSUME_NONNULL_END
