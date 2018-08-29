//
//  CustomAlertView.m
//  mingtao
//
//  Created by Linlin Ge on 2017/6/6.
//  Copyright © 2017年 Linlin Ge. All rights reserved.
//

#import "CustomAlertView.h"
#define LCWINDOWS [UIScreen mainScreen].bounds.size

@interface CustomAlertView()<UITextFieldDelegate>
@property (nonatomic, strong) UIView *blackView;//背景半透明遮罩
@property (strong, nonatomic) UIView * alertview;//弹框
@property (nonatomic, strong) UILabel *nameLable;//姓名Lable
@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *idcardLable;//身份证号lable
@property (nonatomic, strong) UITextField *idcardTextFild;//身份证号输入号
@property (nonatomic, strong) UIButton *cancelButton;//取消按钮
@property (nonatomic, strong) UIButton *sureButton;//确定按钮
@property (nonatomic, strong) NSString *name;//原始姓名的参数
@property (nonatomic, strong) NSString *idnumber;//原始身份证号的参数
@property (nonatomic, strong) UILabel *line1Lable;//灰色横线
@property (nonatomic, strong) UILabel *line2Lable;//灰色竖线
@end
@implementation CustomAlertView

- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        _blackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, LCWINDOWS.width, LCWINDOWS.height+64)];
        _blackView.backgroundColor = [UIColor blackColor];
        _blackView.alpha = 0.5;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(blackClick)];
        tap.enabled=NO;
        [self.blackView addGestureRecognizer:tap];
        [self addSubview:_blackView];
        //创建alert
        self.alertview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 288, 165)];
        self.alertview.center = self.center;
        self.alertview.backgroundColor = [UIColor whiteColor];
        self.alertview.layer.cornerRadius = 3.0f;
        [self addSubview:_alertview];
        [self animationAlert:self.alertview];
    }
    return self;
}
//在弹框的view上布局添加子view(如果想改变弹框里面的view样式布局,在此方法中修改)
- (void)layoutSubviews{
    [super layoutSubviews];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 288, 50)];
    [self.alertview addSubview:view];
    
    _nameLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 288, 50)];
    _nameLable.textAlignment = NSTextAlignmentCenter;
    _nameLable.textColor = [self getColor:@"666666"];
    _nameLable.text = @"请输入邀请码:";
    _nameLable.adjustsFontSizeToFitWidth = YES;
    _nameLable.font = [UIFont systemFontOfSize:14];
    [view addSubview:_nameLable];
    
    _iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(view.frame) + 5, 16, 18)];
    _iconImage.image = [UIImage imageNamed:@"ic_login_pw"];
    [self.alertview addSubview:_iconImage];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImage.frame) + 5, CGRectGetMaxY(view.frame) + 5, 1, 20)];
    lineView.backgroundColor = [self getColor:@"e5e5e5"];
    [self.alertview addSubview:lineView];
    
    _idcardTextFild=[[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lineView.frame) + 5, CGRectGetMaxY(view.frame) + 5, 235, 20)];
    _idcardTextFild.textAlignment = NSTextAlignmentLeft;
    _idcardTextFild.borderStyle = UITextBorderStyleNone;
    _idcardTextFild.placeholder = @"请输入邀请码";
    [_idcardTextFild setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    [_idcardTextFild addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _idcardTextFild.layer.borderColor=[self getColor:@"dadada"].CGColor;
    _idcardTextFild.textColor=[UIColor blackColor];
    _idcardTextFild.secureTextEntry=NO;
    _idcardTextFild.delegate=self;
    _idcardTextFild.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.alertview addSubview:_idcardTextFild];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_idcardTextFild.frame) + 6, 288 - 30, 1)];
    lineView1.backgroundColor = [self getColor:@"e5e5e5"];
    [self.alertview addSubview:lineView1];
    
    _idcardLable=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_idcardTextFild.frame) + 10, 288, 30)];
    _idcardLable.font = [UIFont systemFontOfSize:12];
    _idcardLable.textAlignment = NSTextAlignmentCenter;
    _idcardLable.textColor=[self getColor:@"ff9600"];
