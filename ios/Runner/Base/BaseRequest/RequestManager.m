//
//  RequestManager.m
//  Yavon
//
//  Created by He on 2018/7/6.
//  Copyright © 2018年 He. All rights reserved.
//

#import "RequestManager.h"

@implementation RequestManager

static RequestManager *shareInstance = nil;
+ (RequestManager *)shareInstance {
    static dispatch_once_t pred;
    dispatch_once(&pred,^{
        shareInstance = [[self alloc]init];
    });
    return shareInstance;
}

- (void)requestWithMethod:(RequestMethod)method url:(NSString *)url dict:(NSDictionary *)dict finished:(Finished)finished failed:(Failed)failed {
    [self requestWithMethod:method isAutoMask:YES url:url dict:dict finished:finished failed:failed];
}

- (void)requestWithMethod:(RequestMethod)method isAutoMask:(BOOL)isAutoMask url:(NSString *)url dict:(NSDictionary *)dict finished:(Finished)finished failed:(Failed)failed {
    InstensiveRequest *request = [[InstensiveRequest alloc]init];
    request.requestMethod = method;
    request.url = url;
    request.paramDic = dict;
    request.finished = finished;
    request.failed = failed;
    request.isAutoMask = isAutoMask;
    request.requestType = Ordinary;
    [request beginRequest];
}

- (void)requestPostMultipartWithURL:(NSString *)url params:(NSDictionary *)dicParam updata:(NSData *)updata key:(NSString *)key fileName:(NSString *)fileName mimeType:(NSString *)mimeType finished:(Finished)finished failed:(Failed)failed {
    
    InstensiveRequest *request = [[InstensiveRequest alloc]init];
    request.url = url;
    request.paramDic = dicParam;
    request.finished = finished;
    request.failed = failed;
    request.upData=updata;
    request.key=key;
    request.fileName=fileName;
    request.mimeType=mimeType;
    request.requestType = Img;
    [request beginRequest];
}



@end
