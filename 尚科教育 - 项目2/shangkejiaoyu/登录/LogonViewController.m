//
//  LogonViewController.m
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2017/6/15.
//  Copyright © 2017年 ShangKe. All rights reserved.
//

#import "LogonViewController.h"
#import "LogonCustomView.h"
#import "RootView.h"
#import "LoginViewController.h"
#import "CompanyLoginViewController.h"

@interface LogonViewController () <UITextFieldDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) LogonCustomView *logonView;
@property (nonatomic, strong) UIImageView     *bgImage;
@property (nonatomic,copy)NSString *tag;
@property (nonatomic,strong)NSDictionary  *dic;
@end

@implementation LogonViewController

- (UIImageView *)bgImage {
    if (!_bgImage) {
        self.bgImage = [UIImageView new];
        self.bgImage.frame = self.view.frame;
        self.bgImage.image = [UIImage imageNamed:@"bj"];
    }
    return _bgImage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.barTintColor = kCustomNavColor;
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:16],
       
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    leftBarButton(@"returnImage");
    
    [self.view addSubview:self.bgImage];
    
    _logonView = [[LogonCustomView alloc] initWithFrame:self.view.frame];
    _logonView.pswTF.returnKeyType = UIReturnKeyDefault;
    _logonView.pswTF.delegate = self;
    _logonView.phoneTF.delegate = self;
    [_logonView.logonButton addTarget:self action:@selector(logon:) forControlEvents:UIControlEventTouchUpInside];
    [_logonView.button addTarget:self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];
    [_logonView.forgetBtn addTarget:self action:@selector(forgetBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //游客登录
    [_logonView.touristsBtn addTarget:self action:@selector(touristsBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    [_logonView.pswTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_logonView.phoneTF addTarget:self action:@selector(phoneFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self.view addSubview:_logonView];
    
}

//登录
- (void)button:(UIButton *)sender {
    NSLog(@"登录");
    if ([_logonView.phoneTF.text isEqualToString:@""] && [_logonView.pswTF.text isEqualToString:@""]) {
        [AlertView(@"温馨提示", @"账号密码不能为空！", @"确定", nil) show];
        
    }else {
        [self dismissViewControllerAnimated:YES completion:nil];
        
        //个人登录
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/login"];

        self.dic = @{
                     @"tel":_logonView.phoneTF.text,
                     @"password":_logonView.pswTF.text
                     };
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"token"];
        [HttpRequest postWithURLString:urlStr parameters:_dic success:^(id success) {
            NSLog(@"-dddd--------%@",success);
            NSString *statuStr = [NSString stringWithFormat:@"%@",success[@"status"]];
            
            if ([statuStr isEqualToString:@"1"]) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [[NSUserDefaults standardUserDefaults] setObject:success[@"user_id"] forKey:@"userID"];
                [[NSUserDefaults standardUserDefaults]  setObject:success[@"token"] forKey:@"token"];
                [[NSUserDefaults standardUserDefaults] setObject:_logonView.pswTF.text forKey:@"userPsw"];
                [[NSUserDefaults standardUserDefaults] setObject:_logonView.phoneTF.text forKey:@"userPhone"];
                //个性签名
                if (![success[@"remark"] isKindOfClass:[NSNull class]]) {
                    [[NSUserDefaults standardUserDefaults] setObject:success[@"remark"] forKey:@"remark"];
                }
                //邀请码
                if (![success[@"invitation_code"] isKindOfClass:[NSNull class]]) {
                    [[NSUserDefaults standardUserDefaults] setObject:success[@"invitation_code"] forKey:@"invitation_code"];
                }
                //头像
                if (![success[@"avatar"] isKindOfClass:[NSNull class]]) {
                    [[NSUserDefaults standardUserDefaults] setObject:success[@"avatar"] forKey:@"avatar"];
                }
                //昵称
                if (![success[@"name"] isKindOfClass:[NSNull class]]) {
                    [[NSUserDefaults standardUserDefaults] setObject:success[@"name"] forKey:@"name"];
                }
                
                
                [[NSUserDefaults standardUserDefaults] setObject:success[@"telephone"] forKey:@"telephone"];
                
               
                [RootView logonRootView];
            }
            else{
                 if ([success[@"code"] isEqualToNumber:@200]){
                    //                [AlertView(@"温馨提示", @"该账号已被登录，继续登录吗？", @"确定", @"取消") show];
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                                    message: @"该账号已被登录，继续登录吗？"
                                                                   delegate:self
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:@"取消",nil];
                    alert.tag = 1;
                    [alert show];
                    
                 } else{
                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                NSString *msg = [NSString stringWithFormat:@"%@",success[@"msg"]];
                [MBProgressHUD showMessage:msg toView:self.view delay:1.0];
                     
                
                 }
            }
            

            
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showMessage:@"登录失败！" toView:self.view delay:1.0];
        }];
    }
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"clickButtonAtIndex:%d",buttonIndex);
    if (alertView.tag == 1) {
        if (0 == buttonIndex) {
            if ([_logonView.phoneTF.text isEqualToString:@""] && [_logonView.pswTF.text isEqualToString:@""]) {
                [AlertView(@"温馨提示", @"账号密码不能为空！", @"确定", nil) show];
                
            }else {
                [self dismissViewControllerAnimated:YES completion:nil];
                self.tag = @"2";
                //个人登录
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                
                NSString *urlStr = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/login"];
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"token"];
                NSDictionary *dic = @{
                                    @"tel":_logonView.phoneTF.text,
                                      @"password":_logonView.pswTF.text,
                                      @"cleanToken":@"true"
                                      };
                [HttpRequest postWithURLString:urlStr parameters:dic success:^(id success) {
                    NSLog(@"登录---------%@",success);
                    if ([success[@"code"] isEqualToNumber:@1]) {
                        [[NSUserDefaults standardUserDefaults] setObject:success[@"user_id"] forKey:@"userID"];
                         [[NSUserDefaults standardUserDefaults]  setObject:success[@"token"] forKey:@"token"];
                        [[NSUserDefaults standardUserDefaults] setObject:_logonView.pswTF.text forKey:@"userPsw"];
                        [[NSUserDefaults standardUserDefaults] setObject:_logonView.phoneTF.text forKey:@"userPhone"];
                        //个性签名
                        if (![success[@"remark"] isKindOfClass:[NSNull class]]) {
                            [[NSUserDefaults standardUserDefaults] setObject:success[@"remark"] forKey:@"remark"];
                        }
                        //邀请码
                        if (![success[@"invitation_code"] isKindOfClass:[NSNull class]]) {
                            [[NSUserDefaults standardUserDefaults] setObject:success[@"invitation_code"] forKey:@"invitation_code"];
                        }
                        //头像
                        if (![success[@"avatar"] isKindOfClass:[NSNull class]]) {
                            [[NSUserDefaults standardUserDefaults] setObject:success[@"avatar"] forKey:@"avatar"];
                        }
                        //昵称
                        if (![success[@"name"] isKindOfClass:[NSNull class]]) {
                            [[NSUserDefaults standardUserDefaults] setObject:success[@"name"] forKey:@"name"];
                        }
                        
                    
                        [[NSUserDefaults standardUserDefaults] setObject:success[@"telephone"] forKey:@"telephone"];
                       
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        [RootView logonRootView];
                        
                    }else if ([success[@"code"] isEqualToNumber:@2]) {
                        [AlertView(@"温馨提示", @"密码错误！", @"确定", nil) show];
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                    }else if ([success[@"code"] isEqualToNumber:@3]) {
                        [AlertView(@"温馨提示", @"账号不存在！", @"确定", nil) show];
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                    }else if ([success[@"code"] isEqualToNumber:@200]){
                        //                [AlertView(@"温馨提示", @"该账号已被登录，继续登录吗？", @"确定", @"取消") show];
                        
                        
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                                        message: @"该账号已被登录，继续登录吗？"
                                                                       delegate:self
                                                              cancelButtonTitle:@"确定"
                                                              otherButtonTitles:@"取消",nil];
                        
                        [alert show];
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                    }
                    
                } failure:^(NSError *error) {
                    NSLog(@"%@",error);
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [MBProgressHUD showMessage:@"登录失败！" toView:self.view delay:1.0];
                }];
            }
        }else{
            
        }
    }
   
}


