//
//  MyWebTestViewController.m
//  shareAnimation
//
//  Created by LiMingXing on 2018/5/25.
//  Copyright © 2018年 李明星. All rights reserved.
//

#import "MyWebTestViewController.h"

@interface MyWebTestViewController ()

@end

@implementation MyWebTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)loaddingInfoGet:(WKWebView *)webView navigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    [super loaddingInfoGet:webView navigationAction:navigationAction decisionHandler:decisionHandler];
    NSLog(@"hahah");
}

@end
