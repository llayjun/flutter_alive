//
//  ShareBoardView.h
//  Runner
//
//  Created by 张智慧 on 2020/3/23.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShareBoardView : UIView
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *savePicBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@end

NS_ASSUME_NONNULL_END
