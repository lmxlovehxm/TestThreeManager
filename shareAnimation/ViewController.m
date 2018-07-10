//
//  ViewController.m
//  shareAnimation
//
//  Created by LiMingXing on 2018/5/7.
//  Copyright © 2018年 李明星. All rights reserved.
//

#import "ViewController.h"
#import "BHBPopView.h"
#import "STLShareManager.h"
#import <SVProgressHUD.h>
#import "MJRefreshTestViewController.h"
#import "RefreshAnimationView.h"
#import "LoginViewController.h"
#import "DDMenuViewController.h"
#import "SearchViewController.h"
#import "MyWebTestViewController.h"



@interface ViewController ()
<
    UITextFieldDelegate
>
@property (strong, nonatomic) IBOutlet UITextField *inputTF;

@property (strong, nonatomic) UIVisualEffectView *views;

@property (strong, nonatomic) RefreshAnimationView *animaitonView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.animaitonView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textInputChange) name:UITextFieldTextDidChangeNotification object:nil];
}
- (IBAction)search:(id)sender {
    SearchViewController *vc = [[SearchViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)maoboliAction:(id)sender {
    [[STLShareManager sharedManager] show];
}

- (IBAction)intoWebDetail:(id)sender {
    NSString *path_404 = [[NSBundle mainBundle] pathForResource:@"404" ofType:@"html"];
    MyWebTestViewController *webVc = [[MyWebTestViewController alloc] initWithURL:[NSURL fileURLWithPath:path_404]];
    [self.navigationController pushViewController:webVc animated:YES];
}

//截屏图片
- (UIImage *)imageWithView:(UIView *)view{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(view.frame.size.width, view.frame.size.height), YES, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (IBAction)valueChange:(id)sender {
    UISlider *lider = sender;
    [self.animaitonView showWithProgress:lider.value];
    if (lider.value == 1) {
        [self.animaitonView starAnimationWithProgress:0.0];
    }else{
        [self.animaitonView stopAnimation];
    }
}

- (IBAction)shareAction:(id)sender {
    [SVProgressHUD showInfoWithStatus:@"heihei"];
}

- (IBAction)mjrefreshAction:(id)sender {
    MJRefreshTestViewController *refreshTest = [[MJRefreshTestViewController alloc] init];
    [self.navigationController pushViewController:refreshTest animated:YES];
}

- (RefreshAnimationView *)animaitonView{
    if (!_animaitonView) {
        _animaitonView = [[RefreshAnimationView alloc] init];
        _animaitonView.frame = CGRectMake(100, 80, 23, 23);
    }
    return _animaitonView;
}
- (IBAction)intoMeuController:(id)sender {
    DDMenuViewController *dd = [[DDMenuViewController alloc] init];
    [self.navigationController pushViewController:dd animated:YES];
}

- (IBAction)intoLoginAction:(id)sender {
    LoginViewController *login = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:login animated:YES];
}

#pragma mark ---------------textinputDelegate-------------------

- (void)textInputChange{
    NSString *pass = self.inputTF.text;
    BOOL ret = [self checkPassIsSimple:pass];
    //
}

- (BOOL)checkPassIsSimple:(NSString *)passWord{
    if (passWord.length < 3) {
        return NO;
    }
    NSMutableArray *ary = [[NSMutableArray alloc] init];
    for (NSInteger i = 0 ; i <passWord.length; i++) {
        NSString *item = [passWord substringWithRange:NSMakeRange(i, 1)];
        [ary addObject:item];
    }
    NSInteger count = 0;
    //以下是ASCII判断
    //先判断正序？
    for (NSInteger i = 1; i < ary.count; i++) {
        NSString *lastItem = ary[i - 1];
        NSString *item = ary[i];
        const char *lastItemValue = [lastItem cStringUsingEncoding:NSASCIIStringEncoding];
        const char *itemValue = [item cStringUsingEncoding:NSASCIIStringEncoding];
        int lastItemValueIN = lastItemValue[0];
        int itemValueIN = itemValue[0];
        if (itemValueIN - lastItemValueIN == 1) {
            count += 1;
        }else{
            count = 0;
        }
    }
    if (count >= 2) {
        NSLog(@"有正序连续问题");
        return YES;
    }else{
        //判断逆序
        for (NSInteger i = 1; i < ary.count; i++) {
            NSString *lastItem = ary[i - 1];
            NSString *item = ary[i];
            const char *lastItemValue = [lastItem cStringUsingEncoding:NSASCIIStringEncoding];
            const char *itemValue = [item cStringUsingEncoding:NSASCIIStringEncoding];
            int lastItemValueIN = lastItemValue[0];
            int itemValueIN = itemValue[0];
            if (lastItemValueIN - itemValueIN == 1) {
                count += 1;
            }else{
                count = 0;
            }
        }
        if (count >= 2) {
            NSLog(@"有逆序连续问题");
            return YES;
        }
    }
    return NO;
}


@end
