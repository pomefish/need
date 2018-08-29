//
//  HomeViewController.m
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2017/6/15.
//  Copyright © 2017年 ShangKe. All rights reserved.
//

#import "HomeViewController.h"
#import "StudyModel.h"
#import "StudyViewCustomCell.h"
#import "StudyCustomHaedView.h"
#import "HttpRequest.h"
#import "VedioPlayerViewController.h"
#import "CurriculumViewController.h"
#import "SearchViewController.h"

#import "VedioViewController.h"
#import "VedioPlayerViewController.h"

#import "LogonViewController.h"

#import "HomeCell.h"
#import "AreaViewController.h"
#import "newsCell.h"
#import "IntroduceViewController.h"
#import "UILabel+Size.h"
#import "YDPopViewController.h"
#import "TGWebViewController.h"
#import "UIViewController+PopView.h"

//系统cell
#define kSystemCell @"systemCell"
#define kSystemCustomCell @"kSystemCustomCell"
#define kCustomCell @"customCell"
//区头视图
#define kHeadView @"headView"
//边距
#define kVToSide 0.0f
#define kVToView 0.0f
//分区的个数
#define kSectionCount 6

@interface HomeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UISearchBarDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout * layout;
@property (nonatomic, strong) UISearchBar    *searchBar;
@property (nonatomic, strong) NSMutableArray *modelArr;
@property (nonatomic, strong) NSMutableArray *latestArr;
@property (nonatomic, strong) NSMutableArray *hotArr;
//@property (nonatomic, strong) NoDataView     *noDataView;
@property (nonatomic, strong) NSMutableArray *imageArry;

//数据源
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) NSMutableArray *videoInfoArr1;
@property (nonatomic, strong) NSMutableArray *videoInfoArr2;
@property (nonatomic, strong) NSMutableArray *videoInfoArr3;
@property (nonatomic, strong) NSMutableArray *videoInfoArr4;
@property (nonatomic,strong)NSMutableArray *  freeInfoArr;

@property (nonatomic, strong) NSMutableArray *catIdArr;
@property (nonatomic, strong) NSMutableArray *catNameArr;
@property (nonatomic, strong) NSMutableArray *imageArr;
@property (nonatomic,strong)UIButton *titleBtn;
@property (nonatomic,strong)UIButton *imageBtn;
@property (nonatomic,strong)UIView *leftView;

@property (nonatomic,strong)UIButton *moreBtn;

@property (nonatomic,copy)NSString *backtitle;//定义下一页返回按钮的标题
@property (nonatomic, copy)NSString *iid;
@property (nonatomic,strong)NSMutableDictionary *idDic;

@property (nonatomic, strong) NSMutableDictionary *informationDataDic;//资讯字典

@end

