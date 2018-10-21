//
//  Utils.m
//  XiaoKe
//
//  Created by 大智梦 on 2018/9/26.
//  Copyright © 2018年 com.znycat.com. All rights reserved.
//

#import "Utils.h"
#import "MyMD5.h"
#define kShowTipsWithHUD 1.5
@implementation Utils

//请求参数加密
+(NSString*)encoingWithDic:(NSMutableDictionary*)dataDic

{
    //密匙 PRDH57rrkDrTr8snzNmY8XZ9KH4AFHtv
    NSString *urlKey = @"PRDH57rrkDrTr8snzNmY8XZ9KH4AFHtv";
    
    NSString *returnStr = @"";
    
    /*请求参数按照参数名ASCII码从小到大排序*/
    NSArray *keys = [dataDic allKeys];
    
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
 
    
    //拼接字符串
    
    for (int i=0;i<sortedArray.count;i++){
        
        NSString *category = sortedArray[i];
        
        if (i==0) {
            
            returnStr =[NSString stringWithFormat:@"%@=%@",category,dataDic[category]];
            
        }else{
                
            returnStr = [NSString stringWithFormat:@"%@&%@=%@",returnStr,category,dataDic[category]];
            
        }
        
}
    
    /*拼接上key得到stringSignTemp*/
    
    returnStr = [NSString stringWithFormat:@"%@&%@",returnStr,urlKey];
    
    /*md5加密*/
    
    returnStr = [MyMD5 md5:returnStr];
    
    return returnStr;
    
}
+ (void)setUserToken:(NSString *)userToken
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:userToken forKey:@"userToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)setUserName:(NSString *)name
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:name forKey:@"userName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString *)getUserToken
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"userToken"]?[userDefaults objectForKey:@"userToken"]:@"";
}
+ (NSString *)getUserUserName
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"userName"]?[userDefaults objectForKey:@"userName"]:@"";
}
+(void)setCornerRadius:(UIView *)sender Radius:(float)radius
{
    [sender.layer setCornerRadius:radius];
    sender.layer.masksToBounds = YES;
}

//验证手机号
+ (BOOL)islegalPhoneNum:(NSString *)mobileNum
{
    if (mobileNum.length != 11)
    {
        return NO;
    }
    NSString *mobileRegex = @"[0-9]{11}";
    NSPredicate *mobilePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobileRegex];
    return [mobilePredicate evaluateWithObject:mobileNum];
}
//设置密码正则
+ (BOOL)islegalPasswords:(NSString *)passwords
{
    NSString *passwordsRegex = @"[a-z0-9]{6,}";
    NSPredicate *passwordsPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordsRegex];
    return [passwordsPredicate evaluateWithObject:passwords];
}

+ (void)showTipsWithHUD:(NSString *)labelText showTime:(CGFloat)time
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithWindow:[[[UIApplication sharedApplication] delegate] window]] ;
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = labelText;
    hud.detailsLabelFont = [UIFont systemFontOfSize:15.0];
    hud.removeFromSuperViewOnHide = YES;
    [hud show:YES];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:hud];
    
    [hud hide:YES afterDelay:time];
}

+ (void)showTipsWithHUD:(NSString *)labelText
{
    [self showTipsWithHUD:labelText showTime:kShowTipsWithHUD];
}

+ (void)showTipsWithHUD:(NSString*)labelText inView:(UIView *)inView
{
    [Utils showTipsWithView:inView labelText:labelText showTime:kShowTipsWithHUD];
}

+ (void)showTipsWithView:(UIView *)uiview labelText:(NSString *)labelText showTime:(CGFloat)time
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:uiview] ;
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = labelText;
    hud.detailsLabelFont = [UIFont systemFontOfSize:15.0];
    hud.removeFromSuperViewOnHide = YES;
    [hud show:YES];
    [uiview addSubview:hud];
    
    [hud hide:YES afterDelay:time];
}
+ (void)showProgessInView:(UIView *)view withExtBlock:(void (^)())exBlock withComBlock:(void (^)())comBlock
{
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:view];
    hud.color = [UIColor colorWithWhite:0.8 alpha:0.6];
    //    hud.dimBackground = NO;
    [view addSubview:hud];
    hud.labelText = @"正在加载...";
    if (exBlock) {
        [hud showAnimated:YES whileExecutingBlock:exBlock completionBlock:^{
            if (comBlock) {
                comBlock();
            }
            [hud removeFromSuperview];
        }];
        
    }else
        [hud showAnimated:YES whileExecutingBlock:exBlock completionBlock:^{
            [hud removeFromSuperview];
        }];
}

+ (void) showHudMessage:(NSString*) msg hideAfterDelay:(NSInteger) sec uiview:(UIView *)uiview
{
    
    MBProgressHUD* hud2 = [MBProgressHUD showHUDAddedTo:uiview animated:YES];
    hud2.mode = MBProgressHUDModeText;
    hud2.labelText = msg;
    hud2.margin = 12.0f;
    hud2.yOffset = 20.0f;
    hud2.removeFromSuperViewOnHide = YES;
    [hud2 hide:YES afterDelay:sec];
}

//自定义字符串长度
+ (CGSize)getWidthByString:(NSString*)string withFont:(UIFont*)stringFont withStringSize:(CGSize)stringSize
{
    NSDictionary *attribute = @{NSFontAttributeName: stringFont};
    CGSize size = [string boundingRectWithSize:stringSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
    //MyLog(@"withd:%f,height:%f",size.width,size.height);
    return size;
}

+ (NSDate *)getNowTime
{
    return [NSDate date];
}
+(NSString *)getyyyymmdd{
    NSDate *now = [NSDate date];
    NSDateFormatter *formatDay = [[NSDateFormatter alloc] init];
    formatDay.dateFormat = @"yyyyMMdd";
    NSString *dayStr = [formatDay stringFromDate:now];
    
    return dayStr;
    
}
+(NSString *)gethhmmss{
    NSDate *now = [NSDate date];
    NSDateFormatter *formatTime = [[NSDateFormatter alloc] init];
    formatTime.dateFormat = @"HHmmss";
    NSString *timeStr = [formatTime stringFromDate:now];
    
    return timeStr;
    
}
+ (NSString *)get1970timeString{
    return [NSString stringWithFormat:@"%lld",(long long)[[NSDate date] timeIntervalSince1970] * 1000];
}
+ (NSString *)getTimeString:(NSDate *)date{
    return [NSString stringWithFormat:@"%lld",(long long)[date timeIntervalSince1970] * 1];
}

+ (NSString *)timeStringWithTimeStamp:(long long)timeStamp{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp/1000];
    return [Utils stringFromDate:date];
}
+(NSDate *)dateFromString:(NSString *)dateString usingFormat:(NSString*)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: format];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    return destDate;
    
}
+ (NSDate *)dateFromString:(NSString *)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    return destDate;
}
+ (NSString *)stringFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
}

+ (NSString *)stringFromDate:(NSDate *)date usingFormat:(NSString*)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
    
}
@end
