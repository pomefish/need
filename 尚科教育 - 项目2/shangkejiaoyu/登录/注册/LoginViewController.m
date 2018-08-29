//
//  LoginViewController.m
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2017/6/15.
//  Copyright © 2017年 ShangKe. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginCustomView.h"
#import "RootView.h"
#import "AgreementViewController.h"

@interface LoginViewController ()
@property (nonatomic, strong) LoginCustomView *loginView;
@property (nonatomic, strong) NSString *isPersonal;

@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) UIImageView *selectImage;
@property (nonatomic, strong) NSMutableArray *arr;

@property (nonatomic, strong) NSMutableArray *catDesc;
@property (nonatomic, strong) NSMutableArray *catID;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = kCustomNavColor;
    leftBarButton(@"returnImage");
    self.tabBarController.tabBar.hidden = YES;
    
    _arr = [NSMutableArray array];

//    if ([_titleLabel isEqualToString:@"没有账号，快去注册！"]) {
        self.title = @"注册账号";
        _isPersonal = @"1";
//    }else if ([_titleLabel isEqualToString:@"忘记密码"]) {
//        self.title = @"忘记密码";
//        _isPersonal = @"2";
//        [_loginView.button setTitle:@"找回密码" forState:UIControlStateNormal];
//        _loginView.agreementBtn.hidden = YES;
//        _loginView.label.hidden = YES;
//    }
    [self getSubjectsRequest];
    _loginView = [[LoginCustomView alloc] initWithFrame:self.view.frame];

    [_loginView.popBtn addTarget:self action:@selector(leftButton:) forControlEvents:UIControlEventTouchUpInside];
    [_loginView.button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_loginView.duanxinBtn addTarget:self action:@selector(duanxinBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_loginView.agreementBtn addTarget:self action:@selector(agreementBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _loginView.button.enabled = YES;
    [self.view addSubview:_loginView];

}

- (void)getSubjectsRequest {
    _catDesc = [NSMutableArray array];
    _catID = [NSMutableArray array];
    
    NSString *str = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/subjects"];
    NSDictionary *dic = @{
                          };
    [HttpRequest postWithURLString:str parameters:dic success:^(id success) {
        NSLog(@"-----get------%@",success);
        for (NSDictionary *dict in success[@"body"]) {
            [_catDesc addObject:dict[@"cat_desc"]];
            [_catID addObject:dict[@"cat_id"]];
        }
        NSLog(@"--_catDesc-------------%@",_catDesc);
        NSLog(@"--_catID-------------%@",_catID);
        [self addSubjectsUI:_catDesc];
    } failure:^(NSError *error) {
        NSLog(@"--get-----%@",error);
    }];
    _loginView.subjectsArr = _catID;
}

- (void)addSubjectsUI:(NSArray *)subjectsArr {
    for (NSInteger  i = 0; i < subjectsArr.count ; i++ ) {
        _selectImage = [UIImageView new];
        _selectImage.frame = CGRectMake(13+(kScreenWidth/2.2+10)*(i%2), CGRectGetMaxY(_loginView.promptLabel.frame) + 12 + (25+10)*(i/2), 20, 20);
        _selectImage.image = [UIImage imageNamed:@"noSelectImage"];
        _selectImage.tag = 1000 + i;
        [_loginView addSubview:self.selectImage];
        
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectBtn.frame = CGRectMake(10+(kScreenWidth/2.2+10)*(i%2), CGRectGetMaxY(_loginView.promptLabel.frame) + 8 + (25+10)*(i/2), kScreenWidth/2.2, 25);
        _selectBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _selectBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_selectBtn setTitle:subjectsArr[i] forState:UIControlStateNormal];
        _selectBtn.tag = 100 + i;
        [_selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _selectBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
        //button.frame = CGRectMake(按钮距离屏幕最左侧的距离+（按钮的宽+两个按钮的距离）*（i%按钮列数），按钮距离屏幕最上侧的距离+（按钮的高+两个按钮的上下距离）*（i/按钮列数），按钮的宽，按钮的高)；
        [_selectBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_loginView addSubview:self.selectBtn];
    }
    _loginView.button.frame = CGRectMake(15, CGRectGetMaxY(self.selectBtn.frame) + 20, kScreenWidth - 30, 45);

}

- (void)selectBtnClick:(UIButton *)btn{

//    多选
    if (!btn.selected) {
        UIImageView *image = (UIImageView *)[self.view viewWithTag:1000 + btn.tag - 100];
        image.image = [UIImage imageNamed:@"selectImage"];
        [_arr addObject:_catDesc[btn.tag - 100]];
    }else{
        UIImageView *image = (UIImageView *)[self.view viewWithTag:1000 + btn.tag - 100];
        image.image = [UIImage imageNamed:@"noSelectImage"];
        if ([_arr containsObject:_catDesc[btn.tag - 100]]) {
            [_arr removeObject:_catDesc[btn.tag - 100]];
        }
    }
    btn.selected = !btn.selected;
    NSLog(@"%@", _arr.description);
    if (_arr.count <= 0) {
        _loginView.button.backgroundColor = kCustomColor(213.0, 213.0, 213.0);
        _loginView.button.enabled = NO;

    }else {
        _loginView.button.enabled = YES;
        _loginView.button.backgroundColor = kCustomViewColor;
        
    }
    
    NSLog(@"点击了第%ld 个按钮", (long)btn.tag - 100);
}

- (void)buttonClick:(UIButton *)sender {
    if ( ![_loginView.phoneTF.text isEqualToString:@""] && ![_loginView.messageTF.text isEqualToString:@""] ) {
        if ([_loginView.pswTF.text length] > 18 && [_loginView.pswTF.text length] < 6) {
            [MBProgressHUD showMessage:@"密码位数为6~18，请重新输入" toView:self.view delay:1.0];
        }else {
//            if ([_isPersonal isEqualToString:@"1"]) {
            NSString *subjects = [_arr componentsJoinedByString:@","];
                //个人账号注册
                NSString *urlStr = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/zhuce"];
                NSDictionary *dic = @{@"mobile":_loginView.phoneTF.text,
                                      @"password":_loginView.pswTF.text,
                                      @"sms_code":_loginView.messageTF.text,
                                      @"name":_loginView.niTF.text,
                                      @"remark" : subjects
                                      };
                [HttpRequest postWithURLString:urlStr parameters:dic success:^(id success) {
                    NSLog(@"注册个人账号%@",success);
//                    if ([success[@"msg"] isEqualToString:@"注册成功"]) {
//                        [self.navigationController popToRootViewControllerAnimated:YES];
//                    }
//                    返回code ：1--请填写正确的手机号，2--手机号已注册，3验证码过期了，请重新获取，4--验证码错误 5--注册成功，6注册失败
                    NSString *statuStr = [NSString stringWithFormat:@"%@",success[@"status"]];
                    
                    if ([statuStr isEqualToString:@"1"]) {
                        NSLog(@"注册成功！");
                        [MBProgressHUD showMessage:@"注册成功！" toView:self.view delay:1.0];
                        //                        [self logonChatAccountNumber:_isPersonal];
                        
                        /*---------------存储用户登录信息---------*/
                        //                        NSString *usrID = bodyDic[@"uid"];
                        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                        [userDefaults setObject:success[@"uid"] forKey:@"userID"];
                        [userDefaults setObject:_loginView.pswTF.text forKey:@"userPsw"];
                        [userDefaults setObject:_loginView.phoneTF.text forKey:@"userPhone"];
                        [userDefaults setObject:success[@"invitation_code"] forKey:@"invitation_code"];
                        //存储昵称
                        [userDefaults setObject:_loginView.niTF.text forKey:@"nikName"];
                  
                        //invitation显示
                        [userDefaults setObject:@"1" forKey:@"invitationHidden"];
                        
                        [RootView logonRootView];
                    }else{
                        NSString *msg = [NSString stringWithFormat:@"%@",success[@"msg"]];
                        [MBProgressHUD showMessage:msg toView:self.view delay:1.0];
                        
                    }
                    
//                    if ([success[@"code"] isEqualToNumber:@2]) {
//                        NSLog(@"手机号已经注册");
//                        [MBProgressHUD showMessage:@"手机号已经注册！" toView:self.view delay:1.0];
//                    }else if ([success[@"code"] isEqualToNumber:@3]) {
//                        NSLog(@"验证码过期了，请重新获取！");
//                        [MBProgressHUD showMessage:@"验证码过期了，请重新获取！" toView:self.view delay:1.0];
//                    }else if ([success[@"code"] isEqualToNumber:@4]) {
//                        NSLog(@"验证错误！");
//                        [MBProgressHUD showMessage:@"验证码错误！" toView:self.view delay:1.0];
//                    }else if ([success[@"code"] isEqualToNumber:@5]) {
//                        NSLog(@"注册成功！");
//                        [MBProgressHUD showMessage:@"注册成功！" toView:self.view delay:1.0];
////                        [self logonChatAccountNumber:_isPersonal];
//                        
//                        /*---------------存储用户登录信息---------*/
////                        NSString *usrID = bodyDic[@"uid"];
//                        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//                        [userDefaults setObject:success[@"uid"] forKey:@"userID"];
//                        [userDefaults setObject:_loginView.pswTF.text forKey:@"userPsw"];
//                        [userDefaults setObject:_loginView.phoneTF.text forKey:@"userPhone"];
//                        [userDefaults setObject:success[@"invitation_code"] forKey:@"invitation_code"];
//                        //存储昵称
//                         [userDefaults setObject:_loginView.niTF.text forKey:@"nikName"];
////                        if (![bodyDic[@"remark"] isKindOfClass:[NSNull class]]) {
////                            [userID setObject:bodyDic[@"remark"] forKey:@"remark"];
////                            
////                        }
////                        if (![bodyDic[@"avatar"] isKindOfClass:[NSNull class]]) {
////                            [userID setObject:bodyDic[@"avatar"] forKey:@"avatar"];
////                        }
////                        NSString *nickName = [bodyDic[@"nickname"] isKindOfClass:[NSNull class]] ? bodyDic[@"username"] : bodyDic[@"nickname"];
////                        [userID setObject:nickName forKey:@"nickname"];
//                        /*----------------存储用户登录信息------------*/
//                        //invitation显示
//                        [userDefaults setObject:@"1" forKey:@"invitationHidden"];
//                        
//                        [RootView logonRootView];
//                        
//                        
////                        2017-06-19 10:18:14.186 shangkejiaoyu[97537:9217119] 注册个人账号{
////                            code = 5;
////                            "invitation_code" = 5089940574;
////                            ret =     {
////                                action = post;
////                                application = "1231e660-3070-11e7-b10b-d97b35d1a573";
////                                applicationName = epin;
////                                duration = 0;
////                                entities =         (
////                                                    {
////                                                        activated = 1;
////                                                        created = 1497838693672;
////                                                        modified = 1497838693672;
////                                                        type = user;
////                                                        username = p15899900099;
////                                                        uuid = "8c2d2a80-5495-11e7-9e45-cfec1eacd5d5";
////                                                    }
////                                                    );
////                                organization = 1120170504115008;
////                                path = "/users";
////                                timestamp = 1497838693677;
////                                uri = "https://a1.easemob.com/1120170504115008/epin/users";
////                            };
////                            status = 1;
////                            uid = 77;
////                        }
//                        
//                    }else if ([success[@"code"] isEqualToNumber:@6]) {
//                        NSLog(@"注册失败！");
//                        [MBProgressHUD showMessage:@"注册失败！" toView:self.view delay:1.0];
//                    }
                    if ([success[@"msg"] isEqualToString:@"验证码错误!"]) {
                        [MBProgressHUD showMessage:@"验证码错误！" toView:self.view delay:1.0];
                    }
            } failure:^(NSError *error) {
                    NSLog(@"%@",error);
                    
                }];
                NSLog(@"--------注册个人账号------");
                NSLog(@"-------%@----",_isPersonal);
                
//            }
//            if ([_isPersonal isEqualToString:@"2"]) {
//                //修改个人密码
//                NSString *urlStr = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/ForgetName_psd"];
//                NSDictionary *dic = @{@"mobile":_loginView.phoneTF.text,
//                                      @"password":_loginView.pswTF.text,
//                                      @"sms_code":_loginView.messageTF.text
//                                      
//                                      };
//                [HttpRequest postWithURLString:urlStr parameters:dic success:^(id success) {
//                    NSLog(@"修改个人密码%@",success);
////                    返回code ：1--请填写正确的手机号，2--手机号不能为空，3--密码不能为空；4--手机号未注册，5--修改成功，6--修改失败，7--验证码不为空，8--验证码错误
//                    if ([success[@"code"] isEqualToNumber:@4]) {
//                        [MBProgressHUD showMessage:@"手机号未注册！" toView:self.view delay:1.0];
//                    }else if ([success[@"code"] isEqualToNumber:@5]) {
//                        [MBProgressHUD showMessage:@"修改成功！" toView:self.view delay:1.0];
//                        [self.navigationController popViewControllerAnimated:YES];
//                    }else if ([success[@"code"] isEqualToNumber:@6]) {
//                        [MBProgressHUD showMessage:@"修改失败！" toView:self.view delay:1.0];
//                    }else if ([success[@"code"] isEqualToNumber:@8]) {
//                        [MBProgressHUD showMessage:@"验证码错误！" toView:self.view delay:1.0];
//                    }
//                } failure:^(NSError *error) {
//                    NSLog(@"%@",error);
//                }];
//                NSLog(@"------忘记个人密码-------");
//                NSLog(@"-------%@----",_isPersonal);
//            }
        }
        
    }else {
        [AlertView(@"请输入手机号及验证码", nil, @"确定", nil) show];
    }
    
}

- (void)duanxinBtnClick:(UIButton *)sender {
    NSLog(@"获取验证码");
    if ([self isValidateMobile:_loginView.phoneTF.text] == NO) {
        [AlertView(@"请输入正确的手机号！", nil, @"确定", nil) show];
        
    }else {
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/Ajax_sendSMS"];
        NSDictionary *dic = @{
                              @"mobile":_loginView.phoneTF.text,
                              @"type":_isPersonal
                              };
        [HttpRequest postWithURLString:urlStr parameters:dic success:^(id success) {
            NSLog(@"%@",success);
            //返回code ： 1--手机不能为空；2--该手机号已被注册,3--该用户不存在；4--今日请求次数过多，请稍后再试！,5--短信发送成功；6--短信发送未知错误
             NSString *statuStr = [NSString stringWithFormat:@"%@",success[@"status"]];
            if ([statuStr isEqualToString:@"1"]) {
                NSLog(@"短信发送成功！");
                [self reduceTiome];
            }else{
                NSString *msg = [NSString stringWithFormat:@"%@",success[@"msg"]];
                [MBProgressHUD showMessage:msg toView:self.view delay:1.0];
            }
//            if ([success[@"code"] isEqualToNumber:@2]) {
//                NSLog(@"该手机号已被注册");
//                [MBProgressHUD showMessage:@"该手机号已被注册！" toView:self.view delay:1.0];
//            }else if ([success[@"code"] isEqualToNumber:@3]) {
//                [MBProgressHUD showMessage:@"该用户不存在！" toView:self.view delay:1.0];
//            }else if ([success[@"code"] isEqualToNumber:@4]) {
//                [MBProgressHUD showMessage:@"今日请求次数过多，请稍后再试！" toView:self.view delay:1.0];
//            }else if ([success[@"code"] isEqualToNumber:@5]) {
//                NSLog(@"短信发送成功！");
//                [self reduceTiome];
//            }else if ([success[@"code"] isEqualToNumber:@1]){
//
//                [MBProgressHUD showMessage:@"手机号不能为空！" toView:self.view delay:1.0];
//            }
//            else{
//                 [MBProgressHUD showMessage:@"短信发送未知错误！" toView:self.view delay:1.0];
//            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
            
        }];
    }
}
- (void)reduceTiome {
    __block int timeout = 59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^ {
        if(timeout <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^ {
                //设置界面的按钮显示 根据自己需求设置
                [_loginView.duanxinBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                [_loginView.duanxinBtn setTitleColor:kCustomViewColor forState:UIControlStateNormal];
                _loginView.duanxinBtn.userInteractionEnabled = YES;
            });
        } else {
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^ {
                //设置界面的按钮显示 根据自己需求设置
//                NSLog(@"____%@",strTime);
                [_loginView.duanxinBtn setTitle:[NSString stringWithFormat:@"%@秒后获取",strTime] forState:UIControlStateNormal];
                [_loginView.duanxinBtn setTitleColor:kCustomColor(153, 153, 153) forState:UIControlStateNormal];
                _loginView.duanxinBtn.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
}

#pragma mark -------环信登录
//- (void)logonChatAccountNumber:(NSString *)isPersonal {
//    NSString *personal;
//    if ([isPersonal isEqualToString:@"1"]) {
//        personal = @"p";
//    }else {
//        personal = @"e";
//    }
//    EMError *loginError = [[EMClient sharedClient] loginWithUsername:[NSString stringWithFormat:@"%@%@",personal,_loginView.phoneTF.text] password:_loginView.pswTF.text];
//    if (!loginError) {
//        NSLog(@"环信登录成功");
//        [[EMClient sharedClient].options setIsAutoLogin:YES];
//    }else {
//        NSLog(@"环信登录失败");
//    }
//    
//}

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


- (void)agreementBtnClick:(UIButton *)sender {
    AgreementViewController *agreementVC = [[AgreementViewController alloc] init];
    [self.navigationController pushViewController:agreementVC animated:YES];
}

- (void)leftButton:(UIButton *)sender {
    
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event  {
    [self.view endEditing:NO];
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
