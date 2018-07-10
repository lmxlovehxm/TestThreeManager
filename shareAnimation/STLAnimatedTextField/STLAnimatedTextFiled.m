//
//  STLAnimatedTextFiled.m
//  shareAnimation
//
//  Created by LiMingXing on 2018/5/17.
//  Copyright © 2018年 李明星. All rights reserved.
//

#import "STLAnimatedTextFiled.h"

#define kRGBCOLOR(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define TextColor kRGBCOLOR(51, 51, 51)
#define TitleColor kRGBCOLOR(170, 170, 170)
#define PlaceHolderColor kRGBCOLOR(204, 204, 204)
#define RedLineColor kRGBCOLOR(251, 87, 64)
#define GrayLineColor kRGBCOLOR(230, 230, 230)


@interface STLAnimatedTextFiled()<UITextFieldDelegate>

@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) UIView *bottomLine;
@property (strong, nonatomic) UILabel *placeHolederLB;
@property (strong, nonatomic) UILabel *titleLB;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *placeholder;
@property (assign, nonatomic) NSInteger type;


@property (strong, nonatomic) UIButton *rightBtn;

@end

@implementation STLAnimatedTextFiled

- (instancetype)initWithFrame:(CGRect)frame Title:(NSString *)title placeHolder:(NSString *)placeholder type:(NSInteger)type{
    self = [super initWithFrame:frame];
    if (self) {
        _title = title;
        _type = type;
        _placeholder = placeholder;
        [self setUI];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)setUI{
    [self addSubview:self.textField];
    [self addSubview:self.placeHolederLB];
    [self addSubview:self.titleLB];
    [self addSubview:self.bottomLine];
    [self addSubview:self.rightBtn];
    self.titleLB.hidden = YES;
    
    self.bottomLine.frame = CGRectMake(0, self.frame.size.height - 0.5, self.frame.size.width, 0.5);
    self.textField.frame = CGRectMake(9, 33.5, self.frame.size.width - 18, 20);
    self.placeHolederLB.frame = CGRectMake(9, 21.5, self.frame.size.width - 18, 35);
    self.titleLB.frame = CGRectMake(10.5, 23, self.frame.size.width - 21, 14);
    [self setRightBtnFrame];
}

- (void)setRightBtnFrame{
    if (_type == 0 || _type == 1) {
        self.rightBtn.hidden = YES;
        //手机号输入 或者密码输入
        self.rightBtn.frame = CGRectMake(self.frame.size.width - 15 - 10, self.frame.size.height - 15 - 15, 15, 15);
        self.textField.frame = CGRectMake(9, 33.5, self.frame.size.width - 25 -9, 20);
        if (_type == 0) {
            [self.rightBtn setImage:[UIImage imageNamed:@"phoneRight"] forState:UIControlStateNormal];
        }else{
            self.textField.secureTextEntry = YES;
            [self.rightBtn setImage:[UIImage imageNamed:@"passRightClose"] forState:UIControlStateNormal];
            [self.rightBtn setImage:[UIImage imageNamed:@"passRightOpen"] forState:UIControlStateSelected];
        }
    }else{
        self.rightBtn.hidden = NO;
        self.rightBtn.frame = CGRectMake(self.frame.size.width - 87, self.frame.size.height - 40, 87, 35);
        self.textField.frame = CGRectMake(9, 33.5, self.frame.size.width - 87 -9, 20);
        [self.rightBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.rightBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self.rightBtn setTitleColor:TextColor forState:UIControlStateNormal];
    }
}

#pragma mark ---------------setter-------------------

- (void)setTextAlignment:(NSTextAlignment)textAlignment{
    _textAlignment = textAlignment;
    self.textField.textAlignment = textAlignment;
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType{
    _keyboardType = keyboardType;
    self.textField.keyboardType = keyboardType;
}

- (void)setMaxIputLength:(NSInteger)maxIputLength{
    _maxIputLength = maxIputLength;
}


#pragma mark ---------------textfiled代理-------------------

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self showAnimation];
    self.bottomLine.backgroundColor = RedLineColor;
    self.bottomLine.frame = CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1);
    [self textChanged:nil];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (textField.text.length == 0) {
        [self removeAnimation];
    }
    self.bottomLine.backgroundColor = GrayLineColor;
    self.bottomLine.frame = CGRectMake(0, self.frame.size.height - 0.5, self.frame.size.width, 0.5);
    if (_type == 0) {
        self.rightBtn.hidden = YES;
    }else if (_type == 1){
        if (self.textField.text.length == 0) {
            self.rightBtn.hidden = YES;
        }
    }
    
    return YES;
}


- (void)textChanged:(NSNotification *)fication{
    if ((_type == 0 || _type == 1) && [self.textField isFirstResponder]) {
        if (self.textField.text.length > 0) {
            self.rightBtn.hidden = NO;
        }else{
            self.rightBtn.hidden = YES;
        }
    }
}

#pragma mark ---------------动画-------------------

- (void)showAnimation{
    self.placeHolederLB.hidden = YES;
    self.titleLB.hidden = NO;
    [UIView animateWithDuration:0.12f animations:^{
        self.titleLB.frame  = CGRectMake(10.5, 12, self.frame.size.width - 21, 14);
    } completion:^(BOOL finished) {
    }];
}

- (void)removeAnimation{
    [UIView animateWithDuration:0.12 animations:^{
        self.titleLB.frame  = CGRectMake(10.5, 23, self.frame.size.width - 21, 14);
    } completion:^(BOOL finished) {
        self.placeHolederLB.hidden = NO;
        self.titleLB.hidden = YES;
    }];
}

#pragma mark ---------------按钮点击事件-------------------

- (void)rightTouchAction:(UIButton *)btn{
    if (_type == 0) {
        //做清空操作
        self.textField.text = nil;
        self.rightBtn.hidden = YES;
    }else if (_type == 1){
        //做安全输入切换操作
        self.textField.secureTextEntry = !self.textField.isSecureTextEntry;
        self.rightBtn.selected = !self.rightBtn.isSelected;
    }else{
        //发送验证码操作
    }
}

#pragma mark ---------------懒加载-------------------

- (UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.font = [UIFont systemFontOfSize:18];
        _textField.textColor = TextColor;
        _textField.delegate = self;
        _textField.tintColor = [UIColor blackColor];
    }
    return _textField;
}

- (UIView *)bottomLine{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = GrayLineColor;
    }
    return _bottomLine;
}

- (UILabel *)placeHolederLB{
    if (!_placeHolederLB) {
        _placeHolederLB = [[UILabel alloc] init];
        _placeHolederLB.font = [UIFont systemFontOfSize:18];
        _placeHolederLB.textColor = PlaceHolderColor;
        _placeHolederLB.text = self.placeholder;
    }
    return _placeHolederLB;
}

- (UILabel *)titleLB{
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.font = [UIFont systemFontOfSize:14];
        _titleLB.text = self.title;
        _titleLB.textColor = TitleColor;
    }
    return _titleLB;
}

- (UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc] init];
        [_rightBtn addTarget:self action:@selector(rightTouchAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}


@end
