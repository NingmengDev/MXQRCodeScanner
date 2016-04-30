//
//  MXScannerController.m
//  MXQRCodeScanner
//
//  Created by Apple on 16/2/3.
//  Copyright © 2016年 韦纯航. All rights reserved.
//

#import "MXScannerController.h"

@interface MXScannerController ()

@property (strong, nonatomic) MXQRCodeScanner *scanner;

@end

@implementation MXScannerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"扫一扫";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNavBarButtonItem];
    [self setupMXQRCodeScanner];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.scanner startScanning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.scanner stopScanning];
}

#pragma mark - Item Event

- (void)snav_leftItemEvent:(UIBarButtonItem *)item
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)snav_rightItemEvent:(UIBarButtonItem *)item
{
    [MXQRCodeScanner openOrCloseTorchWithCompletion:^(AVCaptureTorchMode torchMode, NSError *error) {
        if (error == nil) item.title = (torchMode == AVCaptureTorchModeOn) ? @"关灯" : @"开灯";
    }];
}

#pragma mark - Custom Method

- (void)setupNavBarButtonItem
{
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(snav_leftItemEvent:)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    if ([MXQRCodeScanner currentDeviceHasTorch]) {
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"开灯" style:UIBarButtonItemStylePlain target:self action:@selector(snav_rightItemEvent:)];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
}

- (void)setupMXQRCodeScanner
{
    typeof(self) __weak weakSelf = self;
    self.scanner = [[MXQRCodeScanner alloc] initWithTarget:self completion:^(NSString *content, NSError *error) {
        if (error) {
            [weakSelf showScannerErrorAlertWithError:error];
        }
        else {
            [[NSNotificationCenter defaultCenter] postNotificationName:MXScannerDidFinishScanningNotification object:content];
        }
    }];
}

- (void)showScannerErrorAlertWithError:(NSError *)error
{
    if ([UIDevice currentDevice].systemVersion.floatValue < 8.0) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:error.domain delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
        [alertView show];
#pragma clang diagnostic pop
    }
    else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:error.domain preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma mark - dealloc

- (void)dealloc
{
    [MXQRCodeScanner closeTorchWhenDealloc];
    NSLog(@"%@ dealloc.", [[self class] description]);
}

@end