@implementation HomeViewController
#pragma mark - 懒加载
- (NSMutableArray *)todayRecSource
{
    if (_dataSource == nil)
    {
        self.dataSource = [@[] mutableCopy];
    }
    return _dataSource;
}
- (UICollectionViewFlowLayout *)layout
{
    if (_layout == nil)
        
    {
        self.layout = [[UICollectionViewFlowLayout alloc] init];
    }
    return _layout;
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil)
    {
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth,kScreenHeight - kNavHeight - kTabHeight) collectionViewLayout:self.layout];
        //设置代理
        self.collectionView.delegate = self;
        //设置数据源
        self.collectionView.dataSource = self;
        self.collectionView.backgroundColor = kCustomVCBackgroundColor;
        
        //系统自带的cell
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kSystemCell];
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kSystemCustomCell];
        
        [self.collectionView registerClass:[StudyViewCustomCell class] forCellWithReuseIdentifier:kCustomCell];
        [self.collectionView registerNib:[UINib nibWithNibName:@"LatestCurriculumCell" bundle:nil] forCellWithReuseIdentifier:@"LatestCurriculumCell"];
        [self.collectionView registerNib:[UINib nibWithNibName:@"TeacherCell" bundle:nil] forCellWithReuseIdentifier:@"TeacherCell"];
        
        [self.collectionView registerNib:[UINib nibWithNibName:@"HomeCell" bundle:nil] forCellWithReuseIdentifier:@"HomeCell"];
        [self.collectionView registerNib:[UINib nibWithNibName:@"newsCell" bundle:nil] forCellWithReuseIdentifier:@"newsCell"];
        
        //注册区位视图
        [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"sysytemHead"];
        
        //注册区头
        [self.collectionView registerClass:[StudyCustomHaedView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeadView"];
    }
    return _collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:self.backtitle style:UIBarButtonItemStylePlain target:nil action:nil];
    // Do any additional setup after loading the view.
     rightBarButton(@"sousuo");
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //添加子视图
    [self.view addSubview:self.collectionView];
    //设置导航栏上的按钮
    [self setNavigationItem];
    [self  requeatData];
    //请求资讯数据
    [self requestZixun];
    [self getDataRequest];
    
    [self gatBannerImage];
    

    [self specialColumnRequest];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/activity"];
    [HttpRequest postWithURLString:urlStr parameters:nil success:^(id success) {
        NSLog(@"活动-----------------%@",success);
        if ([success[@"body"] count] >0) {
            YDPopViewController * vc1 = [[YDPopViewController alloc] initWithNibName:@"YDPopViewController" bundle:nil];
            vc1.activity_thumb = success[@"body"][0][@"activity_thumb"];
            vc1.typeInt = 0;
            vc1.mainButtonBlock = ^{
                NSLog(@"点击进入主会场=====");
                if ([success[@"body"][0][@"type"] isEqualToString:@"2"]) {
                    NSString *myClassStr = success[@"body"][0][@"ios"];
                    //根据类名跳转
                    if (![NSString cc_isNULLOrEmpty:myClassStr]) {
                        Class myClazz = NSClassFromString(myClassStr);
                        if (myClazz) {
                            UIViewController *myClassInit = [[myClazz alloc] init];
                            myClassInit.hidesBottomBarWhenPushed = YES;
                            [self.navigationController pushViewController:myClassInit animated:YES];
                        }
                    }
                }else {
                    TGWebViewController *web = [[TGWebViewController alloc] init];
                    web.url = success[@"body"][0][@"activity_url"];
                    web.webTitle = success[@"body"][0][@"activity_title"];
                    
                    web.hidesBottomBarWhenPushed = YES;
                    
                    [self.navigationController pushViewController:web animated:YES];
                }
                
            };
            vc1.closeButtonBlock = ^{
                NSLog(@"点击关闭按钮=====");
            };
          [[UIApplication sharedApplication].delegate.window.rootViewController presentpopupViewController:vc1 animationType:(CCPopupViewAnimationFade)];
        }
        
    } failure:^(NSError *error) {
     //   EPLog(@"活动-----------------%@",error);
        
    }];
    
}

- (void)specialColumnRequest {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/article_type"];
    NSDictionary *dic = @{
                          @"type":@"2",
                          
                          };
    [HttpRequest postWithURLString:urlStr parameters:dic success:^(id success) {
        NSLog(@"---------%@",success);
        _catIdArr = [NSMutableArray array];
        _catNameArr = [NSMutableArray array];
        _imageArr = [NSMutableArray array];
        for (NSDictionary *dic in success[@"body"]) {
            [_catIdArr addObject:dic[@"cat_id"]];
            [_catNameArr addObject:dic[@"cat_name"]];
            [_imageArr addObject:dic[@"image"]];
        }
        [self.collectionView reloadData];
    } failure:^(NSError *error) {
    
    }];
    
    
//    //请求资讯数据
//    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/hot_article"];
//    NSDictionary *di = @{@"page":@"1",
//                         @"pagesize":@"1"
//                         };
//    [HttpRequest postWithURLString:urlStr parameters:di success:^(id success) {
//        NSLog(@"------------%@",success);
//        NSArray *arr = success[@"body"];
//        
//        //        for (NSDictionary *dic in arr) {
//        //            NSString *imageName = dic[@"image"];
//        //            NSString *newsTitle = dic[@"title"];
//        //             leftView.image = [UIImage imageNamed:imageName];
//        //            NSLog(@"ming zi = %@    nnnn = %@",imageName,newsTitle);
//        //             headlineView.hotView.SecondLabel.text = newsTitle;
//        //            headlineView.hotView.FirstLabel.text = newsTitle;
//        //
//        //        }
//        NSArray *array = [self getTitleWithJsonDic:success];
//        NSLog(@" 请求的数组 = %@" ,array);
//     
//        
//        
//    } failure:^(NSError *error) {
//        SKLog(@"------直播列表-------%@",error);
//        
//    }];

}

