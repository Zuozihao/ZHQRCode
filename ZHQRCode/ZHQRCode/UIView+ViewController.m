//
//  UIView+ViewController.m
//  ZHQRCode
//
//  Created by 左梓豪 on 16/6/3.
//  Copyright © 2016年 左梓豪. All rights reserved.
//

#import "UIView+ViewController.h"

@implementation UIView (ViewController)

- (UIViewController *)viewController {
    
    UIResponder *next = self.nextResponder;
    
    do {
        
        if ([next isKindOfClass:[UIViewController class]]) {
            
            return (UIViewController *)next;
        }
        
        next = next.nextResponder;
        
    } while (next != nil);
    
    return nil;
}


@end
