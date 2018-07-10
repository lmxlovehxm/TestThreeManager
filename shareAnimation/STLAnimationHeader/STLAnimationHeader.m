//
//  STLAnimationHeader.m
//  shareAnimation
//
//  Created by LiMingXing on 2018/5/14.
//  Copyright © 2018年 李明星. All rights reserved.
//

#import "STLAnimationHeader.h"
#import "RefreshAnimationView.h"

@interface STLAnimationHeader()

@property (strong, nonatomic) RefreshAnimationView *animationView;

@end

@implementation STLAnimationHeader

#pragma mark ---------------监听刷新状态-------------------

- (void)setState:(MJRefreshState)state{
    MJRefreshCheckState;
    // 根据状态做事情
    if (state == MJRefreshStateIdle) {
        if (self.state != MJRefreshStateIdle) return;
        [self.animationView stopAnimation];
    } else if (state == MJRefreshStatePulling) {
        
    } else if (state == MJRefreshStateRefreshing) {
        [self.animationView starAnimationWithProgress:1];
    }
}

- (void)setPullingPercent:(CGFloat)pullingPercent{
    [super setPullingPercent:pullingPercent];
    if (self.state == MJRefreshStateRefreshing) {
        return;
    }
    [self.animationView showWithProgress:pullingPercent];
}



#pragma mark ---------------重构UI-------------------
//准备工作（添加子控件之类）
- (void)prepare{
    [super prepare];
    self.mj_h = 68;//设置控件高度
    [self addSubview:self.animationView];
}
//设置子控件位置
- (void)placeSubviews{
    [super placeSubviews];
    self.animationView.mj_x = self.mj_w/2;
    self.animationView.mj_y = self.mj_h/2;
    self.stateLabel.mj_y = self.animationView.mj_h;
    self.lastUpdatedTimeLabel.hidden = YES;
}


#pragma mark ---------------懒加载-------------------


- (RefreshAnimationView *)animationView{
    if (!_animationView) {
        _animationView = [[RefreshAnimationView alloc] init];
        _animationView.frame = CGRectMake(0, 0, 23, 23);
    }
    return _animationView;
}

@end
