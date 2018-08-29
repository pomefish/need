//
//  UIViewController+PopView.h
//  QiShangDai
//
//  Created by Clyde on 2017/6/16.
//  Copyright © 2017年 Clyde. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    BottomTop,
    TopBottom,
    BottomBottom,
    TopTop,
    LeftLeft,
    LeftRight,
    RightLeft,
    RightRight,
    CCPopupViewAnimationFade
} CCPopupViewAnimationType;

@interface UIViewController (PopView)

@property (nonatomic, strong) UIViewController *popupViewController;
@property (nonatomic, strong) UIView *popupBackgroundView;

- (void)presentpopupViewController:(UIViewController *)popupViewController animationType:(CCPopupViewAnimationType)type;
- (void)dismissPopupViewController:(CCPopupViewAnimationType)type;

@end
