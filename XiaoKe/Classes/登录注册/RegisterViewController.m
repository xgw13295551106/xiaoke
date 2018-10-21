//
//  RegisterViewController.m
//  XiaoKe
//
//  Created by 大智梦 on 2018/9/25.
//  Copyright © 2018年 com.znycat.com. All rights reserved.
//

#import "RegisterViewController.h"
#import "CustomAlertView.h"
@interface RegisterViewController ()
@property (nonatomic,copy) NSString *agreementStr;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"会员注册";
    self.registeBtn.backgroundColor = [UIColor colorWithHexString:@"#e9443d"];
    self.codeBtn.backgroundColor = [UIColor colorWithHexString:@"#e9443d"];
    [Utils setCornerRadius:self.registeBtn Radius:5];
    [Utils setCornerRadius:self.codeBtn Radius:2];
    [self downloadAgreementData];
    
}
- (void)downloadAgreementData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"reg_licence" forKey:@"act"];
    [params setValue:[Utils encoingWithDic:params] forKey:@"sign"];
    [NYHttpTool Post:@"http://shopke.cn/mobile/appservice.php" parameters:params success:^(id responseObject) {
        if ([responseObject[@"error"] isEqual:@(0)]) {
            self.agreementStr = responseObject[@"content"];
            
        }else{
            [Utils showTipsWithHUD:responseObject[@"message"]];
            
        }
    } failure:^(NSError *error) {
        
    }];
}


- (IBAction)sendCode:(UIButton *)sender {
    
    if (![Utils islegalPhoneNum:self.userPhone.text]) {
        [Utils showTipsWithHUD:@"请输入您的正确手机号"];
        return;
    }
    
  
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.userPhone.text forKey:@"mobile"];
    [params setValue:@"send_mobile_code" forKey:@"act"];
    [params setValue:[Utils encoingWithDic:params] forKey:@"sign"];
    [NYHttpTool Post:@"http://shopke.cn/mobile/appservice.php" parameters:params success:^(id responseObject) {
        if ([responseObject[@"error"] isEqual:@(0)]) {
            __block NSInteger time = 119; //倒计时时间
            
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
            
            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            
            dispatch_source_set_event_handler(_timer, ^{
                
                if(time <= 0){ //倒计时结束，关闭
                    
                    dispatch_source_cancel(_timer);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        //设置按钮的样式
                        [self.codeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
                        [self.codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        self.codeBtn.backgroundColor = [UIColor colorWithHexString:@"#e9443d"];
                        self.codeBtn.userInteractionEnabled = YES;
                    });
                    
                }else{
                    
                    int seconds = time % 120;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        //设置按钮显示读秒效果
                        [self.codeBtn setTitle:[NSString stringWithFormat:@"重新发送(%.2d秒)", seconds] forState:UIControlStateNormal];
                        [self.codeBtn setTitleColor:[UIColor colorWithHexString:@"#e9443d"] forState:UIControlStateNormal];
                        self.codeBtn.backgroundColor = [UIColor whiteColor];
                        self.codeBtn.userInteractionEnabled = NO;
                    });
                    time--;
                }
            });
            dispatch_resume(_timer);
            
        }else{
            [Utils showTipsWithHUD:responseObject[@"message"]];
            
        }
    } failure:^(NSError *error) {
        
    }];
    
}
- (IBAction)loginIn:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)RegiserAction:(UIButton *)sender {
    if (! self.agreeBtn.selected) {
        [Utils showTipsWithHUD:@"请勾选潇客shopke服务协议"];
        return;
    }
    if (![Utils islegalPhoneNum:self.inviterPhone.text]) {
        [Utils showTipsWithHUD:@"请输入正确的邀请人手机号"];
        return;
    }
    if (![Utils islegalPhoneNum:self.userPhone.text]) {
         [Utils showTipsWithHUD:@"请输入您的正确手机号"];
        return;
    }
    if (![Utils islegalPasswords:self.passwordsField.text]) {
        [Utils showTipsWithHUD:@"请输入正确格式的密码"];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.userPhone.text forKey:@"uname"];
    [params setValue:self.passwordsField.text forKey:@"pwd"];
    [params setValue:@"reg" forKey:@"act"];
    [params setValue:self.inviterPhone.text forKey:@"pname"];
    [params setValue:self.codeField.text forKey:@"code"];
    [params setValue:[Utils encoingWithDic:params] forKey:@"sign"];
    [NYHttpTool Post:@"http://shopke.cn/mobile/appservice.php" parameters:params success:^(id responseObject) {
        if ([responseObject[@"error"] isEqual:@(0)]) {
            [Utils setUserToken:responseObject[@"token"]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RegisterSuccess" object:nil];
            [self.navigationController popToRootViewControllerAnimated:YES];
            [Utils showTipsWithHUD:@"注册成功"];
            
        }else{
            [Utils showTipsWithHUD:responseObject[@"message"]];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (IBAction)agreeService:(UIButton *)sender {
    sender.selected = NO;
    CustomAlertView *alerview = [[CustomAlertView alloc]initBackroundImage:nil Title:@"shopke潇客用户注册协议" contentString:self.agreementStr sureButtionTitle:@"已阅读并同意此协议" cancelButtionTitle:@"暂不同意此协议"];
    [alerview setSureBolck:^(BOOL clickStatu) {
        sender.selected = YES;
    }];
    
}
@end
