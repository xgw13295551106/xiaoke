//
//  Utils.h
//  XiaoKe
//
//  Created by 大智梦 on 2018/9/26.
//  Copyright © 2018年 com.znycat.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Utils : NSObject
+(NSString*)encoingWithDic:(NSMutableDictionary*)dataDic;
+ (void)setUserToken:(NSString *)userToken;
+ (NSString *)getUserToken;
+(void)setCornerRadius:(UIView *)sender Radius:(float)radius;
+ (BOOL)islegalPhoneNum:(NSString *)mobileNum;//手机号正则
+ (BOOL)islegalPasswords:(NSString *)passwords;//密码正则
+ (void)setUserName:(NSString *)name;
+ (NSString *)getUserUserName;
@end

NS_ASSUME_NONNULL_END
