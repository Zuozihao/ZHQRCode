//
//  ZHQRCodeScanViewController.h
//  ZHQRCode
//
//  Created by 左梓豪 on 16/6/3.
//  Copyright © 2016年 左梓豪. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZHQRCodeScanDelegate <NSObject>

@required

- (void)ZHQRCodeScanDidFinishScan:(NSString *)result;

@end

@interface ZHQRCodeScanViewController : UIViewController

@property(nonatomic,weak) id<ZHQRCodeScanDelegate> delegate;

@end
