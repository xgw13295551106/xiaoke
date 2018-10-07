//
//  LoginViewController.h
//  XiaoKe
//
//  Created by 大智梦 on 2018/9/25.
//  Copyright © 2018年 com.znycat.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordsField;
- (IBAction)loginIn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (nonatomic,copy) NSString *xlogin_appid;
@property (nonatomic,copy) NSString *backUrlStr;
@end

NS_ASSUME_NONNULL_END
