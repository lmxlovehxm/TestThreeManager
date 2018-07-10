//
//  AppDelegate.m
//  shareAnimation
//
//  Created by LiMingXing on 2018/5/7.
//  Copyright © 2018年 李明星. All rights reserved.
//

#import "AppDelegate.h"
#import <SVProgressHUD.h>
#import "SVProgressHUD_Extension.h"
#import <IQKeyboardManager.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self svPreferrenceConf];
    [[IQKeyboardManager  sharedManager] setEnable:YES];
    return YES;
}

- (void)svPreferrenceConf {
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setBackgroundColor:[UIColor clearColor]];
    [SVProgressHUD setMinimumDismissTimeInterval:CGFLOAT_MAX];
    NSMutableArray *imgs = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < 26; i++) {
        NSString *imgTitle = [NSString stringWithFormat:@"%ld", i+1];
        UIImage *img = [UIImage imageNamed:imgTitle];
        [imgs addObject:img];
    }
    UIImage *imgGif = [UIImage animatedImageWithImages:imgs duration:2.6];
    
    [SVProgressHUD setInfoImage:imgGif];
    
    
    UIImageView *svImgView = [[SVProgressHUD sharedView] valueForKey:@"imageView"];
    CGRect imgFrame = svImgView.frame;
    
    // 设置图片的显示大小
    imgFrame.size = CGSizeMake(70, 70);
    svImgView.frame = imgFrame;
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
