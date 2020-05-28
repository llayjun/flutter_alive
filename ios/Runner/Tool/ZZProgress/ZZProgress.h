//
//  ZZProgress.h
//  Mend
//
//  Created by GOOT on 2017/8/26.
//  Copyright © 2017年 wisdom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZProgress : NSObject

#pragma mark -- Loading

+ (void)show;

+ (void)showWithStatus:(NSString *)status;




#pragma mark -- Success

+ (void)showSuccess;

+ (void)showSuccessWithStatus:(NSString *)status;



#pragma mark -- Error

+ (void)showError;

+ (void)showErrorWithStatus:(NSString *)status;

#pragma mark -- dismiss
+ (void)dismiss;



@end
