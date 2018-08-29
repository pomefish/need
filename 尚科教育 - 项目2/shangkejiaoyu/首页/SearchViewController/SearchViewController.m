//
//  SearchViewController.m
//  demo
//
//  Created by smsx on 15/11/23.
//  Copyright (c) 2015年 smsx. All rights reserved.
//

#import "SearchViewController.h"
#import "StudyViewCustomCell.h"
#import "StudyModel.h"
#import "VedioPlayerViewController.h"
#import "VedioViewController.h"

//cell标记
#define kSysytemCell @"systemCell"

#define kHistorySearch [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] stringByAppendingString:@"historySearch.data"]

//topSortBtn高度
#define kTopBtnH 35

//历史搜索cell高度
#define kHistortyTableH 30
//搜索结果cell高度
#define kSearchResultTableH 90

//系统cell
#define kCustomCell @"customCell"

//边距
#define kVToSide 0.0f
#define kVToView 0.0f

@interface SearchViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
//搜索bar
@property (nonatomic, strong) UISearchBar    *searchBar;
//搜索结果tableview
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout * layout;

@property (nonatomic, strong) UIView *searchRusultView;
//历史搜索记录
@property (nonatomic, strong) UITableView *historyTableView;
//历史搜索数据源
@property (nonatomic, strong) NSMutableArray *historyDataSource;
//搜索结果数据源
@property (nonatomic, strong) NSMutableArray *resultDataSource;

@property (nonatomic, strong) NSArray *dataArr;
@end

@implementation SearchViewController

- (NSMutableArray *)historyDataSource
{
    if (_historyDataSource == nil) {
        //判断是否是第一次进入
        BOOL isHasFile = [[NSFileManager defaultManager] fileExistsAtPath:kHistorySearch];
        
        if (isHasFile)
        {
            //从本地读取数据
            self.historyDataSource = [[NSArray arrayWithContentsOfFile:kHistorySearch] mutableCopy];
            
        }
        else
        {
            //生成一个数据
            self.historyDataSource = [@[] mutableCopy];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, kScreenHeight / 3, kScreenWidth  , 20)];
            label.textColor = [UIColor lightGrayColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = @"暂无历史纪录！";
            [self.view addSubview:label];
        }
        
    }
    return _historyDataSource;
}

- (UITableView *)historyTableView {
    if (_historyTableView == nil) {
        self.historyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight + 10, kScreenWidth, kScreenHeight - kNavHeight) style:UITableViewStylePlain];
        //注册cell
        [self.historyTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kSysytemCell];
        self.historyTableView.delegate = self;
        self.historyTableView.dataSource = self;
        //不让其滚动
        self.historyTableView.bounces = NO;
        
        // 如果搜索记录有值
        if (self.historyDataSource.count) {
            self.historyTableView.hidden = NO;
        }else
        {
            //如果没有搜索记录，隐藏
            self.historyTableView.hidden = YES;
        }
        
        UIPanGestureRecognizer *tap = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewClick)];
        [self.historyTableView addGestureRecognizer:tap];
    }
    return _historyTableView;
}

- (void)tableViewClick
{
    [self.searchBar resignFirstResponder];
}

#pragma mark - UICollectionView
- (UICollectionViewFlowLayout *)layout
{
    if (_layout == nil)
        
    {
        self.layout = [[UICollectionViewFlowLayout alloc] init];
    }
    return _layout;
}

-  (UICollectionView *)collectionView {
    if (_collectionView == nil)
    {
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth,kScreenHeight - kNavHeight + 3) collectionViewLayout:self.layout];
        //设置代理
        self.collectionView.delegate = self;
        //设置数据源
        self.collectionView.dataSource = self;
        self.collectionView.backgroundColor = kCustomVCBackgroundColor;
        
        [self.collectionView registerClass:[StudyViewCustomCell class] forCellWithReuseIdentifier:kCustomCell];
    }
    return _collectionView;
}

