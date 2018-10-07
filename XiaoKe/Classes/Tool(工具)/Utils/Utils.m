//
//  Utils.m
//  XiaoKe
//
//  Created by 大智梦 on 2018/9/26.
//  Copyright © 2018年 com.znycat.com. All rights reserved.
//

#import "Utils.h"
#import "MyMD5.h"

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
@end
