//
//  HomeCell.m
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2018/1/12.
//  Copyright © 2018年 ShangKe. All rights reserved.
//

#import "HomeCell.h"
#import "SDCycleScrollView.h"
#import "CurriculumViewController.h"
#import "ThematicListViewController.h"
#import "LSLHeadlineView.h"
#import "SGAdvertScrollView.h"

@implementation HomeCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)homeCellUi:(NSArray *)arr {
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth / 2.4) imageURLStringsGroup:arr];


    [self addSubview:cycleScrollView];
    
//    UIView *backgiew = [[UIView alloc] initWithFrame:CGRectMake(0,kScreenWidth / 2.4+ 70, kScreenWidth, 81 * 2)];
    UIView *backgiew = [[UIView alloc] initWithFrame:CGRectMake(0,kScreenWidth / 2.4+ 70, kScreenWidth, kHeight - cycleScrollView.frame.size.height -70 - (kHeight-70) / 5 )];

    backgiew.backgroundColor = [UIColor whiteColor];
    backgiew.layer.cornerRadius =  2;
    backgiew.layer.masksToBounds = YES;
    backgiew.userInteractionEnabled = YES;
    [self addSubview:backgiew];
    
    

    CGFloat padding = 0;
    CGFloat gunvH = 70;
    
    self.gunView = [[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(cycleScrollView.frame), kScreenWidth, 70 + padding *2)];
    _gunView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_gunView];
    
    //分割线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 69 , kWidth - 30, 1)];
    lineView.backgroundColor = kCustomlightGrayColor;
    [_gunView addSubview:lineView];

    self.leftView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 18.5, 70, 33)];
    
    _leftView.image = [UIImage imageNamed:@"hoticon"];
    _leftView.userInteractionEnabled  = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleNext)];
    [_leftView addGestureRecognizer:tap];
     [_gunView addSubview:_leftView];
    //营养学等按钮放置的视图
    ///backgiew的Y轴位置和高调整一下
    /// UIView *backgiew = [[UIImageView alloc] initWithFrame:CGRectMake(0,kScreenWidth / 2.4+ 70, kScreenWidth, kHeight - cycleScrollView.frame.size.height - kHeight / 5)];
    // 81这个值是我打印H得出来的
   

    
   
    
    
    //每个Item宽高
    CGFloat W = (kScreenWidth - 10*2)/5;
    //Item的高度调整一下, 81这个值是我打印H得出来的
        CGFloat H = (CGRectGetHeight(backgiew.frame) - 5)/2;
  // CGFloat H =  81;
      // CGFloat H =  kScreenWidth/2.4 + 70;

    NSArray *titleArr = @[@"营养学",@"健康管理",@"心理咨询师",@"人力资源",@"自学考试",@"教师资格证",@"消防工程师",@"更多",@"",@"",@"",@"",@"",@"",@"",@"",@""];
    NSMutableArray *imageArr = [NSMutableArray array];
    for (NSInteger i = 0; i<8; i++) {
        [imageArr addObject:[NSString stringWithFormat:@"%ld",(long)i+1]];
        _dianshangBtn = [[StudyCustomView alloc] initWithFrame:CGRectMake(10 + (i % 5) * W + 0, (i / 5) * H +0 , W, H)];
        _dianshangBtn.image.image = [UIImage imageNamed:[NSString stringWithFormat:@"0%@",imageArr[i]]];
        _dianshangBtn.titleLabel.text = titleArr[i];
        [_dianshangBtn.clickButton addTarget:self action:@selector(cuetomeBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        _dianshangBtn.clickButton.tag = i+1;
        [backgiew addSubview:_dianshangBtn];
    }
    
    
    //分割线
    UIView *heng = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(backgiew.frame), kWidth - 30, 1)];
    heng.backgroundColor = kCustomlightGrayColor;
    [self addSubview:heng];
    
    //每个Item宽高
    CGFloat SW = (kScreenWidth - 10*2)/5.5;
    CGFloat SH = 60;
    CGFloat HSpacing =  (kScreenWidth - (SW *4))/4;
  
    for (NSInteger i = 0; i<_catNameArray.count; i++) {
        //_taughtBtn的Y轴位置也改成相对于分割线的值
        //_taughtBtn = [[StudyCustomView alloc] initWithFrame:CGRectMake(10 + (i % 4) * (SW + HSpacing), backgiewY + (i / 4) * SH + WSpacing, SW, SH)];
        _taughtBtn = [[StudyCustomView alloc] initWithFrame:CGRectMake(10 + (i % 4) * (SW + HSpacing), CGRectGetMaxY(heng.frame) + 10, SW, SH)];
        _taughtBtn.backgroundColor = [UIColor whiteColor];
        _taughtBtn.image.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",_imageArray[i]]];
        _taughtBtn.titleLabel.text = _catNameArray[i];
        NSString *iamgeUrl = [NSString stringWithFormat:@"%@%@",skImageUrl,_imageArray[i]];
        [_taughtBtn.image sd_setImageWithURL:[NSURL URLWithString:iamgeUrl] placeholderImage:[UIImage imageNamed:@"loading"]];
        [_taughtBtn.clickButton addTarget:self action:@selector(taughtBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        _taughtBtn.clickButton.tag = i+1000;
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:_taughtBtn];
    }
    
}




