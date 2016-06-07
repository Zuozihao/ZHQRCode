//
//  ZHQRCodeInPic.h
//  ZHQRCode
//
//  Created by 左梓豪 on 16/6/6.
//  Copyright © 2016年 左梓豪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZHQRCodeInPic : NSObject

+ (NSString*)recgnizeQRCodeInPic:(UIImage *)image;

@end
