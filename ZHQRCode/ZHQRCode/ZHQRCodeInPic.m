//
//  ZHQRCodeInPic.m
//  ZHQRCode
//
//  Created by 左梓豪 on 16/6/6.
//  Copyright © 2016年 左梓豪. All rights reserved.
//

#import "ZHQRCodeInPic.h"

@implementation ZHQRCodeInPic

+ (NSString*)recgnizeQRCodeInPic:(UIImage *)image {
    NSData *data = UIImagePNGRepresentation(image);
    CIImage *ciImage = [CIImage imageWithData:data];
    
    NSString *content = @"" ;
    
    if (!ciImage) {
        return content;
    }
    
    if (ciImage == nil) {
        return content;
    }
    
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode
                                              context:[CIContext contextWithOptions:nil]
                                              options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
    
    NSArray *features = [detector featuresInImage:ciImage];
    
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

@end
