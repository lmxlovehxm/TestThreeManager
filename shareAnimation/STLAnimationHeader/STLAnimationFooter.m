//
//  STLAnimationFooter.m
//  shareAnimation
//
//  Created by LiMingXing on 2018/5/14.
//  Copyright © 2018年 李明星. All rights reserved.
//

#import "STLAnimationFooter.h"

@implementation STLAnimationFooter


- (void)placeSubviews{
    [super placeSubviews];
    NSMutableArray *data = [NSMutableArray new];
    for (NSInteger i = 1; i <= 10; i++) {
        NSString *title = [NSString stringWithFormat:@"footer_%ld",i];
        UIImage *img = [UIImage imageNamed:title];
        [data addObject:img];
    }
//    [self setImages:data duration:1 forState:MJRefreshStateRefreshing];
    [self setImages:data forState:MJRefreshStateRefreshing];
}

@end