- (UIView *)searchRusultView
{
    if (_searchRusultView == nil) {
        self.searchRusultView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        self.searchRusultView.backgroundColor = [UIColor whiteColor];
        //添加子视图
        [self.searchRusultView addSubview:self.collectionView];
        //        [self.searchRusultView addSubview:self.topSortBtnView];
        //自动适应布局
        self.automaticallyAdjustsScrollViewInsets = NO;
        // 第一次加载出来默认是隐藏状态
        self.searchRusultView.hidden = YES;
    }
    return _searchRusultView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    leftBarButton(@"returnImage");
    self.view.backgroundColor = [UIColor whiteColor];
    //添加子视图
    [self.view addSubview:self.historyTableView];
    [self.view addSubview:self.searchRusultView];
    
    //添加item
    [self setNavgationItem];
    
    self.resultDataSource = [NSMutableArray array];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.searchBar becomeFirstResponder];
}

- (void)setNavgationItem {
    
    //添加搜索框
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 100, 25)];//allocate titleView
    UIColor *color =  self.navigationController.navigationBar.barTintColor;
    
    _searchBar = [[UISearchBar alloc] init];
    
    _searchBar.delegate = self;
    _searchBar.frame = CGRectMake(0, -2, kScreenWidth - 100, 26);
    _searchBar.backgroundColor = color;
    _searchBar.layer.cornerRadius = 5;
    _searchBar.layer.masksToBounds = YES;
    //    [_searchBar.layer setBorderWidth:8];
    //    [_searchBar.layer setBorderColor:[UIColor whiteColor].CGColor];  //设置边框为白色
    
    _searchBar.placeholder = @"搜索视频／讲师";
//    _searchBar.keyboardType = UIKeyboardTypeDefault;
    [titleView addSubview:_searchBar];
    
    //Set to titleView
    [self.navigationItem.titleView sizeToFit];
    self.navigationItem.titleView = titleView;
    
}

#pragma mark - tableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.historyTableView) {
        return self.historyDataSource.count;
    }
    return self.resultDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //判断tableView的类型
    if (tableView == self.historyTableView)
    {
        //生成cell
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSysytemCell];
        cell.textLabel.text = self.historyDataSource[indexPath.row];
        //设置cell的字体颜色
        cell.textLabel.textColor = [UIColor lightGrayColor];
        return cell;
        
    }
    //    SearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"resultCell" forIndexPath:indexPath];
    //    GoodModel *model = self.resultDataSource[indexPath.row];
    //    //使用变量对model赋值
    //    cell.model = model;
    return nil;
}

//点击cell触发该方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.historyTableView) {
        NSString *keyWord = self.historyDataSource[indexPath.row];
        [self searchGoodsWithKeyWord:keyWord];
    }
}

//返回区头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] init];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 80, 20)];
    label.textColor = [UIColor lightGrayColor];
    label.text = @"历史纪录";
    [headView addSubview:label];
    return headView;
}

//返回区尾视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc] init];
    //添加button按钮
    UIButton *clearHisBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    clearHisBtn.frame = CGRectMake(40, 60, kScreenWidth - 80, 40);
    //添加点击事件
    [clearHisBtn addTarget:self action:@selector(clearHisRecClick:) forControlEvents:UIControlEventTouchUpInside];
    //设置button文字
    [clearHisBtn setTitle:@"清除历史纪录" forState:UIControlStateNormal];
    clearHisBtn.backgroundColor = kCustomViewColor;
    //设置圆角
    clearHisBtn.layer.cornerRadius = 2;
    clearHisBtn.layer.masksToBounds = YES;
    
    [footView addSubview:clearHisBtn];
    return footView;
}
//返回cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.historyTableView)
    {
        return kHistortyTableH;
    }
    return kSearchResultTableH;
}
//返回区头的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.historyTableView)
    {
        return kHistortyTableH;
    }
    return 0;
}

//返回区尾高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (tableView == self.historyTableView) {
        return kSearchResultTableH;
    }
    return 0;
}

