//
//  MXQRCode.m
//  MXQRCodeScanner
//
//  Created by Apple on 16/2/2.
//  Copyright © 2016年 韦纯航. All rights reserved.
//

#import "MXQRCode.h"

static NSString *const MXQRCodeFilterName = @"CIQRCodeGenerator";
static NSString *const MXQRCodeInputMessageKey = @"inputMessage";
static NSString *const MXQRCodeInputCorrectionLevelKey = @"inputCorrectionLevel";

@implementation MXQRCode

extern BOOL MXQRCode_NSStringIsNil(NSString *string)
{
    if (!string || ![string isKindOfClass:[NSString class]]) return YES;
    
    NSString *str = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return [str isEqualToString:@""];
}

/**
 *  根据内容创建二维码
 *
 *  @param content    内容（不可为空）
 *  @param targetSize 二维码图片尺寸（正方形）
 *  @param completion 回调
 */
+ (void)builtQRCodeWithContent:(NSString *)content
                    targetSize:(CGFloat)targetSize
                    completion:(MXQRCodeResultBlock)completion
{
    if (MXQRCode_NSStringIsNil(content) || targetSize <= 0.0) {
        if (completion) completion(nil);
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CIImage *outputImage = [self createQRCIImageWithContent:content];
        UIImage *qrCodeImage = [self createUIImageFormCIImage:outputImage targetSize:targetSize];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) completion(qrCodeImage);
        });
    });
}

/**
 *  使用CIFilter根据内容生成原始二维码图片
 *
 *  @param content 内容
 *
 *  @return 原始二维码图片
 */
+ (CIImage *)createQRCIImageWithContent:(NSString *)content
{
    NSData *stringData = [content dataUsingEncoding:NSUTF8StringEncoding];
    CIFilter *filter = [CIFilter filterWithName:MXQRCodeFilterName];
    [filter setValue:stringData forKey:MXQRCodeInputMessageKey];
    [filter setValue:@"H" forKey:MXQRCodeInputCorrectionLevelKey];
    return filter.outputImage;
}

/**
 *  处理原始二维码图片
 *
 *  @param image      原始二维码图片
 *  @param targetSize 最终输出二维码图片的尺寸（正方形）
 *
 *  @return 处理后的二维码图片
 */
+ (UIImage *)createUIImageFormCIImage:(CIImage *)image targetSize:(CGFloat)targetSize
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(targetSize / CGRectGetWidth(extent), targetSize / CGRectGetHeight(extent));
    
    // 创建Bitmap
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(NULL, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 保存Bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    
    return [UIImage imageWithCGImage:scaledImage];
}

@end
