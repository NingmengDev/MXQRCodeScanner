//
//  MXQRCode.h
//  MXQRCodeScanner
//
//  Created by Apple on 16/2/2.
//  Copyright © 2016年 韦纯航. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^MXQRCodeResultBlock)(UIImage *image);

@interface MXQRCode : NSObject

/**
*  根据内容创建二维码
*
*  @param content    内容（不可为空）
*  @param targetSize 二维码图片尺寸（正方形）
*  @param completion 回调
*/
+ (void)builtQRCodeWithContent:(NSString *)content
                    targetSize:(CGFloat)targetSize
                    completion:(MXQRCodeResultBlock)completion;

@end
