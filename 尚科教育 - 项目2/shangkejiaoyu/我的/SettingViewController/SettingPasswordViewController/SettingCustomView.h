//
//  SettingCustomView.h
//  mingtao
//
//  Created by Linlin Ge on 2016/12/27.
//  Copyright © 2016年 Linlin Ge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingCustomView : UIView
//@property (nonatomic, copy) UITextField *passwordTF;
//@property (nonatomic, copy) UITextField *pswTF;
@property (nonatomic, assign) NSInteger timeCout;
@property (nonatomic, strong) NSTimer *time;
//@property (nonatomic, strong) UIButton *passwordBt;
//@property (nonatomic, strong) UIButton *affirmBt;

@property (nonatomic, strong) UIImageView *phoneImage;
@property (nonatomic, strong) UIView *shu;
@property (nonatomic, strong) UITextField *pswTF;
@property (nonatomic, strong) UIView *heng;
@property (nonatomic, strong) UIImageView *pswImage;
@property (nonatomic, strong) UIView *shu1;
@property (nonatomic, strong) UITextField *duanXinTF;
@property (nonatomic, strong) UIView *heng1;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIView *shu2;
@property (nonatomic, strong) UILabel *label;

@end
