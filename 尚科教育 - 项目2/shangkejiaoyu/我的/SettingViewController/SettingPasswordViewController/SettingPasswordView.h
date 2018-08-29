//
//  SettingPasswordView.h
//  mingtao
//
//  Created by Linlin Ge on 16-11-17.
//  Copyright (c) 2016年 Linlin Ge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingPasswordView : UIView
@property (nonatomic, strong) UIButton *passwordBt;
@property (nonatomic, strong) UIImageView *phoneImage;
@property (nonatomic, strong) UIView *shu;
@property (nonatomic, strong) UITextField *phoneTF;
@property (nonatomic, strong) UIView *heng;
@property (nonatomic, strong) UIImageView *pswImage;
@property (nonatomic, strong) UIView *shu1;
@property (nonatomic, strong) UITextField *duanXinTF;
@property (nonatomic, strong) UIView *heng1;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIView *shu2;
@property (nonatomic, strong) UIButton *duanxinBtn;

- (instancetype)initWithFrame:(CGRect)frame;

@end
