//
//  NYHttpTool.m
//  zhiyingbao
//
//  Created by IOS on 15/11/28.
//  Copyright © 2015年 IOS. All rights reserved.
//

#ifdef DEBUG
#define NYLog(...) NSLog(__VA_ARGS__)
#else
#define NYLog(...)
#endif

#import "NYHttpTool.h"
#import "AFNetworking.h"
#import "NYUploadParam.h"

@interface NYHttpTool() 
@end
@implementation NYHttpTool



+ (void)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    // 创建请求管理者

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // AFN请求成功时候调用block
        // 先把请求成功要做的事情，保存到这个代码块
//        [SVProgressHUD dismiss];
        if (success) {
            NYLog(@"responseObject == %@",responseObject);
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [SVProgressHUD dismiss];
//        [SVProgressHUD showErrorWithStatus:@"网络异常"];
        NYLog(@"%s error = %@ task = %@", __func__, error ,task);
        if (failure) {
            failure(error);
        }
    }];
    
}

+ (void)Post:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    // 创建请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    [manager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NYLog(@"task.response.URL = %@  参数 = %@",task.response.URL,parameters);
        
        [SVProgressHUD dismiss];
        if (success) {
            NYLog(@"responseObject == %@",responseObject);
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
        NYLog(@"%s error = %@ task = %@", __func__, error ,task);
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)Upload:(NSString *)URLString parameters:(id)parameters uploadParam:(NYUploadParam *)uploadParam success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    // 创建请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // 上传的文件全部拼接到formData
        
        /**
         *  FileData:要上传的文件的二进制数据
         *  name:上传参数名称
         *  fileName：上传到服务器的文件名称
         *  mimeType：文件类型
         */
        [formData appendPartWithFileData:uploadParam.data name:uploadParam.name fileName:uploadParam.fileName mimeType:uploadParam.mimeType];
    } progress:^(NSProgress * _Nonnull uploadProgress) {}  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NYLog(@"task.response.URL = %@  参数 = %@",task.response.URL,parameters);
        
        [SVProgressHUD dismiss];
        if (success) {
            NYLog(@"responseObject == %@",responseObject);
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:@"网络异常"];
            NYLog(@"%s error = %@ task = %@", __func__, error ,task);
            failure(error);
        }
    }];
    
}

+ (void)UploadMore:(NSString *)URLString parameters:(id)parameters uploadParams:(NSArray *)uploadParams success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    // 创建请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // 上传的文件全部拼接到formData
        
        /**
         *  uploadParams存放
         *  FileData:要上传的文件的二进制数据
         *  name:上传参数名称
         *  fileName：上传到服务器的文件名称
         *  mimeType：文件类型
         */
        for (NYUploadParam *uploadParam in uploadParams) {
            [formData appendPartWithFileData:uploadParam.data name:uploadParam.name fileName:uploadParam.fileName mimeType:uploadParam.mimeType];
        }

    } progress:^(NSProgress * _Nonnull uploadProgress) {}  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NYLog(@"task.response.URL = %@  参数 = %@",task.response.URL,parameters);
        
        [SVProgressHUD dismiss];
        if (success) {
            NYLog(@"responseObject == %@",responseObject);
            success(responseObject);
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:@"网络异常"];
            NYLog(@"%s error = %@ task = %@", __func__, error ,task);
            failure(error);

        }
    }];
    
}



@end
