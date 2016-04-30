//
//  MainViewController.m
//  MXQRCodeScanner
//
//  Created by 韦纯航 on 16/4/30.
//  Copyright © 2016年 韦纯航. All rights reserved.
//

#import "MainViewController.h"

#import "MXQRCodeScanner/UIViewController+MXQRCode.h"
#import "MXQRCodeScanner/MXQRCode.h"

@interface MainViewController ()

@property (retain, nonatomic) UIImageView *imageView;

@end

@implementation MainViewController

- (void)loadView {
    [super loadView];
    
    self.imageView = [[UIImageView alloc] init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.layer.borderWidth = 0.5;
    self.imageView.layer.borderColor = [UIColor blackColor].CGColor;
    
    UIButton *firstButton = [self buttonWithTitle:@"生成二维码(MXQRCodeScanner)"];
    [firstButton addTarget:self action:@selector(buildQRCodeEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *secondButton = [self buttonWithTitle:@"扫一扫"];
    [secondButton addTarget:self action:@selector(openMXQRCodeScannerEvent:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:self.imageView];
    [self.view addSubview:firstButton];
    [self.view addSubview:secondButton];
    
    CGFloat offsetX = 20.0;
    CGFloat offsetY = ([UIScreen mainScreen].bounds.size.height > 480.0) ? 20.0 : 10.0;;
    CGFloat buttonHeight = ([UIScreen mainScreen].bounds.size.height > 480.0) ? 60.0 : 44.0;
    
    CGRect rect = CGRectZero;
    rect.origin.x = offsetX;
    rect.origin.y = 20.0 + 64.0;
    rect.size.width = CGRectGetWidth(self.view.bounds) - offsetX * 2;
    rect.size.height = rect.size.width;
    [self.imageView setFrame:rect];
    
    rect.origin.y = CGRectGetMaxY(self.imageView.frame) + offsetY;
    rect.size.height = buttonHeight;
    [firstButton setFrame:rect];
    
    rect.origin.y = CGRectGetMaxY(firstButton.frame) + offsetY;
    [secondButton setFrame:rect];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"MXQRCodeScanner";
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UIButton *)buttonWithTitle:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[UIColor whiteColor]];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button.layer setBorderWidth:0.5];
    [button.layer setBorderColor:[UIColor blackColor].CGColor];
    return button;
}

- (void)openMXQRCodeScannerEvent:(UIButton *)button
{
    [self showMXScannerWithCompletion:^(NSString *content) {
        NSLog(@"content = %@", content);
    }];
}

- (void)buildQRCodeEvent:(UIButton *)button
{
    NSString *content = @"MXQRCodeScanner";
    [MXQRCode builtQRCodeWithContent:content targetSize:CGRectGetWidth(self.imageView.bounds) completion:^(UIImage *image) {
        [self.imageView setImage:image];
    }];
}

@end
