//
//  UIWindow+PazLabs.m
//  mingtao
//
//  Created by Linlin Ge on 2017/11/8.
//  Copyright © 2017年 Linlin Ge. All rights reserved.
//

#import "UIWindow+PazLabs.h"

@implementation UIWindow (PazLabs)

- (UIViewController *)visibleViewController {
    UIViewController *rootViewController = self.rootViewController;
    return [UIWindow getVisibleViewControllerFrom:rootViewController];
}

+ (UIViewController *) getVisibleViewControllerFrom:(UIViewController *) vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [UIWindow getVisibleViewControllerFrom:[((UINavigationController *) vc) visibleViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [UIWindow getVisibleViewControllerFrom:[((UITabBarController *) vc) selectedViewController]];
    } else {
        if (vc.presentedViewController) {
            return [UIWindow getVisibleViewControllerFrom:vc.presentedViewController];
        } else {
            return vc;
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
