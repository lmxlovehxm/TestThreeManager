//
//  STLThreeTableView.h
//  shareAnimation
//
//  Created by LiMingXing on 2018/5/21.
//  Copyright © 2018年 李明星. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STLThreeTableTestModel.h"


@interface STLIndexPath :NSObject

@property (nonatomic, assign) NSInteger column;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, assign) NSInteger item;
- (instancetype)initWithColumn:(NSInteger)column row:(NSInteger)row;
// default item = -1
+ (instancetype)indexPathWithCol:(NSInteger)col row:(NSInteger)row;
+ (instancetype)indexPathWithCol:(NSInteger)col row:(NSInteger)row item:(NSInteger)item;

@end


@class STLThreeTableView;

@protocol STLThreeTableViewDataSource<NSObject>

@required

/**
*  返回 menu 第column列有多少行
*/
- (NSInteger)menu:(STLThreeTableView *)menu numberOfRowsInColumn:(NSInteger)column;

/**
 *  返回 menu 第column列 每行title
 */
- (STLThreeTableTestModel *)menu:(STLThreeTableView *)menu titleForRowAtIndexPath:(STLIndexPath *)indexPath;

/**
 *  返回 menu 有多少列 ，默认3列
 */
- (NSInteger)numberOfColumnsInMenu:(STLThreeTableView *)menu;
/**
 *  返回 menu列宽度
 */
- (CGFloat)widthInCoulumn:(NSInteger)column;


@end

#pragma mark - delegate
@protocol STLThreeTableViewDelegate <NSObject>

@optional
/**
 *  点击代理，点击了第column 第row 或者item项，如果 item >=0
 */
- (void)menu:(STLThreeTableView *)menu didSelectRowAtIndexPath:(STLIndexPath *)indexPath;

/** 新增
 *  return nil if you don't want to user select specified indexpath
 *  optional
 */
- (NSIndexPath *)menu:(STLThreeTableView *)menu willSelectRowAtIndexPath:(STLIndexPath *)indexPath;

@end


@interface STLThreeTableView : UIView <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) id <STLThreeTableViewDataSource> dataSource;
@property (nonatomic, weak) id <STLThreeTableViewDelegate> delegate;

// 重新加载数据
- (void)reloadData;



@end