- (void)playLiveIngNumber {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/zhibo"];
    NSDictionary *dic = @{@"page":@"1",
                          @"pagesize":@"100"
                          };
   
    [HttpRequest postWithURLString:urlStr parameters:dic success:^(id success) {
         NSLog(@"zhibo = %@",dic);
        NSLog(@"zhibo------------%@",success);
//        if ([model.status isEqualToString:@"0"]) {
//            [AlertView(@"温馨提示", @"直播还未开始！", @"确定", nil) show];
//        }else  if ([model.status isEqualToString:@"2"]) {
//            [AlertView(
        NSInteger num = 0;
        for (NSDictionary *dic in success[@"body"]) {
            if ([dic[@"status"] isEqualToString:@"1"]) {
                num++;
            }
        }
//        self.tabBarController.tabBar.items[2].badgeValue = num > 0 ? [NSString stringWithFormat: @"%ld", (long)num] : nil;
    } failure:^(NSError *error) {
        SKLog(@"------直播列表-------%@",error);
        
    }];

}

#pragma mark -- 查看有几条未读信息
- (void)getArticleNumberRequest {
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/article"];
    NSDictionary *dic = @{@"page":@(1),
                          @"pagesize":@"10",
                          @"uid":userID
                          
                          };
    [HttpRequest postWithURLString:urlStr parameters:dic success:^(id success) {
//        NSLog(@"%@",success);
        NSString *count = success[@"count"];
        NSInteger num = [count  integerValue];
        self.tabBarController.tabBar.items[1].badgeValue = num > 0 ? [NSString stringWithFormat: @"%ld", (long)num] : nil;
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",num] forKey:@"countNumber"];
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)gatBannerImage {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",sHTTPURL,bannerUrl];
    NSDictionary *dic = @{
                          @"type":@"4"
                          };
    [HttpRequest postWithURLString:urlStr parameters:dic success:^(id success) {
        NSLog(@"学习BannerImage%@",success);
        _imageArry = [NSMutableArray array];
        for (NSDictionary *dic in success[@"body"]) {
            NSString *imageStr = [NSString stringWithFormat:@"%@%@%@",skBannerUrl,dic[@"path"],dic[@"name"]];
            [_imageArry addObject:imageStr];
        }
        [self.collectionView reloadData];
    } failure:^(NSError *error) {
//        NSLog(@"学习BannerImage%@",error);
        
    }];
}

//最新视频
//- (void)getLatestVideoListRequest {
//    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/new_video"];
//    NSDictionary *dic = @{
//                          @"page":@"1",
//                          @"pagesize":@"6"
//                          };
//    [HttpRequest postWithURLString:urlStr parameters:dic success:^(id success) {
//        NSLog(@"最新视频列表%@",success);
//        for (NSDictionary *temp in  success[@"body"]) {
//            StudyModel *model = [[StudyModel alloc] initWithDic:temp];
//            if (!_hotArr) {
//                _hotArr = [NSMutableArray array];
//            }
//            [_hotArr addObject:model];
//        }
//        
//        [self.collectionView reloadData];
//    } failure:^(NSError *error) {
//        NSLog(@"最新视频列表%@",error);
//        
//    }];
//}

//热门视频
//- (void)getHotVideoListRequest {
//    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/hot_video"];
//    NSDictionary *dic = @{
//                          @"page":@"1",
//                          @"pagesize":@"6"
//                          };
//    [HttpRequest postWithURLString:urlStr parameters:dic success:^(id success) {
//        NSLog(@"热门视频列表%@",success);
//        for (NSDictionary *temp in  success[@"body"]) {
//            StudyModel *model = [[StudyModel alloc] initWithDic:temp];
//            if (!_latestArr) {
//                _latestArr = [NSMutableArray array];
//            }
//            [_latestArr addObject:model];
//        }
//        
//        [self.collectionView reloadData];
//    } failure:^(NSError *error) {
//        NSLog(@"热门最新视频列表%@",error);
//        
//    }];
//}

- (void)requeatData{
    
    

NSString *urlStr = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/free_video"];
//
//      NSDictionary  *did = @{@"":@""};
//     [HttpRequest postWithURLString:urlStr parameters:did success:^(id success) {
//    NSArray *arr = success[@"body"];
//    
//       self.freeInfoArr = [NSMutableArray arrayWithCapacity:0];
//    
//        for (NSDictionary *dic in arr) {
//         StudyModel *model = [[StudyModel alloc] initWithDic:dic];
//        [self.freeInfoArr addObject:model];
//       }
//
    
//} failure:^(NSError *error) {
//    
//}];
}

- (void)getDataRequest {
    
    _videoInfoArr1 = [NSMutableArray array];
    _videoInfoArr2 = [NSMutableArray array];
    _videoInfoArr3 = [NSMutableArray array];
    _videoInfoArr4 = [NSMutableArray array];
    _freeInfoArr = [NSMutableArray array];
    
    NSDictionary *dic = @{
                          @"page":@"1",
                          @"pagesize":@"2",
                          };
    NSString *string = [NSString stringWithFormat:@"%@%@",sHTTPURL,categoryNew];
    [HttpRequest postWithURLString:string parameters:dic success:^(id result) {
       NSLog(@" 请求的  ++++ ===%@",result);
        
        self.idDic = [NSMutableDictionary dictionaryWithCapacity:0];
        _idDic = result[@"body"];
    
        NSLog(@"----推荐视频%@",result[@"body"]);
        NSArray *video_info1 = result[@"body"][@"video_info1"];
        NSArray *video_info2 = result[@"body"][@"video_info2"];
        NSArray *video_info3 = result[@"body"][@"video_info3"];
        NSArray *video_info4 = result[@"body"][@"video_info4"];
        NSArray *video_infoFree = result[@"body"][@"video_info0"];
        if (![video_infoFree isEqual:[NSNull null]]) {
            for (NSDictionary *dic  in video_infoFree)  {
                StudyModel *model = [[StudyModel alloc] initWithDic:dic];
                if (!_freeInfoArr) {
                    _freeInfoArr = [NSMutableArray array];
                }

                [_freeInfoArr addObject:model];
                
            }
        }
        
        
        if (![video_info1 isEqual:[NSNull null]]) {
                for (NSDictionary *temp in  video_info1) {
                    StudyModel *model = [[StudyModel alloc] initWithDic:temp];
                    if (!_videoInfoArr1) {
                        _videoInfoArr1 = [NSMutableArray array];
                    }
                    [_videoInfoArr1 addObject:model];
                }
            }
        if (![video_info2 isEqual:[NSNull null]]) {
            for (NSDictionary *temp in  video_info2) {
                StudyModel *model = [[StudyModel alloc] initWithDic:temp];
                if (!_videoInfoArr2) {
                    _videoInfoArr2 = [NSMutableArray array];
                }
                [_videoInfoArr2 addObject:model];
            }
        }

        if (![video_info3 isEqual:[NSNull null]]) {
            for (NSDictionary *temp in  video_info3) {
                StudyModel *model = [[StudyModel alloc] initWithDic:temp];
                if (!_videoInfoArr3) {
                    _videoInfoArr3 = [NSMutableArray array];
                }
                [_videoInfoArr3 addObject:model];
            }
        }
        if (![video_info4 isEqual:[NSNull null]]) {
            for (NSDictionary *temp in  video_info4) {
                StudyModel *model = [[StudyModel alloc] initWithDic:temp];
                if (!_videoInfoArr4) {
                    _videoInfoArr4 = [NSMutableArray array];
                }
                [_videoInfoArr4 addObject:model];
            }
        }
        

//
        [_collectionView reloadData];
    } failure:^(NSError *NSError) {
        [MBProgressHUD showMessage:@"加载失败！" toView:self.view delay:1.0];
        
        NSLog(@"推荐视频%@",NSError);
    }];
    
}

- (void)setNavigationItem {
    
    //设置导航栏左边按钮
    self.titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_titleBtn setTitle:@"北京" forState:UIControlStateNormal];
    _titleBtn.titleLabel.font = [UIFont systemFontOfSize: 14];
      NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14],};
    CGSize textSize = [_titleBtn.titleLabel.text boundingRectWithSize:CGSizeMake(100, 100) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    
    
    
    _titleBtn.frame = CGRectMake(0, 0,textSize.width,40);
    [_titleBtn addTarget:self action:@selector(handleTouch:) forControlEvents: UIControlEventTouchUpInside];
  

    self.imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_imageBtn setImage:[UIImage imageNamed:@"downjt"] forState:UIControlStateNormal];
    
    _imageBtn.frame = CGRectMake(CGRectGetMaxX(_titleBtn.frame)+2, 11.5,15,17);
    [_imageBtn addTarget:self action:@selector(handleTouch:) forControlEvents: UIControlEventTouchUpInside ];
  
     self.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 55, 40)];
    _leftView.userInteractionEnabled = YES;
    [_leftView addSubview:_titleBtn];
    [_leftView addSubview:_imageBtn];
    
    
    self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc] initWithCustomView:_leftView];
    
    //Set to titleView
    //添加搜索框
