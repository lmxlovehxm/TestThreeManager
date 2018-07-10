//
//  SearchResultViewController.h
//  shareAnimation
//
//  Created by LiMingXing on 2018/5/24.
//  Copyright © 2018年 李明星. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultViewController : UIViewController<UISearchResultsUpdating>

@property (strong, nonatomic) UINavigationController *nav;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) NSMutableArray *dataListArry;

@end
