//
//  CycleTakePhotoView.h
//  BlueBricks
//
//  Created by GOOT on 2018/10/24.
//  Copyright © 2018年 Wisdom. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^NeedReloadGoodsListBlock)(void);
typedef void(^NeedOpenWindowBlock)(void);
typedef void (^SendSocketMesBlock)(NSArray *arr);

@interface CycleTakePhotoView : UIView

@property (nonatomic, copy) NSString *lbId;
@property (nonatomic, copy) NeedReloadGoodsListBlock needReloadGoodsBlock;
@property (nonatomic, copy) NeedOpenWindowBlock needOpenWindowBlock;
@property (nonatomic, copy) SendSocketMesBlock sendSocketMesBlock;

@end
