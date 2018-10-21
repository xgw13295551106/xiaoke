//
//  AppDelegate.m
//  XiaoKe
//
//  Created by IOS on 16/2/18.
//  Copyright © 2016年 com.znycat.com. All rights reserved.
//

#import "AppDelegate.h"
#import "NYWebViewController.h"
#import "IQKeyboardManager.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "AppDelegate+AliPay.h"
#import "AppDelegate+WXPay.h"

#pragma mark -  微信开放平台
#define WeiXinKEY  @"wx2452bca7fa836813"   //对应的商户号为 ：1516410391 (绑定王涛微信登录)
#define WeiXinSecret @"8fe697eed064ff7120bbb8189a2963bd"

#pragma mark -  蚂蚁金服开放平台
#define AliAppId @"2018100961612697"
@interface AppDelegate ()<CLLocationManagerDelegate>

@property (nonatomic,strong ) CLLocationManager *locationManager;//定位服务
@property (nonatomic,copy)    NSString *currentCity;//城市
@property (nonatomic,copy)    NSString *strLatitude;//经度
@property (nonatomic,copy)    NSString *strLongitude;//维度



@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    NYWebViewController *tbVC = [[NYWebViewController alloc]init];
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:tbVC];
    self.window.rootViewController = nav;
    [self setKeyBoard];
    [self.window makeKeyAndVisible];
    [WXApi registerApp:@"wx2452bca7fa836813"];
    [self locatemap];
    [self checkVersion];
    return YES;
}
- (void)locatemap{
    
    if ([CLLocationManager locationServicesEnabled]) {
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.delegate = self;
        [_locationManager requestAlwaysAuthorization];
        _currentCity = [[NSString alloc]init];
        [_locationManager requestWhenInUseAuthorization];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = kCLLocationAccuracyHundredMeters;
        [_locationManager startUpdatingLocation];
    }
}
#pragma mark - 定位失败
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请在设置中打开定位" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"打开定位" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *settingURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication]openURL:settingURL];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:cancel];
    [alert addAction:ok];
    [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
}
#pragma mark - 定位成功
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    [_locationManager stopUpdatingLocation];
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    //当前的经纬度
    NYLog(@"当前的经纬度 %f,%f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude);
    //这里的代码是为了判断didUpdateLocations调用了几次 有可能会出现多次调用 为了避免不必要的麻烦 在这里加个if判断 如果大于1.0就return
 //   NSTimeInterval locationAge = -[currentLocation.timestamp timeIntervalSinceNow];
//    if (locationAge > 1.0){//如果调用已经一次，不再执行
//        return;
//    }
    //地理反编码 可以根据坐标(经纬度)确定位置信息(街道 门牌等)
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count >0) {
            CLPlacemark *placeMark = placemarks[0];
            _currentCity = placeMark.locality;
            if (!_currentCity) {
                _currentCity = @"无法定位当前城市";
            }
            //看需求定义一个全局变量来接收赋值
            NYLog(@"当前国家 - %@",placeMark.country);//当前国家
            NYLog(@"当前城市 - %@",_currentCity);//当前城市
            NYLog(@"当前位置 - %@",placeMark.subLocality);//当前位置
            NYLog(@"当前街道 - %@",placeMark.thoroughfare);//当前街道
            NYLog(@"具体地址 - %@",placeMark.name);//具体地址
            NSDictionary *dict = @{@"lng":@(currentLocation.coordinate.longitude),@"lat":@(currentLocation.coordinate.latitude),@"city":_currentCity};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"GetcurrentLocation" object:nil userInfo:dict];
            NSString *message = [NSString stringWithFormat:@"%@,%@,%@,%@,%@",placeMark.country,_currentCity,placeMark.subLocality,placeMark.thoroughfare,placeMark.name];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:cancelAction];
            [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
            
        }else if (error == nil && placemarks.count){
            NYLog(@"NO location and error return");
        }else if (error){
            NYLog(@"loction error:%@",error);
        }
        
    }];
    

}
- (void)setKeyBoard
{
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager]; // 获取类库的单例变量
    
    keyboardManager.enable = YES; // 控制整个功能是否启用
    
    keyboardManager.shouldResignOnTouchOutside = YES; // 控制点击背景是否收起键盘
    
    keyboardManager.shouldToolbarUsesTextFieldTintColor = YES; // 控制键盘上的工具条文字颜色是否用户自定义
    
    keyboardManager.toolbarManageBehaviour = IQAutoToolbarBySubviews; // 有多个输入框时，可以通过点击Toolbar 上的“前一个”“后一个”按钮来实现移动到不同的输入框
    
    keyboardManager.enableAutoToolbar = YES; // 控制是否显示键盘上的工具条
    
    keyboardManager.shouldShowToolbarPlaceholder = YES; // 是否显示占位文字
    
    keyboardManager.placeholderFont = [UIFont boldSystemFontOfSize:17]; // 设置占位文字的字体
    
    keyboardManager.keyboardDistanceFromTextField = 10.0f; // 输入框距离键盘的距离
    
}

