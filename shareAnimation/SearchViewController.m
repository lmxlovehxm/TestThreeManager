//
//  SearchViewController.m
//  shareAnimation
//
//  Created by LiMingXing on 2018/5/23.
//  Copyright © 2018年 李明星. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchResultViewController.h"
#import "AppDelegate.h"

@interface SearchViewController ()
<
    UITableViewDelegate,
    UITableViewDataSource,
    UISearchBarDelegate,
    UISearchControllerDelegate
>

@property (strong, nonatomic) UISearchController *searchVc;
@property (strong, nonatomic) SearchResultViewController *searchResultVc;

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataAry;

@end

@implementation SearchViewController

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.frame = self.view.frame;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

- (NSMutableArray *)dataAry{
    if (!_dataAry) {
        _dataAry = [NSMutableArray new];
        for (NSInteger i = 0; i < 10; i++) {
            NSString *title = [NSString stringWithFormat:@"1%ld", i];
            [_dataAry addObject:title];
        }
    }
    return _dataAry;
}

- (SearchResultViewController *)searchResultVc{
    if (!_searchResultVc) {
        _searchResultVc = [[SearchResultViewController alloc] init];
    }
    return _searchResultVc;
}

- (UISearchController *)searchVc{
    if (!_searchVc) {
        _searchVc = [[UISearchController alloc] initWithSearchResultsController:self.searchResultVc];
        _searchVc.searchResultsUpdater = self.searchResultVc;
        _searchVc.delegate = self;
        _searchVc.searchBar.delegate = self;
//        [_searchVc.searchBar sizeToFit];
        _searchVc.searchBar.placeholder = @"搜索手机号";
        //包着搜索框外层的颜色
//        _searchVc.searchBar.barTintColor = [UIColor whiteColor];//11以下生效
        _searchVc.searchBar.tintColor = [UIColor whiteColor];//11以上生效
        //修改文本框背景色

        //    iOS11之后searchController有了新样式，可以放在导航栏
        if (@available(iOS 11.0, *)) {
            self.navigationItem.searchController = self.searchVc;
            self.navigationItem.hidesSearchBarWhenScrolling = NO;
        } else {
            self.tableView.tableHeaderView = self.searchVc.searchBar;
        }
//#warning 如果进入预编辑状态,searchBar消失(UISearchController套到TabBarController可能会出现这个情况),请添加下边这句话
//        self.definesPresentationContext = YES;
//        self.searchResultVc.nav = self.navigationController;
//        self.searchResultVc.searchBar = self.searchVc.searchBar;
//        self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
//        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
    return _searchVc;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    self.searchVc.searchBar.placeholder = @"请输入手机号搜索";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = self.dataAry[indexPath.row];
    return cell;
}


#pragma mark - UISearchBarDelegate
//- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
//    [searchBar setShowsCancelButton:YES animated:YES];
//    for (id obj in [searchBar subviews]) {
//        if ([obj isKindOfClass:[UIView class]]) {
//            for (id obj2 in [obj subviews]) {
//                if ([obj2 isKindOfClass:[UIButton class]]) {
//                    UIButton *btn = (UIButton *)obj2;
//                    [btn setTitle:@"取消" forState:UIControlStateNormal];
//                }
//            }
//        }
//    }
//    return YES;
//}

//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
//    SearchDetailVC *vc = [[SearchDetailVC alloc]initWithNibName:@"SearchDetailVC" bundle:nil];
//    [self.navigationController pushViewController:vc animated:YES];
//    //    self.searchController.active = NO;
//}

//#pragma mark - UISearchControllerDelegate代理
////测试UISearchController的执行过程
//- (void)willPresentSearchController:(UISearchController *)searchController {
//    NSLog(@"willPresentSearchController");
//    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    [delegate tabbarHidden:YES];
//}
//
- (void)didPresentSearchController:(UISearchController *)searchController {
    NSLog(@"didPresentSearchController");
    self.searchResultVc.dataListArry = self.dataAry;
}
//
//- (void)willDismissSearchController:(UISearchController *)searchController {
//    NSLog(@"willDismissSearchController");
//}
//
//- (void)didDismissSearchController:(UISearchController *)searchController {
//    NSLog(@"didDismissSearchController");
//    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    [delegate tabbarHidden:NO];
//}
//
//- (void)presentSearchController:(UISearchController *)searchController {
//    NSLog(@"presentSearchController");
//}
//


@end
