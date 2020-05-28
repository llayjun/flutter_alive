//
//  AliLiveModel.h
//  Runner
//
//  Created by 张智慧 on 2020/3/5.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseModel : NSObject

@end

@class SquareCoverModel;
@interface AliLiveModel : NSObject
@property (nonatomic, strong) NSDictionary *bannerCover;
@property (nonatomic, copy) NSString *beginTime;
@property (nonatomic, copy) NSString *createDate;
@property (nonatomic, copy) NSString *myDescription; ///
@property (nonatomic, copy) NSString *editTime;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, strong) NSDictionary *minAppCodeImg;
@property (nonatomic, strong) NSArray *products;
@property (nonatomic, copy) NSString *pushUrl;
@property (nonatomic, strong) NSDictionary *squareCover;
@property (nonatomic, strong) SquareCoverModel *squareCoverModel;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *totalPraise;
@property (nonatomic, copy) NSString *totalView;
@property (nonatomic, copy) NSString *updateDate;
@property (nonatomic, copy) NSString *sharePosterLive;
@property (nonatomic, copy) NSString *sharePosterPending;
@property (nonatomic, copy) NSString *nickname;

@end


@interface DisPlayWindowModel : BaseModel
@property (nonatomic, copy) NSString *displayWindow;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *originPrice;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *productId;
@property (nonatomic, copy) NSString *saleAmount;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *totalStockNum;

@end

@interface StatisticsModel : BaseModel
@property (nonatomic, copy) NSString *interaction;
@property (nonatomic, copy) NSString *online;
@property (nonatomic, copy) NSString *productView;
@property (nonatomic, copy) NSString *view;
@end


@interface SquareCoverModel : BaseModel
@property (nonatomic, copy) NSString *createDate;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *ext;
@property (nonatomic, copy) NSString *fileId;
@property (nonatomic, copy) NSDictionary *meta;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *siteId;
@property (nonatomic, copy) NSString *size;
@property (nonatomic, copy) NSString *updateDate;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *visitCount;
@end

NS_ASSUME_NONNULL_END