//    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 50, 25)];//allocate titleView
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - self.leftView.frame.size.width-10, 25)];//allocate titleView

    UIColor *color =  self.navigationController.navigationBar.barTintColor;
    
    _searchBar = [[UISearchBar alloc] init];
    
    _searchBar.delegate = self;
    _searchBar.frame = CGRectMake(3, -2, kScreenWidth  - 95, 26);
    _searchBar.backgroundColor = color;
    _searchBar.layer.cornerRadius = 5;
    _searchBar.layer.masksToBounds = YES;
    
    _searchBar.placeholder = @"搜索视频／讲师";
    [titleView addSubview:_searchBar];
    [self.navigationItem.titleView sizeToFit];
    self.navigationItem.titleView = titleView;
}

#pragma mark - collectionView数据源方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return kSectionCount;
}

#pragma mark - 每个分区返回cell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    }else if (section == 5) {
        return _videoInfoArr4.count;
    }else if (section == 4) {
        return _videoInfoArr3.count;
    }else if (section == 2) {
        return _videoInfoArr1.count;
    }else if (section == 3) {
        return _videoInfoArr2.count;
    }else{
    return _freeInfoArr.count;
    }
}
//垂直滚动资讯数据
- (void)requestZixun{
    //请求资讯数据
    _informationDataDic = [NSMutableDictionary dictionary];

    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/hot_article"];
    NSDictionary *di = @{@"page":@"1",
                         @"pagesize":@"2"
                         };
    __weak typeof (self)weakSelf = self;
    [HttpRequest postWithURLString:urlStr parameters:di success:^(id success) {
        NSLog(@"------------%@",success);
        NSMutableArray *titleArr = [NSMutableArray array];
        NSMutableArray *descriptionArr = [NSMutableArray array];
        for (NSDictionary *dic in success[@"body"]) {
            [titleArr addObject:dic[@"title"]];
            [descriptionArr addObject:dic[@"description"]];        }
        [_informationDataDic setObject:titleArr forKey:@"title"];
        [_informationDataDic setObject:descriptionArr forKey:@"description"];
        [self.collectionView reloadData];
        
    }failure:^(NSError *error) {
        SKLog(@"------直播列表-------%@",error);
        
    }];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
            HomeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCell" forIndexPath:indexPath];
            cell.catNameArray = _catNameArr;
            cell.catIdArray = _catIdArr;
            cell.imageArray = _imageArr;
            [cell homeCellUi:_imageArry];
            [cell setTitleArray:_informationDataDic];

            return cell;
           }
    if (indexPath.section == 1) {
        StudyViewCustomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCustomCell forIndexPath:indexPath];
        cell.layer.cornerRadius =  2;
        cell.layer.masksToBounds = YES;
        cell.backgroundColor = [UIColor whiteColor];
        StudyModel*model = _freeInfoArr[indexPath.row];
        NSLog(@"加载第一个数据了");
        [cell initCustomCellModel:model];
        return  cell;
    }
    
    if (indexPath.section == 2) {
        StudyViewCustomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCustomCell forIndexPath:indexPath];
        cell.layer.cornerRadius =  2;
        cell.layer.masksToBounds = YES;
        cell.backgroundColor = [UIColor whiteColor];
        StudyModel *model = _videoInfoArr1[indexPath.row];
        [cell initCustomCellModel:model];
        
        return cell;

    }
    if (indexPath.section == 3) {
        StudyViewCustomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCustomCell forIndexPath:indexPath];
        cell.layer.cornerRadius =  2;
        cell.layer.masksToBounds = YES;
        cell.backgroundColor = [UIColor whiteColor];
        StudyModel *model = _videoInfoArr2[indexPath.row];
        [cell initCustomCellModel:model];
        return cell;
        
    }
    if (indexPath.section == 4) {
        StudyViewCustomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCustomCell forIndexPath:indexPath];
        cell.layer.cornerRadius =  2;
        cell.layer.masksToBounds = YES;
        cell.backgroundColor = [UIColor whiteColor];
        StudyModel*model = _videoInfoArr3[indexPath.row];
        [cell initCustomCellModel:model];
        return cell;
    }
    if (indexPath.section == 5) {
        StudyViewCustomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCustomCell forIndexPath:indexPath];
        cell.layer.cornerRadius =  2;
        cell.layer.masksToBounds = YES;
        cell.backgroundColor = [UIColor whiteColor];
        StudyModel*model = _videoInfoArr4[indexPath.row];
        [cell initCustomCellModel:model];
        return cell;
    }
    
    return nil;
}



