//
//  NSString+Filter.h
//  ALAMHCustomer
//
//  Created by 张智慧 on 2019/7/2.
//  Copyright © 2019 张智慧. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Filter)

+ (BOOL)isEmpty:(NSString *)text;

+ (NSString *)cancelEmpty:(NSString *)text;

+ (NSString *)arrayToJSONString:(NSArray *)array;

+ (NSString *)dictionaryToJSONString:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
