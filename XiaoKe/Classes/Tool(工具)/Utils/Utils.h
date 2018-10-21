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

+ (void)showTipsWithHUD:(NSString *)labelText;
+ (void)showTipsWithHUD:(NSString *)labelText inView:(UIView *)inView;
+ (void)showTipsWithView:(UIView *)uiview labelText:(NSString *)labelText showTime:(CGFloat)time;
+ (void) showHudMessage:(NSString*) msg hideAfterDelay:(NSInteger) sec uiview:(UIView *)uiview;

/**
 *  返回字符串所占用的尺寸
 *
 *  @param stringFont    字体
 *  @param stringSize 最大尺寸
 */
+ (CGSize)getWidthByString:(NSString*)string withFont:(UIFont*)stringFont withStringSize:(CGSize)stringSize;

+ (NSDate *)dateFromString:(NSString *)dateString usingFormat:(NSString*)format;
+ (NSDate *)dateFromString:(NSString *)dateString;
+ (NSString *)stringFromDate:(NSDate *)date;
+ (NSString *)stringFromDate:(NSDate *)date usingFormat:(NSString*)format;

/**
 根据时间戳获取时间
 
 @param timeStamp long long 的时间戳参数
 @return 格式化后的时间字符串
 */
+ (NSString *)timeStringWithTimeStamp:(long long)timeStamp;
@end

NS_ASSUME_NONNULL_END
