//
//  AppDelegate+AliPay.m
//  XiaoKe
//
//  Created by 大智梦 on 2018/10/8.
//  Copyright © 2018年 com.znycat.com. All rights reserved.
//

#import "AppDelegate+AliPay.h"

@implementation AppDelegate (AliPay)
// 仅支持iOS9以上系统

- (BOOL)AliPayApplication:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NYLog(@"result = %@",resultDic);
            NSString *message ;
            if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
                message = @"支付成功";
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PaySuccess" object:nil];
            }else if ([resultDic[@"resultStatus"] isEqualToString:@"6001"]) {
                message = @"用户已取消支付";
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PayCancel" object:nil];
            }else{
                message = @"支付失败";
            }
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];

            [alertController addAction:cancelAction];
            [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NYLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NYLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)AliPayApplication:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NYLog(@"result = %@",resultDic);
            NSString *message ;
            if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
                message = @"支付成功";
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PaySuccess" object:nil];
            }else if ([resultDic[@"resultStatus"] isEqualToString:@"6001"]) {
                message = @"用户已取消支付";
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PayCancel" object:nil];
            }else{
                message = @"支付失败";
            }
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            
            [alertController addAction:cancelAction];
            [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NYLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NYLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }
    return YES;
}
@end
