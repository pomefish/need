//
//  SettingPawViewController.m
//  mingtao
//
//  Created by Linlin Ge on 2016/12/27.
//  Copyright © 2016年 Linlin Ge. All rights reserved.
//

#import "SettingPawViewController.h"
#import "SettingCustomView.h"
#import "TGHeader.h"
#import "HttpRequest.h"

@interface SettingPawViewController ()
@property (nonatomic, strong) SettingCustomView *settingCustom;
@end

@implementation SettingPawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    leftBarButton(@"returnImage");

    _settingCustom = [[SettingCustomView alloc] initWithFrame:self.view.frame];
    
    [_settingCustom.button addTarget:self action:@selector(affirmBtClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_settingCustom];
}

- (void)affirmBtClick:(UIButton *)sender {
    if ([_phone isEqualToString:@""]|| [_settingCustom.pswTF.text isEqualToString:@""] || ![_settingCustom.pswTF.text isEqualToString:_settingCustom.duanXinTF.text]) {
        [AlertView(@"温馨提示！", @"请核对密码。", @"确定", nil) show];
        
    }else {
        
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/Change_psd"];
        NSDictionary *dic = @{
                              @"mobile":_phone,
                              @"psd":_settingCustom.pswTF.text
                              };
        
        [HttpRequest postWithURLString:urlStr parameters:dic success:^(id success) {
            NSLog(@"%@",success);
            NSNumberFormatter*numberFor = [[NSNumberFormatter alloc]init];
            NSString *codeStr = [numberFor stringFromNumber:[success objectForKey:@"status"]];
            
            if (![codeStr isEqualToString:@"1"]) {
                
                [AlertView(success[@"msg"], nil, nil, @"确定") show];
                
            }else {
                
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            }
            
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
            
        }];
        
    }

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
