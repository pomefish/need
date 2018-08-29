//
//  LogonCustomView.h
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2017/6/15.
//  Copyright © 2017年 ShangKe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogonCustomView : UIView
@property (nonatomic, strong) UIImageView *bgImage;
@property (nonatomic, strong) UIImageView *headImage;
@property (nonatomic, strong) UIImageView *phoneImage;
@property (nonatomic, strong) UIView      *shu;
@property (nonatomic, strong) UITextField *phoneTF;
@property (nonatomic, strong) UIView      *heng;
@property (nonatomic, strong) UIImageView *pswImage;
@property (nonatomic, strong) UIView      *shu1;
@property (nonatomic, strong) UITextField *pswTF;
@property (nonatomic, strong) UIView      *heng1;

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIView   *shu2;
@property (nonatomic, strong) UIButton *logonButton;

@property (nonatomic, strong) UIButton *forgetBtn;

@property (nonatomic, strong) UIView      *heng2;
@property (nonatomic, strong) UILabel     *ORLabel;
@property (nonatomic, strong) UIView      *shu3;

@property (nonatomic, strong) UIButton    *touristsBtn;
- (instancetype)initWithFrame:(CGRect)frame;

@end
