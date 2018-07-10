//
//  DDMenuViewController.m
//  shareAnimation
//
//  Created by LiMingXing on 2018/5/21.
//  Copyright © 2018年 李明星. All rights reserved.
//

#import "DDMenuViewController.h"
#import "STLThreeTableView.h"
#import "STLThreeTableTestModel.h"

@interface DDMenuViewController ()
<
    STLThreeTableViewDelegate,
    STLThreeTableViewDataSource
>

@property (strong, nonatomic) STLThreeTableView *menu;

@property (strong, nonatomic) NSMutableArray *data_0;
@property (strong, nonatomic) NSMutableArray *data_1;
@property (strong, nonatomic) NSMutableArray *data_2;


@end

@implementation DDMenuViewController

#pragma mark ---------------懒加载-------------------

- (STLThreeTableView *)menu{
    if (!_menu) {
        _menu = [[STLThreeTableView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _menu.backgroundColor = [UIColor redColor];
        _menu.delegate = self;
        _menu.dataSource = self;
    }
    return _menu;
}

- (NSMutableArray *)data_0{
    if (!_data_0) {
        _data_0 = [NSMutableArray new];
    }
    return _data_0;
}

- (NSMutableArray *)data_1{
    if (!_data_1) {
        _data_1 = [NSMutableArray new];
    }
    return _data_1;
}

- (NSMutableArray *)data_2{
    if (!_data_2) {
        _data_2 = [NSMutableArray new];
    }
    return _data_2;
}


#pragma mark ---------------生命周期-------------------

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    for (NSInteger i = 0; i < 10; i++) {
        NSString *title = [NSString stringWithFormat:@"%ld", i];
        STLThreeTableTestModel *model = [[STLThreeTableTestModel alloc] init];
        model.title = title;
        [self.data_0 addObject:model];
        [self.data_1 addObject:model];
        [self.data_2 addObject:model];
    }
    [self.view addSubview:self.menu];
    [self.menu reloadData];
}

#pragma mark ---------------delegate-------------------

/**
 *  返回 menu 第column列有多少行
 */
- (NSInteger)menu:(STLThreeTableView *)menu numberOfRowsInColumn:(NSInteger)column{
    if (column == 0) {
        return self.data_0.count;
    }else if (column == 1){
        return self.data_1.count;
    }else{
        return self.data_2.count;
    }
}

/**
 *  返回 menu 第column列 每行title
 */
- (NSString *)menu:(STLThreeTableView *)menu titleForRowAtIndexPath:(STLIndexPath *)indexPath{
    NSInteger column = indexPath.column;
    if (column == 0) {
        return self.data_0[indexPath.row];
    }else if (column == 1){
        return self.data_1[indexPath.row];
    }else{
        return self.data_2[indexPath.row];
    }
}
/**
 *  返回 menu 有多少列 ，默认1列
 */
- (NSInteger)numberOfColumnsInMenu:(STLThreeTableView *)menu{
    return 3;
}

- (CGFloat)widthInCoulumn:(NSInteger)column{
    if (column == 0) {
        if (self.data_1.count == 0) {
            return [UIScreen mainScreen].bounds.size.width;
        }else{
            NSLog(@"123");
            return [UIScreen mainScreen].bounds.size.width / 3;
        }
    }else if (column == 1){
        if (self.data_2.count == 0) {
            return [UIScreen mainScreen].bounds.size.width / 3 *2;
        }else{
            return [UIScreen mainScreen].bounds.size.width / 3;
        }
    }else{
        if (self.data_2.count == 0) {
            return 0;
        }else{
            return [UIScreen mainScreen].bounds.size.width / 3;
        }
    }
}

- (void)menu:(STLThreeTableView *)menu didSelectRowAtIndexPath:(STLIndexPath *)indexPath{
    if (indexPath.column == 0) {
        for (NSInteger i = 0; i < self.data_0.count; i++) {
            STLThreeTableTestModel *model = self.data_0[i];
            model.isSelect = NO;
        }
        STLThreeTableTestModel *model = self.data_0[indexPath.row];
        model.isSelect = YES;
    }
    
    [self.menu reloadData];
}


@end
