//
//  ClassMethod.h
//  Runner
//
//  Created by 张智慧 on 2020/4/13.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ClassMethod : NSObject

+ (CGSize)sizeText:(NSString*)text
       font:(UIFont*)font
       limitHeight:(float)height;

@end

NS_ASSUME_NONNULL_END
