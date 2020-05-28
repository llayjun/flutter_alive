//
//  GoodsListTableView.h
//  Runner
//
//  Created by 张智慧 on 2020/3/18.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^NeedRefreshBlock)(void);
typedef void(^GetOnlineBlock)(NSInteger currentNum);
@interface GoodsListTableView : UITableView

- (void)setCurrentStatus:(NSString *)currentStatus lbIdWith:(NSString *)lbId;
@property (nonatomic, copy) NeedRefreshBlock needLoadBlock;
@property (nonatomic, copy) GetOnlineBlock onlineBlock;


@end

NS_ASSUME_NONNULL_END
