//
//  UIViewController+MXQRCode.h
//  MXQRCodeScanner
//
//  Created by Apple on 16/2/3.
//  Copyright © 2016年 韦纯航. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^MXScannerResultBlock)(NSString *content);

@interface UIViewController (MXQRCode)

/**
 *  打开二维码扫描
 *
 *  @param completion 回调
 */
- (void)showMXScannerWithCompletion:(MXScannerResultBlock)completion;

@end
