//
//  AreaViewController.m
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2018/3/26.
//  Copyright © 2018年 ShangKe. All rights reserved.
//

#import "AreaViewController.h"
#import "HomeViewController.h"
#import "Masonry.h"
#import "UIColor+Hex.h"
#import "HttpRequest.h"
#import "HttpsHeader.h"
#import "HexColors.h"
@interface AreaViewController ()
@property (nonatomic,strong)UILabel *areaLabel;
@property (nonatomic,strong)UIButton *areaBtn;
@property (nonatomic, strong) NSMutableArray *areaNameArr;
@property (nonatomic,copy)NSString *titleText;//  存储地区按钮点击时的文字

@end

@implementation AreaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"returnImage"] style:UIBarButtonItemStylePlain target:self action:@selector(handleBack:)];
    left.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = left;
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth - 70, 44)];
    UILabel *choiceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 85, 44)];
    choiceLabel.text = @"校区选择";
    choiceLabel.textColor = [UIColor whiteColor];
    [titleView addSubview:choiceLabel];
    self.navigationItem.titleView = titleView;
    //数据请求地区信息
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",sHTTPURL,areaUrl];
    NSDictionary *dic = @{
                          @"page":@"",@"pagesize":@"",
                          
                          };
    [HttpRequest postWithURLString:urlStr parameters:dic success:^(id success) {
        //        id object = [NSJSONSerialization JSONObjectWithData:success options:NSJSONWritingPrettyPrinted  error:nil];
        //
        //        NSLog(@"jiexi de = %@",object);
        NSLog(@"解析的字典= %@", success);
        _areaNameArr = [NSMutableArray array];
        
        for (NSDictionary *dict in success[@"body"]) {
            NSString *name = dict[@"campus_name"] ;
//        转码stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            [_areaNameArr addObject:name];
        }
        
        [self setUpViews];
        
    } failure:^(NSError *error) {
        
        
    }];
    
    
    
    
}

- (void)setUpViews{
    UIView *frontView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight *0.06)];
    [self.view addSubview:frontView];
    
    self.areaLabel = [[UILabel alloc] init];
    _areaLabel.text = [NSString stringWithFormat:@"当前校区:%@",self.frontText];
     [frontView addSubview:_areaLabel];
    [_areaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(frontView.mas_left).offset(10);
        make.width.mas_equalTo(kScreenWidth - 20);
        make.height.mas_equalTo(frontView.mas_height);
        make.bottom.mas_equalTo(frontView.mas_bottom).offset(0);
    }];
    
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0,  64 + frontView.frame.size.height, kScreenWidth, kScreenHeight -64 -frontView.frame.size.height)];
    footerView.backgroundColor = [UIColor whiteColor];
   footerView.backgroundColor = [UIColor colorWithHexString:@"#247247"];
       footerView.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#F7F7F7"];
    [self.view addSubview:footerView];
    
    UILabel *schoolLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth - 20, 40)];
    schoolLabel.text = @"请选择校区";
    schoolLabel.textColor = [UIColor lightGrayColor];
    [footerView addSubview:schoolLabel];
    
    CGFloat vPadding = 10;
    CGFloat hPadding = 10;
    CGFloat widthBtn = (kScreenWidth - 20 - 2*hPadding)/3 ;
    CGFloat heightBtn = kScreenHeight *0.06;
    int n = 0;
    for (int i = 0; i < 4; i++) {
            for (int j= 0; j < 3; j ++) {
                self.areaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [_areaBtn setTitle:[NSString stringWithFormat:@"%@",self.areaNameArr[n]] forState:UIControlStateNormal ];
                _areaBtn.backgroundColor = [UIColor redColor];
                _areaBtn.frame = CGRectMake(10 + (hPadding + widthBtn)*j, 10 + 40+( vPadding + heightBtn) *i, widthBtn, heightBtn);
                _areaBtn.backgroundColor = [UIColor whiteColor];
                [_areaBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [_areaBtn addTarget:self action:@selector(handleTouchup:) forControlEvents:UIControlEventTouchUpInside];
                [footerView addSubview:_areaBtn];
                n++;

                    }
            }
    
    self.areaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_areaBtn setTitle:@"北京" forState:UIControlStateNormal];
    _areaBtn.backgroundColor = [UIColor whiteColor];
    _areaBtn.frame = CGRectMake(10 + (hPadding + widthBtn)*0, 10 + 40+( hPadding + heightBtn) *4, widthBtn, heightBtn);
    [_areaBtn addTarget:self action:@selector(handleTouchup:) forControlEvents:UIControlEventTouchUpInside];
    
    [_areaBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_areaBtn setTitle:[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",[self.areaNameArr lastObject]]] forState:UIControlStateNormal];
    [footerView addSubview:_areaBtn];

}


- (void)text:(newBlock)block{
    self.block = block;
}


- (void)handleTouchup:(UIButton *)sender{
    self.titleText = sender.titleLabel.text;
    self.areaLabel.text = [NSString stringWithFormat:@"当前校区：%@",_titleText];
//    NSLog(@"点击button了 = %@",titleText);
    if (self.block != nil) {
        self.block(_titleText);
    }
    self.areaLabel.text = self.titleText;
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)handleBack:(UIBarButtonItem *)buttonItem{
//    HomeViewController *home = [[HomeViewController alloc] init];
    if (self.block != nil) {
        if (_titleText != nil) {
              self.block(_titleText);
        }else{
            self.block(_frontText);
        }
        
   
    }
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
