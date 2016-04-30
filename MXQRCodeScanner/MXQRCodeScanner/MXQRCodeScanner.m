//
//  MXQRCodeScanner.m
//  MXQRCodeScanner
//
//  Created by Apple on 16/2/4.
//  Copyright © 2016年 韦纯航. All rights reserved.
//

#import "MXQRCodeScanner.h"

#import "MXScannerContentView.h"
#import "MXQRCodeController.h"

static const NSInteger AVCaptureTorchModeError = -1;
static const NSInteger MXQRCodeScannerCommonErrorCode = -4000;
NSString *const MXScannerDidFinishScanningNotification = @"MXScannerDidFinishScanning";

@interface MXQRCodeScanner () <AVCaptureMetadataOutputObjectsDelegate, MXScannerContentViewDelegate>

@property (weak, nonatomic) UIViewController *target;
@property (retain, nonatomic) MXScannerContentView *scannerContentView;

@property (strong, nonatomic) AVCaptureSession *session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;

@property (copy, nonatomic) MXQRCodeScannerResultBlock completion;

@end

@implementation MXQRCodeScanner

/**
 *  检测设备是否具有闪光灯
 *
 *  @return 检测结果
 */
+ (BOOL)currentDeviceHasTorch
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    return device.hasTorch && device.isTorchAvailable;
}

/**
 *  打开或关闭闪光灯
 *
 *  @param completion  回调
 */
+ (void)openOrCloseTorchWithCompletion:(MXQRCodeScannerTorchBlock)completion;
{
    NSError *error;
    if (![self currentDeviceHasTorch]) {
        error = [NSError errorWithDomain:@"设备不支持闪光灯" code:MXQRCodeScannerCommonErrorCode userInfo:nil];
        if (completion) completion(AVCaptureTorchModeError, error);
        return;
    }
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device lockForConfiguration:&error]) {
        AVCaptureTorchMode torchModeTo = (device.torchMode == AVCaptureTorchModeOff) ? AVCaptureTorchModeOn : AVCaptureTorchModeOff;
        device.torchMode = torchModeTo;
        [device unlockForConfiguration];
        if (completion) completion(device.torchMode, error);
    }
    else {
        error = [NSError errorWithDomain:error.localizedDescription code:error.code userInfo:nil];
        if (completion) completion(AVCaptureTorchModeError, error);
    }
}

/**
 *  当扫描界面退出后要关闭闪光灯
 */
+ (void)closeTorchWhenDealloc
{
    if (![self currentDeviceHasTorch]) return;
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device.torchMode == AVCaptureTorchModeOff) return;
    
    if ([device lockForConfiguration:nil]) {
        device.torchMode = AVCaptureTorchModeOff;
        [device unlockForConfiguration];
    }
}

/**
 *  初始化描界器
 *
 *  @param target     扫描界面所在的UIViewController
 *  @param completion 回调
 */
- (id)initWithTarget:(UIViewController *)target completion:(MXQRCodeScannerResultBlock)completion
{
    NSAssert(target.view, @"targetView can not be nil.");
    
    self = [[MXQRCodeScanner alloc] init];
    if (self) {
        self.target = target;
        self.completion = completion;
        
        [self setupScanner];
    }
    return self;
}

/**
 *  开始扫描
 */
- (void)startScanning
{
    if (self.session == nil || [self.session isRunning]) return;
    
    [self.session startRunning];
    [self.scannerContentView startScannerAnimating];
}

/**
 *  结束扫描
 */
- (void)stopScanning
{
    if (self.session == nil || ![self.session isRunning]) return;
    
    [self.session stopRunning];
    [self.scannerContentView stopScannerAnimating];
}

#pragma mark - Setter & Getter

- (MXScannerContentView *)scannerContentView
{
    if (_scannerContentView == nil) {
        _scannerContentView = [[MXScannerContentView alloc] initWithFrame:self.target.view.bounds];
        _scannerContentView.delegate = self;
    }
    return _scannerContentView;
}

#pragma mark - Private

- (void)setupScanner
{
    NSError *error;
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (error) {
        error = [NSError errorWithDomain:error.localizedDescription code:error.code userInfo:nil];
        if (self.completion) self.completion(nil, error);
        return;
    }
    
    self.session = [[AVCaptureSession alloc] init];
    AVCaptureMetadataOutput *dataOutput = [[AVCaptureMetadataOutput alloc] init];
    
    if (![self.session canAddInput:videoInput]) {
        error = [NSError errorWithDomain:@"无法添加输入设备" code:MXQRCodeScannerCommonErrorCode userInfo:nil];
        if (self.completion) self.completion(nil, error);
        return;
    }
    
    if (![self.session canAddOutput:dataOutput]) {
        error = [NSError errorWithDomain:@"无法添加输出设备" code:MXQRCodeScannerCommonErrorCode userInfo:nil];
        if (self.completion) self.completion(nil, error);
        return;
    }
    
    [self.session addInput:videoInput];
    [self.session addOutput:dataOutput];
    
    dataOutput.metadataObjectTypes = dataOutput.availableMetadataObjectTypes;
    [dataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.previewLayer.frame = self.target.view.bounds;
    [self.target.view.layer insertSublayer:self.previewLayer atIndex:0];
    [self.target.view addSubview:self.scannerContentView];
}

#pragma mark - MXScannerContentViewDelegate

- (void)scannerContentViewShouldShowMyQRCode:(MXScannerContentView *)scannerContentView
{
    MXQRCodeController *qrCodeController = [[MXQRCodeController alloc] init];
    [self.target.navigationController pushViewController:qrCodeController animated:YES];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    for (id obj in metadataObjects) {
        
        // 判断检测到的对象类型
        if (![obj isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) return;
        
        // 转换对象坐标
        AVMetadataMachineReadableCodeObject *dataObject = (AVMetadataMachineReadableCodeObject *)[self.previewLayer transformedMetadataObjectForMetadataObject:obj];
        
        // 判断扫描范围
        if (!CGRectContainsRect(self.scannerContentView.scanRect, dataObject.bounds)) continue;
        
        // 扫描完成，停止扫描
        [self stopScanning];
        
        // 回调扫描结果
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.completion) self.completion(dataObject.stringValue, nil);
        });
    }
}

@end
