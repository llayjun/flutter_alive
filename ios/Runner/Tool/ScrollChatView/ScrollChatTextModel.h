//
//  ScrollChatTextModel.h
//  ScrollChatView
//
//  Created by jokechen on 2018/5/10.
//  Copyright © 2018年 陈红. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScrollChatTextModel : NSObject

@property (nonatomic ,assign)NSInteger yx_height;

@property (nonatomic ,copy)NSString *yx_content;

@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *createdAt;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *onlineCount;
@property (nonatomic, copy) NSString *roomId;
@property (nonatomic, copy) NSString *roomName;
@property (nonatomic, assign) NSInteger type; /// 0进入 1 离开 其他随便
@end

