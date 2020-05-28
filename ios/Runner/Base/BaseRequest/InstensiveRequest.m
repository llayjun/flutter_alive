//
//  InstensiveRequest.m
//  Yavon
//
//  Created by GOOT on 2018/7/9.
//  Copyright © 2018年 He. All rights reserved.
//

#import "InstensiveRequest.h"
#import <AFHTTPSessionManager.h>



@implementation InstensiveRequest

- (NSString *)urlWithPath:(NSString *)url{
    return [NSString stringWithFormat:@"%@%@",BaseURL,url];
}

- (void)beginRequest {
    if(self.requestType == Img) {
        [self beginMultipartRequst];
    }else {
        switch (self.requestMethod) {
            case GET:
            {
                [self getRequest];
            }
                break;
            case POST:
            {
                [self postRequest];
            }
                break;
            case PUT:
            {
                [self putRequest];
            }
                break;
            case PATCH:
            {
                [self patchRequest];
            }
                break;
            case DELETE:
            {
                [self deleteRequest];
            }
                break;
            case BodyPOST:
            {
                [self bodyRequest];
            }
                break;
                
            default:
                break;
        }
    }
}

#pragma mark -- 上传图片相关
- (void)beginMultipartRequst {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    /// 如果报接受类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"image/jpeg",@"image/png", nil];
    [manager POST:[self urlWithPath:self.url] parameters:self.paramDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:self.upData name:self.key fileName:self.fileName mimeType:self.mimeType];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (task.error.code == NSURLErrorCancelled) {
        } else {
          
            if (self.failed) {
                self.failed(error);
            }
        }
        
    }];
}

#pragma mark -- Ordinary
/// GET请求
- (void)getRequest {
    AFHTTPSessionManager *mananger=[AFHTTPSessionManager manager];
    mananger.requestSerializer = [AFJSONRequestSerializer serializer];
    mananger.responseSerializer = [AFJSONResponseSerializer serializer];
    /// 如果报接受类型不一致请替换一致text/html或别的
     mananger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/html",@"text/plain",nil];
    mananger.requestSerializer.timeoutInterval = 20.f;
    [mananger.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [mananger.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    if([RequestManager shareInstance].token.length!=0) {
         [mananger.requestSerializer setValue:[RequestManager shareInstance].token forHTTPHeaderField:@"Authorization"];
    }
    if (self.isAutoMask) {
        [ZZProgress showWithStatus:@"加载中..."];
    }
    [mananger GET:[self urlWithPath:self.url] parameters:self.paramDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
      if (self.isAutoMask) {
          [ZZProgress dismiss];
      }
        if([responseObject[@"success"] integerValue] == 1) {
            if(self.finished) {
                self.finished(responseObject[@"data"]);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.isAutoMask) {
            [ZZProgress showErrorWithStatus:@"网络连接失败"];
        }
        if(self.failed) {
            self.failed(error);
        }
        
    }];
}

/// POST请求
- (void)postRequest {
    AFHTTPSessionManager *mananger=[AFHTTPSessionManager manager];
    mananger.requestSerializer = [AFJSONRequestSerializer serializer];
    mananger.responseSerializer = [AFJSONResponseSerializer serializer];
    /// 如果报接受类型不一致请替换一致text/html或别的
     mananger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/html",@"text/plain",nil];
    mananger.requestSerializer.timeoutInterval = 20.f;
    [mananger.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [mananger.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    if([RequestManager shareInstance].token.length!=0) {
         [mananger.requestSerializer setValue:[RequestManager shareInstance].token forHTTPHeaderField:@"Authorization"];
    }
    if (self.isAutoMask) {
        [ZZProgress showWithStatus:@"加载中..."];
    }
    [mananger POST:[self urlWithPath:self.url] parameters:self.paramDic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       if (self.isAutoMask) {
           [ZZProgress dismiss];
       }
        if([responseObject[@"success"] integerValue] == 1) {
            if(self.finished) {
                self.finished(responseObject[@"data"]);
            }
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.isAutoMask) {
            [ZZProgress showErrorWithStatus:@"网络连接失败"];
        }
        if(self.failed) {
            self.failed(error);
        }
    }];

}


- (void)putRequest {
    AFHTTPSessionManager *mananger=[AFHTTPSessionManager manager];
    mananger.requestSerializer = [AFJSONRequestSerializer serializer];
    mananger.responseSerializer = [AFJSONResponseSerializer serializer];
    /// 如果报接受类型不一致请替换一致text/html或别的
     mananger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/html",@"text/plain",nil];
    mananger.requestSerializer.timeoutInterval = 20.f;
    [mananger.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [mananger.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    if([RequestManager shareInstance].token.length!=0) {
         [mananger.requestSerializer setValue:[RequestManager shareInstance].token forHTTPHeaderField:@"Authorization"];
    }
    if (self.isAutoMask) {
        [ZZProgress showWithStatus:@"加载中..."];
    }
    [mananger PUT:[self urlWithPath:self.url] parameters:self.paramDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.isAutoMask) {
            [ZZProgress dismiss];
        }
        if([responseObject[@"success"] integerValue] == 1) {
            if(self.finished) {
                self.finished(responseObject[@"data"]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.isAutoMask) {
            [ZZProgress showErrorWithStatus:@"网络连接失败"];
        }
        if(self.failed) {
            self.failed(error);
        }
    }];
}


#pragma mark ----

/// PATCH请求
- (void)patchRequest {
    AFHTTPSessionManager *mananger=[AFHTTPSessionManager manager];
    mananger.requestSerializer = [AFJSONRequestSerializer serializer];
    mananger.responseSerializer = [AFJSONResponseSerializer serializer];
    /// 如果报接受类型不一致请替换一致text/html或别的
    mananger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/plain",nil];
    mananger.requestSerializer.timeoutInterval = 20.f;
    [mananger.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [mananger.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [mananger PATCH:[self urlWithPath:self.url] parameters:self.paramDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
      
        if([responseObject[@"code"] integerValue] == 200) {
            if(self.finished) {
                self.finished(responseObject[@"datas"]);
            }
        }
 
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
    }];
}

/// DELETE请求
- (void)deleteRequest {
    AFHTTPSessionManager *mananger=[AFHTTPSessionManager manager];
    mananger.requestSerializer = [AFJSONRequestSerializer serializer];
    mananger.responseSerializer = [AFJSONResponseSerializer serializer];
    /// 如果报接受类型不一致请替换一致text/html或别的
    mananger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/plain",nil];
    mananger.requestSerializer.timeoutInterval = 20.f;
    [mananger.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [mananger.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
  
    [mananger DELETE:[self urlWithPath:self.url] parameters:self.paramDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       
        if([responseObject[@"code"] integerValue] == 200) {
            if(self.finished) {
                self.finished(responseObject[@"datas"]);
            }
        }
    
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
    }];
}


- (void)bodyRequest {
 
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.paramDic options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:[self urlWithPath:self.url] parameters:nil error:nil];
    request.timeoutInterval = 20;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                if([responseObject[@"code"] integerValue] == 200) {
                    if(self.finished) {
                        self.finished(responseObject[@"datas"]);
                    }
                }
            } else {
                /// 再做处理
            }
        } else {
            if (task.error.code == NSURLErrorCancelled) {
                // 取消了请求
      
            } else {
               
            }
        }
    }];
    
    [task resume];
    
}

@end
