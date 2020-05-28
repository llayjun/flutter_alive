//
//  BoardHeader.h
//  Runner
//
//  Created by 张智慧 on 2020/2/18.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

#ifndef BoardMacro_h
#define BoardMacro_h

/// 宏定义
#define WIDE   [UIScreen mainScreen].bounds.size.width
#define WIDES   ([UIScreen mainScreen].bounds.size.width/320)
#define HIGHT  [UIScreen mainScreen].bounds.size.height

//判断iPHoneXr
#define Device_Is_iPhoneXR ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !UI_IS_IPAD : NO)

//判断iPHoneX、iPHoneXs
#define Device_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !UI_IS_IPAD : NO)
#define Device_Is_iPhoneXs ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !UI_IS_IPAD : NO)

//判断iPhoneXs Max
#define SCREENSIZE_IS_XS_MAX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && !UI_IS_IPAD : NO)

#define IS_IPhoneX_All ([UIScreen mainScreen].bounds.size.height == 812 || [UIScreen mainScreen].bounds.size.height == 896)

#define NAV_H               (IS_IPhoneX_All? 88 : 64)
#define FNAV_H              (IS_IPhoneX_All? -88 : -64)
#define NSTATUS_H           (IS_IPhoneX_All? 44 : 20)
#define TAB_H               (IS_IPhoneX_All? 83 : 49)
#define Indicator_H         (IS_IPhoneX_All? 34 : 0)



#define ChannelName @"com.czh.tvmerchantapp/plugin"
#define ShareChannelName @"com.czh.tvmerchantapp/shareplugin"
#define UMengKey @"5e7c08be167edde766000c6c"

#define WeakSelf(type) autoreleasepool{} __weak __typeof__(type) weakSelf = type;
#define StrongSelf(type) autoreleasepool{} __strong __typeof__(type) strongSelf = type;

#define HexColor(ColorString) \
[UIColor colorWithHexString:ColorString]

#define COLOR_FFFFFF HexColor(@"FFFFFF")
#define COLOR_F95259 HexColor(@"F95259")
#define COLOR_F0F0F0 HexColor(@"F0F0F0")
#define COLOR_F63825 HexColor(@"F63825")
#define COLOR_020204 HexColor(@"020204")
#define COLOR_F56043 HexColor(@"F56043")

#endif /* BoardMacro_h */
