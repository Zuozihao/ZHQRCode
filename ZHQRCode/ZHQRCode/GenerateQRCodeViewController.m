//
//  GenerateQRCodeViewController.m
//  ZHQRCode
//
//  Created by 左梓豪 on 16/6/4.
//  Copyright © 2016年 左梓豪. All rights reserved.
//

#import "GenerateQRCodeViewController.h"
#import "ZHGenerateQRCode.h"

@interface GenerateQRCodeViewController ()

@end

@implementation GenerateQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    ZHGenerateQRCode *QRCode = [[ZHGenerateQRCode alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    QRCode.center = self.view.center;
//    QRCode.message = @"ThisIsMyWorld";
    QRCode.barCodeMessage = @"111122223";
    [self.view addSubview:QRCode];
    // Do any additional setup after loading the view.
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

@end
