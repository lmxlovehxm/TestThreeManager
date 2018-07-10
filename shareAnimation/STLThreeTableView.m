//
//  STLThreeTableView.m
//  shareAnimation
//
//  Created by LiMingXing on 2018/5/21.
//  Copyright © 2018年 李明星. All rights reserved.
//

#import "STLThreeTableView.h"

@implementation STLIndexPath

- (instancetype)initWithColumn:(NSInteger)column row:(NSInteger)row {
    self = [super init];
    if (self) {
        _column = column;
        _row = row;
        _item = -1;
    }
    return self;
}

- (instancetype)initWithColumn:(NSInteger)column row:(NSInteger)row tem:(NSInteger)item {
    self = [self initWithColumn:column row:row];
    if (self) {
        _item = item;
    }
    return self;
}

+ (instancetype)indexPathWithCol:(NSInteger)col row:(NSInteger)row {
    STLIndexPath *indexPath = [[self alloc] initWithColumn:col row:row];
    return indexPath;
}

+ (instancetype)indexPathWithCol:(NSInteger)col row:(NSInteger)row item:(NSInteger)item
{
    return [[self alloc]initWithColumn:col row:row tem:item];
}

@end

@interface STLThreeTableView()

@property (strong, nonatomic) UITableView *firstTableView;
@property (strong, nonatomic) UITableView *secondTableView;
@property (strong, nonatomic) UITableView *thirdTableView;

@end

NSString *const firstID = @"firstCellID";
NSString *const secondID = @"secondCellID";
NSString *const thirdID = @"thirdCellID";

@implementation STLThreeTableView

#pragma mark ---------------懒加载-------------------

- (UITableView *)firstTableView{
    if (!_firstTableView) {
        _firstTableView = [[UITableView alloc] init];
        _firstTableView.delegate = self;
        _firstTableView.dataSource = self;
        [_firstTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:firstID];
    }
    return _firstTableView;
}

- (UITableView *)secondTableView{
    if (!_secondTableView) {
        _secondTableView = [[UITableView alloc] init];
        _secondTableView.delegate = self;
        _secondTableView.dataSource = self;
        [_secondTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:secondID];
    }
    return _secondTableView;
}

- (UITableView *)thirdTableView{
    if (!_thirdTableView) {
        _thirdTableView = [[UITableView alloc] init];
        _thirdTableView.delegate = self;
        _thirdTableView.dataSource = self;
        [_thirdTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:thirdID];
    }
    return _thirdTableView;
}


#pragma mark ---------------初始化-------------------


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.firstTableView];
        [self addSubview:self.secondTableView];
        [self addSubview:self.thirdTableView];
        [self setUI];
    }
    return self;
}

#pragma mark ---------------界面-------------------

- (void)setUI{
    CGFloat height = self.frame.size.height;
    CGFloat firstWidth = [self.dataSource widthInCoulumn:0];
    CGFloat secondWidth = [self.dataSource widthInCoulumn:1];
    CGFloat thirdWidth = [self.dataSource widthInCoulumn:2];
    NSLog(@"%lf-%lf-%lf-%lf", height, firstWidth, secondWidth, thirdWidth);
    self.firstTableView.frame = CGRectMake(0, 0, firstWidth, height);
    self.secondTableView.frame = CGRectMake(firstWidth, 0, secondWidth, height);
    self.thirdTableView.frame = CGRectMake(firstWidth + secondWidth, 0, thirdWidth, height);
    self.firstTableView.backgroundColor = [UIColor redColor];
    self.secondTableView.backgroundColor = [UIColor blueColor];
    self.thirdTableView.backgroundColor = [UIColor orangeColor];
}


