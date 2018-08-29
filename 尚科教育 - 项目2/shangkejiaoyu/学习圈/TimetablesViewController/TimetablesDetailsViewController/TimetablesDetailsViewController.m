//
//  TimetablesDetailsViewController.m
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2017/7/10.
//  Copyright © 2017年 ShangKe. All rights reserved.
//

#import "TimetablesDetailsViewController.h"

@interface TimetablesDetailsViewController ()
@property (nonatomic, strong) NSMutableArray *imageArry;

@end

@implementation TimetablesDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    leftBarButton(@"returnImage");
    self.title = @"我的手记";
    self.view.backgroundColor = kCustomVCBackgroundColor;
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/subject_img"];
    [HttpRequest postWithURLString:urlStr parameters:nil success:^(id success) {
//        NSLog(@"课程表%@",success);
        _imageArry = [NSMutableArray array];
        
        for (NSDictionary *dic in success[@"body"]) {
            NSString *imageStr = [NSString stringWithFormat:@"%@%@",skBannerUrl,dic[@"images"]];
            NSString *name = dic[@"name"];
            [_imageArry addObject:imageStr];
        }
    } failure:^(NSError *error) {
//        NSLog(@"课程表%@",error);
        
    }];

}

- (void)leftButton:(UIButton*)sender {
    
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
