//
//  UIColor+ColorChange.h
//  GreatSecond
//
//  Created by GOOT on 2018/1/22.
//  Copyright © 2018年 wisdom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ColorChange)

// 颜色转换：iOS中（以#开头）十六进制的颜色转换为UIColor(RGB)
+ (UIColor *)colorWithHexString:(NSString *)color;

@end
