//
//  RegisterViewController.h
//  XiaoKe
//
//  Created by 大智梦 on 2018/9/25.
//  Copyright © 2018年 com.znycat.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RegisterViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextField *inviterPhone;
@property (weak, nonatomic) IBOutlet UITextField *userPhone;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
- (IBAction)sendCode:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UITextField *codeField;
@property (weak, nonatomic) IBOutlet UITextField *passwordsField;
- (IBAction)loginIn:(UIButton *)sender;
- (IBAction)RegiserAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *registeBtn;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;

- (IBAction)agreeService:(UIButton *)sender;
@end

NS_ASSUME_NONNULL_END
