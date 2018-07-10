//
//  STLWebViewController.m
//  shareAnimation
//
//  Created by LiMingXing on 2018/5/25.
//  Copyright © 2018年 李明星. All rights reserved.
//

#import "STLWebViewController.h"
#import <WebKit/WebKit.h>
/**
 *  需求：添加进度条
        二级界面添加关闭按钮
        获取导航栏标题自动变化
 */

@interface STLWebViewController ()
<
    WKNavigationDelegate,
    WKUIDelegate
>


@property (strong, nonatomic) WKWebView *wkWebView;//web视图
@property (strong, nonatomic) UIProgressView *progressView;//进度条
@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic) UIBarButtonItem *navigationBackBarButtonItem;
@property (strong, nonatomic) UIBarButtonItem *navigationCloseBarButtonItem;

@end

#define SCROLLCONTENTOFFSETCHANGEINFO @"scrollView.contentOffset"
#define WEBVIEWTITLECHANGEINFO @"title"
#define PROGRESSCHANGEINFO @"estimatedProgress"
#define BACKGROUNDCOLORCHANGEINFO @""

@implementation STLWebViewController

#pragma mark ---------------懒加载-------------------


- (WKWebView *)wkWebView{
    if (!_wkWebView) {
        
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.preferences.minimumFontSize = 9;
        if ([config respondsToSelector:@selector(setAllowsInlineMediaPlayback:)]) {
            [config setAllowsInlineMediaPlayback:YES];
        }
        
        _wkWebView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
        _wkWebView.allowsBackForwardNavigationGestures = YES;
        _wkWebView.backgroundColor = [UIColor clearColor];
        _wkWebView.scrollView.backgroundColor = [UIColor clearColor];
        _wkWebView.translatesAutoresizingMaskIntoConstraints = NO;
        _wkWebView.navigationDelegate = self;
        _wkWebView.UIDelegate = self;
    }
    return _wkWebView;
}

- (UIProgressView *)progressView{
    if (!_progressView) {
        CGFloat progressBarHeight = 2.0f;
        CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
        CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
        _progressView = [[UIProgressView alloc] initWithFrame:barFrame];
        _progressView.trackTintColor = [UIColor clearColor];
        _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        _progressView.progressTintColor = [UIColor redColor];
    }
    return _progressView;
}

- (UIBarButtonItem *)navigationBackBarButtonItem {
    if (_navigationBackBarButtonItem) return _navigationBackBarButtonItem;
    UIButton *leftBtn= [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 30)];
//    [leftBtn setImage:[[UIImage imageNamed:@"classify6"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [leftBtn setTitle:@"返回" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(navigationItemHandleBack:) forControlEvents:UIControlEventTouchUpInside];
    _navigationBackBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    return _navigationBackBarButtonItem;
}

- (UIBarButtonItem *)navigationCloseBarButtonItem {
    if (_navigationCloseBarButtonItem) return _navigationCloseBarButtonItem;
    UIButton * exitBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [exitBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [exitBtn setTitleColor:[UIColor colorWithRed:30 / 255.f green:30 / 255.f blue:30 / 255.f alpha:1] forState:UIControlStateNormal];
    exitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [exitBtn addTarget:self action:@selector(navigationIemHandleClose:) forControlEvents:UIControlEventTouchUpInside];
    _navigationCloseBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:exitBtn];
    return _navigationCloseBarButtonItem;
}


#pragma mark ---------------生命周期-------------------

- (instancetype)initWithURL:(NSURL *)url{
    self = [super init];
    if (self) {
        _url = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.wkWebView addObserver:self forKeyPath:SCROLLCONTENTOFFSETCHANGEINFO options:NSKeyValueObservingOptionNew context:NULL];
    [self.wkWebView addObserver:self forKeyPath:WEBVIEWTITLECHANGEINFO options:NSKeyValueObservingOptionNew context:NULL];
    [self.wkWebView addObserver:self forKeyPath:PROGRESSCHANGEINFO options:NSKeyValueObservingOptionNew context:NULL];
    [self setUI];
    if (self.url) {
        [self.wkWebView loadRequest:[NSURLRequest requestWithURL:self.url]];
    }
}

- (void)dealloc{
    [self.wkWebView stopLoading];
    self.wkWebView.UIDelegate = nil;
    self.wkWebView.navigationDelegate = nil;
    [self.wkWebView removeObserver:self forKeyPath:PROGRESSCHANGEINFO];
    [self.wkWebView removeObserver:self forKeyPath:SCROLLCONTENTOFFSETCHANGEINFO];
    [self.wkWebView removeObserver:self forKeyPath:WEBVIEWTITLECHANGEINFO];
}

