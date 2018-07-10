//
//  STLAnimatedTextFiled.h
//  shareAnimation
//
//  Created by LiMingXing on 2018/5/17.
//  Copyright © 2018年 李明星. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STLAnimatedTextFiled : UIView

/**
 *  title 标题
 *  type  0 ==手机号输入 1==密码输入 2==验证码输入
 */
- (instancetype)initWithFrame:(CGRect)frame Title:(NSString *)title placeHolder:(NSString *)placeholder type:(NSInteger)type;
/**
 *  文字方向
 */
@property (assign, nonatomic) NSTextAlignment textAlignment;
/**
 *  键盘类型
 */
@property (assign, nonatomic) UIKeyboardType keyboardType;
/**
 *  文字限制长度
 */
@property (assign, nonatomic) NSInteger maxIputLength;




@end
