//
//  ViewController.m
//  ZHQRCode
//
//  Created by 左梓豪 on 16/6/3.
//  Copyright © 2016年 左梓豪. All rights reserved.
//

#import "ViewController.h"
#import "GenerateQRCodeViewController.h"
#import "ZHQRCodeScanViewController.h"
#import "PicQRCodeViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,ZHQRCodeScanDelegate>

@property(nonatomic,strong)UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"扫码";
            break;
        case 1:
            cell.textLabel.text = @"生成二维码";
            break;
        case 2:
            cell.textLabel.text = @"识别图片中的二维码";
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self performSelectorOnMainThread:@selector(goScan) withObject:nil waitUntilDone:nil];
    } else if (indexPath.row == 1) {
        GenerateQRCodeViewController *vc = [GenerateQRCodeViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 2) {
        PicQRCodeViewController *vc = [PicQRCodeViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)goScan {
    ZHQRCodeScanViewController *vc = [ZHQRCodeScanViewController new];
    vc.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:^{
        
    }];
}

- (void)ZHQRCodeScanDidFinishScan:(NSString *)result {
    self.title = result;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
