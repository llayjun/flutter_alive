//
//  BeautySettingView.h
//  ocflutter
//
//  Created by 张智慧 on 2020/2/19.
//  Copyright © 2020 张智慧. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AlivcLivePusher/AlivcLivePusher.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, BeautyType) {
    /// @"磨皮",@"美白",@"红润",@"腮红",@"瘦脸",@"收下巴",@"大眼"
    BeautyType_beautyBuffing = 0,
    BeautyType_beautyWhite,
    BeautyType_beautyRuddy,
    BeautyType_beautyCheekPink,
    BeautyType_beautyThinFace,
    BeautyType_beautyShortenFace,
    BeautyType_beautyBigEye,
};
@class BeautySettingView;
@protocol BeautySettingViewDelegate <NSObject>

@optional
- (void)didClickBeautyView:(BeautySettingView *)settingView typeWith:(BeautyType)type valueWith:(int)value;

@end

@interface BeautySettingView : UIView

- (instancetype)initWithFrame:(CGRect)frame configWith:(AlivcLivePushConfig *)config;

@property (nonatomic, weak) id<BeautySettingViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