#pragma mark - 点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    @property (nonatomic, strong) NSMutableArray *videoInfoArr1;
//    @property (nonatomic, strong) NSMutableArray *videoInfoArr2;
//    @property (nonatomic, strong) NSMutableArray *videoInfoArr3;
//    @property (nonatomic, strong) NSMutableArray *videoInfoArr4;
//    @property (nonatomic,strong)NSMutableArray *  freeInfoArr;
        if  (indexPath.section == 2) {
            StudyModel *model = _videoInfoArr1[indexPath.row];
            VedioPlayerViewController *searchVC = [VedioPlayerViewController new];
            searchVC.model = model;
            searchVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:searchVC animated:YES];

            
        }else if (indexPath.section == 3) {
            StudyModel *model = _videoInfoArr2[indexPath.row];
            VedioPlayerViewController *searchVC = [VedioPlayerViewController new];
            searchVC.model = model;
            searchVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:searchVC animated:YES];


        }else if (indexPath.section == 4) {
            StudyModel *model = _videoInfoArr3[indexPath.row];
            VedioPlayerViewController *searchVC = [VedioPlayerViewController new];
            searchVC.model = model;
            searchVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:searchVC animated:YES];
            
        }
        else if (indexPath.section == 5) {
            StudyModel *model = _videoInfoArr4[indexPath.row];
            VedioPlayerViewController *searchVC = [VedioPlayerViewController new];
            searchVC.model = model;
            searchVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:searchVC animated:YES];
        }
        else if (indexPath.section == 1){
            StudyModel *model = _freeInfoArr[indexPath.row];
            VedioPlayerViewController *searchVC = [VedioPlayerViewController new];
            searchVC.model = model;
            searchVC.freeId = 1;
            searchVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:searchVC animated:YES];

        }

}

