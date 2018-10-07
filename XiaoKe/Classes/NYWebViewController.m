//
//  NYWebViewController.m
//  潇客
//
//  Created by IOS on 16/2/18.
//  Copyright © 2016年 com.znycat.com. All rights reserved.
//

#import "NYWebViewController.h"
#import <WebKit/WebKit.h>
#import "WKWebViewJavascriptBridge.h"
#import "LoginViewController.h"
@interface NYWebViewController ()<WKUIDelegate, WKNavigationDelegate,WKScriptMessageHandler>

@property (nonatomic, strong) UIButton *backBtn;
@property WKWebViewJavascriptBridge *webViewBridge;
@property (nonatomic,strong) WKWebView *webView;
@property (nonatomic,strong) NSURL *url;
@property (nonatomic,copy) NSString *backUrlStr;
@property (nonatomic,copy) NSString *xlogin_appid;
@end
//
@implementation NYWebViewController

-(instancetype)init{
    if(self = [super init]){
        self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
        self.webView.scrollView.bounces = NO;
        self.webView.scrollView.showsHorizontalScrollIndicator = NO;
        self.webView.scrollView.showsVerticalScrollIndicator = NO;
        //更改ua
        __weak typeof(self) weakSelf = self;
        
        [self.webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id result, NSError *error) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            NSString *userAgent = result;
            NSString *newUserAgent = [userAgent stringByAppendingString:@" native_ios"];
            NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:newUserAgent, @"UserAgent", nil];
            [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
            strongSelf.webView = [[WKWebView alloc] initWithFrame:strongSelf.view.bounds];
            //加载页面
            NSString *userToken = [Utils getUserToken];
            if (userToken.length >0) {
                self.url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"http://shopke.cn/mobile/user.php?app_token=%@",userToken]];
            }else{
                self.url = [NSURL URLWithString:@"http://shopke.cn/mobile/default.php"];  //http://shopke.cn/mobile/user.php?act=login&test=1 http://shopke.cn/mobile/default.php
            }
            
            NSURLRequest *request = [[NSURLRequest alloc]initWithURL:self.url];
            [strongSelf.webView loadRequest:request];
            [self.view addSubview: self.webView];
            //js交互
            WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
            configuration.userContentController = [WKUserContentController new];
              _webViewBridge = [WKWebViewJavascriptBridge bridgeForWebView:self.webView];
            [_webViewBridge setWebViewDelegate:self.webView];
            self.webView.navigationDelegate = self;
            [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"iosLogin"];
            [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"iosLogout"];
            [strongSelf.webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id result, NSError *error) {
                NSLog(@"======%@", result);
                
            }];
        }];
        //
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoginRefershWebView:) name:@"LoginSuccess" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RegisterRefershWebView) name:@"RegisterSuccess" object:nil];

        //创建返回按钮
        self.backBtn = [[UIButton alloc]initWithFrame:CGRectMake(NYScreenW-90, NYScreenH - 140, 90, 63)];
        [self.backBtn addTarget:self action:@selector(goBackClick:) forControlEvents:UIControlEventTouchUpInside];
        //[self.backBtn setImage:[UIImage imageNamed:@"backc"] forState:UIControlStateNormal];
        //self.backBtn.hidden = YES;
        //self.backBtn.backgroundColor = [UIColor redColor];
        [self.view addSubview:self.backBtn];
        
    }
    return self;
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

    }
    
}
- (void)dealloc
{
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"iosLogin"]; //
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"iosLogout"];
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

//微信h5支付
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
    
    
//    NSString *strUrl = [NSString stringWithFormat:@"%@",webView.URL];
//    NSString *str1 = @"shopke.cn/mobile/default.php";
//    NSString *str2 = @"shopke.cn/o/default.php";
//
//    if (strUrl.length) {
//        if ([strUrl rangeOfString:str1].location != NSNotFound) {
//            NYLog(@"strURL === %@ 包含str1 %@ ",strUrl ,str1);
//            self.backBtn.hidden = YES;
//
//
//        }else{
//            NYLog(@"不包含 %@", strUrl);
//
//            if ([strUrl rangeOfString:str2].location != NSNotFound) {
//                NYLog(@"strURL === %@ 包含str2 %@ ",strUrl ,str2);
//                self.backBtn.hidden = YES;
//
//
//            }else{
//                self.backBtn.hidden = NO;
//            }
//        }
//
//    }else{
//
//        self.backBtn.hidden = YES;
//    }
}

@end
