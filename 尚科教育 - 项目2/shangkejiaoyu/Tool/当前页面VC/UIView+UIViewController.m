//
//  UIView+UIViewController.m
//  mingtao
//
//  Created by Linlin Ge on 2017/11/13.
//  Copyright © 2017年 Linlin Ge. All rights reserved.
//

#import "UIView+UIViewController.h"

@implementation UIView (UIViewController)

/**
 获取当前页面的UIViewController
 
 @return UIViewController
 */
- (UIViewController *)getCurrentViewController {
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
}

@end
