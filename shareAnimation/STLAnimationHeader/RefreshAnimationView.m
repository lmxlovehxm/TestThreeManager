//
//  RefreshAnimationView.m
//  shareAnimation
//
//  Created by LiMingXing on 2018/5/10.
//  Copyright © 2018年 李明星. All rights reserved.
//

#import "RefreshAnimationView.h"
@interface RefreshAnimationView()<CAAnimationDelegate>

@property (strong, nonatomic) UIImageView *animationIv;
@property (nonatomic, assign) CGFloat progress;
@property (strong, nonatomic) UIImageView *logoIv;

@end

@implementation RefreshAnimationView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [self addSubview:self.animationIv];
    self.animationIv.frame = CGRectMake(0, 0, 23,23);
    self.animationIv.center =CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    [self addSubview:self.logoIv];
    self.logoIv.frame = CGRectMake(0, 0, 23, 23);
    self.logoIv.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    self.animationIv.hidden = YES;
    self.logoIv.hidden = YES;
}

- (void)showWithProgress:(float)value{
    self.animationIv.hidden = NO;
    self.logoIv.hidden = YES;
    NSInteger titleLD = (NSInteger)(value *10);
    if (titleLD >= 10) {
        titleLD = 10;
    }
    if (titleLD < 1) {
        titleLD = 1;
    }
    NSString *titleIv = [NSString stringWithFormat:@"%ld", titleLD];
    self.animationIv.image = [UIImage imageNamed:titleIv];
}

- (void)starAnimationWithProgress:(float)value{
    self.animationIv.hidden = YES;
    self.logoIv.hidden = NO;
}

- (void)stopAnimation{
    self.animationIv.image = [UIImage imageNamed:@"10"];
    self.animationIv.hidden = NO;
    self.logoIv.hidden = YES;
}


- (UIImageView *)logoIv{
    if (!_logoIv) {
        NSMutableArray *animaitionImg = [NSMutableArray new];
        for (NSInteger i = 0; i <=2; i++) {
            NSString *titleImg = [NSString stringWithFormat:@"%ld",i + 10];
            UIImage *img = [UIImage imageNamed:titleImg];
            [animaitionImg addObject:img];
        }
        UIImage *gifImg  =[UIImage animatedImageWithImages:animaitionImg duration:0.5];
        _logoIv = [[UIImageView alloc] initWithImage:gifImg];
    }
    return _logoIv;
}

- (UIImageView *)animationIv{
    if (!_animationIv) {
        _animationIv = [[UIImageView alloc] init];
    }
    return _animationIv;
}
//
//- (NSTimer *)timer{
//    if (!_timer) {
//        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
//            [self showWithProgress:self.lastProgress];
//            self.lastProgress += 0.1;
//            if (self.lastProgress >=1.3) {
//                self.lastProgress = 0;
//            }
//        }];
//        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
//    }
//    return _timer;
//}
@end
