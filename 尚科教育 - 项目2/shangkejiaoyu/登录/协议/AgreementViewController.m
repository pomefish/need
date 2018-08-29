//
//  AgreementViewController.m
//  mingtao
//
//  Created by Linlin Ge on 2017/4/12.
//  Copyright © 2017年 Linlin Ge. All rights reserved.
//

#import "AgreementViewController.h"

@interface AgreementViewController ()

@end

@implementation AgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    leftBarButton(@"returnImage");
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    UIWebView *webView  = [[UIWebView alloc]initWithFrame:self.view.bounds];
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"agreement" ofType:@"html"];
    
    NSString *html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    [webView loadHTMLString:html baseURL:nil];
    
    [self.view addSubview:webView];
    
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
