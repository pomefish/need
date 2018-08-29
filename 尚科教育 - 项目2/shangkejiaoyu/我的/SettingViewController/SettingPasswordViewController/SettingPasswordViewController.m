//
//  SettingPasswordViewController.m
//  mingtao
//
//  Created by Linlin Ge on 16-11-17.
//  Copyright (c) 2016年 Linlin Ge. All rights reserved.
//

#import "SettingPasswordViewController.h"
#import "SettingPasswordView.h"
#import "SettingPawViewController.h"

@interface SettingPasswordViewController ()
@property (nonatomic, strong) SettingPasswordView *password;
@end

@implementation SettingPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"修改密码";
    leftBarButton(@"returnImage");
    
    self.view.backgroundColor = [UIColor whiteColor];
    _password = [[SettingPasswordView alloc] initWithFrame:self.view.frame];
    [_password.button addTarget:self action:@selector(affirmClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_password];
    
}

//修改密码
- (void)affirmClick:(UIButton *)sender {
    if ([self isValidateMobile:_password.phoneTF.text] == NO) {
        [AlertView(@"温馨提示！", @"请核对手机号码", @"确定", nil) show];
    }else {
        
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/Ajax_check_sms_key"];
        NSDictionary *dic = @{
                              @"mobile":_password.phoneTF.text,
                              @"sms_key":_password.duanXinTF.text
                              };
        
        [HttpRequest postWithURLString:urlStr parameters:dic success:^(id success) {
            NSLog(@"%@",success);
            
            
            NSNumberFormatter*numberFor = [[NSNumberFormatter alloc]init];
            NSString *codeStr = [numberFor stringFromNumber:[success objectForKey:@"code"]];
            
            if (![codeStr isEqualToString:@"1"]) {
                
                [AlertView(success[@"msg"], nil, @"确定", nil) show];
                
            }else {
                SettingPawViewController *settingPawVC = [SettingPawViewController new];
                settingPawVC.phone = _password.phoneTF.text;
                [self.navigationController pushViewController:settingPawVC animated:YES];
            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
            
        }];
        
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES]; //实现该方法是需要注意view需要是继承UIControl而来的
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
