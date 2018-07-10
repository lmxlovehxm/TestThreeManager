//
//  LoginViewController.m
//  shareAnimation
//
//  Created by LiMingXing on 2018/5/17.
//  Copyright © 2018年 李明星. All rights reserved.
//

#import "LoginViewController.h"
#import "STLAnimatedTextFiled.h"
#import <IQKeyboardManager.h>

@interface LoginViewController ()

@property (strong, nonatomic) STLAnimatedTextFiled *loginTf;
@property (strong, nonatomic) STLAnimatedTextFiled *passTf;
@property (strong, nonatomic) STLAnimatedTextFiled *codeTf;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    _loginTf = [[STLAnimatedTextFiled alloc] initWithFrame:CGRectMake(10, 100, 300, 68) Title:@"手机号" placeHolder:@"请输入手机号" type:0];
    [self.view addSubview:self.loginTf];
    _codeTf = [[STLAnimatedTextFiled alloc] initWithFrame:CGRectMake(10, 168, 300, 68) Title:@"验证码" placeHolder:@"请输入验证码" type:2];
    [self.view addSubview:self.codeTf];

    _passTf = [[STLAnimatedTextFiled alloc] initWithFrame:CGRectMake(10, 236, 300, 68) Title:@"密码" placeHolder:@"请输入密码" type:1];
    [self.view addSubview:self.passTf];

}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [[IQKeyboardManager sharedManager] resignFirstResponder];
}


@end
