//
//  SettingPasswordView.m
//  mingtao
//
//  Created by Linlin Ge on 16-11-17.
//  Copyright (c) 2016年 Linlin Ge. All rights reserved.
//

#import "SettingPasswordView.h"
#import "TGHeader.h"
#import "HttpRequest.h"

@implementation SettingPasswordView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initCustomCell];
    }
    return self;
}

- (void)initCustomCell {
//    UILabel *label = [UILabel new];
//    
//    label.text = @"请输入您注册的手机号码。";
//    label.font = [UIFont systemFontOfSize:13];
//    label.textColor = kCustomViewColor;
//    [self addSubview:label];
//    label.sd_layout.topSpaceToView(self,120).
//    leftSpaceToView(self,(kScreenWidth - 160)/2).
//    widthIs(160).heightIs(13);
//    
//    _phoneImage = [UIImageView new];
//    _phoneImage.image = [UIImage imageNamed:@"tb_02"];
//    [self addSubview:self.phoneImage];
//    _phoneImage.sd_layout.topSpaceToView(label,40)
//    .leftSpaceToView(self,30)
//    .widthIs(20)
//    .heightIs(25);
//    
//    _shu = [UIView new];
//    _shu.backgroundColor = [UIColor lightGrayColor];
//    [self addSubview:self.shu];
//    _shu.sd_layout.topEqualToView(self.phoneImage)
//    .leftSpaceToView(_phoneImage,10)
//    .widthIs(1)
//    .heightIs(30);
//    
//    _phoneTF = [UITextField new];
//    _phoneTF.placeholder = @"请输入手机号";
//    [_phoneTF addTarget:self action:@selector(phoneFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
//    _phoneTF.clearButtonMode = UITextFieldViewModeAlways;
//    _phoneTF.keyboardType = UIKeyboardTypePhonePad;
//    [self addSubview:_phoneTF];
//    _phoneTF.sd_layout.
//    topSpaceToView(label,40).
//    leftSpaceToView(self.shu,15).
//    widthIs(kScreenWidth - 150).
//    heightIs(30);
//    
//    _heng = [UIView new];
//    _heng.backgroundColor = [UIColor lightGrayColor];
//    [self addSubview:self.heng];
//    _heng.sd_layout.topSpaceToView(self.phoneImage,10)
//    .leftSpaceToView(self,30)
//    .widthIs(kScreenWidth - 60)
//    .heightIs(1);
//    
//    
//    _pswImage = [UIImageView new];
//    _pswImage.image = [UIImage imageNamed:@"tb_4"];
//    [self addSubview:self.pswImage];
//    _pswImage.sd_layout.topSpaceToView(self.heng,20)
//    .leftSpaceToView(self,30)
//    .widthIs(20)
//    .heightIs(25);
//    
//    _shu1 = [UIView new];
//    _shu1.backgroundColor = [UIColor lightGrayColor];
//    [self addSubview:self.shu1];
//    _shu1.sd_layout.topEqualToView(self.pswImage)
//    .leftSpaceToView(_pswImage,10)
//    .widthIs(1)
//    .heightIs(30);
//    
//    _duanXinTF = [UITextField new];
//    _duanXinTF.placeholder = @"请输入验证码";
//    [_duanXinTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
//    [self addSubview:_duanXinTF];
//    _duanXinTF.sd_layout.
//    topSpaceToView(_heng,20).
//    leftSpaceToView(self.shu1,15).
//    widthIs(kScreenWidth - 200).
//    heightIs(30);
//    
//    _shu2 = [UIView new];
//    _shu2.backgroundColor = [UIColor lightGrayColor];
//    [self addSubview:self.shu2];
//    _shu2.sd_layout
//    .topEqualToView(self.pswImage)
//    .leftSpaceToView(_duanXinTF,2)
//    .widthIs(1)
//    .heightIs(30);
    
//    _duanxinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
////    _duanxinBtn.backgroundColor = kCustomViewColor;
//    [_duanxinBtn setTitleColor:kCustomViewColor forState:UIControlStateNormal];
//    [_duanxinBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
//    [_duanxinBtn addTarget:self action:@selector(passwordClick:) forControlEvents:UIControlEventTouchUpInside];
//    _duanxinBtn.clipsToBounds = YES;
//    _duanxinBtn.titleLabel.font = [UIFont systemFontOfSize:12];
//    _duanxinBtn.layer.cornerRadius = 5;
//    [self addSubview:_duanxinBtn];
//    _duanxinBtn.sd_layout
//    .topEqualToView(self.pswImage)
//    .leftSpaceToView(_shu2,10)
//    .widthIs(70)
//    .heightIs(30);
//    
//    _heng1 = [UIView new];
//    _heng1.backgroundColor = [UIColor lightGrayColor];
//    [self addSubview:self.heng1];
//    _heng1.sd_layout.topSpaceToView(self.pswImage,10)
//    .leftSpaceToView(self,30)
//    .widthIs(kScreenWidth - 60)
//    .heightIs(1);
//    
//    _button = [UIButton buttonWithType:UIButtonTypeCustom];
//    _button.backgroundColor = kCustomColor(213.0, 213.0, 213.0);
//    [_button setTitle:@"下一步" forState:UIControlStateNormal];
//    _button.titleLabel.font = [UIFont systemFontOfSize:15];
//    _button.layer.cornerRadius = 5;
//    _button.clipsToBounds = YES;
//    [self addSubview:_button];
//    _button.sd_layout
//    .topSpaceToView(_heng1,30)
//    .leftSpaceToView(self,30)
//    .widthIs(kScreenWidth - 60)
//    .heightIs(45);
    
}

