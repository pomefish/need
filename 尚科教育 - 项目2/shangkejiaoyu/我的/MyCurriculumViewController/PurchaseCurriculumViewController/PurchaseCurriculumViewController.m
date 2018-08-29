//
//  PurchaseCurriculumViewController.m
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2017/7/14.
//  Copyright © 2017年 ShangKe. All rights reserved.
//

#import "PurchaseCurriculumViewController.h"
#import "StudyCustomHaedView.h"
#import "OneCollectionViewCell.h"
#import "StudyModel.h"
#import "IntroduceViewController.h"

#define kVToSide 8.0f
#define kVToView 8.0f
@interface PurchaseCurriculumViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate>
{
    NSArray *_bodyArr;
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout * layout;

@property (nonatomic, strong) NSMutableArray *categoryArr;
@property (nonatomic, strong) NSMutableArray *mutableArr;
@property (nonatomic, strong) NSMutableArray *catNameArr;

@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation PurchaseCurriculumViewController

-(NSMutableArray *)categoryArr
{
    if (_categoryArr == nil) {
        self.categoryArr = [[NSMutableArray alloc]init];
    }
    return _categoryArr;
}
-(NSMutableArray*)dataArr
{
    if (_dataArr == nil) {
        self.dataArr = [[NSMutableArray alloc]init];
    }
    return _dataArr;
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
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,kScreenHeight - kNavHeight - kTabHeight) collectionViewLayout:self.layout];
        //设置代理
        self.collectionView.delegate = self;
        //设置数据源
        self.collectionView.dataSource = self;
        self.collectionView.backgroundColor = kCustomVCBackgroundColor;
        
        //系统自带的cell
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"kSystemCell"];
        
        [self.collectionView registerClass:[OneCollectionViewCell class] forCellWithReuseIdentifier:@"customCell"];
        
        //注册区头
        [self.collectionView registerClass:[StudyCustomHaedView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeadView"];
    }
    return _collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _mutableArr = [NSMutableArray array];
    _dataArr = [NSMutableArray array];
    [self.view addSubview:self.collectionView];
    
    [self getDataRequest];
}

- (void)getDataRequest {
    
    NSUserDefaults* user = [[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];
    NSDictionary *dic = @{
                          @"page":@"1",
                          @"pagesize":@"10",
                          @"uid":user
                          };
    NSString *string = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/my_course"];
    [HttpRequest postWithURLString:string parameters:dic success:^(id success) {
        NSLog(@"------已购课程-------%@",success);
        _bodyArr = success[@"body"];
        
        for (NSDictionary *dict in success[@"body"]) {
            if (!_categoryArr) {
                _categoryArr = [NSMutableArray array];
            }
            [_categoryArr addObject:dict[@"cat_name"]];
        }
        if (_bodyArr.count <= 0) {
            [self noDataView];
        }
        [_collectionView reloadData];
    } failure:^(NSError *NSError) {
        [MBProgressHUD showMessage:@"加载失败！" toView:self.view delay:1.0];
        [self noDataView];
        NSLog(@"已购课程%@",NSError);
    }];
}
#pragma mark - collectionView数据源方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _bodyArr.count;
}

#pragma mark - 每个分区返回cell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (![_bodyArr[section][@"category"] isKindOfClass:[NSNull class]]) {
        NSArray *itemsArr = _bodyArr[section][@"category"];
        return itemsArr.count;
    }else{
        return 0;
    }
    
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    OneCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"customCell" forIndexPath:indexPath];
    
    if (![_bodyArr[indexPath.section][@"category"] isKindOfClass:[NSNull class]]) {
        NSArray *itemsArr = _bodyArr[indexPath.section][@"category"];
        NSDictionary *tempDic = itemsArr[indexPath.row];
        NSString *lableTitle = tempDic[@"cat_name"];
        cell.titleLabel.text = lableTitle;
        
    }
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
}

#pragma mark - 区头
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableview = [UICollectionReusableView new];
    reusableview.frame = CGRectMake(0, 0, kScreenWidth, 50);
    //NSLog(@"kind = %@", kind);
    if (kind == UICollectionElementKindSectionHeader){
        
        StudyCustomHaedView *headerV = (StudyCustomHaedView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeadView" forIndexPath:indexPath];
        headerV.haedView.backgroundColor = [UIColor clearColor];
        headerV.backgroundColor = kCustomVCBackgroundColor;
        headerV.titleLabel.text = _categoryArr[indexPath.section];
        reusableview = headerV;
    }
    
    return reusableview;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    IntroduceViewController *introduceVC = [IntroduceViewController new];

    if (![_bodyArr[indexPath.section][@"category"] isKindOfClass:[NSNull class]]) {
        NSArray *itemsArr = _bodyArr[indexPath.section][@"category"];
        NSDictionary *tempDic = itemsArr[indexPath.row];
        NSString *lableTitle = tempDic[@"cat_id"];
        introduceVC.catID = lableTitle;
    }
    introduceVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:introduceVC animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return  CGSizeMake((kScreenWidth - 40) / 3, 45);
}

//当我们的不同分区区头区尾高度不一致时,可通过以下两种方法进行实时配置,如果统一就不用实现.
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(0, 45);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, kVToSide, kVToView, kVToSide);
}

- (void)noDataView {
    NoDataView *noData = [[NoDataView alloc] initWithFrame:self.collectionView.frame];
    [noData noDataViewTryImage:@"no_data" tryLabel:@"暂无已购课程!" tryBtn:@""];
    noData.tryBtn.hidden = YES;
    noData.backgroundColor = kCustomVCBackgroundColor;
    [self.collectionView addSubview:noData];
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
