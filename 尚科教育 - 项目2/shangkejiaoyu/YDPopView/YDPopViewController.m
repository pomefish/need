//
//  YDPopViewController.m
//  CCFrameDemo
//
//  Created by Clyde on 2017/12/8.
//  Copyright © 2017年 ChenLY. All rights reserved.
//

#import "YDPopViewController.h"
#import "UIViewController+PopView.h"

@interface YDPopViewController ()

@end

@implementation YDPopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    if (_typeInt == 1) {
        self.mainButton.hidden = YES;
    } else {
        self.mainButton.hidden = NO;
    }
    
    NSURL *str = [NSURL URLWithString:[NSString stringWithFormat:@"https://app.mingtaokeji.com/%@",_activity_thumb]];
    NSLog(@"llll = %@",str);
    [self.bgImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://shangke.mingtaokeji.com//%@",_activity_thumb]] placeholderImage:[UIImage imageNamed:@""]];
}

- (IBAction)mainButtonClick:(UIButton *)sender {
    [[UIApplication sharedApplication].delegate.window.rootViewController dismissPopupViewController:(CCPopupViewAnimationFade)];
    if (self.mainButtonBlock) {
        self.mainButtonBlock();
    }
}

- (IBAction)closeButtonClick:(UIButton *)sender {
    [[UIApplication sharedApplication].delegate.window.rootViewController dismissPopupViewController:(CCPopupViewAnimationFade)];
    if (self.closeButtonBlock) {
        self.closeButtonBlock();
    }
}

@end
