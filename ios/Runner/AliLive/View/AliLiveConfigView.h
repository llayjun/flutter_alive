//
//  AliLiveConfigView.h
//  ocflutter
//
//  Created by 张智慧 on 2020/2/19.
//  Copyright © 2020 张智慧. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AlivcLivePusher/AlivcLivePusher.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger ,ConfigType) {
    ConfigType_skin = 0,
    ConfigType_music,
    ConfigType_flash,
    ConfigType_camera,
    ConfigType_setting,
};

@class AliLiveConfigView;
@protocol AliLiveConfigViewDelegate <NSObject>
@optional;
- (void)didClickView:(AliLiveConfigView *)configView typeWith:(ConfigType)currentType;
@end

@interface AliLiveConfigView : UIView

@property (nonatomic, weak) id<AliLiveConfigViewDelegate> delegate;

@property (nonatomic, strong) AlivcLivePushConfig *pushConfig;

- (void)initConfigWith:(AlivcLivePushConfig *)config;


@end

NS_ASSUME_NONNULL_END