//    _idcardLable.text = @"跳过后你可以在“个人中心”里找到我";
    _idcardLable.adjustsFontSizeToFitWidth=YES;
    [self.alertview addSubview:_idcardLable];
    
    
    _line1Lable=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_idcardLable.frame) + 1, self.alertview.bounds.size.width, 1)];
    _line1Lable.backgroundColor=[self getColor:@"e5e5e5"];
    [self.alertview addSubview:_line1Lable];
    _line2Lable=[[UILabel alloc]initWithFrame:CGRectMake(self.alertview.bounds.size.width/2-0.5, CGRectGetMaxY(_line1Lable.frame), 1, 40)];
    _line2Lable.backgroundColor=[self getColor:@"e5e5e5"];
    [self.alertview addSubview:_line2Lable];
    
    _cancelButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _cancelButton.backgroundColor=[UIColor whiteColor];
    _cancelButton.frame=CGRectMake(0, CGRectGetMaxY(_idcardLable.frame) + 5, self.alertview.bounds.size.width/2-0.5, 35);
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    _cancelButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_cancelButton setTitleColor:[self getColor:@"333333"] forState:UIControlStateNormal];
    [_cancelButton setBackgroundColor:[UIColor whiteColor]];
    [_cancelButton addTarget:self action:@selector(cancelBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.alertview addSubview:_cancelButton];
    
    _sureButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _sureButton.backgroundColor=[UIColor whiteColor];
    _sureButton.frame=CGRectMake(self.alertview.bounds.size.width/2+0.2, CGRectGetMaxY(_idcardLable.frame) + 5, self.alertview.bounds.size.width/2, 35);
    _sureButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [_sureButton setBackgroundColor:[UIColor whiteColor]];
    [_sureButton setTitleColor:kCustomViewColor forState:UIControlStateNormal];
    [_sureButton addTarget:self action:@selector(sureBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.alertview addSubview:_sureButton];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return YES;
}
//背景遮罩加点击手势,不做任何的处理
- (void)blackClick{
    
}
//创建
+(instancetype)alertViewWithCancelbtnClicked:(cancelBlock) cancelBlock andSureBtnClicked:(sureBlock) sureBlock withName:(NSString *)name withidcard:(NSString *)idnumber{
    CustomAlertView *alertView=[[CustomAlertView alloc]initWithFrame:CGRectMake(0, 0, LCWINDOWS.width,LCWINDOWS.height)];
    alertView.center=CGPointMake(LCWINDOWS.width/2, LCWINDOWS.height/2-64);//view的中点
    alertView.cancel_block=cancelBlock;//取消block
    alertView.sure_block=sureBlock;//确定block
    alertView.name=[NSString stringWithFormat:@"%@",name];//将传入的姓名参数接收
    alertView.idnumber=[NSString stringWithFormat:@"%@",idnumber];//将传入的身份证号参数接收
    
    return alertView;
    
}
//name字符串属性重写(注意:NSString类型的属性都要重写,不然会出现无法显示到界面的情况)
- (void)setName:(NSString *)name{
    
    _name=[NSString stringWithFormat:@"%@",name];
}
//idnumber字符串属性重写
- (void)setIdnumber:(NSString *)idnumber{
    
    _idnumber=[NSString stringWithFormat:@"%@",idnumber];
}
//取消按钮点击
- (void)cancelBtnClicked{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha=0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.alertview=nil;
        self.cancel_block();
    }];
    
    
}
//确定按钮点击
- (void)sureBtnClicked{
    //如果输入的姓名和身份证号不符合正则表达式,则return;(这里不做验证,请根据项目需求修改)
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha=0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.alertview = nil;
        
        //将新输入的姓名和身份证号值传出去.
        self.sure_block(_idcardTextFild.text,_idcardTextFild.text);
    }];
    
}

//弹框动画自定义(可以修改参数改变动画)
- (void)animationAlert:(UIView *)view{
    CAKeyframeAnimation *popAnimation=[CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration=0.6;
    popAnimation.values=@[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],[NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes=@[@0.0f,@0.5f,@0.75f];
    popAnimation.timingFunctions=@[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [view.layer addAnimation:popAnimation forKey:nil];
    
}

- (void)textFieldDidChange:(UITextField *)textField {
    if (textField.text == nil) {
        _iconImage.image = [UIImage imageNamed:@"ic_login_pw"];
    }else {
        _iconImage.image = [UIImage imageNamed:@"ic_login_pwing"];
    }
}

//十六进制颜色转换
- (UIColor *)getColor:(NSString*)hexColor
{
    unsigned int red,green,blue;
    NSRange range;
    range.length = 2;
    
    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&red];
    
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&green];
    
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f)green:(float)(green / 255.0f) blue:(float)(blue / 255.0f)alpha:1.0f];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
