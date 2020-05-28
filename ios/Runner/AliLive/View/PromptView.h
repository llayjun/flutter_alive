//
//  PromptView.h
//  Runner
//
//  Created by 张智慧 on 2020/4/7.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PromptView : UIView

- (void)showWith:(NSString *)text;

- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
