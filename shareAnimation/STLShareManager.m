//
//  STLShareManager.m
//  shareAnimation
//
//  Created by LiMingXing on 2018/5/7.
//  Copyright © 2018年 李明星. All rights reserved.
//

#import "STLShareManager.h"
#import <UIKit/UIKit.h>

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define KWidth_Scale    [UIScreen mainScreen].bounds.size.width/375.0f//相对4.7 屏幕宽度比
#define KHeight_Scale (LL_iPhoneX ? ([UIScreen mainScreen].bounds.size.height - 58)/667.0f : ([UIScreen mainScreen].bounds.size.height)/667.0f)//相对4.7 屏幕高度比

#define MoveDistance 300

@interface STLShareBtn : UIView

@property (strong, nonatomic) NSString *image;
@property (copy, nonatomic) NSString *title;
@property (assign, nonatomic) NSUInteger index;
@property (copy, nonatomic) void(^IndexBlock)(NSInteger index);

@end

@implementation STLShareBtn

- (instancetype)initWithImage:(NSString *)image title:(NSString *)title index:(NSUInteger)index{
    self = [super init];
    if (self) {
        _image = image;
        _title = title;
        _index = index;
        [self setUI];
    }
    return self;
}

- (void)setUI{
    self.tag = self.index+ 1000;
    UIImageView *iv = [[UIImageView alloc] init];
    iv.image = [UIImage imageNamed:self.image];
    UILabel *titleLB = [[UILabel alloc] init];
    titleLB.font = [UIFont systemFontOfSize:13 *KWidth_Scale];
    titleLB.textColor = [UIColor whiteColor];
    titleLB.textAlignment = 1;
    titleLB.text = self.title;
    [self addSubview:iv];
    [self addSubview:titleLB];
    iv.frame = CGRectMake(10 *KWidth_Scale, 0, 50 *KWidth_Scale, 50 *KWidth_Scale);
    titleLB.frame = CGRectMake(0, 58 *KWidth_Scale, 71 *KWidth_Scale, 13 *KWidth_Scale);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchSelfAction:)];
    [self addGestureRecognizer:tap];
}

- (void)touchSelfAction:(UITapGestureRecognizer *)tap{
    NSInteger tag = tap.view.tag;
    self.IndexBlock(tag - 1000);
}

@end


@interface STLShareManager()

@property (strong, nonatomic) UIVisualEffectView *veffectView;
@property (strong, nonatomic) UIButton *dismissBtn;
@property (assign, nonatomic) BOOL statusHidden;
@property (strong, nonatomic) NSMutableArray *btnArys;

@end

@implementation STLShareManager

+ (instancetype)sharedManager{
    static STLShareManager *sharedManger;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManger = [[STLShareManager alloc] init];
    });
    return sharedManger;
}

- (instancetype)init{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)show{
    self.statusHidden = [UIApplication sharedApplication].isStatusBarHidden;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [[UIApplication sharedApplication].keyWindow addSubview:self.veffectView];
    [self showAnimation];
}

- (void)showAnimation{
    [self.btnArys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        STLShareBtn *btn = obj;
        btn.alpha = 0.0;
        //关闭按钮动画
        if (idx == 0) {
            [UIView animateWithDuration:0.5f delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:2 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.dismissBtn.transform = CGAffineTransformMakeTranslation(0, -MoveDistance);
            } completion:^(BOOL finished) {
            }];
        }
        //图标动画
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(idx * 0.03f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5f delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:2 options:UIViewAnimationOptionCurveEaseIn animations:^{
                btn.alpha = 1;
                btn.transform = CGAffineTransformMakeTranslation(0, -MoveDistance);
            } completion:^(BOOL finished) {
                
            }];
        });

    }];
}

- (void)dismiss{
    [self dismissAnimation];
}

- (void)dismissAnimation{
    [self.btnArys enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        STLShareBtn * btn = obj;
        //关闭按钮消失动画
        if (idx == 0) {
            [UIView animateWithDuration:0.3f delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:1 options:0 animations:^{
                self.dismissBtn.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
            }];
        }
        //图标消失动画
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((self.btnArys.count - idx) * 0.03f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3f delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:1 options:0 animations:^{
                btn.alpha = 0;
                btn.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                if (idx == self.btnArys.count - 1) {
                    [[UIApplication sharedApplication] setStatusBarHidden:self.statusHidden];
                    [self.veffectView removeFromSuperview];
                }
            }];
        });
        
    }];
    
}


- (void)touchActionWithIndex:(NSInteger)index{
    NSLog(@"点了%ld", index);
}

#pragma mark ---------------实例-------------------

- (NSMutableArray *)btnArys{
    if (!_btnArys) {
        _btnArys = [NSMutableArray new];
        NSArray *images = @[@"qq1", @"qq2", @"wei1", @"wei2"];
        NSArray *titles = @[@"QQ好友", @"QQ空间", @"微信", @"微信朋友圈"];
        __weak typeof(self) weakSelf = self;
        for (NSInteger i = 0; i < images.count; i++) {
            STLShareBtn *btn = [[STLShareBtn alloc] initWithImage:images[i] title:titles[i] index:i];
            CGFloat centerX = ScreenWidth / 6 * (i%3 *2 +1);
            if (i == images.count - 1) {
                centerX = ScreenWidth / 2;
            }
            CGFloat centerY = ScreenHeight- 280 *KWidth_Scale + (i / 3) *110 *KWidth_Scale + MoveDistance;
            CGFloat width = 71 *KWidth_Scale;
            CGFloat height = 71 *KWidth_Scale;
            btn.frame = CGRectMake(0, 0, width, height);
            btn.center = CGPointMake(centerX, centerY);
            btn.IndexBlock = ^(NSInteger index) {
                [weakSelf touchActionWithIndex:index];
            };
            [_btnArys addObject:btn];
        }
    }
    return _btnArys;
}

- (UIVisualEffectView *)veffectView{
    if (!_veffectView) {
        UIBlurEffect *blurEffect =[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _veffectView =[[UIVisualEffectView alloc]initWithEffect:blurEffect];
        _veffectView.frame = [UIScreen mainScreen].bounds;
        _veffectView.alpha = 0.8;
        [_veffectView.contentView addSubview:self.dismissBtn];
        for (STLShareBtn *btn in self.btnArys) {
            [_veffectView.contentView addSubview:btn];
        }
    }
    return _veffectView;
}

- (UIButton *)dismissBtn{
    if (!_dismissBtn) {
        _dismissBtn = [[UIButton alloc] init];
        [_dismissBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [_dismissBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        _dismissBtn.frame = CGRectMake(0, 0, 34 *KWidth_Scale, 34 *KWidth_Scale);
        _dismissBtn.center = CGPointMake(ScreenWidth / 2, ScreenHeight - 45 *KWidth_Scale + MoveDistance);
    }
    return _dismissBtn;
}

@end
