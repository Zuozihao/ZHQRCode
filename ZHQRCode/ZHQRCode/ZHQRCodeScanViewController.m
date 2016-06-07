//
//  ZHQRCodeScanViewController.m
//  ZHQRCode
//
//  Created by 左梓豪 on 16/6/3.
//  Copyright © 2016年 左梓豪. All rights reserved.
//

#import "ZHQRCodeScanViewController.h"
#import <AVFoundation/AVFoundation.h>

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHigh  [UIScreen mainScreen].bounds.size.height

static const char *kScanQRCodeQueueName = "ScanQRCodeQueue";

@interface ZHQRCodeScanViewController ()<AVCaptureMetadataOutputObjectsDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic) AVCaptureSession *captureSession;
@property (nonatomic) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic) BOOL lastResult;

@end

@implementation ZHQRCodeScanViewController
{
    CALayer *scanLayer;
    UIView *boxView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor orangeColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismissController)];
    _lastResult = [self startReading];
    
    // Do any additional setup after loading the view.
}

- (BOOL)startReading {
    // 获取 AVCaptureDevice 实例
    NSError *error;
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //初始化输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    //创建会话
    _captureSession = [[AVCaptureSession alloc] init];
    //添加输入流
    [_captureSession addInput:input];
    //初始化输出流
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [captureMetadataOutput setRectOfInterest:CGRectMake((124)/ScreenHigh,((ScreenWidth-220)/2)/ScreenWidth,220/ScreenHigh,220/ScreenWidth)];
    // 添加输出流
    [_captureSession addOutput:captureMetadataOutput];
    // 创建dispatch queue.
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create(kScanQRCodeQueueName, NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    // 设置元数据类型 AVMetadataObjectTypeQRCode
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    captureMetadataOutput.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeInterleaved2of5Code,AVMetadataObjectTypeITF14Code,AVMetadataObjectTypeDataMatrixCode,AVMetadataObjectTypeUPCECode,AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeCode39Mod43Code,AVMetadataObjectTypeCode93Code,AVMetadataObjectTypePDF417Code,AVMetadataObjectTypeAztecCode];
    
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:_captureSession];
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    layer.frame = self.view.layer.bounds;

    [self.view.layer insertSublayer:layer atIndex:0];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.view.frame];
    
    path.usesEvenOddFillRule = YES;
    
    UIBezierPath *rect = [UIBezierPath bezierPathWithRect:CGRectMake(ScreenWidth/2 - ScreenWidth/8*2.5, self.view.center.y - ScreenWidth/8*2.5 , ScreenWidth/4*2.5, ScreenWidth/4*2.5)];
    [path appendPath:rect];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.fillColor= [UIColor blackColor].CGColor;  //其他颜色都可以，只要不是透明的
    shapeLayer.fillRule=kCAFillRuleEvenOdd;
    
    UIView *translucentView = [UIView new];
    translucentView.frame = self.view.bounds;
    translucentView.backgroundColor = [UIColor blackColor];
    translucentView.alpha = 0.5;
    translucentView.layer.mask = shapeLayer;
    
    [self.view addSubview:translucentView];
    
    //把shapeLayer的透明度改为0.5，直接添加layer也一样
    // shapeLayer.opacity = 0.5
    //[self.imageView.layer addSublayer:shapeLayer];
    
    //10.1.扫描框
    boxView = [[UIView alloc] initWithFrame:rect.bounds];
    boxView.layer.borderColor = [UIColor greenColor].CGColor;
    boxView.layer.borderWidth = 1.0f;
    [self.view addSubview:boxView];
    //10.2.扫描线
    scanLayer = [[CALayer alloc] init];
    scanLayer.frame = CGRectMake(0, 0, boxView.bounds.size.width, 1);
    scanLayer.backgroundColor = [UIColor orangeColor].CGColor;
    [boxView.layer addSublayer:scanLayer];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.02f target:self selector:@selector(moveScanLayer:) userInfo:nil repeats:YES];
    [timer fire];
    
    // 开始会话
    [_captureSession startRunning];
    return YES;
}

- (void)stopReading
{
    // 停止会话
    [_captureSession stopRunning];
    _captureSession = nil;
}

- (void)moveScanLayer:(NSTimer *)timer
{
    CGRect frame = scanLayer.frame;
    if( ScreenWidth/4*2.5 < scanLayer.frame.origin.y) {
        frame.origin.y = 0;
        scanLayer.frame = frame;
//        frame.origin.y += 2;
//        scanLayer.frame = frame;

    } else {
      frame.origin.y += 2;
      scanLayer.frame = frame;
//        frame.origin.y = -70;
//        scanLayer.frame = frame;
    }
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        NSString *result;
        result = metadataObj.stringValue;
        
        //返回主线程刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            [self stopReading];
            [self.delegate ZHQRCodeScanDidFinishScan:result];
            [self dismissController];
        });
    }
}

#pragma mark - 照明系统是否开启
- (void)systemLightSwitch:(BOOL)open
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch]) {
        [device lockForConfiguration:nil];
        if (open) {
            [device setTorchMode:AVCaptureTorchModeOn];
        } else {
            [device setTorchMode:AVCaptureTorchModeOff];
        }
        [device unlockForConfiguration];
    }
}

- (void)dismissController {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
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
