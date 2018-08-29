//
//  CurriculumViewController.m
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2017/6/15.
//  Copyright © 2017年 ShangKe. All rights reserved.
//

#import "CurriculumViewController.h"
#import "LinkageMenuView.h"
#import "OneView.h"
#import "TwoView.h"
#import "OneCollectionViewCell.h"
#import "IntroduceViewController.h"

@interface UIViewController ()<CurriculumVCDelegate> //遵守协议
@end

@interface CurriculumViewController ()
@property (strong,nonatomic) OneView *oneView;

@property (nonatomic, strong) NSMutableArray *categoryArr;
@property (nonatomic, strong) NSMutableArray *catIDArr;
@property (nonatomic, strong) NSMutableArray *catNameArr;
@property (nonatomic, strong) NSMutableArray *mutableArr;
@property (nonatomic, strong) NSMutableArray *viewsArr;

@property (nonatomic,strong) NSMutableArray *titleImageName;
@end

@implementation CurriculumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;

    leftBarButton(@"returnImage");
    self.view.backgroundColor = [UIColor whiteColor];
    _mutableArr = [NSMutableArray array];
    _catIDArr = [NSMutableArray array];
    _catNameArr = [NSMutableArray array];
    
    _titleImageName = [NSMutableArray arrayWithObjects:@"titleImageName01.jpg",@"titleImageName02.jpg",@"titleImageName03.jpg",@"titleImageName04.jpg",@"titleImageName05.jpg",@"titleImageName06.jpg",@"titleImageName07.jpg",@"titleImageName04.jpg",@"titleImageName04.jpg", nil];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",sHTTPURL,categoryUrl];
    NSDictionary *dic = @{
                          @"type":_type,
                          };
    [HttpRequest postWithURLString:urlStr parameters:dic success:^(id success) {
//        _dataArr = success[@"body"][@"category"];
        NSLog(@"-------------%@",success);
        for (NSDictionary *dict in success[@"body"]) {
            if (!_categoryArr) {
                _categoryArr = [NSMutableArray array];
            }
            [_categoryArr addObject:dict[@"cat_name"]];
        }
        
        for (NSDictionary *dict in success[@"body"]) {
            NSArray *array = dict[@"category"];
            if (![array isEqual:[NSNull null]]) {
                [_mutableArr addObject:array];
            }else {
                NSDictionary *dic = [NSDictionary dictionary];
                [_mutableArr addObject:dic];
            }
        }
        
        [self addView];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;

}

- (void)addView {
    _viewsArr = [NSMutableArray array];
    for (NSInteger i = 0; i<_categoryArr.count; i++) {
        OneView *oneView = [[OneView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 101, kScreenHeight - kNavHeight)];
      if (_mutableArr.count > i) {
            NSMutableArray *catNameArr = [NSMutableArray array];
            NSMutableArray *catIDArr = [NSMutableArray array];
            for (NSDictionary *dic in _mutableArr[i]) {
                [catNameArr addObject:dic[@"cat_name"]];
                [catIDArr addObject:dic[@"cat_id"]];
            }
            oneView.dataArray = catNameArr;
            oneView.catIdArr = catIDArr;
            
        }
        //oneView.dataArray = _mutableArr[i];
        oneView.titleStr = _categoryArr[i];
        int intString = [_type intValue];
        oneView.titleImageName = _titleImageName[intString - 1];
        oneView.delegate = self;//设置代理
        
        //views array
        [_viewsArr addObject:oneView];
       
    }
    
    //if views count less than menu count, leftover views will load the last view of the views
    //如果view数量少于标题数量，剩下的view会默认加载view数组的最后一个view
    LinkageMenuView *lkMenu = [[LinkageMenuView alloc] initWithFrame:CGRectMake(0, kNavHeight,kScreenWidth , kScreenHeight - kNavHeight) WithMenu:_categoryArr andViews:_viewsArr];
    
    //    lkMenu.textSize = 11;
    //    lkMenu.textColor = [UIColor blueColor];
    lkMenu.selectTextColor = [UIColor blackColor];
    //    lkMenu.bottomViewColor = [UIColor yellowColor];
    
    [self.view addSubview:lkMenu];
}

- (void)CurriculumVC:(NSDictionary *)dic {
    
    IntroduceViewController *introduceVC = [IntroduceViewController new];
    introduceVC.hidesBottomBarWhenPushed = YES;
    introduceVC.catID = dic[@"catId"];
    introduceVC.titleText = dic[@"name"];
    introduceVC.tagId = 0;
    [self.navigationController pushViewController:introduceVC animated:YES];
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
