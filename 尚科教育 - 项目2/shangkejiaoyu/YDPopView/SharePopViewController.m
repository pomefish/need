//
//  SharePopViewController.m
//  mingtao
//
//  Created by Linlin Ge on 2018/1/9.
//  Copyright © 2018年 Linlin Ge. All rights reserved.
//

#import "SharePopViewController.h"
#import "UIViewController+PopView.h"

@interface SharePopViewController ()

@end

@implementation SharePopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [self.view addGestureRecognizer:tap];
    
}

- (void)tapClick:(UITapGestureRecognizer *)sender {
    [[UIApplication sharedApplication].delegate.window.rootViewController dismissPopupViewController:(CCPopupViewAnimationFade)];
}

- (IBAction)shareBtn:(UIButton *)sender {
    [[UIApplication sharedApplication].delegate.window.rootViewController dismissPopupViewController:(CCPopupViewAnimationFade)];
    if (_shareBtnBlock) {
        self.shareBtnBlock();
    }
}

- (IBAction)closeBtn:(UIButton *)sender {
    [[UIApplication sharedApplication].delegate.window.rootViewController dismissPopupViewController:(CCPopupViewAnimationFade)];
    if (_closeBtnBlock) {
        self.closeBtnBlock();
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
