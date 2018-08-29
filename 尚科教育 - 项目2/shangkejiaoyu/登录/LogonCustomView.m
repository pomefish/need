//
//  LogonCustomView.m
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2017/6/15.
//  Copyright © 2017年 ShangKe. All rights reserved.
//

#import "LogonCustomView.h"

@implementation LogonCustomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initCustomView];
        
    }
    return self;
}

- (void)initCustomView {
    
    _bgImage = [UIImageView new];
    _bgImage.frame = self.frame;
    _bgImage.image = [UIImage imageNamed:@"bj"];
//    [self addSubview:_bgImage];
    
    _headImage = [UIImageView new];
    _headImage.image = logo;
    _headImage.frame = CGRectMake(kScreenWidth / 2 - 40, 80, 80, 80);
//    _headImage.clipsToBounds = YES;
//    _headImage.layer.cornerRadius = 40;
    [self addSubview:self.headImage];
    
    _shu = [UIView new];
    _shu.frame = CGRectMake(15, CGRectGetMaxY(_headImage.frame) + 40, 40, 40);
    _shu.backgroundColor = [UIColor colorWithRed:59.0/255.0 green:60.0/255.0 blue:64.0/255.0 alpha:0.8];
    [self addSubview:self.shu];
    
    _phoneImage = [UIImageView new];
    _phoneImage.frame = CGRectMake(CGRectGetMaxX(self.shu.frame) - 27, CGRectGetMaxY(self.shu.frame) - 20 -8, 16, 20);
    _phoneImage.image = [UIImage imageNamed:@"accountNumber"];
    [self addSubview:self.phoneImage];
    
    _heng = [UIView new];
    _heng.backgroundColor = [UIColor colorWithRed:9.0/255.0 green:14.0/255.0 blue:24.0/255.0 alpha:0.2];
    _heng.frame = CGRectMake(CGRectGetMaxX(self.shu.frame), CGRectGetMaxY(self.shu.frame) - 40, kScreenWidth - 30 - 40, 40);
    [self addSubview:self.heng];
    
    _phoneTF = [UITextField new];
    //修改placeholder颜色
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary]; // 创建属性字典
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:15]; // 设置font
    attrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor]; // 设置颜色
    NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:@"请输入手机号" attributes:attrs]; // 初始化富文本占位字符串
    _phoneTF.attributedPlaceholder = attStr;
    _phoneTF.placeholder = @"请输入手机号";
    _phoneTF.frame = CGRectMake(CGRectGetMaxX(self.shu.frame) + 3, CGRectGetMaxY(self.shu.frame) - 40, kScreenWidth - 30 - 40, 40);
//    _phoneTF.font = [UIFont systemFontOfSize:14];
    _phoneTF.textColor = [UIColor whiteColor];
    _phoneTF.clearButtonMode = UITextFieldViewModeAlways;
    _phoneTF.keyboardType = UIKeyboardTypePhonePad;
    [self addSubview:_phoneTF];
    
    _shu1 = [UIView new];
    _shu1.frame = CGRectMake(15, CGRectGetMaxY(_heng.frame) + 1, 40, 40);
    _shu1.backgroundColor = [UIColor colorWithRed:59.0/255.0 green:60.0/255.0 blue:64.0/255.0 alpha:0.8];
    [self addSubview:self.shu1];
    
    _pswImage = [UIImageView new];
    _pswImage.image = [UIImage imageNamed:@"psw"];
    _pswImage.frame = CGRectMake(CGRectGetMaxX(self.shu1.frame) - 27, CGRectGetMaxY(self.shu1.frame) - 20 -8, 16, 20);
    [self addSubview:self.pswImage];
    
    _heng1 = [UIView new];
    _heng1.backgroundColor = [UIColor colorWithRed:9.0/255.0 green:14.0/255.0 blue:24.0/255.0 alpha:0.2];
    _heng1.frame = CGRectMake(CGRectGetMaxX(self.shu1.frame), CGRectGetMaxY(self.shu1.frame) - 40, kScreenWidth - 30 - 40, 40);
    [self addSubview:self.heng1];
    
    _pswTF = [UITextField new];
    _pswTF.frame = CGRectMake(CGRectGetMaxX(self.shu1.frame) + 3, CGRectGetMaxY(self.shu1.frame) - 40, kScreenWidth - 30 - 40, 40);
    
    //修改placeholder颜色
    NSMutableDictionary *pswAttrs = [NSMutableDictionary dictionary]; // 创建属性字典
    pswAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:15]; // 设置font
    pswAttrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor]; // 设置颜色
    NSAttributedString *pswAttStr = [[NSAttributedString alloc] initWithString:@"请输入密码" attributes:pswAttrs]; // 初始化富文本占位字符串
    _pswTF.attributedPlaceholder = pswAttStr;
    
    _pswTF.placeholder = @"请输入密码";
    _pswTF.textColor = [UIColor whiteColor];
