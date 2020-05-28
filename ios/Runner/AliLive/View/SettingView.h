//
//  SettingView.h
//  Runner
//
//  Created by 张智慧 on 2020/3/16.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, SettingType) {
    SettingType_beauty = 0,
    SettingType_clarity
};

typedef void (^ChooseSettingBlock)(SettingType settingType);

@interface SettingView : UIView

@property (nonatomic, copy) ChooseSettingBlock settingBlock;

+ (void)showWith:(BOOL)isBeautyOn blockWith:(ChooseSettingBlock)setBlock;




@end

NS_ASSUME_NONNULL_END
