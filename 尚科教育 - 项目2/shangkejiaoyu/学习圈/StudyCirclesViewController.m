//
//  StudyCirclesViewController.m
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2017/6/29.
//  Copyright © 2017年 ShangKe. All rights reserved.
//

#import "StudyCirclesViewController.h"
#import "PagerView.h"

#import "MessageViewController.h"
#import "QuestionsViewController.h"
#import "TimetablesViewController.h"

#define btnW  (kScreenWidth -(views.count + 1)*10)/views.count

@interface StudyCirclesViewController ()<UIScrollViewDelegate>
{
    PagerView *_pagerView;
}


@property (nonatomic, strong) UIScrollView *mainScroll;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIScrollView *smollScrollView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) NSMutableArray *catIdArr;
@property (nonatomic, strong) NSMutableArray *catNameArr;

@end

@implementation StudyCirclesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/article_type"];
    NSDictionary *dic = @{
                          @"type":@"1",
                          
                          };
    [HttpRequest postWithURLString:urlStr parameters:dic success:^(id success) {
        SKLog(@"---------%@",success);
        _catIdArr = [NSMutableArray array];
        _catNameArr = [NSMutableArray array];
        for (NSDictionary *dic in success[@"body"]) {
            [_catIdArr addObject:dic[@"cat_id"]];
            [_catNameArr addObject:dic[@"cat_name"]];
        }
        [self addChildViewControllers];
        [self initLayoutPagerView];
        
    } failure:^(NSError *error) {
       
        
    }];

    
}

- (void)initLayoutPagerView{
    
    
    _pagerView = [[PagerView alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth,kScreenHeight - 20)
                               SegmentViewHeight:kNavHeight
                                      titleArray:_catNameArr
                                      Controller:self
                                       lineWidth:kScreenWidth/5
                                      lineHeight:2];
    
    [self.view addSubview:_pagerView];
    
}

- (void)addChildViewControllers{
    
    MessageViewController *smoll2VC = [MessageViewController new];
    smoll2VC.cat_id = _catIdArr[0];
    [self addChildViewController:smoll2VC];
    
    QuestionsViewController *smoll3VC = [QuestionsViewController new];
    smoll3VC.cat_id = _catIdArr[1];
    [self addChildViewController:smoll3VC];
    
    TimetablesViewController *smoll4VC = [TimetablesViewController new];
    smoll4VC.cat_id = _catIdArr[2];
    [self addChildViewController:smoll4VC];
    
    TimetablesViewController *smoll5VC = [TimetablesViewController new];
    smoll5VC.cat_id = _catIdArr[3];
    [self addChildViewController:smoll5VC];
}

- (void)viewDidAppear:(BOOL)animated{
    //隐藏导航栏
    self.navigationController.navigationBarHidden = YES;
}
//视图将要消失
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
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
