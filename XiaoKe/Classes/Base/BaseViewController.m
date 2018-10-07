//
//  BaseViewController.m
//  XiaoKe
//
//  Created by 大智梦 on 2018/9/27.
//  Copyright © 2018年 com.znycat.com. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 40, 30, 30)];
    [leftBtn setImage:[UIImage imageNamed:@"left_icon"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(tapLeftButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * buttonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem= buttonItem;
    
    self.navigationController.navigationBar.titleTextAttributes=
  @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#1E1E1E"],
    NSFontAttributeName:[UIFont systemFontOfSize:16]};

}

- (void)tapLeftButton:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
