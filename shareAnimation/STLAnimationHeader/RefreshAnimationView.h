//
//  RefreshAnimationView.h
//  shareAnimation
//
//  Created by LiMingXing on 2018/5/10.
//  Copyright © 2018年 李明星. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RefreshAnimationView : UIView

@property (assign, nonatomic) BOOL isAnimation;

- (void)showWithProgress:(float)value;

- (void)starAnimationWithProgress:(float)value;

- (void)stopAnimation;

@end
