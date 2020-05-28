//
//  ClarityActionView.h
//  Runner
//
//  Created by 张智慧 on 2020/3/16.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ClarityBlock)(NSInteger type);
@interface ClarityActionView : UIView
@property (nonatomic, copy) ClarityBlock clarityBlock;
@property (nonatomic, assign) BOOL is540;
@end

NS_ASSUME_NONNULL_END
