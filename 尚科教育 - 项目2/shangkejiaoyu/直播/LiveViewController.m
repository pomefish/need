//
//  LiveViewController.m
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2017/11/9.
//  Copyright © 2017年 ShangKe. All rights reserved.
//

#import "LiveViewController.h"
#import "LiveView.h"
#import "PlayLiveViewController.h"
#import "InformViewController.h"

@interface LiveViewController ()
@property (nonatomic, strong) LiveView *pagerView;

@end

@implementation LiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.barTintColor = kCustomNavColor;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:16],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @" ";
    
    [self addChildViewControllers];
    [self initLayoutPagerView];
}

- (void)initLayoutPagerView{
    _pagerView = [[LiveView alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth,kScreenHeight - 20)
                                      SegmentViewHeight:64
                                             titleArray:@[@"直播",@"试听"]
                                             Controller:self
                                              lineWidth:kScreenWidth / 3.6
                                             lineHeight:2
                                                buttonY:12];
    [self.view addSubview:_pagerView];
    
}

- (void)addChildViewControllers{
    
    PlayLiveViewController *smoll2VC = [PlayLiveViewController new];
    [self addChildViewController:smoll2VC];
    
    InformViewController *smoll3VC = [InformViewController new];
    [self addChildViewController:smoll3VC];
    
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
