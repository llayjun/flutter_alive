//
//  GoodsonWindowView.h
//  Runner
//
//  Created by 张智慧 on 2020/3/18.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GoodsonWindowView : UIView
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet CycleTakePhotoView *cycGoodsView;


- (void)show;

@end

NS_ASSUME_NONNULL_END
