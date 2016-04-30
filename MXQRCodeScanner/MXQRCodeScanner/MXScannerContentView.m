//
//  MXScannerContentView.m
//  MXQRCodeScanner
//
//  Created by Apple on 16/2/4.
//  Copyright © 2016年 韦纯航. All rights reserved.
//

#import "MXScannerContentView.h"

#define MXBundle_Image(name) ([UIImage imageNamed:[@"MXQRCodeScanner.bundle" stringByAppendingPathComponent:name]])

@interface MXScannerContentView ()

@property (retain, nonatomic) UIView *scannerArea;
@property (retain, nonatomic) UIImageView *scannerLine;

@property (assign, nonatomic) CGRect scanRect;

@end

@implementation MXScannerContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        CGRect scanRect = self.bounds;
        scanRect.origin.x = 44.0;
        scanRect.origin.y = 64.0 * 2;
        scanRect.size.width = CGRectGetWidth(self.bounds) - (scanRect.origin.x * 2);
        scanRect.size.height = CGRectGetWidth(scanRect);
        self.scanRect = scanRect;
        
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews
{
    self.scannerArea = [[UIView alloc] initWithFrame:self.scanRect];
    self.scannerArea.backgroundColor = [UIColor clearColor];
    [self addSubview:self.scannerArea];
    
    UIImage *image = MXBundle_Image(@"mx_sc_line.png");
    UIEdgeInsets insets = UIEdgeInsetsZero;
    insets.left = image.size.width / 2 - 2.5;
    insets.right = insets.left;
    image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeTile];
    
    CGRect rect = self.scannerArea.bounds;
    rect.size.height = image.size.height;
    self.scannerLine = [[UIImageView alloc] initWithFrame:rect];
    self.scannerLine.image = image;
    [self.scannerArea addSubview:self.scannerLine];
    
    image = MXBundle_Image(@"mx_sc_tl.png");
    UIImageView *tl = [[UIImageView alloc] initWithImage:image];
    [self.scannerArea addSubview:tl];
    
    image = MXBundle_Image(@"mx_sc_tr.png");
    UIImageView *tr = [[UIImageView alloc] initWithImage:image];
    rect = tl.bounds;
    rect.origin.x = CGRectGetWidth(self.scannerArea.bounds) - rect.size.width;
    [tr setFrame:rect];
    [self.scannerArea addSubview:tr];
    
    image = MXBundle_Image(@"mx_sc_bl.png");
    UIImageView *bl = [[UIImageView alloc] initWithImage:image];
    rect = bl.bounds;
    rect.origin.y = CGRectGetHeight(self.scannerArea.bounds) - rect.size.height;
    [bl setFrame:rect];
    [self.scannerArea addSubview:bl];
    
    image = MXBundle_Image(@"mx_sc_br.png");
    UIImageView *br = [[UIImageView alloc] initWithImage:image];
    rect = br.bounds;
    rect.origin.x = CGRectGetWidth(self.scannerArea.bounds) - rect.size.width;
    rect.origin.y = CGRectGetHeight(self.scannerArea.bounds) - rect.size.height;
    [br setFrame:rect];
    [self.scannerArea addSubview:br];
    
    UILabel *remindLabel = [[UILabel alloc] init];
    remindLabel.text = @"将二维码放入框中，即可自动扫描";
    remindLabel.font = [UIFont systemFontOfSize:13.0];
    remindLabel.textColor = [UIColor whiteColor];
    remindLabel.textAlignment = NSTextAlignmentCenter;
    [remindLabel sizeToFit];
    [remindLabel setCenter:(CGPoint){self.scannerArea.center.x, CGRectGetMaxY(self.scannerArea.frame) + 30.0}];
    [self addSubview:remindLabel];
    
    UIButton *myQRCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [myQRCodeButton.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
    [myQRCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [myQRCodeButton setTitle:@"我的二维码" forState:UIControlStateNormal];
    [myQRCodeButton addTarget:self action:@selector(myQRCodeButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [myQRCodeButton sizeToFit];
    [myQRCodeButton setCenter:(CGPoint){self.scannerArea.center.x, CGRectGetMaxY(remindLabel.frame) + 30.0}];
    [self addSubview:myQRCodeButton];
}

- (void)drawRect:(CGRect)rect
{
    if (CGRectEqualToRect(self.scanRect, CGRectZero)) return;
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [[UIColor colorWithWhite:0.0 alpha:0.4] setFill];
    CGContextFillRect(ctx, rect);
    
    CGContextClearRect(ctx, self.scanRect);
    [[UIColor colorWithWhite:0.95 alpha:1.0] setStroke];
    CGContextStrokeRectWithWidth(ctx, CGRectInset(self.scanRect, 1.0, 1.0), 1.0);
}

- (void)myQRCodeButtonEvent:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(scannerContentViewShouldShowMyQRCode:)]) {
        [self.delegate scannerContentViewShouldShowMyQRCode:self];
    }
}

/**
 *  开始扫描动画
 */
- (void)startScannerAnimating
{
    [UIView beginAnimations:@"com.mx.ScannerAnimating" context:NULL];
    [UIView setAnimationDuration:3.0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationRepeatCount:MAXFLOAT];
    
    CGRect rect = self.scannerLine.bounds;
    rect.origin.y = CGRectGetHeight(self.scannerArea.bounds) - CGRectGetHeight(rect);
    [self.scannerLine setFrame:rect];
    
    [UIView commitAnimations];
}

/**
 *  停止扫描动画
 */
- (void)stopScannerAnimating
{
    [self.scannerLine.layer removeAllAnimations];
    [self.scannerLine setFrame:self.scannerLine.bounds];
}

@end
