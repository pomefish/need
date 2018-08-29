//
//  TeachingViewController.m
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2017/8/28.
//  Copyright © 2017年 ShangKe. All rights reserved.
//

#import "TeachingViewController.h"
#import "TeachingCell.h"
#import "TeachingImageCell.h"
#import "MessageModel.h"
//#import "ContentViewController.h"
#import "TGWebViewController.h"
#import "TeachingSearhBarViewController.h"

@interface TeachingViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchBar    *searchBar;

@property (nonatomic, strong) NSMutableArray *teachingArr;
@property (nonatomic, assign) NSInteger numberOfPageSize;
@property (nonatomic, assign) BOOL isMoreData;

@end

@implementation TeachingViewController
- (UITableView *)tableView {
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.tableFooterView = [UIView new];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [self.tableView registerNib:[UINib nibWithNibName:@"TeachingCell" bundle:nil] forCellReuseIdentifier:@"TeachingCell"];
         [self.tableView registerNib:[UINib nibWithNibName:@"TeachingImageCell" bundle:nil] forCellReuseIdentifier:@"TeachingImageCell"];
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.barTintColor = kCustomNavColor;
    
    leftBarButton(@"returnImage");
    
    [self setNavigationItem];
    
    [self.view addSubview:self.tableView];
    
    _teachingArr = [NSMutableArray array];
    [self getTeachingDataRequest:YES];
    __typeof (self) __weak weakSelf = self;
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        
        [weakSelf getTeachingDataRequest:YES];
        
    }];
    
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        
        [weakSelf getTeachingDataRequest:NO];
        
    }];
    
}


- (void)setNavigationItem {
    //添加搜索框
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 100, 25)];//allocate titleView
    UIColor *color =  self.navigationController.navigationBar.barTintColor;
    
    _searchBar = [[UISearchBar alloc] init];
    
    _searchBar.delegate = self;
    _searchBar.frame = CGRectMake(0, -2, kScreenWidth - 100, 26);
    _searchBar.backgroundColor = color;
    _searchBar.layer.cornerRadius = 5;
    _searchBar.layer.masksToBounds = YES;
    
    _searchBar.placeholder = @"请输入关键词搜索！";
    [titleView addSubview:_searchBar];
    
    //Set to titleView
    [self.navigationItem.titleView sizeToFit];
    self.navigationItem.titleView = titleView;
    
}

- (void)getTeachingDataRequest:(BOOL)isPull {
    
    if (isPull) {
        _numberOfPageSize = 1;
        
    }
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
    NSDictionary *dic = @{
                          @"page":@(_numberOfPageSize),
                          @"pagesize":@"10",
                          @"uid":userID
                          };
    NSString *string = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/teachservice"];
    [HttpRequest postWithURLString:string parameters:dic success:^(id success) {
        
        NSLog(@"----Teaching--------%@",[success objectForKey:@"body"]);
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        if (_numberOfPageSize == 1) {
            [_teachingArr removeAllObjects];
            
        };
        _isMoreData = [success[@"body"] count] > 0 && [success[@"body"] count] < 10;
        if (_isMoreData) {
            [_tableView.footer noticeNoMoreData];
            _numberOfPageSize --;
        }
        _numberOfPageSize ++;
        
        for (NSInteger i = 0; i<[[success objectForKey:@"body"]count]; i++) {
            MessageModel *model = [[MessageModel alloc] initWithDic:[success objectForKey:@"body"][i]];
            
            [_teachingArr addObject:model];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (_teachingArr.count <= 0) {
            [self noDataView];
        }
        [self.tableView reloadData];
    } failure:^(NSError *NSError) {
        [MBProgressHUD showMessage:@"加载失败！" toView:self.view delay:1.0];
        [self noDataView];
        NSLog(@"-------Teaching-------%@",NSError);
    }];
    
}


- (void)noDataView {
    NoDataView *noData = [[NoDataView alloc] initWithFrame:self.tableView.frame];
    [noData noDataViewTryImage:@"no_data" tryLabel:@"暂无信息!" tryBtn:@""];
    noData.tryBtn.hidden = YES;
    noData.backgroundColor = kCustomVCBackgroundColor;
    [self.tableView addSubview:noData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageModel *model = _teachingArr[indexPath.row];
    if ([model.image isEqualToString:@""]) {
        TeachingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TeachingCell"];
        
        [cell customCellModel:model];
        return cell;
    }else {
        TeachingImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TeachingImageCell"];
        
        [cell customCellModel:model];
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MessageModel *model = _teachingArr[indexPath.row];
    
    if ([model.image isEqualToString:@""]) {
        return 120.0f;
    }else {
        return 300.0f;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _teachingArr.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageModel *model = _teachingArr[indexPath.row];
    
//    ContentViewController *contenVC = [[ContentViewController alloc] init];
//    contenVC.contentModel = model;
//    contenVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:contenVC animated:YES];
    TGWebViewController *TGWebVC = [TGWebViewController new];
    TGWebVC.url = [NSString stringWithFormat:@"http://newapp.mingtaokeji.com/article_app.php?id=%@",[NSString stringWithFormat:@"%@",model.ID]];
    TGWebVC.title = model.title;
    TGWebVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:TGWebVC animated:YES];

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0 ) {
        UIView *header = [[UIView alloc] init];
        header.frame = CGRectMake(0, 0, kScreenWidth, 0.01);
        return header;
        
    }
    UIView *header = [[UIView alloc] init];
    header.frame = CGRectMake(0, 0, kScreenWidth, 10);
    
    return header;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *header = [[UIView alloc] init];
    header.frame = CGRectMake(0, 0, kScreenWidth, 0.01);
    return header;
}
#pragma mark - UISearchBar代理方法
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    NSLog(@"UISearchBar第一响应");
    TeachingSearhBarViewController *searchVC = [TeachingSearhBarViewController new];
    searchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:NO];
    
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
