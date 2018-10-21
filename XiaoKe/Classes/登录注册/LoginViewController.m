//
//  LoginViewController.m
//  XiaoKe
//
//  Created by 大智梦 on 2018/9/25.
//  Copyright © 2018年 com.znycat.com. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"会员登录";
    self.loginBtn.backgroundColor = [UIColor colorWithHexString:@"#e9443d"];
    self.userNameField.text = [Utils getUserUserName];
    [Utils setCornerRadius:self.loginBtn Radius:5];
    
}

- (IBAction)register:(UIButton *)sender {
    RegisterViewController *ctrl = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:ctrl animated:YES];

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (IBAction)loginIn:(UIButton *)sender {
    if (![Utils islegalPhoneNum:self.userNameField.text]) {
        [Utils showTipsWithHUD:@"请输入正确的用户名"];
        return;
    }
    if (self.passwordsField.text.length == 0) {
        [Utils showTipsWithHUD:@"请输入密码"];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.userNameField.text forKey:@"uname"];
    [params setValue:self.passwordsField.text forKey:@"pwd"];
    [params setValue:@"signin" forKey:@"act"];
    [params setValue:self.xlogin_appid forKey:@"xlogin_appid"];
    [params setValue:self.backUrlStr forKey:@"back_act"];
    [params setValue:[Utils encoingWithDic:params] forKey:@"sign"];
    [NYHttpTool Post:@"http://shopke.cn/mobile/appservice.php" parameters:params success:^(id responseObject) {
        if ([responseObject[@"error"] isEqual:@(0)]) {
            [Utils setUserToken:responseObject[@"token"]];
            [Utils setUserName:self.userNameField.text];
            if ([responseObject[@"back_act"] length] >0) {
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"LoginSuccess" object:@{@"back_act":responseObject[@"back_act"]}];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"LoginSuccess" object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }
            [Utils showTipsWithHUD:@"登录成功"];

        }else{
            [Utils showTipsWithHUD:responseObject[@"message"]];
        }
    } failure:^(NSError *error) {
        
    }];

    
        
}
@end
