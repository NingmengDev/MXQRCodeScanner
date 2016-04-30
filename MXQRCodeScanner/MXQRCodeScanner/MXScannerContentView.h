//
//  MXScannerContentView.h
//  MXQRCodeScanner
//
//  Created by Apple on 16/2/4.
//  Copyright © 2016年 韦纯航. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MXScannerContentView;

@protocol MXScannerContentViewDelegate <NSObject>

@optional
- (void)scannerContentViewShouldShowMyQRCode:(MXScannerContentView *)scannerContentView;

@end

@interface MXScannerContentView : UIView

@property (assign, nonatomic) id <MXScannerContentViewDelegate> delegate;

/**
 *  扫描区域
 */
@property (assign, readonly, nonatomic) CGRect scanRect;

/**
 *  开始扫描动画
 */
- (void)startScannerAnimating;

/**
 *  停止扫描动画
 */
- (void)stopScannerAnimating;

@end
