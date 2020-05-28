//
//  BottomChatView.h
//  Runner
//
//  Created by 张智慧 on 2020/3/12.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, InteractionType) {
    InteractionType_board = 0,
    InteractionType_data,
    InteractionType_share,
    InteractionType_goodlist
};
@class BottomChatView;

@protocol BottomChatViewDelegate <NSObject>

- (void)didClickInteractionView:(BottomChatView *)chatView typeWith:(InteractionType)currentType;

@end
@interface BottomChatView : UIView
@property (nonatomic, weak) id<BottomChatViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *bottomNumBtn;
@end

NS_ASSUME_NONNULL_END
