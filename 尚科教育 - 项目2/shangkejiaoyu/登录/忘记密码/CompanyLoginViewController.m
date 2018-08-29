//
//  CompanyLoginViewController.m
//  mingtao
//
//  Created by Linlin Ge on 2017/5/10.
//  Copyright © 2017年 Linlin Ge. All rights reserved.
//

#import "CompanyLoginViewController.h"
#import "CompanyLoginCustomView.h"
#import "HttpRequest.h"
#import "AgreementViewController.h"
#import "RootView.h"

@interface CompanyLoginViewController ()
@property (nonatomic, strong) CompanyLoginCustomView *loginView;

@end

@implementation CompanyLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = kCustomNavColor;
    leftBarButton(@"returnImage");

    NSLog(@"--------%@",_titleLabel);
    _loginView = [[CompanyLoginCustomView alloc] initWithFrame:self.view.frame];
    [_loginView.duanxinBtn setTitleColor:kCustomViewColor forState:UIControlStateNormal];
    [_loginView.agreementBtn setTitleColor:kCustomViewColor forState:UIControlStateNormal];
    
    self.title = @"忘记密码";
    [_loginView.button setTitle:@"提交" forState:UIControlStateNormal];
    _loginView.label.hidden = YES;
    _loginView.agreementBtn.hidden = YES;
    
    self.tabBarController.tabBar.hidden = YES;
    
    [_loginView.popBtn addTarget:self action:@selector(leftButton:) forControlEvents:UIControlEventTouchUpInside];
    [_loginView.button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_loginView.duanxinBtn addTarget:self action:@selector(duanxinBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_loginView.agreementBtn addTarget:self action:@selector(agreementBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginView];
}

- (void)buttonClick:(UIButton *)sender {
    if ( ![_loginView.phoneTF.text isEqualToString:@""] && ![_loginView.messageTF.text isEqualToString:@""] ) {
        if ([_loginView.pswTF.text length] > 18 && [_loginView.pswTF.text length] < 6) {
            [MBProgressHUD showMessage:@"密码位数为6~18，请重新输入" toView:self.view delay:1.0];
        }else {
                NSString *urlStr = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/ForgetName_psd"];
                NSDictionary *dic = @{@"mobile":_loginView.phoneTF.text,
                                      @"password":_loginView.pswTF.text,
                                      @"sms_code":_loginView.messageTF.text
                                      
                                      };
                [HttpRequest postWithURLString:urlStr parameters:dic success:^(id success) {
                    NSLog(@"---修改密码---%@",success);
                    NSString *statuStr = [NSString stringWithFormat:@"%@",success[@"status"]];
                    
                    if ([statuStr isEqualToString:@"1"]) {
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }else{
                        NSString *msg = [NSString stringWithFormat:@"%@",success[@"msg"]];
                        [MBProgressHUD showMessage:msg toView:self.view delay:1.0];
                    
                    }
//                    if ([success[@"code"] isEqualToNumber:@4]) {
//                        [MBProgressHUD showMessage:@"手机号未注册！" toView:self.view delay:1.0];
//                    }else if ([success[@"code"] isEqualToNumber:@5]) {
//                        [self.navigationController popToRootViewControllerAnimated:YES];
//                    }else if ([success[@"code"] isEqualToNumber:@8]) {
//                        [MBProgressHUD showMessage:@"验证码错误！" toView:self.view delay:1.0];
//                    }
                    
                } failure:^(NSError *error) {
                    NSLog(@"%@",error);
                    
                }];
                NSLog(@"-------%@----",_isPersonal);
            
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
        NSLog(@"-----------%@-----",_isPersonal);
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/Ajax_sendSMS"];
        NSDictionary *dic = @{
                              @"mobile":_loginView.phoneTF.text,
                              @"type":@"2"
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