//    _pswTF.font = [UIFont systemFontOfSize:14];
    _pswTF.secureTextEntry = YES;

    _pswTF.clearButtonMode = UITextFieldViewModeAlways;
    [self addSubview:_pswTF];
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.frame = CGRectMake(15, CGRectGetMaxY(_heng1.frame) + 30, kScreenWidth - 30, 45);
    _button.backgroundColor = kCustomViewColor;
    [_button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_button setTitle:@"登录" forState:UIControlStateNormal];
    _button.titleLabel.font = [UIFont systemFontOfSize:15];
    _button.layer.cornerRadius = 2;
    _button.clipsToBounds = YES;
    _button.enabled = NO;
    [self addSubview:_button];
    
    
//    _logonButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    _logonButton.frame = CGRectMake(kScreenWidth/2 - 75, CGRectGetMaxY(_button.frame) + 25, 150, 35);
//    [_logonButton setTitle:@"没有账号，快去注册！" forState:UIControlStateNormal];
//    [_logonButton setTitleColor:kCustomColor(220, 220, 220) forState:UIControlStateNormal];
//    _logonButton.titleLabel.font = [UIFont systemFontOfSize:14];
//    [self addSubview:_logonButton];
    
    _logonButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _logonButton.frame = CGRectMake(15, CGRectGetMaxY(_button.frame) + 25, 150, 35);
    [_logonButton setTitle:@"没有账号，快去注册！" forState:UIControlStateNormal];
    [_logonButton setTitleColor:kCustomColor(220, 220, 220) forState:UIControlStateNormal];
    _logonButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_logonButton];
    
    _forgetBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _forgetBtn.frame = CGRectMake(kScreenWidth - 100, CGRectGetMaxY(_button.frame) + 25, 80, 35);
    [_forgetBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [_forgetBtn setTitleColor:kCustomColor(220, 220, 220) forState:UIControlStateNormal];
    _forgetBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_forgetBtn];
    
    _touristsBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _touristsBtn.frame = CGRectMake(kScreenWidth / 2 - 40, CGRectGetMaxY(_forgetBtn.frame) + 20, 80, 35);
    [_touristsBtn setTitle:@"游客登录" forState:UIControlStateNormal];
    [_touristsBtn setTitleColor:kCustomColor(220, 220, 220) forState:UIControlStateNormal];
    _touristsBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_touristsBtn];

//    _shu2 = [UIView new];
//    _shu2.frame = CGRectMake(15, kScreenHeight - 80, kScreenWidth /2 - 30, 1);
//    _shu2.backgroundColor = kCustomColor(125, 125, 125);
//    [self addSubview:self.shu2];

//    _heng2 = [UIView new];
//    _heng2.frame = CGRectMake(CGRectGetMaxX(self.shu2.frame) + 30, kScreenHeight - 80, kScreenWidth /2- 30, 1);
//    _heng2.backgroundColor = kCustomColor(125, 125, 125);
//    [self addSubview:_heng2];
//    
//    _ORLabel = [UILabel new];
//    _ORLabel.text = @"OR";
//    _ORLabel.textColor = kCustomColor(125, 125, 125);
//    _ORLabel.font = [UIFont systemFontOfSize:14];
//    _ORLabel.textAlignment = NSTextAlignmentCenter;
//    _ORLabel.frame = CGRectMake(kScreenWidth / 2 - 15, kScreenHeight - 90, 30, 20);
//    [self addSubview:_ORLabel];
//    
//    _shu3 = [UIView new];
//    _shu3.frame = CGRectMake(kScreenWidth/2, kScreenHeight - 50, 1, 20);
//    _shu3.backgroundColor = [UIColor whiteColor];
//    [self addSubview:_shu3];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