//支付宝 微信 支付回调
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([url.scheme isEqualToString:WeiXinKEY]){
         return  [self WXapplication:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    }else{
         return   [self AliPayApplication:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    }
    
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
  
    if ([url.scheme isEqualToString:WeiXinKEY]){
        return [self WXapplication:app openURL:url options:options];
    }else{
        return [self AliPayApplication:app openURL:url options:options];
    }

}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    if ([url.scheme isEqualToString:WeiXinKEY]){
         return  [WXApi handleOpenURL:url delegate:self];
    }else{
        return YES;
    }
}

- (void)checkVersion
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"up_version_ios" forKey:@"act"];
    [params setValue:[Utils encoingWithDic:params] forKey:@"sign"];
    [NYHttpTool Post:@"http://shopke.cn/mobile/ajax.php" parameters:params success:^(id responseObject) {
        if ([responseObject[@"error"] isEqual:@(0)]) {
            NSDictionary *dict = responseObject[@"info"];
            NSString *versonAPP = dict[@"v"];
            NSString *urlStr = @"https://itunes.apple.com/cn/app/id1088194281?mt=8";
            NSString *isforce = dict[@"up_type"];
            NSString *description = dict[@"memo"];
            // app版本
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            NSString *localVerson = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
            //将版本号按照.切割后存入数组中
            NSArray *localArray = [localVerson componentsSeparatedByString:@"."];
            NSArray *appArray = [versonAPP componentsSeparatedByString:@"."];
            NSInteger minArrayLength = MIN(localArray.count, appArray.count);
            BOOL needUpdate = NO;
            for(int i=0;i<minArrayLength;i++){//以最短的数组长度为遍历次数,防止数组越界
                //取出每个部分的字符串值,比较数值大小
                NSString *localElement = localArray[i];
                NSString *appElement = appArray[i];
                NSInteger  localValue =  localElement.integerValue;
                NSInteger  appValue = appElement.integerValue;
                if(localValue<appValue) {
                    //从前往后比较数字大小,一旦分出大小,跳出循环
                    needUpdate = YES;
                    break;
                }else{
                    if (localValue >appValue) {
                        needUpdate = NO;
                        break;
                    }else{
                        needUpdate = NO;
                    }
                    
                }
            }
            
            if (needUpdate) {
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"升级提示" message:description preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"下次再说" style:UIAlertActionStyleDefault handler:nil];
                UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"现在升级"style:UIAlertActionStyleDestructive handler:^(UIAlertAction*action) {
                    NSURL *url = [NSURL URLWithString:urlStr];
                    [[UIApplication sharedApplication]openURL:url];
                }];
                if (isforce.intValue == 0) {
                    [alertController addAction:cancelAction];
                }
                
                [alertController addAction:otherAction];
                
                [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
            }
        }else{
            [Utils showTipsWithHUD:responseObject[@"message"]];
                
        }
    } failure:^(NSError *error) {
        
    }];
   
}
@end
