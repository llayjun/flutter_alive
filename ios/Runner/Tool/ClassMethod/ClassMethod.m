//
//  ClassMethod.m
//  Runner
//
//  Created by 张智慧 on 2020/4/13.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

#import "ClassMethod.h"

@implementation ClassMethod

+ (CGSize)sizeText:(NSString*)text
              font:(UIFont*)font
       limitHeight:(float)height
{
    NSDictionary *attributes = @{NSFontAttributeName:font};
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                     options:NSStringDrawingUsesLineFragmentOrigin//|NSStringDrawingUsesFontLeading
                                  attributes:attributes
                                     context:nil];
    rect.size.height=height;
    rect.size.width=ceil(rect.size.width);
    return rect.size;
}


@end
