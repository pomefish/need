//
//  LoginCustomView.h
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2017/6/15.
//  Copyright © 2017年 ShangKe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginCustomView : UIView

 //

@property (nonatomic,strong)UIImageView *niImage;
@property (nonatomic,strong)UITextField *niTF;
@property (nonatomic,strong)UIView *lineView;

@property (nonatomic, strong) UIImageView *logoImage;
@property (nonatomic, strong) UIImageView *phoneImage;
@property (nonatomic, strong) UIView *shu;
@property (nonatomic, strong) UITextField *phoneTF;
@property (nonatomic, strong) UIView *heng;
@property (nonatomic, strong) UIImageView *messageImage;
@property (nonatomic, strong) UIView *shu1;
@property (nonatomic, strong) UITextField *messageTF;
@property (nonatomic, strong) UIView *heng1;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIView *shu2;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *popBtn;
@property (nonatomic, strong) UIButton *duanxinBtn;
@property (nonatomic, strong) UIButton *agreementBtn;

@property (nonatomic, strong) UIImageView *pswImage;
@property (nonatomic, strong) UIView *shu3;
@property (nonatomic, strong) UITextField *pswTF;
@property (nonatomic, strong) UIView *heng3;

@property (nonatomic, strong) UILabel *promptLabel;

@property (nonatomic, strong) NSMutableArray *subjectsArr;

@property (nonatomic,copy)NSString *niText;//
- (instancetype)initWithFrame:(CGRect)frame;

@end