#pragma mark -- 游客登录
- (void)touristsBtnClick:(UIButton *)sender {
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"userID"];
    [RootView logonRootView];
}
//键盘return事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [UIView animateWithDuration: 0.3 delay: 0.15 options: UIViewAnimationOptionCurveEaseInOut animations: ^{
        _logonView.frame = self.view.frame;
        _logonView.headImage.frame = CGRectMake(kScreenWidth / 2 - 40, 100, 80, 80);
        
        _logonView.logonButton.frame = CGRectMake(kScreenWidth/2 - 75, CGRectGetMaxY(_logonView.button.frame) + 25, 150, 35);
        _logonView.forgetBtn.frame = CGRectMake(kScreenWidth /2 - 40, CGRectGetMaxY(_logonView.button.frame) + 25, 0, 0);
    } completion: ^(BOOL finished) {
        
        [textField endEditing:NO];
    }];
    
    return YES;
}

//注册
- (void)logon:(UIButton *)sender {
    NSLog(@"--------------%@",sender.titleLabel.text);
    
    LoginViewController *loginVC = [[LoginViewController alloc]init];
    loginVC.titleLabel = sender.titleLabel.text;
    
    [self.navigationController pushViewController:loginVC animated:NO];

}

//textField点击事件
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    [UIView animateWithDuration: 0.3 delay: 0.15 options: UIViewAnimationOptionCurveEaseInOut animations: ^{
        
        _logonView.frame = CGRectMake(0, - 80, kScreenWidth, kScreenHeight);
        _logonView.headImage.frame = CGRectMake(kScreenWidth/ 2, 140, 0, 0);
        //        _logonView.logonButton.frame = CGRectMake(kScreenWidth/2, CGRectGetMaxY(_logonView.button.frame) + 25, 0, 0);
        //        _logonView.logonButton.hidden = YES;
        //        _logonView.forgetBtn.frame = CGRectMake(kScreenWidth /2 - 40, CGRectGetMaxY(_logonView.button.frame) + 25, 80, 35);
        //        _logonView.forgetBtn.hidden = NO;
        //        [_logonView.logonButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    } completion: ^(BOOL finished) {
        
    }];
    
    //开始编辑时触发，文本字段将成为first responder
    
}

