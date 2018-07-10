//
//  MJRefreshTestViewController.m
//  shareAnimation
//
//  Created by LiMingXing on 2018/5/9.
//  Copyright © 2018年 李明星. All rights reserved.
//

#import "MJRefreshTestViewController.h"
#import "RefreshAnimationView.h"
#import <MJRefreshNormalHeader.h>
#import "STLAnimationHeader.h"
#import <MJRefresh.h>
#import "STLAnimationFooter.h"

@interface MJRefreshTestViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *data;
@property (strong, nonatomic) RefreshAnimationView *animationView;
@property (assign, nonatomic) float progress;

@property (strong, nonatomic) STLAnimationHeader *header;
@property (strong, nonatomic) STLAnimationFooter *footer;


@property (strong, nonatomic) MJRefreshNormalHeader *stateHeader;



@end

@implementation MJRefreshTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.tableView];
    self.animationView = [[RefreshAnimationView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.animationView.center =CGPointMake([UIScreen mainScreen].bounds.size.width /2, [UIScreen mainScreen].bounds.size.height /2);    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id"];
    NSString *title = self.data[indexPath.row];
    cell.textLabel.text = title;
    return cell;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 50;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"id"];
//        _tableView.mj_header = self.header;
        _tableView.mj_header = self.header;
        _tableView.mj_footer = self.footer;
//        _tableView.mj_header = self.stateHeader;
        _tableView.bounces = YES;
    }
    return _tableView;
}

- (NSMutableArray *)data{
    if (!_data) {
        _data = [NSMutableArray new];
        for (NSInteger i = 0; i < 10; i++) {
            NSString *str = [NSString stringWithFormat:@"%ld", i];
            [_data addObject:str];
        }
    }
    return _data;
}

- (STLAnimationFooter *)footer{
    if (!_footer) {
        _footer = [STLAnimationFooter footerWithRefreshingBlock:^{
            [self performSelector:@selector(stopRefresh) withObject:nil afterDelay:5];
        }];
    }
    return _footer;
}


- (void)stopRefresh{
    [self.header endRefreshing];
    [self.footer endRefreshing];
}


- (MJRefreshNormalHeader *)stateHeader{
    if (!_stateHeader) {
        _stateHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            NSLog(@"123");
            [self performSelector:@selector(stopRefresh) withObject:nil afterDelay:5];
        }];
    }
    return _stateHeader;
}

- (STLAnimationHeader *)header{
    if (!_header) {
        _header= [STLAnimationHeader headerWithRefreshingBlock:^{
            [self performSelector:@selector(stopRefresh) withObject:nil afterDelay:5];
        }];
    }
    return _header;
}

@end
