//
//  AppDelegate+WXPay.h
//  XiaoKe
//
//  Created by 大智梦 on 2018/10/8.
//  Copyright © 2018年 com.znycat.com. All rights reserved.
//

#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (WXPay)<WXApiDelegate>
- (BOOL)WXapplication:(UIApplication *)application handleOpenURL:(NSURL *)url;

- (BOOL)WXapplication:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

-  (BOOL)WXapplication:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary*)options;

@end

NS_ASSUME_NONNULL_END