#pragma mark - 区头
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableview = [UICollectionReusableView new];
    reusableview.frame = CGRectMake(0, 0, kScreenWidth, 50);
    //NSLog(@"kind = %@", kind);
    if (kind == UICollectionElementKindSectionHeader){
        
        StudyCustomHaedView *headerV = (StudyCustomHaedView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeadView" forIndexPath:indexPath];
        headerV.backgroundColor = kCustomVCBackgroundColor;
        
        NSArray *array = @[@"",@"免费课程",@"营养学最新课程",@"健康管理最新课程",@"心理学最新课程",@"人力资源最新课程"];
        

        headerV.titleLabel.text = array[indexPath.section];
        
        UIImage *image = [UIImage imageNamed:@"arrowImage"];
            [headerV.button setImage:image forState:UIControlStateNormal];
        [headerV.button addTarget:self action:@selector(gengduoBtn:) forControlEvents:UIControlEventTouchUpInside];
     
  
        headerV.button.tag = indexPath.section;
        

        reusableview = headerV;
    }
    
    return reusableview;
}

#pragma mark - FlowLayoutDelegate
#pragma mark - 宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 每行有几个item
    int numPerLine = 0;
    
    if (indexPath.section == 0) {
//        NSLog(@"点点滴滴 = %f,kScreenHeight / 1.65");

        return CGSizeMake(kScreenWidth, kScreenHeight / 1.65  + 70);


    }else {
        
        numPerLine = 2;
        CGFloat itemW = (kScreenWidth - kVToSide * 2 - kVToView) / numPerLine;
        CGFloat itemH = itemW * 1.2;
        if (kScreenWidth < 375)
        {
            itemH = itemW * 0.8;
        }
        return  CGSizeMake(itemW, kScreenHeight / 3.6);
    }
    return CGSizeMake(0, 0);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, kVToSide, kVToView, kVToSide);
}

