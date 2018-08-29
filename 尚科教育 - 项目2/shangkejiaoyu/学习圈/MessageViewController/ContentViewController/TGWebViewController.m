//
//  TGWebViewController.m
//  TGWebViewController
//
//  Created by 赵群涛 on 2017/9/15.
//  Copyright © 2017年 QR. All rights reserved.
//

#import "TGWebViewController.h"
#import "TGWebProgressLayer.h"
#import <WebKit/WebKit.h>
@interface TGWebViewController ()<WKNavigationDelegate>

@property (nonatomic, strong)WKWebView *tgWebView;

@property (nonatomic, strong)TGWebProgressLayer *webProgressLayer;


@end

@implementation TGWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = kCustomNavColor;
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = self.webTitle;
    [self setUpUI];
}

- (void)setUpUI {
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 14, 28);
    [backBtn setImage:[UIImage imageNamed:@"returnImage"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backButton:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
   
    self.tgWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64)];
    self.tgWebView.navigationDelegate =self;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [self.tgWebView loadRequest:request];
    [self.view addSubview:self.tgWebView];
    
    self.webProgressLayer = [[TGWebProgressLayer alloc] init];
    self.webProgressLayer.frame = CGRectMake(0, 42, WIDTH, 2);
    self.webProgressLayer.strokeColor = [UIColor colorWithRed:27.0/255.0 green:130.0/255.0 blue:209.0/255.0 alpha:1.0].CGColor;
    [self.navigationController.navigationBar.layer addSublayer:self.webProgressLayer];
    
}

- (void)backButton:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self.webProgressLayer removeFromSuperlayer];
}

#pragma mark - UIWebViewDelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [self.webProgressLayer tg_startLoad];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self.webProgressLayer tg_finishedLoadWithError:nil];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self.webProgressLayer tg_finishedLoadWithError:error];
    
}

- (void)dealloc {
    [self.webProgressLayer tg_closeTimer];
    [_webProgressLayer removeFromSuperlayer];
    _webProgressLayer = nil;
}

@end
