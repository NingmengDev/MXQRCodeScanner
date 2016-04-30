//
//  UIViewController+MXQRCode.m
//  MXQRCodeScanner
//
//  Created by Apple on 16/2/3.
//  Copyright © 2016年 韦纯航. All rights reserved.
//

#import "UIViewController+MXQRCode.h"

#import <objc/runtime.h>
#import "MXSNavigationController.h"

@interface UIViewController () <MXSNavigationControllerDelegate>

@property (copy, nonatomic) MXScannerResultBlock scannerResultBlock;

@end

@implementation UIViewController (MXQRCode)

static const void * MXScannerResultBlockKey = &MXScannerResultBlockKey;

#pragma mark - Setter & Getter

- (void)setScannerResultBlock:(MXScannerResultBlock)scannerResultBlock
{
    [self willChangeValueForKey:@"scannerResultBlock"];
    objc_setAssociatedObject(self, MXScannerResultBlockKey, scannerResultBlock, OBJC_ASSOCIATION_COPY);
    [self didChangeValueForKey:@"scannerResultBlock"];
}

- (MXScannerResultBlock)scannerResultBlock
{
    return objc_getAssociatedObject(self, MXScannerResultBlockKey);
}

/**
 *  打开二维码扫描
 *
 *  @param completion 回调
 */
- (void)showMXScannerWithCompletion:(MXScannerResultBlock)completion
{
    self.scannerResultBlock = completion;
    
    MXSNavigationController *nav = [[MXSNavigationController alloc] init];
    [nav setFinishedDelegate:self];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - MXSNavigationControllerDelegate

- (void)navigationController:(MXSNavigationController *)navigationController didFinishScanningWithContent:(NSString *)content
{
    if (self.scannerResultBlock) self.scannerResultBlock(content);
    [navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
