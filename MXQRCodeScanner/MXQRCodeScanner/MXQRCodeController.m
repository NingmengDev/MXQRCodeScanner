//
//  MXQRCodeController.m
//  MXQRCodeScanner
//
//  Created by Apple on 16/2/4.
//  Copyright © 2016年 韦纯航. All rights reserved.
//

#import "MXQRCodeController.h"

#import "MXQRCode.h"

@interface MXQRCodeController ()

@property (retain, nonatomic) UIImageView *imageView;

@end

@implementation MXQRCodeController

- (void)loadView {
    [super loadView];
    
    CGRect rect = self.view.bounds;
    rect.origin.y = (self.navigationController.navigationBar.translucent) ? 64.0 * 2 : 64.0;
    rect.origin.x = 20.0;
    rect.size.width -= (rect.origin.x * 2);
    rect.size.height = rect.size.width;
    
    self.imageView = [[UIImageView alloc] initWithFrame:rect];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.layer.borderWidth = 1.0;
    self.imageView.layer.borderColor = [UIColor blackColor].CGColor;
    [self.view addSubview:self.imageView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的二维码";
    self.view.backgroundColor = [UIColor whiteColor];
    
    typeof(self) __weak weakSelf = self;
    NSString *content = @"MXQRCodeController";
    [MXQRCode builtQRCodeWithContent:content targetSize:CGRectGetWidth(self.imageView.bounds) completion:^(UIImage *image) {
        [weakSelf.imageView setImage:image];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
