//
//  AboutUsViewController.m
//  mingtao
//
//  Created by Linlin Ge on 2017/3/22.
//  Copyright © 2017年 Linlin Ge. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"关于我们";
    leftBarButton(@"returnImage");

    self.bgView1.clipsToBounds = YES;
    self.bgView1.layer.cornerRadius = 5;
    self.bgView.clipsToBounds = YES;
    self.bgView.layer.cornerRadius = 5;
    self.logoImage.clipsToBounds = YES;
    self.logoImage.layer.cornerRadius = 15;
    [self.phoneBtn addTarget:self action:@selector(phoneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDictionary));
    
    //app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    self.appBuildLabel.text = [NSString stringWithFormat:@"上课网 V%@",app_Version];
}

- (void)phoneBtnClick:(UIButton *)sender {
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"400-000-0262"];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}

- (void)leftButton:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    //Dispose of any resources that can be recreated.
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