#pragma mark ---------------KVO-------------------

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:PROGRESSCHANGEINFO]) {
        //进度变化
        if (self.navigationController && self.progressView.superview != self.navigationController.navigationBar) {
            NSLog(@"进度条加上去");
            [self updateFrameOfProgressView];
            [self.navigationController.navigationBar addSubview:self.progressView];//防止重复添加进度条
        }
        //更新进度
        float progress = [[change objectForKey:NSKeyValueChangeNewKey] floatValue];
        NSLog(@"%f", progress);
        if (progress >= _progressView.progress) {
            [_progressView setProgress:progress animated:YES];
        } else {
            [_progressView setProgress:progress animated:NO];
        }
        if (_progressView.progress == 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.progressView removeFromSuperview];
            });
        }
    }else if ([keyPath isEqualToString:WEBVIEWTITLECHANGEINFO]){
        //标题变化
        [self updateControllerTitle];
        [self updateNavigationItems];
    }else if ([keyPath isEqualToString:SCROLLCONTENTOFFSETCHANGEINFO]){
        //偏移变化
//        CGPoint contentOffset = [change[NSKeyValueChangeNewKey] CGPointValue];
    }
}

#pragma mark ---------------界面-------------------

- (void)setUI{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.wkWebView];
    [self updateNavigationItems];
}

//更新界面标题
- (void)updateControllerTitle{
    NSString *title = self.title;
    title = title.length >0 ?title:[self.wkWebView title];//防止自定义title被覆盖
    if (title.length > 10) {
        title = [[title substringToIndex:9] stringByAppendingString:@"..."];//超过10个字符修改为。。。
    }
    self.navigationItem.title = title.length>0 ?title:@"加载中";
}
//更新加载进度条位置
- (void)updateFrameOfProgressView {
    CGFloat progressBarHeight = 2.0f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    self.progressView.frame = barFrame;
}
//更新导航栏按钮
- (void)updateNavigationItems {
    [self.navigationItem setHidesBackButton:YES];
    UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceButtonItem.width = -6.5;
    
    [self.navigationItem setLeftBarButtonItems:nil animated:NO];
    if (self.wkWebView.canGoBack/* || self.webView.backForwardList.backItem*/) {// Web view can go back means a lot requests exist.
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        [self.navigationItem setLeftBarButtonItems:@[spaceButtonItem, self.navigationBackBarButtonItem, self.navigationCloseBarButtonItem] animated:NO];
    } else {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        [self.navigationItem setLeftBarButtonItems:@[spaceButtonItem, self.navigationBackBarButtonItem] animated:NO];
    }
}

#pragma mark ---------------导航栏按钮点击事件-------------------

- (void)navigationItemHandleBack:(UIBarButtonItem *)sender {
    if ([self.wkWebView canGoBack]) {
        [self.wkWebView goBack];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navigationIemHandleClose:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark ---------------加载网页-------------------

- (void)loadURL:(NSURL *)url{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.timeoutInterval = 10;
    request.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    [self.wkWebView loadRequest:request];
}


#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    [self loaddingInfoGet:webView navigationAction:navigationAction decisionHandler:decisionHandler];
    // URL actions for 404 and Errors:
    if ([navigationAction.request.URL.absoluteString isEqualToString:@"ax_404_not_found"] || [navigationAction.request.URL.absoluteString isEqualToString:@"ax_network_error"]) {
        [self loadURL:self.url];
    }
    [self updateControllerTitle];
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    [self updateControllerTitle];
    [self didStartLoad];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    [self updateControllerTitle];
    [self didFinishLoad];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    [self updateControllerTitle];
    NSLog(@"加载失败：%@",error);
    if (error.code == NSURLErrorCancelled) {
        [webView reloadFromOrigin];
        return;
    }
    [self didFailLoadWithError:error];
}


#pragma mark ---------------加载回调处理-------------------
//重写加载拦截
- (void)loaddingInfoGet:(WKWebView *)webView navigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    //默认直接允许一切
    NSLog(@"加载中");
    decisionHandler(WKNavigationActionPolicyAllow);
}
//开始加载
- (void)didStartLoad{
    NSLog(@"加载开始");
    [self updateNavigationItems];
}
//结束加载
- (void)didFinishLoad{
    NSLog(@"加载结束");
    [self.progressView setProgress:1 animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.progressView removeFromSuperview];
        [self.progressView setProgress:0.0];
    });
    [self updateNavigationItems];
}
//加载失败
- (void)didFailLoadWithError:(NSError *)error{
    NSLog(@"加载失败");
    if (error.code == NSURLErrorCannotFindHost) {// 404
        NSString *path_404 = [[NSBundle mainBundle] pathForResource:@"404" ofType:@"html"];
        [self loadURL:[NSURL fileURLWithPath:path_404]];
    } else {
        NSString *path_neterror = [[NSBundle mainBundle] pathForResource:@"neterror" ofType:@"html"];
        [self loadURL:[NSURL fileURLWithPath:path_neterror]];
    }
    // #endif
    self.navigationItem.title = @"load failed";
    [self.progressView setProgress:1 animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.progressView removeFromSuperview];
        [self.progressView setProgress:0.0];
    });
    [self updateNavigationItems];
}

@end
