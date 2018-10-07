//
//  UIColor+Hex.h
//  XiaoKe
//
//  Created by 大智梦 on 2018/9/27.
//  Copyright © 2018年 com.znycat.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Hex)
// 默认alpha位1
+ (UIColor *)colorWithHexString:(NSString *)color;

//从十六进制字符串获取颜色，
//color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;


@end

NS_ASSUME_NONNULL_END