//滑动删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.historyDataSource removeObjectAtIndex:indexPath.row];
        [[NSUserDefaults standardUserDefaults] setObject:self.historyDataSource forKey:kHistorySearch];
        [tableView reloadData];
        
    }
}
//只可以删除历史记录
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.historyTableView) {
        return YES;
    }
    return NO;
}
//清除历史纪录
- (void)clearHisRecClick:(UIButton *)sender {
    //清空数据源
    [self.historyDataSource removeAllObjects];
    //做个标记 沙盒中没有数据
    [[NSFileManager defaultManager] removeItemAtPath:kHistorySearch error:nil];
    [self.historyTableView reloadData];
    //隐藏历史纪录视图
    [self.historyTableView setHidden:YES];
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchBar.text.length == 0) {
        //隐藏搜索结果
        //        [self.topSortBtnView removeFromSuperview];
        //        self.topSortBtnView = nil;
        self.searchRusultView.hidden = YES;
        //刷新历史纪录
        [self.historyTableView reloadData];
        self.historyTableView.hidden = NO;
        
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    //把搜索记录添加到数组里
    if (![self.historyDataSource containsObject:searchBar.text]) {
        [self.historyDataSource insertObject:searchBar.text atIndex:0];
        // [self.historyDataSource addObject:searchBar.text];
    }
    
    //每次都存到沙盒里
    [self.historyDataSource writeToFile:kHistorySearch atomically:YES];
    
    [self searchGoodsWithKeyWord:searchBar.text];
    
}

#pragma mark - 根据输入关键字查找
- (void)searchGoodsWithKeyWord:(NSString *)keyWord {
    if (![keyWord isEqualToString:@""]) {
        NSString *httpStr = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/v_search"];
        NSDictionary *dic = @{
                              @"page":@"1",
                              @"pagesize":@"10",
                              @"key":keyWord
                              };
        [HttpRequest postWithURLString:httpStr parameters:dic success:^(id success) {
            NSLog(@"-----------%@",success[@"body"]);
            _dataArr = success[@"body"];
            self.view.backgroundColor = [UIColor whiteColor];
            if ([success[@"msg"] isEqualToString:@"无内容"]) {
                [MBProgressHUD showMessage:@"没有搜索到内容" toView:self.view delay:1.0];
                self.collectionView.backgroundColor = kCustomColor(239, 239, 244);
                self.view.backgroundColor = kCustomColor(239, 239, 244);
            }else {
                self.searchBar.text = keyWord;
                //隐藏历史纪录视图
                self.historyTableView.hidden = YES;
                //显示搜索结果视图
                self.searchRusultView.hidden = NO;
                NSLog(@"搜索结果 = %@",success);
                for (NSDictionary *temp in  success[@"body"]) {
                    StudyModel *model = [[StudyModel alloc] initWithDic:temp];
                    if (!self.resultDataSource) {
                        self.resultDataSource = [NSMutableArray array];
                    }
                    [self.resultDataSource addObject:model];
                }
                
                [self.collectionView reloadData];
            }
            
        } failure:^(NSError *error) {
            NSLog(@"搜索学习%@",error);
            [MBProgressHUD showMessage:@"搜索失败！" toView:self.collectionView delay:1.0];

        }];
        
    }else {
        [MBProgressHUD showMessage:@"请输入关键词搜索！" toView:self.view delay:1.0];
    }
    //退出键盘
    [self.searchBar resignFirstResponder];
    
}

#pragma mark - 点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    StudyModel *model = _resultDataSource[indexPath.row];
    VedioPlayerViewController *vedioPlayerVC = [VedioPlayerViewController new];
    vedioPlayerVC.model = model;
    [self.navigationController pushViewController:vedioPlayerVC animated:YES];
}

#pragma mark - 每个分区返回cell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _resultDataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    StudyViewCustomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCustomCell forIndexPath:indexPath];
    cell.layer.cornerRadius =  2;
    cell.layer.masksToBounds = YES;
    cell.backgroundColor = [UIColor whiteColor];
    StudyModel *model = _resultDataSource[indexPath.row];
    [cell initCustomCellModel:model];
    
    return cell;
}

//最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return kVToView;
}

//最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return kVToView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 每行有几个item
    int numPerLine = 0;
    
    numPerLine = 2;
    CGFloat itemW = (kScreenWidth - kVToSide * 2 - kVToView) / numPerLine;
    CGFloat itemH = itemW * 1.2;
    if (kScreenWidth < 375)
    {
        itemH = itemW * 0.8;
    }
    return  CGSizeMake(itemW, 140);
}

- (void)leftButton:(UIButton*)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
