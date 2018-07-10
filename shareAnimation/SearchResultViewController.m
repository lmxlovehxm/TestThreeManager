
//
//  SearchResultViewController.m
//  shareAnimation
//
//  Created by LiMingXing on 2018/5/24.
//  Copyright © 2018年 李明星. All rights reserved.
//

#import "SearchResultViewController.h"

@interface SearchResultViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *searchList;//满足搜索条件的数组


@end

@implementation SearchResultViewController

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.searchList = [NSMutableArray new];
    self.dataListArry = [NSMutableArray new];
    [self.view addSubview:self.tableView];
    
    self.automaticallyAdjustsScrollViewInsets = NO;//不加的话，table会下移
    self.edgesForExtendedLayout = UIRectEdgeNone;//不加的话，UISearchBar返回后会上移
}

//- (void)viewWillLayoutSubviews{
//    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    [delegate tabbarHidden:YES];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.searchBar resignFirstResponder];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = self.searchList[indexPath.row];
    return cell;
//    if (self.searchList.count > 0) {
//        static NSString *identifier = @"cell";
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//        if (!cell) {
//            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//        }
//        cell.textLabel.text = self.searchList[indexPath.row];
//        cell.textLabel.textColor = [UIColor redColor];
//        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//        return cell;
//    }else{
//        CustomTableViewCell *cell = [[NSBundle mainBundle]loadNibNamed:@"CustomTableViewCell" owner:self options:nil][0];
//        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        return cell;
//    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    SearchDetailVC *vc = [[SearchDetailVC alloc]initWithNibName:@"SearchDetailVC" bundle:nil];
//    [self.nav pushViewController:vc animated:YES];
}

#pragma mark - UISearchResultsUpdating
//每输入一个字符都会执行一次
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSLog(@"搜索关键字：%@",searchController.searchBar.text);
    //    searchController.searchResultsController.view.hidden = NO;
    NSLog(@"%@",_dataListArry);
    if (self.searchList!= nil) {
        [self.searchList removeAllObjects];
    }
    //谓词搜索
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", searchController.searchBar.text];
    //过滤数据
    self.searchList = [NSMutableArray arrayWithArray:[_dataListArry filteredArrayUsingPredicate:preicate]];
//    for (NSInteger i = 0; i < self.dataListArry.count; i++) {
//        NSString *title = self.dataListArry[i];
//        if ([title rangeOfString:searchController.searchBar.text].location != NSNotFound) {
//            [self.searchList addObject:title];
//        }
//    }
    NSLog(@"%@", self.searchList);
    //刷新表格
    [self.tableView reloadData];
}
@end