//获取验证码请求
- (void)passwordClick:(UIButton *)sender {
    NSLog(@"获取验证码");    
    if ([self isValidateMobile:_phoneTF.text] == NO) {
        [AlertView(@"温馨提示！", @"请核对手机号码", @"确定", nil) show];
    }else {
        __block int timeout = 59; //倒计时时间
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^ {
            if(timeout <= 0){ //倒计时结束，关闭
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^ {
                    //设置界面的按钮显示 根据自己需求设置
                    [_duanxinBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                    [_duanxinBtn setTitleColor:kCustomViewColor forState:UIControlStateNormal];
                    _duanxinBtn.userInteractionEnabled = YES;
                });
            } else {
                int seconds = timeout % 60;
                NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                dispatch_async(dispatch_get_main_queue(), ^ {
                    //设置界面的按钮显示 根据自己需求设置
                    NSLog(@"____%@",strTime);
                    [_duanxinBtn setTitle:[NSString stringWithFormat:@"%@秒后获取",strTime] forState:UIControlStateNormal];
                    [_duanxinBtn setTitleColor:kCustomColor(153, 153, 153) forState:UIControlStateNormal];
                    _duanxinBtn.userInteractionEnabled = NO;
                    
                });
                timeout--;
            }
        });
        dispatch_resume(_timer);
    }
    
}

/**
 *  正则表达式验证手机号
 *
 *  @param mobile 传入手机号
 *
 *  @return
 */
- (BOOL)isValidateMobile:(NSString *)mobile{
    //手机号以13、15、18开头，八个\d数字字符
    // 130-139  150-153,155-159  180-189  145,147  170,171,173,176,177,178
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0-9])|(14[57])|(17[013678]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}


- (void)phoneFieldDidChange:(UITextView *)textField {
    if (![_duanXinTF.text isEqualToString:@""] && ![_phoneTF.text isEqualToString:@""]) {
        self.button.backgroundColor = kCustomViewColor;
        self.phoneImage.image = [UIImage imageNamed:@"tb_1"];
        self.pswImage.image = [UIImage imageNamed:@"tb_2"];
        
        self.button.enabled = YES;
        
    } else {
        self.button.backgroundColor = kCustomColor(213.0, 213.0, 213.0);
        self.button.enabled = NO;
        
        if (![self.phoneTF.text isEqualToString:@""]) {
            self.phoneImage.image = [UIImage imageNamed:@"tb_1"];
        }else {
            self.phoneImage.image = [UIImage imageNamed:@"tb_02"];
        }
    }
}

- (void)textFieldDidChange:(UITextField *)textField {
    if (![_duanXinTF.text isEqualToString:@""] && ![_phoneTF.text isEqualToString:@""]) {
        self.button.backgroundColor = kCustomViewColor;
        self.pswImage.image = [UIImage imageNamed:@"tb_04"];
        self.button.enabled = YES;
        
    } else {
        if (![self.duanXinTF.text isEqualToString:@""]) {
            self.pswImage.image = [UIImage imageNamed:@"tb_04"];
            
        }else {
            self.button.backgroundColor = kCustomColor(213.0, 213.0, 213.0);
            
            self.pswImage.image = [UIImage imageNamed:@"tb_4"];
            self.button.enabled = NO;
            
        }
        
    }
}

@end
