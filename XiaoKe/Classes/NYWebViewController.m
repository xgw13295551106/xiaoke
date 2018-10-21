//
//  NYWebViewController.m
//  潇客
//
//  Created by IOS on 16/2/18.
//  Copyright © 2016年 com.znycat.com. All rights reserved.
//

#import "NYWebViewController.h"
#import <WebKit/WebKit.h>
//#import "WKWebViewJavascriptBridge.h"
#import "LoginViewController.h"
@interface NYWebViewController ()<WKUIDelegate, WKNavigationDelegate,WKScriptMessageHandler,CLLocationManagerDelegate>

@property (nonatomic, strong) UIButton *backBtn;
//@property WKWebViewJavascriptBridge *webViewBridge;
@property (nonatomic,strong) WKWebView *webView;
@property (nonatomic,strong) NSURL *url;
@property (nonatomic,copy) NSString *backUrlStr;
@property (nonatomic,copy) NSString *xlogin_appid;
@property (nonatomic,strong) WKWebViewConfiguration *configuration;
@property (nonatomic,copy) NSString *log_id; //支付宝支付完成之后 跳转的页面id

@property (nonatomic,strong) NSDictionary *locationInfo;

@end
//
@implementation NYWebViewController

-(instancetype)init{
    if(self = [super init]){

        self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
        //更改ua 区分是手机app 还是其他浏览器
        __weak typeof(self) weakSelf = self;
        [self.webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id result, NSError *error) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            NSString *userAgent = result;
            NSString *newUserAgent = [userAgent stringByAppendingString:@" native_ios"];
            NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:newUserAgent, @"UserAgent", nil];
            [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
            strongSelf.webView = [[WKWebView alloc] initWithFrame:strongSelf.view.bounds];
            strongSelf.webView.scrollView.bounces = NO;
            strongSelf.webView.scrollView.showsHorizontalScrollIndicator = NO;
            strongSelf.webView.scrollView.showsVerticalScrollIndicator = NO;
            [strongSelf cleanCookie];
            
            //加载页面
          NSString *userToken = [Utils getUserToken];
//            if (userToken.length >0) {
//                self.url = [[NSURL alloc]initWithString:@"http://shopke.cn/mobile/test.php"]; //测试js传值
//            }else{
//                self.url = [NSURL URLWithString:@"http://shopke.cn/mobile/test.php"];
//            }
            
            if (userToken.length >0) {
                strongSelf.url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"http://shopke.cn/mobile/user.php?app_token=%@",userToken]];
            }else{
                strongSelf.url = [NSURL URLWithString:@"http://shopke.cn/mobile/default.php"];
            }

            NSURLRequest *request = [[NSURLRequest alloc]initWithURL:self.url];
            [strongSelf.webView loadRequest:request];
            [strongSelf.view addSubview: self.webView];
            
            //js交互
            strongSelf.configuration = [[WKWebViewConfiguration alloc] init];
            strongSelf.configuration.userContentController = [WKUserContentController new];
            strongSelf.webView.navigationDelegate = self;
            [strongSelf.webView.configuration.userContentController addScriptMessageHandler:self name:@"iosLogin"];
            [strongSelf.webView.configuration.userContentController addScriptMessageHandler:self name:@"iosLogout"];
            [strongSelf.webView.configuration.userContentController addScriptMessageHandler:self name:@"AliPay"];
            [strongSelf.webView.configuration.userContentController addScriptMessageHandler:self name:@"native_WXPay"];
            
            [strongSelf.webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id result, NSError *error) {
                NYLog(@"======%@", result);
                
            }];
        }];
        
        //注册通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoginRefershWebView:) name:@"LoginSuccess" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RegisterRefershWebView) name:@"RegisterSuccess" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PaySuccess) name:@"PaySuccess" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PayCancel) name:@"PayCancel" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetcurrentLocation:) name:@"GetcurrentLocation" object:nil];

    }
    return self;
}
- (void)dealloc
{
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"iosLogin"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"iosLogout"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"AliPay"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"native_WXPay"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"LoginSuccess" object:nil];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RegisterSuccess" object:nil];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PaySuccess" object:nil];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PayCancel" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetcurrentLocation" object:nil];
}
- (void)GetcurrentLocation:(NSNotification *)noti
{
     self.locationInfo = noti.userInfo;
   
}
- (void)PaySuccess
{
    if (self.log_id.length >0 ) {
        NSURL *paySuccess = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"http://shopke.cn/mobile/return_alipay.php?log_id=%@",self.log_id]];
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:paySuccess];
        [self.webView loadRequest:request];
    }
}
- (void)PayCancel
{
    [self.webView goBack];
}
- (void)LoginRefershWebView:(NSNotification *)notification
{
    NSDictionary * infoDic = [notification object];
    if ([infoDic[@"back_act"] length] >0) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@&app_token=%@",infoDic[@"back_act"],[Utils getUserToken]] ]]];
    }else{
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?app_token=%@", self.backUrlStr, [Utils getUserToken]]]]];
    }
    

}

