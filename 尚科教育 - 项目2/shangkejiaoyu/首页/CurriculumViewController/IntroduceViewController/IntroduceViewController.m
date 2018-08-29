//
//  IntroduceViewController.m
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2017/6/19.
//  Copyright © 2017年 ShangKe. All rights reserved.
//

#import "IntroduceViewController.h"
#import "IntroduceCell.h"
#import "StudyModel.h"
#import "VedioPlayerViewController.h"
//#import "VedioViewController.h"
#import "VedioPlayerViewController.h"

#import "LogonViewController.h"

@interface IntroduceViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *tableArr;
@property (nonatomic, assign) NSInteger numberOfPageSize;

@property (nonatomic, strong) NoDataView *noDataView;
@end

@implementation IntroduceViewController

- (UITableView *)tableView {
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.tableFooterView = [UIView new];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [self.tableView registerNib:[UINib nibWithNibName:@"IntroduceCell" bundle:nil] forCellReuseIdentifier:@"customCell"];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.barTintColor = kCustomNavColor;
    
    leftBarButton(@"returnImage");
    self.title = self.titleText;
    
    _tableArr = [NSMutableArray array];
    _dataArr = [NSMutableArray array];
    
    [self.view addSubview:self.tableView];
    
    [self requestHttp:YES];
    
    [self configoreNoDataView];
    __typeof (self) __weak weakSelf = self;
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        
        [weakSelf requestHttp:YES];
        
    }];
    
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        
        [weakSelf requestHttp:NO];
      
        
    }];
    
}

