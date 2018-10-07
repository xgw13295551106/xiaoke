//
//  NYHttpTool.h
//  zhiyingbao
//
//  Created by IOS on 15/11/28.
//  Copyright © 2015年 IOS. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NYUploadParam;

@interface NYHttpTool : NSObject

/**
 *  发送get请求
 *
 *  @param URLString  请求的基本的url
 *  @param parameters 请求的参数字典
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 */
+ (void)GET:(NSString *)URLString
 parameters:(id)parameters
    success:(void (^)(id responseObject))success
    failure:(void (^)(NSError *error))failure;


/**
 *  发送post请求
 *
 *  @param URLString  请求的基本的url
 *  @param parameters 请求的参数字典
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 */
+ (void)Post:(NSString *)URLString
  parameters:(id)parameters
     success:(void (^)(id responseObject))success
     failure:(void (^)(NSError *error))failure;


/**
 *  上传请求
 *
 *  @param URLString  请求的基本的url
 *  @param parameters 请求的参数字典
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 */
+ (void)Upload:(NSString *)URLString
    parameters:(id)parameters
   uploadParam:(NYUploadParam *)uploadParam
       success:(void (^)(id responseObject))success
       failure:(void (^)(NSError *error))failure;

/**
 *  上传多文件请求
 *
 *  @param URLString   请求的基本的url
 *  @param parameters  请求的参数字典
 *  @param uploadParams 请求的参数数组内需要装NYUploadParam类型的上传数据
 *  @param success     请求成功的回调
 *  @param failure     请求失败的回调
 */
+ (void)UploadMore:(NSString *)URLString
    parameters:(id)parameters
   uploadParams:(NYUploadParam *)uploadParams
       success:(void (^)(id responseObject))success
       failure:(void (^)(NSError *error))failure;

@end
