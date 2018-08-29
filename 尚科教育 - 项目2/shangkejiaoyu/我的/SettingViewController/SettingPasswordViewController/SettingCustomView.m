//
//  SettingCustomView.m
//  mingtao
//
//  Created by Linlin Ge on 2016/12/27.
//  Copyright © 2016年 Linlin Ge. All rights reserved.
//

#import "SettingCustomView.h"
#import "TGHeader.h"

@implementation SettingCustomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initCustomCell];
    }
    return self;
}

- (void)initCustomCell {
//    UILabel *label = [UILabel new];
//    label.text = @"重置您的密码。";
//    label.font = [UIFont systemFontOfSize:13];
//    label.textColor = kCustomViewColor;
//    [self addSubview:label];
//    label.sd_layout.topSpaceToView(self,120).
//    leftSpaceToView(self,(kScreenWidth - 100)/2).
//    widthIs(100).heightIs(13);
//
//    _phoneImage = [UIImageView new];
//    _phoneImage.image = [UIImage imageNamed:@"tb_02"];
//    [self addSubview:self.phoneImage];
//    _phoneImage.sd_layout.topSpaceToView(label,40)
//    .leftSpaceToView(self,30)
//    .widthIs(30)
//    .heightIs(30);
//    
//    _shu = [UIView new];
//    _shu.backgroundColor = [UIColor lightGrayColor];
//    [self addSubview:self.shu];
//    _shu.sd_layout.topEqualToView(self.phoneImage)
//    .leftSpaceToView(_phoneImage,10)
//    .widthIs(1)
//    .heightIs(30);
//    
//    _pswTF = [UITextField new];
//    _pswTF.placeholder = @"请输入密码";
//    [_pswTF addTarget:self action:@selector(phoneFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
//    [self addSubview:_pswTF];
//    _pswTF.sd_layout.
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
//    _pswImage.image = [UIImage imageNamed:@"tb_01"];
//    [self addSubview:self.pswImage];
//    _pswImage.sd_layout.topSpaceToView(self.heng,20)
//    .leftSpaceToView(self,30)
//    .widthIs(30)
//    .heightIs(30);
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
//    _duanXinTF.placeholder = @"请确认密码";
//    [_duanXinTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
//    [self addSubview:_duanXinTF];
//    _duanXinTF.sd_layout.
//    topSpaceToView(_heng,20).
//    leftSpaceToView(self.shu1,15).
//    widthIs(kScreenWidth - 150).
//    heightIs(30);
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
//    [_button setTitle:@"重置密码" forState:UIControlStateNormal];
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

- (void)phoneFieldDidChange:(UITextView *)textField {
    if (![_duanXinTF.text isEqualToString:@""] && ![_pswTF.text isEqualToString:@""]) {
        _button.backgroundColor = kCustomViewColor;
        //        _phoneImage.image = [UIImage imageNamed:@"tb_1"];
        _pswImage.image = [UIImage imageNamed:@"tb_2"];
        
    } else {
        _button.backgroundColor = [UIColor lightGrayColor];
        //        _phoneImage.image = [UIImage imageNamed:@"tb_02"];
        //        _pswImage.image = [UIImage imageNamed:@"tb_01"];
        
        if (![_pswTF.text isEqualToString:@""]) {
            _phoneImage.image = [UIImage imageNamed:@"tb_1"];
        }else {
            _phoneImage.image = [UIImage imageNamed:@"tb_02"];
        }
        
    }
}

- (void)textFieldDidChange:(UITextField *)textField {
    if (![_duanXinTF.text isEqualToString:@""] && ![_pswTF.text isEqualToString:@""]) {
        _button.backgroundColor = kCustomViewColor;
        //        _phoneImage.image = [UIImage imageNamed:@"tb_1"];
        _pswImage.image = [UIImage imageNamed:@"tb_2"];
        
    } else {
        _button.backgroundColor = kCustomColor(213.0, 213.0, 213.0);
        //        _phoneImage.image = [UIImage imageNamed:@"tb_02"];
        _pswImage.image = [UIImage imageNamed:@"tb_01"];
        
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