//- (void)requestHttp {
//    [_tableArr removeAllObjects];
//    _numberOfPageSize = 1;
//    if (self.tagId == 0) {
//        NSString *urlStr = [NSString stringWithFormat:@"%@%@",sHTTPURL,skVideoUrl];
//        NSDictionary *dic = @{@"page":@(_numberOfPageSize),
//                              @"pagesize":@"10",
//                              @"cat_id":_catID
//                              };
//        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        [HttpRequest postWithURLString:urlStr parameters:dic success:^(id success) {
//            [MBProgressHUD  hideHUDForView:self.view animated:YES];
//
//
//
//            NSLog(@"-=--视频----------%@",success);
//
//            _dataArr = [success objectForKey:@"body"];
//            if (_dataArr.count != 0) {
//                _noDataView.hidden = YES;
//                [self requestData];
//                  [self.tableView.header endRefreshing];
//                if (_dataArr.count  < 10) {
//                    [self.tableView.footer noticeNoMoreData];
//                }
//
//            }else {
//                _noDataView.hidden = NO;
//                [self.tableView.header endRefreshing];
//                return;
//            }
//        } failure:^(NSError *error) {
//            [MBProgressHUD  hideHUDForView:self.view animated:YES];
//
//            [_tableArr removeAllObjects];
//            [_tableView reloadData];
//            _noDataView.hidden = NO;
//            [self.tableView.header endRefreshing];
//
//        }];
//
//
//    }else if (self.tagId == 1){
//        NSString *urlStr = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/free_video"];
//
//        NSDictionary *dic = @{
//                              @"page":@(_numberOfPageSize),
//                              @"pagesize":@"10",
//                              @"cat_id":_catID
//
//                              };
//        [HttpRequest postWithURLString:urlStr parameters:dic success:^(id success) {
//
//
//            _dataArr = [success objectForKey:@"body"];
//
//            if (_dataArr.count != 0) {
//                _noDataView.hidden = YES;
//                [self requestData];
//                [self.tableView.header endRefreshing];
//                if(_dataArr.count < 10 *_numberOfPageSize){
//                    [self.tableView.footer noticeNoMoreData];
//                }
//
//            }else {
//                _noDataView.hidden = NO;
//                [self.tableView.header endRefreshing];
//
//                return;
//            }
//
//        } failure:^(NSError *error) {
//            [_tableArr removeAllObjects];
//            [_tableView reloadData];
//            _noDataView.hidden = NO;
//            [self.tableView.header endRefreshing];
//
//
//        }];
//
//    }
//    else{
//
//        NSString *urlStr = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/new_video"];
//        NSDictionary *dic = @{
//                              @"page":@(_numberOfPageSize),
//                              @"pagesize":@"10",
//                              @"cat_id":_catID
//                              };
//        [HttpRequest postWithURLString:urlStr parameters:dic success:^(id success) {
//
//
//
//            NSLog(@"-=--视频----------%@",success);
//
//            _dataArr = [success objectForKey:@"body"];
//
//            if (_dataArr.count != 0) {
//                _noDataView.hidden = YES;
//                [self requestData];
//                  [self.tableView.header endRefreshing];
//                if (_dataArr.count < 10) {
//                    [self.tableView.footer noticeNoMoreData];
//                }
//
//
//            }else {
//                _noDataView.hidden = NO;
//                [self.tableView.header endRefreshing];
//
//                return;
//            }
//
//        } failure:^(NSError *error) {
//            [_tableArr removeAllObjects];
//            [_tableView reloadData];
//            _noDataView.hidden = NO;
//            [self.tableView.header endRefreshing];
//
//
//        }];
//    }
//
//}
//
//- (void)requestMoreHttp {
//
//     _numberOfPageSize ++;
//    if (self.tagId == 0) {
//        NSString *urlStr = [NSString stringWithFormat:@"%@%@",sHTTPURL,skVideoUrl];
//        NSDictionary *dic = @{@"page":@(_numberOfPageSize),
//                              @"pagesize":@"10",
//                              @"cat_id":_catID
//                              };
//        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        [HttpRequest postWithURLString:urlStr parameters:dic success:^(id success) {
//            [MBProgressHUD  hideHUDForView:self.view animated:YES];
//
//
//            NSLog(@"-=--视频----------%@",success);
//
//            _dataArr = [success objectForKey:@"body"];
//
//
//            if (_dataArr.count != 0) {
//                _noDataView.hidden = YES;
//                [self requestData];
//                   [self.tableView.footer endRefreshing];
//                if(_dataArr.count < 10 *_numberOfPageSize){// 判断数据加载完了没
//                    [self.tableView.footer noticeNoMoreData];
//                }
//
//            }else {
//                [self.tableView.footer endRefreshing];
//
//                _noDataView.hidden = NO;
//                return;
//            }
//        } failure:^(NSError *error) {
//            [MBProgressHUD  hideHUDForView:self.view animated:YES];
//
//            [_tableArr removeAllObjects];
//            [_tableView reloadData];
//            _noDataView.hidden = NO;
//            [self.tableView.footer endRefreshing];
//
//
//        }];
//
//
//    }else if (self.tagId == 1){
//                NSString *urlStr = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/free_video"];
//
//                 NSDictionary *dic = @{
//                                       @"page":@(_numberOfPageSize),
//                                       @"pagesize":@"10",
//                                       @"cat_id":_catID
//
//                                        };
//                [HttpRequest postWithURLString:urlStr parameters:dic success:^(id success) {
//
//
//                    _dataArr = [success objectForKey:@"body"];
//
//                    if (_dataArr.count != 0) {
//                        _noDataView.hidden = YES;
//                        [self requestData];
//                        [self.tableView.footer endRefreshing];
//
//                        if(_dataArr.count < 10 *_numberOfPageSize){
//                            [self.tableView.footer noticeNoMoreData];
//                        }
//                    }else {
//                        _noDataView.hidden = NO;
//                        [self.tableView.footer endRefreshing];
//
//                        return;
//                    }
//
//                } failure:^(NSError *error) {
//                    [_tableArr removeAllObjects];
//                    [_tableView reloadData];
//                    _noDataView.hidden = NO;
//                    [self.tableView.footer endRefreshing];
//
//
//                }];
//
//            }else{
//
//        NSString *urlStr = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/new_video"];
//        NSDictionary *dic = @{
//                              @"page":@(_numberOfPageSize),
//                              @"pagesize":@"10",
//                              @"cat_id":_catID
//                              };
//        [HttpRequest postWithURLString:urlStr parameters:dic success:^(id success) {
//
//
//            NSLog(@"-=--视频----------%@",success);
//
//            _dataArr = [success objectForKey:@"body"];
//
//            if (_dataArr.count != 0) {
//                _noDataView.hidden = YES;
//                [self requestData];
//                 [self.tableView.footer endRefreshing];
//                if(_dataArr.count < 10 *_numberOfPageSize){
//                     [self.tableView.footer noticeNoMoreData];
//                }
//
//            }else {
//                _noDataView.hidden = NO;
//                [self.tableView.footer endRefreshing];
//
//                return;
//            }
//
//        } failure:^(NSError *error) {
//            [_tableArr removeAllObjects];
//            [_tableView reloadData];
//            _noDataView.hidden = NO;
//            [self.tableView.footer endRefreshing];
//
//
//        }];
//    }
//
//}
- (void)requestData {
    for (NSInteger i = 0; i < _dataArr.count; i ++) {
        StudyModel *model = [[StudyModel alloc] initWithDic:_dataArr[i]];
        
        [_tableArr addObject:model];
    }
    
    [_tableView reloadData];
}
//
- (void)requestHttp:(BOOL)isPull {

    if (isPull) {

        _numberOfPageSize = 1;
    }
    

    if (self.tagId == 0) {
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",sHTTPURL,skVideoUrl];
        NSDictionary *dic = @{@"page":@(_numberOfPageSize),
                              @"pagesize":@"10",
                              @"cat_id":_catID
                              };
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [HttpRequest postWithURLString:urlStr parameters:dic success:^(id success) {
            [MBProgressHUD  hideHUDForView:self.view animated:YES];

            [self.tableView.header endRefreshing];
            [self.tableView.footer endRefreshing];
            
            NSLog(@"-=--视频----------%@",success);
            if (_numberOfPageSize == 1) {
                [_tableArr removeAllObjects];
            }
            _dataArr = [success objectForKey:@"body"];
            if (_dataArr.count != 0) {
                _noDataView.hidden = YES;
                [self requestData];
            }else {
                _noDataView.hidden = NO;
                return;
            }
            BOOL isMore = _dataArr.count > 0 && _dataArr.count < 10;
            if (isMore) {
                [_tableView.footer noticeNoMoreData];
                _numberOfPageSize --;
            }
            _numberOfPageSize ++;
        } failure:^(NSError *error) {
            [MBProgressHUD  hideHUDForView:self.view animated:YES];

            [_tableArr removeAllObjects];
            [_tableView reloadData];
            _noDataView.hidden = NO;
            
        }];

        
    }else if (self.tagId == 1){
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/free_video"];
//        NSDictionary *dic = @{ @"":@""};
         NSDictionary *dic = @{
                               @"page":@(_numberOfPageSize),
                               @"pagesize":@"10",
                               @"cat_id":_catID
                               
                                };
        [HttpRequest postWithURLString:urlStr parameters:dic success:^(id success) {
            
            [self.tableView.header endRefreshing];
            [self.tableView.footer endRefreshing];
            
//            NSLog(@"-=--视频----------%@",success);
            if (_numberOfPageSize == 1) {
                [_tableArr removeAllObjects];
            }
            _dataArr = [success objectForKey:@"body"];
            if (_dataArr.count != 0) {
                _noDataView.hidden = YES;
                [self requestData];
            }else {
                _noDataView.hidden = NO;
                return;
            }
            BOOL isMore = _dataArr.count > 0 && _dataArr.count < 10;
            if (isMore) {
                [_tableView.footer noticeNoMoreData];
                _numberOfPageSize --;
            }
            _numberOfPageSize ++;
        } failure:^(NSError *error) {
            [_tableArr removeAllObjects];
            [_tableView reloadData];
            _noDataView.hidden = NO;
            
        }];

    }else{
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/new_video"];
        NSDictionary *dic = @{
                              @"page":@(_numberOfPageSize),
                              @"pagesize":@"10",
                              @"cat_id":_catID
                              };
        [HttpRequest postWithURLString:urlStr parameters:dic success:^(id success) {
            // _noDataView.hidden = YES;
            
            [self.tableView.header endRefreshing];
            [self.tableView.footer endRefreshing];
            
//            NSLog(@"-=--视频----------%@",success);
            if (_numberOfPageSize == 1) {
                [_tableArr removeAllObjects];
            }
            _dataArr = [success objectForKey:@"body"];
            if (_dataArr.count != 0) {
                _noDataView.hidden = YES;
                [self requestData];
            }else {
                _noDataView.hidden = NO;
                return;
            }
            BOOL isMore = _dataArr.count > 0 && _dataArr.count < 10;
            if (isMore) {
                [_tableView.footer noticeNoMoreData];
                _numberOfPageSize --;
            }
            _numberOfPageSize ++;
        } failure:^(NSError *error) {
            [_tableArr removeAllObjects];
            [_tableView reloadData];
            _noDataView.hidden = NO;
            
        }];
    }
    
}
//
//- (void)requestData {
//    for (NSInteger i = 0; i < _dataArr.count; i ++) {
//        StudyModel *model = [[StudyModel alloc] initWithDic:_dataArr[i]];
//        
//        [_tableArr addObject:model];
//    }
//    
//    [_tableView reloadData];
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        IntroduceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"customCell" forIndexPath:indexPath];
    cell.describeLabel.hidden = YES;
        StudyModel*model = _tableArr[indexPath.row];
        
        [cell customCellModel:model];
        return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSString *user = [[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];
//    if (user == nil) {
//        [AlertView(@"温馨提示", @"观看视频需要收费，请先注册登录！", @"取消", @"去登录") show];
//        
//    }else {
    StudyModel *model = _tableArr[indexPath.row];
    VedioPlayerViewController *vedioPlayerVC = [[VedioPlayerViewController alloc] init];
    vedioPlayerVC.freeId = self.freeID;
    vedioPlayerVC.model = model;
    vedioPlayerVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vedioPlayerVC animated:YES];
//    }
}

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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 10;
    return _tableArr.count;
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 120.f;
}

- (void)configoreNoDataView {
    _noDataView = [[NoDataView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _noDataView.backgroundColor = kCustomColor(246, 246, 246);
    [_noDataView noDataViewTryImage:@"no_data" tryLabel:@"暂时没有视频！" tryBtn:@""];
    _noDataView.tryBtn.backgroundColor = kCustomColor(246, 246, 246);
    [self.tableView addSubview:_noDataView];
    _noDataView.hidden = YES;
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
