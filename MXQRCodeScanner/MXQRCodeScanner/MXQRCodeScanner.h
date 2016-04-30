//
//  MXQRCodeScanner.h
//  MXQRCodeScanner
//
//  Created by Apple on 16/2/4.
//  Copyright © 2016年 韦纯航. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

typedef void (^MXQRCodeScannerTorchBlock)(AVCaptureTorchMode torchMode, NSError *error);
typedef void (^MXQRCodeScannerResultBlock)(NSString *content, NSError *error);
FOUNDATION_EXTERN NSString *const MXScannerDidFinishScanningNotification;

@interface MXQRCodeScanner : NSObject

/**
 *  检测设备是否具有闪光灯
 *
 *  @return 检测结果
 */
+ (BOOL)currentDeviceHasTorch;

/**
 *  打开或关闭闪光灯
 *
 *  @param completion  回调
 */
+ (void)openOrCloseTorchWithCompletion:(MXQRCodeScannerTorchBlock)completion;

/**
 *  当扫描界面退出后要关闭闪光灯
 */
+ (void)closeTorchWhenDealloc;

/**
 *  初始化描界器
 *
 *  @param target     扫描界面所在的UIViewController
 *  @param completion 回调
 */
- (id)initWithTarget:(UIViewController *)target completion:(MXQRCodeScannerResultBlock)completion;

/**
 *  开始扫描
 */
- (void)startScanning;

/**
 *  结束扫描
 */
- (void)stopScanning;

@end
