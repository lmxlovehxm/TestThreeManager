//
//  MenuView.m
//  shareAnimation
//
//  Created by LiMingXing on 2018/5/30.
//  Copyright © 2018年 李明星. All rights reserved.
//

#import "MenuView.h"

@interface MenuView()

@property (strong, nonatomic) UIButton *moreBtn;
@property (strong, nonatomic) UIButton *selectBtn;
@property (strong, nonatomic) UIButton *searchBtn;


@end

@implementation MenuView

- (UIButton *)moreBtn{
    if (!_moreBtn) {
        _moreBtn = [[UIButton alloc] init];
    }
    return _moreBtn;
}

- (UIButton *)selectBtn{
    if (!_selectBtn) {
        _selectBtn = [[UIButton alloc] init];
    }
    return _selectBtn;
}

- (UIButton *)searchBtn{
    if (!_searchBtn) {
        _searchBtn = [[UIButton alloc] init];
    }
    return _searchBtn;
}


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

@end
