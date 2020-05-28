//
//  AllGoodsListView.h
//  Runner
//
//  Created by 张智慧 on 2020/3/17.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^NeedLoadWindowBlock)(void);

@interface AllGoodsListView : UIView


- (void)showWithlbId:(NSString *)bId;

- (void)dismiss;

@property (nonatomic, copy) NeedLoadWindowBlock needloadWindowBlock;

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
