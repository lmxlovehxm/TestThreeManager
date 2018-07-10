//
//  STLWebViewController.h
//  shareAnimation
//
//  Created by LiMingXing on 2018/5/25.
//  Copyright © 2018年 李明星. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface STLWebViewController : UIViewController


- (instancetype)initWithURL:(NSURL *)url;

- (void)didStartLoad;
- (void)didFinishLoad;
- (void)didFailLoadWithError:(NSError *)error;
//网页内部跳转拦截
- (void)loaddingInfoGet:(WKWebView *)webView navigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler;
@end