//最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0f;
}

//最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return kVToView;
}

//当我们的不同分区区头区尾高度不一致时,可通过以下两种方法进行实时配置,如果统一就不用实现.
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0)
    {
        //不返回高度
        return CGSizeMake(0, 0);
    }
    //返回区头高度
    if (section == 1) {
        if (_freeInfoArr .count == 0) {
            return CGSizeMake(0, 0);
        }else{
            return CGSizeMake(0, 45);
        }
    }
    if (section == 2) {
        if (_videoInfoArr1.count == 0) {
            return CGSizeMake(0, 0);
        }else {
            return CGSizeMake(0, 45);
        }
    }
    if (section == 3) {
        if (_videoInfoArr2.count == 0) {
            return CGSizeMake(0, 0);
        }else {
            return CGSizeMake(0, 45);
        }
    }
    if (section == 4) {
        if (_videoInfoArr3.count == 0) {
            return CGSizeMake(0, 0);
        }else {
            return CGSizeMake(0, 40);
        }
    }
    if (section == 5) {
        if (_videoInfoArr4.count == 0) {
            return CGSizeMake(0, 0);
        }else {
            return CGSizeMake(0, 40);
        }
    }
    return CGSizeMake(0, 45);
}
#pragma mark ---- 分区上更多按钮 ------
- (void)gengduoBtn:(UIButton *)sender {
 
    IntroduceViewController *introVC = [[IntroduceViewController alloc] init];
    introVC.hidesBottomBarWhenPushed = YES;

    introVC.tagId = sender.tag;
    NSArray *array = @[@"",@"免费课程",@"营养学最新课程",@"健康管理最新课程",@"心理学最新课程",@"人力资源最新课程"];
    introVC.titleText = array[sender.tag];
    NSArray *idArr2 = self.idDic[@"video_info1"];
    NSArray *idArr3 = self.idDic[@"video_info2"];

    NSArray *idArr4 = self.idDic[@"video_info3"];
    NSArray *idArr5 = self.idDic[@"video_info4"];
    NSArray *idArr1 = self.idDic[@"video_info0"];

    
     if (sender.tag == 2) {
        NSDictionary *dic = idArr2[0];
            self.iid = dic[@"cat_id"];
          introVC.catID = self.iid;

       
    }else if (sender.tag == 3){
        NSDictionary *dic = idArr3[0];
            self.iid = dic[@"cat_id"];

        introVC.catID = self.iid;

        
    }else if (sender.tag == 4){
        NSDictionary *dic = idArr4[0];

            self.iid = dic[@"cat_id"];

        introVC.catID = self.iid;


        
    }else if (sender.tag == 5){
        NSDictionary *dic = idArr5[0];

        self.iid = dic[@"cat_id"];
        introVC.catID = self.iid;


    }else if (sender.tag == 1){
        NSDictionary *dic = idArr1[0];
        self.iid = dic[@"cat_id"];
        introVC.catID = self.iid;
        introVC.freeID = 1;
    }
    
    [self.navigationController pushViewController:introVC animated:YES];
}

