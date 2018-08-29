//
//  TeachingSearhBarViewController.m
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2017/8/28.
//  Copyright © 2017年 ShangKe. All rights reserved.
//

#import "TeachingSearhBarViewController.h"
#import "TeachingCell.h"
#import "TeachingImageCell.h"
#import "MessageModel.h"
#import "ContentViewController.h"

@interface TeachingSearhBarViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchBar    *searchBar;

@property (nonatomic, strong) NSMutableArray *teachingArr;
@property (nonatomic, assign) NSInteger numberOfPageSize;
@property (nonatomic, assign) BOOL isMoreData;

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *resultDataSource;
@end

@implementation TeachingSearhBarViewController
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
    
    [self.view addSubview:self.tableView];
    [self setNavigationItem];
    
    _teachingArr = [NSMutableArray array];
//    [self getTeachingDataRequest:YES];
//    __typeof (self) __weak weakSelf = self;
//    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        // 进入刷新状态后会自动调用这个block
//        
//        [weakSelf getTeachingDataRequest:YES];
//        
//    }];
//    
//    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        // 进入刷新状态后会自动调用这个block
//        
//        [weakSelf getTeachingDataRequest:NO];
//        
//    }];
    
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
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"%@",searchBar.text);
    [_dataArr removeAllObjects];//点击确定按钮的时候 先清空之前的数据源数组，以便于存入最新的搜索结果
//    [self httpRequest];//根据输入的关键字，从新请求数据 请求之后 刷新表
    
    [self searchGoodsWithKeyWord:searchBar.text];
}
#pragma mark - 根据输入关键字查找
- (void)searchGoodsWithKeyWord:(NSString *)keyWord {
    if (![keyWord isEqualToString:@""]) {
        NSString *httpStr = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/teachservice"];
        NSDictionary *dic = @{
                              @"page":@"1",
                              @"pagesize":@"1000",
                              @"key":keyWord
                              };
        [HttpRequest postWithURLString:httpStr parameters:dic success:^(id success) {
            
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
            
            [self.tableView reloadData];
            
        } failure:^(NSError *error) {
            NSLog(@"搜索学习%@",error);
            [MBProgressHUD showMessage:@"搜索失败！" toView:self.tableView delay:1.0];
            
        }];
        
    }else {
        [MBProgressHUD showMessage:@"请输入关键词搜索！" toView:self.view delay:1.0];
    }
    //退出键盘
    [self.searchBar resignFirstResponder];
    
}


//- (void)getTeachingDataRequest:(BOOL)isPull {
//    
//    if (isPull) {
//        _numberOfPageSize = 1;
//        
//    }
//    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
//    NSDictionary *dic = @{
//                          @"page":@(_numberOfPageSize),
//                          @"pagesize":@"10",
//                          @"uid":userID
//                          };
//    NSString *string = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/teachservice"];
//    [HttpRequest postWithURLString:string parameters:dic success:^(id success) {
//        
//        NSLog(@"----Teaching--------%@",[success objectForKey:@"body"]);
//        [self.tableView.header endRefreshing];
//        [self.tableView.footer endRefreshing];
//        if (_numberOfPageSize == 1) {
//            [_teachingArr removeAllObjects];
//            
//        };
//        _isMoreData = [success[@"body"] count] > 0 && [success[@"body"] count] < 10;
//        if (_isMoreData) {
//            [_tableView.footer noticeNoMoreData];
//            _numberOfPageSize --;
//        }
//        _numberOfPageSize ++;
//        
//        for (NSInteger i = 0; i<[[success objectForKey:@"body"]count]; i++) {
//            MessageModel *model = [[MessageModel alloc] initWithDic:[success objectForKey:@"body"][i]];
//            
//            [_teachingArr addObject:model];
//        }
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        
//        [self.tableView reloadData];
//    } failure:^(NSError *NSError) {
//        [MBProgressHUD showMessage:@"加载失败！" toView:self.view delay:1.0];
//        
//        NSLog(@"-------Teaching-------%@",NSError);
//    }];
//    
//}

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
    
    ContentViewController *contenVC = [[ContentViewController alloc] init];
    contenVC.contentModel = model;
    contenVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:contenVC animated:YES];
    
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
    
    if (section == 0) {
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
- (void)leftButton:(UIButton*)sender {
    
    [self.navigationController popViewControllerAnimated:NO];
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
