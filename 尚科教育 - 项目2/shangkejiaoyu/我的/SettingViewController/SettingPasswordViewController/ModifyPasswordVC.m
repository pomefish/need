//
//  ModifyPasswordVC.m
//  mingtao
//
//  Created by Linlin Ge on 2017/4/13.
//  Copyright © 2017年 Linlin Ge. All rights reserved.
//

#import "ModifyPasswordVC.h"
#import "LogonViewController.h"
@interface ModifyPasswordVC ()

@end

@implementation ModifyPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    leftBarButton(@"returnImage");
    self.title = @"修改密码";
    [self.originalPswTF addTarget:self action:@selector(originalPswFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.originalPswTF.clearButtonMode = UITextFieldViewModeAlways;
    self.originalPswTF.secureTextEntry = YES;
    
    [self.pswNewTF addTarget:self action:@selector(pswNewTFFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.pswNewTF.clearButtonMode = UITextFieldViewModeAlways;
    self.pswNewTF.secureTextEntry = YES;
    
    [self.pswTF addTarget:self action:@selector(newPswTFFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.pswTF.clearButtonMode = UITextFieldViewModeAlways;
    self.pswTF.secureTextEntry = YES;
    
    self.confirmBtn.enabled = NO;
    self.confirmBtn.layer.cornerRadius = 2;
    self.confirmBtn.clipsToBounds = YES;
    self.confirmBtn.backgroundColor = kCustomColor(213.0, 213.0, 213.0);

}

- (IBAction)confirmBtnClick:(UIButton *)sender {
    if ([_pswNewTF.text isEqualToString:_pswTF.text]) {
        
        NSString *userPsw = [[NSUserDefaults standardUserDefaults]objectForKey:@"userPsw"];
        NSLog(@"%@",userPsw);
        
        NSString *userPhone = [[NSUserDefaults standardUserDefaults]objectForKey:@"userPhone"];
        if (![_originalPswTF.text isEqualToString:@""] && ![_pswNewTF.text isEqualToString:@""]) {
            if ([userPsw isEqualToString:_originalPswTF.text]) {
                NSString *urlStr = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/Change_psd"];
                NSDictionary *dic = @{
                                      @"mobile":userPhone,
                                      @"password":userPsw,
                                      @"psd":_pswNewTF.text
                                      };
                
                [HttpRequest postWithURLString:urlStr parameters:dic success:^(id success) {
                    NSLog(@"%@",success);
                    if ([success[@"code"] isEqualToNumber:@2]) {
                        
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userID"];
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userPsw"];
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userPhone"];
                        
                        NSUserDefaults *userID = [NSUserDefaults standardUserDefaults];
                        [userID setObject:@"" forKey:@"remark"];
                        [userID setObject:@"" forKey:@"avatar"];
                        [userID setObject:@"" forKey:@"nickname"];
                        [MBProgressHUD showMessage:@"修改成功！" toView:self.view delay:1.0];
                        LogonViewController *logonVC = [LogonViewController new];
                        [self.navigationController pushViewController:logonVC animated:YES];
                    }else {
                        [MBProgressHUD showMessage:@"修改失败！" toView:self.view delay:1.0];
                    }
                } failure:^(NSError *error) {
                    NSLog(@"%@",error);
                    
                }];
            }else {
                [AlertView(@"温馨提示", @"原始密码不正确！", @"确定", nil) show];
            }
        }else {
            [AlertView(@"温馨提示", @"请填写完整密码！", @"确定", nil) show];
        }
        
        
    }else {
        [MBProgressHUD showMessage:@"两次密码输入不一致！" toView:self.view delay:1.0];
    }
}

- (void)originalPswFieldDidChange:(UITextView *)textField {
        if (![_originalPswTF.text isEqualToString:@""] && ![_pswNewTF.text isEqualToString:@""] && ![_pswTF.text isEqualToString:@""]) {
            self.confirmBtn.backgroundColor = kCustomViewColor;
            self.originalPswImage.image = [UIImage imageNamed:@"pswBright"];
            self.pswNewImage.image = [UIImage imageNamed:@"pswBright"];
            
            self.confirmBtn.enabled = YES;
            
        } else {
            self.confirmBtn.backgroundColor = kCustomColor(213.0, 213.0, 213.0);
            self.confirmBtn.enabled = NO;
            
            if (![self.originalPswTF.text isEqualToString:@""]) {
                self.originalPswImage.image = [UIImage imageNamed:@"pswBright"];
            }else {
                self.originalPswImage.image = [UIImage imageNamed:@"psw"];
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

- (void)pswNewTFFieldDidChange:(UITextField *)textField {

        if (![_originalPswTF.text isEqualToString:@""] && ![_pswNewTF.text isEqualToString:@""] && ![_pswTF.text isEqualToString:@""]) {
            self.confirmBtn.backgroundColor = kCustomViewColor;
            self.pswNewImage.image = [UIImage imageNamed:@"pswBright"];
            self.confirmBtn.enabled = YES;
            
        } else {
            if (![self.pswNewTF.text isEqualToString:@""]) {
                self.pswNewImage.image = [UIImage imageNamed:@"pswBright"];
                
            }else {
                self.confirmBtn.backgroundColor = kCustomColor(213.0, 213.0, 213.0);
                
                self.pswNewImage.image = [UIImage imageNamed:@"psw"];
                self.confirmBtn.enabled = NO;
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

- (void)newPswTFFieldDidChange:(UITextField *)textField {
    
        if (![_originalPswTF.text isEqualToString:@""] && ![_pswNewTF.text isEqualToString:@""] && ![_pswTF.text isEqualToString:@""]) {
            self.confirmBtn.backgroundColor = kCustomViewColor;
            self.pswImage.image = [UIImage imageNamed:@"pswBright"];
            self.confirmBtn.enabled = YES;
            
        } else {
            if (![self.pswTF.text isEqualToString:@""]) {
                self.pswImage.image = [UIImage imageNamed:@"pswBright"];
                
            }else {
                self.confirmBtn.backgroundColor = kCustomColor(213.0, 213.0, 213.0);
                
                self.pswImage.image = [UIImage imageNamed:@"psw"];
                self.confirmBtn.enabled = NO;
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)leftButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
