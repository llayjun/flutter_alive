//
//  CALayer+ZZXibBorderColor.m
//  GreatSecond
//
//  Created by GOOT on 2018/1/17.
//  Copyright © 2018年 wisdom. All rights reserved.
//

#import "CALayer+ZZXibBorderColor.h"
#import <UIKit/UIKit.h>

@implementation CALayer (ZZXibBorderColor)

- (void)setBorderUIColor:(UIColor *)borderUIColor {
    self.borderColor = borderUIColor.CGColor;
}

-(UIColor *)borderUIColor {
    return [UIColor colorWithCGColor:self.borderColor];
}

-(void)setShadowUIColor:(UIColor*)color {
    self.shadowColor = color.CGColor;
}

- (UIColor *)shadowUIColor {
    return [UIColor colorWithCGColor:self.shadowColor];
}

@end
