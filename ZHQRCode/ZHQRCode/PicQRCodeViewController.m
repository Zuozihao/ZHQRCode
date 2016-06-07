//
//  PicQRCodeViewController.m
//  ZHQRCode
//
//  Created by 左梓豪 on 16/6/4.
//  Copyright © 2016年 左梓豪. All rights reserved.
//

#import "PicQRCodeViewController.h"
#import "ZHQRCodeInPic.h"

@interface PicQRCodeViewController ()

@end

@implementation PicQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = [UIImage imageNamed:@"44.png"];
    [self.view addSubview:imageView];
    
    UIImage *img = imageView.image;
    
    self.title = [ZHQRCodeInPic recgnizeQRCodeInPic:img];
    // Do any additional setup after loading the view.
}

- (NSString *)stringFromCiImage:(CIImage *)ciimage {
    
    NSString *content = @"" ;
    
    
    
    if (!ciimage) {
        
        return content;
        
    }
    
    if (ciimage == nil) {
        return content;
    }
    
    
    
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode
                            
                                              context:[CIContext contextWithOptions:nil]
                            
                                              options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
    
    NSArray *features = [detector featuresInImage:ciimage];
    
    if (features.count) {
        
        
        
        for (CIFeature *feature in features) {
            
            if ([feature isKindOfClass:[CIQRCodeFeature class]]) {
                
                content = ((CIQRCodeFeature *)feature).messageString;
                NSLog(@"结果为%@",content);
                
                break;
                
            }
            
        }
        
    } else {
        
        NSLog(@"未正常解析二维码图片, 请确保iphone5/5c以上的设备");
        
    }
    
    
    
    return content;
    
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
