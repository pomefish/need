//
//  MyCurriculumViewController.m
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2017/6/21.
//  Copyright © 2017年 ShangKe. All rights reserved.
//

#import "MyCurriculumViewController.h"
#import "NoDataView.h"

@interface MyCurriculumViewController ()

@end

@implementation MyCurriculumViewController

-(instancetype)initWithAddVCARY:(NSArray *)VCS TitleS:(NSArray *)TitleS{
    if (self = [super init]) {
        _VCAry = VCS;
        _TitleAry = TitleS;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
        //先初始化各个界面
        UIView *BJView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        BJView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:BJView];
        
        for (int i = 0 ; i<_VCAry.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(i*(kScreenWidth/_VCAry.count), 0, kScreenWidth/_VCAry.count, BJView.frame.size.height-2);
            [btn setTitle:_TitleAry[i] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn setTitleColor:kCustomViewColor forState:UIControlStateNormal];
            [btn setTitleColor:kCustomViewColor forState:UIControlStateSelected];
            btn.tag = 1000+i;
            [btn addTarget:self action:@selector(SeleScrollBtn:) forControlEvents:UIControlEventTouchUpInside];
            [BJView addSubview:btn];
        }
        
        _LineView = [[UIView alloc] initWithFrame:CGRectMake(60, BJView.frame.size.height-2, kScreenWidth/_VCAry.count - 120, 1)];
        _LineView.backgroundColor = kCustomViewColor;
        [BJView addSubview:_LineView];
        
        
        _MeScroolView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, BJView.frame.size.height, kScreenWidth, kScreenHeight-BJView.frame.size.height-64)];
        _MeScroolView.backgroundColor = kCustomVCBackgroundColor;
        _MeScroolView.pagingEnabled = YES;
        _MeScroolView.delegate = self;
        [self.view addSubview:_MeScroolView];
        
        for (int i2 = 0; i2<_VCAry.count; i2++) {
            UIView *view = [[_VCAry objectAtIndex:i2] view];
            view.frame = CGRectMake(i2*kScreenWidth, 0, kScreenWidth, _MeScroolView.frame.size.height);
            [_MeScroolView addSubview:view];
            [self addChildViewController:[_VCAry objectAtIndex:i2]];
        }
        
        [_MeScroolView setContentSize:CGSizeMake(kScreenWidth*_VCAry.count, _MeScroolView.frame.size.height)];
        
    }
    return self;
}

/**
 *  滚动停止调用
 *
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int index = scrollView.contentOffset.x/scrollView.frame.size.width;
    NSLog(@"当前第几页====%d",index);
    
    /**
     *  此方法用于改变x轴
     */
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = _LineView.frame;
        f.origin.x = index*(kScreenWidth/_VCAry.count) + 60;
        _LineView.frame = f;
    }];
    
    UIButton *btn = [self.view viewWithTag:1000+index];
    for (UIButton *b in btn.superview.subviews) {
        if ([b isKindOfClass:[UIButton class]]) {
            b.selected = (b==btn)?YES:NO;
        }
    }
    
}

//点击每个按钮然后选中对应的scroolview页面及选中按钮
-(void)SeleScrollBtn:(UIButton*)btn{
    for (UIButton *button in btn.superview.subviews)
    {
        if ([button isKindOfClass:[UIButton class]]) {
            button.selected = (button != btn) ? NO : YES;
        }
    }
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = _LineView.frame;
        f.origin.x = (btn.tag-1000)*(kScreenWidth/_VCAry.count) + 60;
        _LineView.frame = f;
        _MeScroolView.contentOffset = CGPointMake((btn.tag-1000)*kScreenWidth, 0);
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    leftBarButton(@"returnImage");
    self.title = @"我的课程";
    self.view.backgroundColor = kCustomVCBackgroundColor;
    
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
