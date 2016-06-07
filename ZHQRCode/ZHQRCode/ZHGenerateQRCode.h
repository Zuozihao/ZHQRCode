//
//  ZHGenerateQRCode.h
//  ZHQRCode
//
//  Created by 左梓豪 on 16/6/4.
//  Copyright © 2016年 左梓豪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHGenerateQRCode : UIImageView

//设置二维码用message传入字符串
@property(nonatomic, copy) NSString *message;
//设置条码用barCodeMessage,且字符串为数字
@property(nonatomic, copy) NSString *barCodeMessage;

@end