#pragma mark ---------------dataSource-------------------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.firstTableView) {
        return [self.dataSource menu:self numberOfRowsInColumn:0];
    }else if (tableView == self.secondTableView){
        return [self.dataSource menu:self numberOfRowsInColumn:1];
    }else{
        return [self.dataSource menu:self numberOfRowsInColumn:2];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.firstTableView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:firstID];
        if (cell.contentView.subviews.count  <= 1) {
            UIView *indicatiorView= [[UIView alloc] init];
            indicatiorView.backgroundColor = [UIColor colorWithRed:251/255.f green:87/255.f blue:64/255.f alpha:1];
            [cell.contentView addSubview:indicatiorView];
            indicatiorView.frame = CGRectMake(0, 12.5, 5, 25);
            UILabel *titleLB = [[UILabel alloc] init];
            titleLB.font = [UIFont systemFontOfSize:14];
            titleLB.numberOfLines = 2;
            titleLB.textColor = [UIColor blackColor];
            [cell.contentView addSubview:titleLB];
            titleLB.frame = CGRectMake(15, 10, cell.contentView.frame.size.width - 30, 30);
        }
        STLIndexPath *stlIndexpath = [STLIndexPath indexPathWithCol:0 row:indexPath.row];
        STLThreeTableTestModel *model = [self.dataSource menu:self titleForRowAtIndexPath:stlIndexpath];
        UILabel *titleLB = cell.contentView.subviews[1];
        titleLB.text = model.title;
        UIView *indicatorView = cell.contentView.subviews.firstObject;
        
        if (!model.isSelect) {
            indicatorView.hidden = YES;
        }else{
            indicatorView.hidden = NO;
        }
        
        return cell;
    }else if (tableView == self.secondTableView){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:secondID];
        if (cell.contentView.subviews.count == 0) {
            UILabel *titleLB = [[UILabel alloc] init];
            titleLB.font = [UIFont systemFontOfSize:14];
            titleLB.textColor = [UIColor blackColor];
            titleLB.numberOfLines = 2;
            [cell.contentView addSubview:titleLB];
            titleLB.frame = CGRectMake(15, 10, cell.contentView.frame.size.width - 30, 30);
        }
        STLIndexPath *stlIndexpath = [STLIndexPath indexPathWithCol:1 row:indexPath.row];
        STLThreeTableTestModel *model = [self.dataSource menu:self titleForRowAtIndexPath:stlIndexpath];
        UILabel *titleLB = cell.contentView.subviews[0];
        titleLB.text = model.title;
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:thirdID];
        if (cell.contentView.subviews.count == 0) {
            UILabel *titleLB = [[UILabel alloc] init];
            titleLB.font = [UIFont systemFontOfSize:14];
            titleLB.numberOfLines = 2;
            titleLB.textColor = [UIColor blackColor];

            [cell.contentView addSubview:titleLB];
            titleLB.frame = CGRectMake(15, 10, cell.contentView.frame.size.width - 30, 30);
        }
        STLIndexPath *stlIndexpath = [STLIndexPath indexPathWithCol:1 row:indexPath.row];
        STLThreeTableTestModel *model = [self.dataSource menu:self titleForRowAtIndexPath:stlIndexpath];
        UILabel *titleLB = cell.contentView.subviews[0];
        titleLB.text = model.title;
        return cell;
    }
}

#pragma mark ---------------tableSelect-------------------

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{    
    STLIndexPath *stlIndexpath;
    if (tableView == self.firstTableView) {
        stlIndexpath = [STLIndexPath indexPathWithCol:0 row:indexPath.row];
    }else if (tableView == self.secondTableView){
        stlIndexpath = [STLIndexPath indexPathWithCol:1 row:indexPath.row];
    }else{
        stlIndexpath = [STLIndexPath indexPathWithCol:2 row:indexPath.row];
    }
    [self.delegate menu:self didSelectRowAtIndexPath:stlIndexpath];
}


- (void)reloadData{
    [self setUI];
    [self.firstTableView reloadData];
    [self.secondTableView reloadData];
    [self.thirdTableView reloadData];
}

@end