//忘记密码
- (void)forgetBtnClick:(UIButton *)sender {
    
    CompanyLoginViewController *completeVC = [[CompanyLoginViewController alloc]init];
    completeVC.titleLabel = sender.titleLabel.text;
    [self.navigationController pushViewController:completeVC animated:NO];
}

- (void)leftButton:(UIButton *)sender {
    
       [self dismissViewControllerAnimated:YES completion:nil];
    
}

//视图将要出现时 调用此方法
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    //    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event  {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [UIView animateWithDuration: 0.3 delay: 0.15 options: UIViewAnimationOptionCurveEaseInOut animations: ^{
        _logonView.frame = self.view.frame;
        _logonView.headImage.frame = CGRectMake(kScreenWidth / 2 - 40, 100, 80, 80);
        
        [_logonView.logonButton setTitle:@"没有账号，快去注册！" forState:UIControlStateNormal];
        
    } completion: ^(BOOL finished) {
        
        [self.view endEditing:NO];
        
    }];
    
}

- (void)phoneFieldDidChange:(UITextField *)textField {
    
    if (![_logonView.pswTF.text isEqualToString:@""] && ![_logonView.phoneTF.text isEqualToString:@""]) {
        _logonView.button.backgroundColor = kCustomViewColor;
        [_logonView.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _logonView.phoneImage.image = [UIImage imageNamed:@"accountNumberBright"];
        _logonView.pswImage.image = [UIImage imageNamed:@"pswBright"];
        _logonView.button.enabled = YES;
    } else {
        //        self.button.backgroundColor = kCustomColor(213.0, 213.0, 213.0);
        _logonView.button.enabled = NO;
        
        if (![_logonView.phoneTF.text isEqualToString:@""]) {
            _logonView.phoneImage.image = [UIImage imageNamed:@"accountNumberBright"];
        }else {
            _logonView.phoneImage.image = [UIImage imageNamed:@"accountNumber"];
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

- (void)textFieldDidChange:(UITextField *)textField {
    
    if (![_logonView.pswTF.text isEqualToString:@""] && ![_logonView.phoneTF.text isEqualToString:@""]) {
        _logonView.button.backgroundColor = kCustomViewColor;
        [_logonView.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _logonView.pswImage.image = [UIImage imageNamed:@"pswBright"];
        _logonView.button.enabled = YES;
    } else {
        if (![_logonView.pswTF.text isEqualToString:@""]) {
            _logonView.pswImage.image = [UIImage imageNamed:@"pswBright"];
            
        }else {
            _logonView.pswImage.image = [UIImage imageNamed:@"psw"];
            _logonView.button.enabled = NO;
            
        }
    }
    
    //限制textField字数
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
