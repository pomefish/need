//
//  LoginCustomView.m
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2017/6/15.
//  Copyright © 2017年 ShangKe. All rights reserved.
//

#import "LoginCustomView.h"

@implementation LoginCustomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initCustomView];
    }
    return self;
}

- (void)initCustomView {
    
    NSLog(@"-----_subjectsArr-------%@",_subjectsArr);
//    1.在我们的app中，VIP用户可以购买并观看一系列套餐视频，而非VIP用户只能观看个别视频。

//    - 什么是VIP？
//    1.在我们的app中，VIP只是为了我们区分游客登录还是注册用户登录。
//    - 用户如何获得VIP？
//    2.用户可以通过“VIP登录”入口进入，注册账号即可成为VIP用户。
//    - VIP成为VIP后将获得什么特别的内容？
//    3.用户注册成账号后，可以“VIP登录”。“VIP登录”后可以购买系列套餐视频。
//    - 用户如何支付VIP费用？
//    4.注册账号即可成为VIP，VIP不需要任何费用，想要观看“VIP登录”中的视频，需要苹果内购或者余额购买。
    
    
//    _logoImage = [UIImageView new];
//    _logoImage.image = [UIImage imageNamed:@"logo"];
//    [self addSubview:self.logoImage];
//    _logoImage.sd_layout.topSpaceToView(self,100)
//    .leftSpaceToView(self,(kScreenWidth - 80)/2)
//    .widthIs(80)
//    .heightIs(80);
    
    self.niImage = [UIImageView new];
    _niImage.frame = CGRectMake(15, 120, 20, 25);
    _niImage.image = [UIImage imageNamed:@"accountNumber"];
    [self addSubview:self.niImage];
    
    self.niTF = [UITextField new];
    _niTF.frame = CGRectMake(CGRectGetMaxX(self. niImage.frame) + 10, 120, kScreenWidth - 30 - 20, 30);
    [_niTF addTarget:self action:@selector(niFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _niTF.placeholder = @"昵称";
    _niTF.clearButtonMode = UITextFieldViewModeAlways;
//    _niTF.keyboardType = UIKeyboardTypeNumberPad;
    [self addSubview:_niTF];
    
    _lineView = [UIView new];
    _lineView.frame = CGRectMake(15, CGRectGetMaxY(self.niTF.frame) + 5, kScreenWidth - 30, 1);
    _lineView.backgroundColor = kCustomColor(220, 220, 220);
    [self addSubview:self.lineView];
    
    
    
    
    
    _phoneImage = [UIImageView new];
    _phoneImage.frame = CGRectMake(15, CGRectGetMaxY(self.lineView.frame) + 15, 20, 25);
    _phoneImage.image = [UIImage imageNamed:@"ic_phone"];
    [self addSubview:self.phoneImage];
    
//    _shu = [UIView new];
//    _shu.backgroundColor = kCustomColor(220, 220, 220);
//    [self addSubview:self.shu];

    _phoneTF = [UITextField new];
    _phoneTF.frame = CGRectMake(CGRectGetMaxX(self.phoneImage.frame) + 10, CGRectGetMaxY(self.phoneImage.frame) - 25, kScreenWidth - 30 - 20, 30);
    _phoneTF.placeholder = @"手机号(仅支持中国大陆号)";
    [_phoneTF addTarget:self action:@selector(phoneFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _phoneTF.clearButtonMode = UITextFieldViewModeAlways;
    _phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    [self addSubview:_phoneTF];

    _heng = [UIView new];
    _heng.frame = CGRectMake(15, CGRectGetMaxY(self.phoneTF.frame) + 5, kScreenWidth - 30, 1);
    _heng.backgroundColor = kCustomColor(220, 220, 220);
    [self addSubview:self.heng];
    
    _messageImage = [UIImageView new];
    _messageImage.frame = CGRectMake(15, CGRectGetMaxY(self.heng.frame) + 15, 20, 25);
    _messageImage.image = [UIImage imageNamed:@"ic_login_pw"];
    [self addSubview:self.messageImage];
    
    _messageTF = [UITextField new];
    _messageTF.frame = CGRectMake(CGRectGetMaxX(self.messageImage.frame) + 10, CGRectGetMaxY(self.messageImage.frame) - 25, kScreenWidth - 130, 30);
    _messageTF.placeholder = @"验证码";
    _messageTF.clearButtonMode = UITextFieldViewModeAlways;
    _messageTF.keyboardType = UIKeyboardTypeNumberPad;
    [_messageTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:_messageTF];

    _duanxinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _duanxinBtn.frame = CGRectMake(CGRectGetMaxX(self.messageTF.frame) - 5, CGRectGetMaxY(self.messageImage.frame) - 25, 80, 30);
    //    _duanxinBtn.backgroundColor = kCustomViewColor;
    [_duanxinBtn setTitleColor:kCustomViewColor forState:UIControlStateNormal];
    [_duanxinBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    _duanxinBtn.clipsToBounds = YES;
    _duanxinBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _duanxinBtn.layer.cornerRadius = 5;
    _duanxinBtn.backgroundColor = [UIColor yellowColor];
    [self addSubview:_duanxinBtn];
    
    _heng1 = [UIView new];
    _heng1.frame = CGRectMake(15, CGRectGetMaxY(self.messageTF.frame) + 5, kScreenWidth - 30, 1);
    _heng1.backgroundColor = kCustomColor(220, 220, 220);
    [self addSubview:self.heng1];
    
    _pswImage = [UIImageView new];
    _pswImage.frame = CGRectMake(15, CGRectGetMaxY(self.heng1.frame) + 15, 20, 25);
    _pswImage.image = [UIImage imageNamed:@"psw"];
    [self addSubview:self.pswImage];
    
    _pswTF = [UITextField new];
    _pswTF.frame = CGRectMake(CGRectGetMaxX(self.pswImage.frame) + 10, CGRectGetMaxY(self.pswImage.frame) - 25, kScreenWidth - 30 - 20, 30);
    _pswTF.placeholder = @"密码(6-12位数字或字母)";
    _pswTF.secureTextEntry = YES;
    [_pswTF addTarget:self action:@selector(pswFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _pswTF.clearButtonMode = UITextFieldViewModeAlways;
    _pswTF.keyboardType = UIKeyboardTypeDefault;
    [self addSubview:_pswTF];
    
    _heng3 = [UIView new];
    _heng3.frame = CGRectMake(15, CGRectGetMaxY(self.pswTF.frame) + 5, kScreenWidth - 30, 1);
    _heng3.backgroundColor = kCustomColor(220, 220, 220);
    [self addSubview:self.heng3];
    
    
    _promptLabel = [UILabel new];
    _promptLabel.frame = CGRectMake(15, CGRectGetMaxY(self.heng3.frame) + 20, kScreenWidth - 30, 20);
    _promptLabel.font = [UIFont systemFontOfSize:14];
    _promptLabel.text = @"请选择想要关注的项目，可多选：";
    _promptLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:_promptLabel];
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.frame = CGRectMake(15, CGRectGetMaxY(self.promptLabel.frame) + (25 * 3), kScreenWidth - 30, 45);
    _button.backgroundColor = kCustomColor(213.0, 213.0, 213.0);
    [_button setTitle:@"注册并登录" forState:UIControlStateNormal];
    _button.titleLabel.font = [UIFont systemFontOfSize:15];
    _button.layer.cornerRadius = 2;
    _button.clipsToBounds = YES;
    _button.enabled = NO;
    [self addSubview:_button];

    _label = [UILabel new];
//    _label.frame = CGRectMake(kScreenWidth/ 4.3, CGRectGetMaxY(self.button.frame) + 20, 100, 20);
    _label.frame = CGRectMake(kScreenWidth/ 4.3, kScreenHeight - 50, 100, 20);
    _label.text = @"注册代表你已同意";
    _label.font = [UIFont systemFontOfSize:12];
    _label.tintColor = [UIColor lightGrayColor];
    [self addSubview:self.label];
    
    _agreementBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _agreementBtn.frame = CGRectMake(CGRectGetMaxX(self.label.frame) - 3, CGRectGetMaxY(self.button.frame) + 20, 100, 20);
    _agreementBtn.frame = CGRectMake(CGRectGetMaxX(self.label.frame) - 3, kScreenHeight - 50, 100, 20);
    [_agreementBtn setTitle:@"尚科用户协议。" forState:UIControlStateNormal];
    _agreementBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_agreementBtn setTitleColor:kCustomViewColor forState:UIControlStateNormal];
    [self addSubview:_agreementBtn];
    
}

- (void)niFieldDidChange:(UITextField *)textField{

    self.niText = textField.text;
    
//    self.niImage.image = [UIImage imageNamed:@"accountNumberBright"];
    if ([self.niTF.text isEqualToString:@""]) {
        self.niImage.image = [UIImage imageNamed:@"accountNumber"];
    }else {
        self.niImage.image = [UIImage imageNamed:@"accountNumberBright"];
    }
}


- (void)phoneFieldDidChange:(UITextField *)textField {
    if (![_messageTF.text isEqualToString:@""] && ![_phoneTF.text isEqualToString:@""] && ![_pswTF.text isEqualToString:@""]) {
//        self.button.backgroundColor = kCustomViewColor;
        self.phoneImage.image = [UIImage imageNamed:@"ic_phoneing"];
        self.messageImage.image = [UIImage imageNamed:@"ic_login_pwing"];
        
//        self.button.enabled = YES;
        
    } else {
//        self.button.backgroundColor = kCustomColor(213.0, 213.0, 213.0);
        self.button.enabled = NO;
        
        if (![self.phoneTF.text isEqualToString:@""]) {
            self.phoneImage.image = [UIImage imageNamed:@"ic_phoneing"];
        }else {
            self.phoneImage.image = [UIImage imageNamed:@"ic_phone"];
        }
    }
    //限制字数
    if (textField.text.length > 11) {
        UITextRange *markedRange = [textField markedTextRange];
        if (markedRange) {
            return;
        }
        //Emoji占2个字符，如果是超出了半个Emoji，用15位置来截取会出现Emoji截为2半
        //超出最大长度的那个字符序列(Emoji算一个字符序列)的range
        NSRange range = [textField.text rangeOfComposedCharacterSequenceAtIndex:11];
        textField.text = [textField.text substringToIndex:range.location];
    }

}

- (void)pswFieldDidChange:(UITextField *)textField {
    if (![_messageTF.text isEqualToString:@""] && ![_phoneTF.text isEqualToString:@""] && ![_pswTF.text isEqualToString:@""]) {
//        self.button.backgroundColor = kCustomViewColor;
        self.pswImage.image = [UIImage imageNamed:@"pswBright"];
//        self.button.enabled = YES;
    } else {
        if (![self.pswTF.text isEqualToString:@""]) {
            self.pswImage.image = [UIImage imageNamed:@"pswBright"];
            
        }else {
//            self.button.backgroundColor = kCustomColor(213.0, 213.0, 213.0);
            
            self.pswImage.image = [UIImage imageNamed:@"psw"];
            self.button.enabled = NO;
        }
    }
    //限制字数
    if (textField.text.length > 18) {
        UITextRange *markedRange = [textField markedTextRange];
        if (markedRange) {
            return;
        }
        //Emoji占2个字符，如果是超出了半个Emoji，用15位置来截取会出现Emoji截为2半
        //超出最大长度的那个字符序列(Emoji算一个字符序列)的range
        NSRange range = [textField.text rangeOfComposedCharacterSequenceAtIndex:18];
        textField.text = [textField.text substringToIndex:range.location];
    }
}

- (void)textFieldDidChange:(UITextField *)textField {
    if (![_messageTF.text isEqualToString:@""] && ![_phoneTF.text isEqualToString:@""] && ![_pswTF.text isEqualToString:@""]) {
//        self.button.backgroundColor = kCustomViewColor;
        self.messageImage.image = [UIImage imageNamed:@"ic_login_pwing"];
//        self.button.enabled = YES;
    } else {
        if (![self.messageTF.text isEqualToString:@""]) {
            self.messageImage.image = [UIImage imageNamed:@"ic_login_pwing"];
            
        }else {
//            self.button.backgroundColor = kCustomColor(213.0, 213.0, 213.0);
            
            self.messageImage.image = [UIImage imageNamed:@"ic_login_pw"];
            self.button.enabled = NO;
        }
    }
}

#pragma mark ------正则表达式
- (BOOL)isMobileNumber:(NSString *)mobileNum {
    /**
          * 手机号码
          * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
          * 联通：130,131,132,152,155,156,185,186
          * 电信：133,1349,153,180,189
          */
    
    //移动
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    //联通
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    //电信
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    
    
    //创建谓词
    NSPredicate *testCM = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CM];
    
    NSPredicate *testMobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",MOBILE];
    
    NSPredicate *testCU = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CU];
    
    if ([testMobile evaluateWithObject:mobileNum] || [testCU evaluateWithObject:mobileNum] || [testCM evaluateWithObject:mobileNum])
    {
        return YES;
    }
    
    return NO;
}






/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
