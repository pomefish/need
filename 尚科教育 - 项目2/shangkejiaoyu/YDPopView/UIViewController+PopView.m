//
//  UIViewController+PopView.m
//  QiShangDai
//
//  Created by Clyde on 2017/6/16.
//  Copyright © 2017年 Clyde. All rights reserved.
//

#import "UIViewController+PopView.h"
#import <objc/runtime.h>

@implementation UIViewController (PopView)

- (void)setPopupViewController:(UIViewController *)popupViewController {
    UInt8 kpopupViewController = 0;
    objc_setAssociatedObject(self, &kpopupViewController, popupViewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIViewController *)popupViewController {
    UInt8 kpopupViewController = 0;
    return objc_getAssociatedObject(self, &kpopupViewController);
}

- (void)setPopupBackgroundView:(UIView *)popupBackgroundView {
    objc_setAssociatedObject(self, 0, popupBackgroundView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)popupBackgroundView {
    return objc_getAssociatedObject(self, 0);
}

- (UIView *)getTopView {
    UIViewController *vc = self;
    if (vc.parentViewController) {
        vc = vc.parentViewController;
    }
    return vc.view;
}

#pragma mark -- 方法

- (void)btnDismissViewControllerWithAnimation:(UIButton *)sender {
    CCPopupViewAnimationType animationType = sender.tag;
    switch (animationType) {
        case  BottomTop:
            [self dismissPopupViewController:animationType];
            break;
            
        default:
            [self dismissPopupViewController:CCPopupViewAnimationFade];
            break;
    }
}

- (void)presentpopupViewController:(UIViewController *)popupViewController animationType:(CCPopupViewAnimationType)type {
    self.popupViewController = popupViewController;
    UIView *sourceView = [self getTopView];
    
    sourceView.tag = 1111;
    
    UIView *popView = popupViewController.view;
    popView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    popView.tag = 2222;
    if ([sourceView.subviews containsObject:popView]) {
        return;
    }
    popView.layer.shadowPath = [UIBezierPath bezierPathWithRect:popView.bounds].CGPath;
    popView.layer.shouldRasterize = YES;
    popView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    popView.alpha = 0.0;
    
    UIView *overlayView = [[UIView alloc] initWithFrame:sourceView.bounds];
    overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    overlayView.tag = 2222;
    overlayView.backgroundColor = [UIColor clearColor];
    
    self.popupBackgroundView = [[UIView alloc] initWithFrame:sourceView.bounds];
    self.popupBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.popupBackgroundView.backgroundColor = [UIColor blackColor];
    self.popupBackgroundView.alpha = 0.0;
    
    if (self.popupBackgroundView) {
        [overlayView addSubview:self.popupBackgroundView];
    }

    UIButton *dismissButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    dismissButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    dismissButton.backgroundColor = [UIColor clearColor];
    dismissButton.frame = sourceView.bounds;
    [dismissButton addTarget:self action:@selector(btnDismissViewControllerWithAnimation:) forControlEvents:(UIControlEventTouchUpInside)];
//    [overlayView addSubview:dismissButton];
    [overlayView addSubview:popView];
    [sourceView addSubview:overlayView];

    switch (type) {
        case BottomTop:
            dismissButton.tag = type;
            [self slideView:popView sourceView:sourceView overlayView:overlayView type:type];
            break;
            
        default:
             dismissButton.tag = CCPopupViewAnimationFade;
            [self fadeViewPopupView:popView sourceView:sourceView overlayView:overlayView];
            break;
    }
}

- (void)dismissPopupViewController:(CCPopupViewAnimationType)type {
    UIView *sourceView = [self getTopView];
    UIView *popView = [sourceView viewWithTag:2222];
    UIView *overlayView = [sourceView viewWithTag:2222];
    switch (type) {
        case BottomTop:
            [self slideViewOut:popView sourceView:sourceView overlayView:overlayView type:type];
            break;
            
        default:
            [self fadeViewOutPopupView:popView sourceView:sourceView overlayView:overlayView];
            break;
    }
}

- (void)fadeViewPopupView:(UIView *)popupView sourceView:(UIView *)sourceView overlayView:(UIView *)overlayView {
    CGSize sourceSize = sourceView.bounds.size;
    CGSize popupSize = popupView.bounds.size;
    popupView.frame = CGRectMake((sourceSize.width - popupSize.width)/2,
                                 (sourceSize.height - popupSize.height)/2,
                                 popupSize.width,
                                 popupSize.height);
    popupView.alpha = 0.0;
    [UIView animateWithDuration:0.35 animations:^{
        [self.popupViewController viewWillAppear:NO];
        self.popupBackgroundView.alpha = 0.5;
        popupView.alpha = 1.0;
    } completion:^(BOOL finished) {
        [self.popupViewController viewWillAppear:NO];
    }];
}

- (void)fadeViewOutPopupView:(UIView *)popupView sourceView:(UIView *)sourceView overlayView:(UIView *)overlayView {
//    [popupView removeFromSuperview];
//    [overlayView removeFromSuperview];
    [UIView animateWithDuration:0.35 animations:^{
        [self.popupViewController viewDidDisappear:NO];
        self.popupBackgroundView.alpha = 0.0;
        popupView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [popupView removeFromSuperview];
        [overlayView removeFromSuperview];
        [self.popupViewController viewDidDisappear:NO];
        self.popupViewController = nil;
    }];
}

- (void)slideView:(UIView *)popupView sourceView:(UIView *)sourceView overlayView:(UIView *)overlayView type:(CCPopupViewAnimationType)type {
    CGSize sourceSize = sourceView.bounds.size;
    CGSize popupSize = popupView.bounds.size;
    CGRect popupStartRect;
    switch (type) {
        case  BottomTop:
            popupStartRect = CGRectMake((sourceSize.width - popupSize.width)/2, sourceSize.height, popupSize.width, popupSize.height);
            break;
            
        default:
            popupStartRect = CGRectMake(sourceSize.width, (sourceSize.height - popupSize.height)/2, popupSize.width, popupSize.height);
            break;
    }
    CGRect popupEndRect = CGRectMake((sourceSize.width - popupSize.width)/2, (sourceSize.height - popupSize.height)/2, popupSize.width, popupSize.height);
    popupView.frame = popupStartRect;
    popupView.alpha = 1.0;
    [UIView animateWithDuration:0.35 animations:^{
        [self.popupViewController viewWillAppear:NO];
        self.popupBackgroundView.alpha = 0.5;
        popupView.frame = popupEndRect;
    } completion:^(BOOL finished) {
        [self.popupViewController viewDidAppear:NO];
    }];
    
}

- (void)slideViewOut:(UIView *)popupView sourceView:(UIView *)sourceView overlayView:(UIView *)overlayView type:(CCPopupViewAnimationType)type {
    CGSize sourceSize = sourceView.bounds.size;
    CGSize popupSize = popupView.bounds.size;
    CGRect popupEndRect;
    switch (type) {
        case  BottomTop:
            popupEndRect = CGRectMake((sourceSize.width - popupSize.width)/2, -popupSize.height, popupSize.width, popupSize.height);
            break;
            
        default:
             popupEndRect = CGRectMake(-popupSize.width, popupView.frame.origin.y, popupSize.width, popupSize.height);
            break;
    }
    
    [UIView animateWithDuration:0.2 delay:0.0 options:(UIViewAnimationOptionCurveEaseIn) animations:^{
        self.popupBackgroundView.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.35 delay:0.0 options:(UIViewAnimationOptionCurveEaseIn) animations:^{
             [self.popupViewController viewDidDisappear:NO];
        } completion:^(BOOL finished) {
            [popupView removeFromSuperview];
            [overlayView removeFromSuperview];
            [self.popupViewController viewDidDisappear:NO];
            self.popupViewController = nil;
        }];
    }];
}

@end
