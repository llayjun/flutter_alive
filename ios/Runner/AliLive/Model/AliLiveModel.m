
//
//  AliLiveModel.m
//  Runner
//
//  Created by 张智慧 on 2020/3/5.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

#import "AliLiveModel.h"


@implementation BaseModel

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property{
    if ([NSString isEmpty:oldValue]) {// 以字符串类型为例
        return  @"";
    }
    return oldValue;
}


@end

@implementation AliLiveModel

//- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property{
//    if ([NSString isEmpty:oldValue]) {// 以字符串类型为例
//        return  @"";
//    }
//    return oldValue;
//}

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"myDescription":@"description"};
}


//+ (NSDictionary *)mj_objectClassInArray {
//    return @{
//             @"products" : @"",
//             };
//}

@end


@implementation DisPlayWindowModel

@end


@implementation StatisticsModel

@end

@implementation SquareCoverModel

@end
