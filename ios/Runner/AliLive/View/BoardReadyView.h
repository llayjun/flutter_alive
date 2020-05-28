//
//  BoardReadyView.h
//  Runner
//
//  Created by 张智慧 on 2020/3/17.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^SuccessBlock)(void);

@interface BoardReadyView : UIView

+ (void)showWith:(SuccessBlock)completeBlock;

@property (nonatomic, copy) SuccessBlock successBlock;

@end

NS_ASSUME_NONNULL_END
