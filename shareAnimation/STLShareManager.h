//
//  STLShareManager.h
//  shareAnimation
//
//  Created by LiMingXing on 2018/5/7.
//  Copyright © 2018年 李明星. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STLShareManager : NSObject

+ (instancetype)sharedManager;

- (void)show;

- (void)dismiss;

@end