- (void)RegisterRefershWebView
{
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?app_token=%@", self.backUrlStr, [Utils getUserToken]]]]];
    
}
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    NSDictionary *body = message.body;
    if([message.name isEqualToString:@"iosLogin"]){
        self.backUrlStr = body[@"back_act"];
        self.xlogin_appid = body[@"xlogin_appid"];
        LoginViewController *logVc = [[LoginViewController alloc] init];
        logVc.xlogin_appid = self.xlogin_appid;
        logVc.backUrlStr = self.backUrlStr ;
        [self.navigationController pushViewController:logVc animated:YES];
    }
    if([message.name isEqualToString:@"iosLogout"]){
        [Utils setUserToken:@""];
        [self cleanCookie];
    }
    if([message.name isEqualToString:@"AliPay"]){
        self.log_id = body[@"log_id"];
            [[AlipaySDK defaultService] payOrder:body[@"payOrder"] fromScheme:@"xiaoke" callback:^(NSDictionary* resultDic) {
        //如果h唤起h5页面支付同步回调会从这里走
            NYLog(@"%@",resultDic);
        
            }];
    }
    if ([message.name isEqualToString:@"native_WXPay"]) {
        self.log_id = body[@"log_id"];
        NSDictionary *dict = body[@"payOrder"];
        PayReq *req = [[PayReq alloc] init];
        req.partnerId = dict[@"partnerid"];
        req.prepayId = dict[@"prepayid"];
        req.nonceStr = dict[@"noncestr"];
        req.timeStamp = [dict[@"timestamp"] unsignedIntValue];
        req.package = dict[@"package"];
        req.sign = dict[@"sign"];
        
        if (![WXApi sendReq:req]) {
            [Utils showTipsWithHUD:@"支付失败，无法打开微信支付。"];
            
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PaySuccess" object:nil];
        }
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //隐藏导航栏
    self.navigationController.navigationBarHidden = YES;
    if ([Utils getUserToken].length == 0) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://shopke.cn/mobile/default.php"]]];
    }
    
}

-(void)goBackClick:(UIButton *)btn{
    [self.webView goBack];
}

#pragma mark - WKWebView代理
//微信h5支付（弃用，改成app原生微信支付）
- (void)webView:(WKWebView*)webView decidePolicyForNavigationAction:(WKNavigationAction*)navigationAction decisionHandler:(void(^)(WKNavigationActionPolicy))decisionHandler{
    NSURLRequest *request = navigationAction.request;
    if ([request.URL.absoluteString hasPrefix:@"weixin://"]) {
        [[UIApplication sharedApplication]openURL:navigationAction.request.URL];
        //bSucc是否成功调起微信
    }
    NSString *wxPre = @"https://wx.tenpay.com/cgi-bin/mmpayweb-bin/checkmweb";
    if ([request.URL.absoluteString hasPrefix:wxPre]) {
        NSMutableURLRequest *newRequest = [[NSMutableURLRequest alloc] init];
        newRequest.allHTTPHeaderFields = request.allHTTPHeaderFields;
        NSString *newURLStr = nil;
        //TODO: 对newURLStr追加或修改参数redirect_url=URLEncode(A.company.com://)
        newRequest.URL = [NSURL URLWithString:newURLStr];
        [webView loadRequest:request];
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
   
    NYLog(@"=====%@",[NSString stringWithFormat:@"%@",webView.URL]);
    NSString *locStr = [NSString stringWithFormat:@"%@,%@,'%@'",self.locationInfo[@"lng"],self.locationInfo[@"lat"],self.locationInfo[@"city"]];
    NSString * jsStr  =[NSString stringWithFormat:@"save_loc('%@')",locStr];
    [webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NYLog(@"%@",result);
    }];
   
    
}
- (void)cleanCookie
{
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookieArray = [NSArray arrayWithArray:[cookieJar cookies]];
    for (id obj in cookieArray) {
        [cookieJar deleteCookie:obj];
    }
}
@end
