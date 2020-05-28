//
//  BoardWillStopView.h
//  Runner
//
//  Created by 张智慧 on 2020/3/17.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^BoardWillStopBlock)(void);

@interface BoardWillStopView : UIView

@property (nonatomic, copy) BoardWillStopBlock willStopBlock;

+ (void)showIdWith:(NSString *)boardId  favWith:(NSString *)favNum   resultWith:(BoardWillStopBlock)stopBlock;

@end

NS_ASSUME_NONNULL_END
