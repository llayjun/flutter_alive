//
//  InstensiveRequest.h
//  Yavon
//
//  Created by GOOT on 2018/7/9.
//  Copyright © 2018年 He. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, RequestMethod) {
    GET = 1,
    POST,
    PUT,
    PATCH,
    DELETE,
    BodyPOST
};

typedef NS_ENUM(NSInteger, RequestType){
    Ordinary = 1,
    Img
};


typedef void (^Finished)(id request);
typedef void (^Failed)(NSError *error);

@interface InstensiveRequest : NSObject
/// 请求方式
@property (nonatomic ,assign) RequestMethod requestMethod;
/// 请求类型
@property (nonatomic ,assign) RequestType requestType;
/// 当前url
@property (nonatomic ,copy) NSString *url;
/// 参数
@property (nonatomic ,copy) NSDictionary *paramDic;
/// 成功方法
@property (nonatomic, copy) Finished finished;
/// 失败方法
@property (nonatomic, copy) Failed failed;
/// 是否自动遮罩
@property (nonatomic, assign) BOOL isAutoMask;
/// 存储数据
@property (nonatomic ,strong) NSData *data;
/// 错误信息
@property (nonatomic ,strong) NSError *error;


/// 上传的data
@property (nonatomic ,copy) NSData *upData;
/// 上传key
@property (nonatomic ,copy) NSString *key;
/// 上传文件名
@property (nonatomic ,copy) NSString *fileName;
/// 上传type
@property (nonatomic ,copy) NSString *mimeType;


- (void)beginRequest;

@end