//- (void)rightButton:(UIButton *)sender {
////    if (![_searchBar.text isEqualToString:@""]) {
////        NavigationViewController *navigationVC = [[NavigationViewController alloc] init];
////        navigationVC.keyStr = _searchBar.text;
////        navigationVC.hidesBottomBarWhenPushed = YES;
////        [self.navigationController pushViewController:navigationVC animated:YES];
////    }else {
////        [MBProgressHUD showMessage:@"请输入关键词搜索！" toView:self.view delay:1.0];
////    }
//}

#pragma mark AlertView
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSLog(@"....");
        LogonViewController *logonVC = [LogonViewController new];
        UINavigationController *loginNav = [[UINavigationController alloc]initWithRootViewController:logonVC];
        //模态弹出  这里
        [self presentViewController:loginNav animated:YES completion:nil];
    }
}

//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
//    [self rightButton:(UIButton *)searchBar];
//}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    // 获取开始拖拽时collectionView偏移量
    [_searchBar resignFirstResponder];
    
}

//视图将要出现时 调用此方法
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barTintColor = kCustomNavColor;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:16],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [self getArticleNumberRequest];
    
    [self playLiveIngNumber];
}

#pragma mark - UISearchBar代理方法
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    NSLog(@"UISearchBar第一响应");
    SearchViewController *searchVC = [SearchViewController new];
    searchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:NO];
    
}
#pragma mark - 导航栏左地区按钮点击

- (void)handleTouch:(UIBarButtonItem *)buttonItem{
    AreaViewController *area = [[AreaViewController alloc] init];
//    area.flag = 1;
    
    area.frontText = self.titleBtn.titleLabel.text;
    area.block = ^(NSString *str) {
            [MBProgressHUD showMessage:[NSString stringWithFormat:@"已经切换到%@校区",str] toView:self.view  delay:1.5];
    
        [_titleBtn setTitle:str forState:UIControlStateNormal];
            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14],};
       CGSize textSize = [str boundingRectWithSize:CGSizeMake(100, 100) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
        
        
        
        _titleBtn.frame = CGRectMake(0, 0,textSize.width,40);
        _imageBtn.frame = CGRectMake(CGRectGetMaxX(_titleBtn.frame)+2, 11.5,15,17);
      
      //_imageBtn.frame = CGRectMake(CGRectGetMaxX(_titleBtn.frame), 8.5,20,23);
        self.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, textSize.width +18, 40)];
    };
    area.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:area animated:YES];
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
