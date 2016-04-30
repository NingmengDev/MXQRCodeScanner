//
//  MXSNavigationController.m
//  MXQRCodeScanner
//
//  Created by Apple on 16/2/3.
//  Copyright © 2016年 韦纯航. All rights reserved.
//

#import "MXSNavigationController.h"

#import "MXScannerController.h"

@interface MXSNavigationController ()

@end

@implementation MXSNavigationController

- (id)init
{
    MXScannerController *scannerController = [[MXScannerController alloc] init];
    return [super initWithRootViewController:scannerController];
}

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    MXScannerController *scannerController = [[MXScannerController alloc] init];
    return [super initWithRootViewController:scannerController];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    self.navigationBar.tintColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleFinishingScanningNotification:) name:MXScannerDidFinishScanningNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait; //进入扫描界面，只能支持一个屏幕方向
}

#pragma mark - NSNotification

- (void)handleFinishingScanningNotification:(NSNotification *)notification
{
    if (self.finishedDelegate && [self.finishedDelegate respondsToSelector:@selector(navigationController:didFinishScanningWithContent:)]) {
        [self.finishedDelegate navigationController:self didFinishScanningWithContent:notification.object];
    }
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    [[NSNotificationCenter defaultCenter] removeObserver:self]; //注销通知
    [super dismissViewControllerAnimated:flag completion:completion];
}

@end
