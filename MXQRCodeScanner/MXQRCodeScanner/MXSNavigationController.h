//
//  MXSNavigationController.h
//  MXQRCodeScanner
//
//  Created by Apple on 16/2/3.
//  Copyright © 2016年 韦纯航. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MXSNavigationController;

@protocol MXSNavigationControllerDelegate <NSObject>

@optional
- (void)navigationController:(MXSNavigationController *)navigationController
didFinishScanningWithContent:(NSString *)content;

@end

@interface MXSNavigationController : UINavigationController

@property (assign, nonatomic) id <MXSNavigationControllerDelegate> finishedDelegate;

@end
