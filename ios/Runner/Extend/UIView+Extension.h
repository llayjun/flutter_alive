//
//  UIView+Extension.h
//  MammonDrive
//
//  Created by 张智慧 on 2019/5/15.
//  Copyright © 2019 张智慧. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Extension)
/// x坐标属性
@property (nonatomic, assign)CGFloat x;
/// y坐标
@property (nonatomic, assign)CGFloat y;
/// 宽度
@property (nonatomic, assign)CGFloat width;
/// 高度
@property (nonatomic, assign)CGFloat height;
/// 大小
@property (nonatomic, assign)CGSize size;
/// 位置
@property (nonatomic, assign)CGPoint origin;
/// 中心点x
@property (nonatomic, assign)CGFloat centerX;
/// 中心点y
@property (nonatomic, assign)CGFloat centerY;
@end

NS_ASSUME_NONNULL_END