- (void)taughtBtnClick:(UIButton *)sender {
    SKLog(@"---_catIdArr-----%@",_catIdArray);

    ThematicListViewController *thematicListVC = [ThematicListViewController new];
    thematicListVC.cat_id = _catIdArray[sender.tag - 1000];
    thematicListVC.hidesBottomBarWhenPushed = YES;
    //设置导航栏标题
    thematicListVC.title = _catNameArray[sender.tag - 1000];
    [[self getCurrentViewController].navigationController pushViewController:thematicListVC animated:YES];
}

////点击滚动资讯跳转
//- (void)selectBtnWithIndex:(NSInteger)index{
//    NSLog(@"第几个按钮==%ld", index);
//    //资讯滚动图点击事件
//    ThematicListViewController *VC = [[ThematicListViewController alloc] init];
//    VC.tagId = 1;
//    //设置导航栏标题
//    VC.title = @"热门资讯";
//    VC.hidesBottomBarWhenPushed = YES;
//    [[self viewController].navigationController pushViewController:VC animated:YES];
//
//}


//  获取view所在的视图
- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}
#pragma mark -- 0区点击事件
- (void)cuetomeBtnClick:(UIButton *)sender {
    NSArray *titleArr = @[@"营养学",@"健康管理",@"心理咨询师",@"人力资源",@"自学考试",@"教师资格证",@"消防工程师",@"更多",@"",@"",@"",@"",@"",@"",@"",@"",@""];
    if (sender.tag == 8) {
        UIWindow *winder = [[[UIApplication sharedApplication]delegate]window];
        [MBProgressHUD showMessage:@"敬请期待！" toView:winder delay:1.0];
    }else {
        CurriculumViewController *curriculumVC = [CurriculumViewController new];
        curriculumVC.type = [NSString stringWithFormat:@"%ld",(long)sender.tag];
        curriculumVC.title = titleArr[sender.tag - 1];
        curriculumVC.hidesBottomBarWhenPushed = YES;
        [[self getCurrentViewController].navigationController pushViewController:curriculumVC animated:YES];

    }
}


- (void)setTitleArray:(NSMutableDictionary *)titleLabelDic {
    
    NSArray *topTitleArr = titleLabelDic[@"title"];
    //    NSArray *signImageArr = @[@"hot", @"",@"", @"activity"];
    NSArray *bottomTitleArr = titleLabelDic[@"description"];
    _advertScrollView2 = [[SGAdvertScrollView alloc] initWithFrame:CGRectMake(85, 6, kScreenWidth - 95, 58)];
    _advertScrollView2.delegate = self;
    _advertScrollView2.advertScrollViewStyle = SGAdvertScrollViewStyleMore;
    _advertScrollView2.topTitles = topTitleArr;
    _advertScrollView2.bottomTitles = bottomTitleArr;
    [_gunView addSubview:_advertScrollView2];
}

- (void)handleNext{
    //资讯滚动图点击事件
    ThematicListViewController *VC = [[ThematicListViewController alloc] init];
    VC.tagId = 1;
    //设置导航栏标题
    VC.title = @"热门资讯";
    VC.hidesBottomBarWhenPushed = YES;
    [[self viewController].navigationController pushViewController:VC animated:YES];
}
/// 代理方法
- (void)advertScrollView:(SGAdvertScrollView *)advertScrollView didSelectedItemAtIndex:(NSInteger)index {
    //    NSLog(@"-----------%ld",(long)index);
    //资讯滚动图点击事件
    ThematicListViewController *VC = [[ThematicListViewController alloc] init];
    VC.tagId = 1;
    //设置导航栏标题
    VC.title = @"热门资讯";
    VC.hidesBottomBarWhenPushed = YES;
    [[self viewController].navigationController pushViewController:VC animated:YES];
}
@end
