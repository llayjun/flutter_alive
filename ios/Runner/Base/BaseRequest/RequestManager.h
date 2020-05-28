//
//  RequestManager.h
//  Yavon
//
//  Created by He on 2018/7/6.
//  Copyright © 2018年 He. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InstensiveRequest.h"

@interface RequestManager : NSObject

+ (RequestManager *)shareInstance;

@property (nonatomic, copy) NSString *token;

/// Method目前支持GET／POST/PUT/DELETE请求。自动管理遮罩
- (void)requestWithMethod:(RequestMethod)method url:(NSString*)url dict:(NSDictionary*)dict finished:(Finished)finished failed:(Failed)failed;

/// Method目前支持GET／POST/PUT/DELETE请求。是否手动管理遮罩
- (void)requestWithMethod:(RequestMethod)method isAutoMask:(BOOL)isAutoMask url:(NSString*)url dict:(NSDictionary*)dict finished:(Finished)finished failed:(Failed)failed;

- (void)requestPostMultipartWithURL:(NSString *)url params:(NSDictionary *)dicParam  updata:(NSData*)updata key:(NSString*)key fileName:(NSString*)fileName mimeType:(NSString*)mimeType finished:(Finished)finished failed:(Failed)failed;
;

@end
