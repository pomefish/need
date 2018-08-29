//
//  InformViewController.m
//  mingtao
//
//  Created by Linlin Ge on 2017/8/14.
//  Copyright © 2017年 Linlin Ge. All rights reserved.
//

#import "InformViewController.h"
#import "InformTableViewCell.h"
#import "LiveModel.h"
#import "NoDataView.h"
#import "PlaybackViewController.h"

@interface InformViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *tableArr;
@property (nonatomic, assign) NSInteger numberOfPageSize;
@property (nonatomic, strong) NoDataView *noDataView;
@property (nonatomic, strong) NSMutableArray *imageArry;

@end

@implementation InformViewController

- (UITableView *)tableView {
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 110) style:UITableViewStylePlain];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.tableFooterView = [UIView new];
        self.tableView.separatorStyle = NO;//隐藏Cell线
        self.tableView.backgroundColor = kCustomVCBackgroundColor;
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [self.tableView registerNib:[UINib nibWithNibName:@"InformTableViewCell" bundle:nil] forCellReuseIdentifier:@"InformTableViewCell"];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.barTintColor = kCustomViewColor;
    self.view.backgroundColor = kCustomVCBackgroundColor;
    
    leftBarButton(@"jiantou_01_on");
    
    _tableArr = [NSMutableArray array];
    _dataArr = [NSMutableArray array];
    
    
    [self.view addSubview:self.tableView];
    [self configoreNoDataView];
    
    [self requestHttp:YES];
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

- (void)leftButton:(UIButton*)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)requestHttp:(BOOL)isPull {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if (isPull) {
        _numberOfPageSize = 1;
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/foreshow"];
    NSDictionary *dic = @{@"page":@(_numberOfPageSize),
                          @"pagesize":@"10"
                          };
    [HttpRequest postWithURLString:urlStr parameters:dic success:^(id success) {
        _noDataView.hidden = YES;
        
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        if (_numberOfPageSize == 1) {
            [_tableArr removeAllObjects];
        }
        _dataArr = [success objectForKey:@"body"];
        BOOL isMore = _dataArr.count > 0 && _dataArr.count < 10;
        if (isMore) {
            [_tableView.footer noticeNoMoreData];
            _numberOfPageSize --;
        }
        _numberOfPageSize ++;
        if (_dataArr.count == 0) {
            _noDataView.hidden = NO;
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
        
        [self requestData];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [_tableArr removeAllObjects];
        [_tableView reloadData];
        _noDataView.hidden = NO;
        
    }];
    
}

- (void)configoreNoDataView {
    _noDataView = [[NoDataView alloc] initWithFrame:CGRectMake(0, -60, kScreenWidth, kScreenHeight)];
    _noDataView.hidden = YES;
    [_noDataView noDataViewTryImage:@"no_data" tryLabel:@"您暂时没有回播！" tryBtn:@"刷新试试！"];
    [_noDataView.tryBtn addTarget:self action:@selector(tryBttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_noDataView];
}

- (void)tryBttonClick:(UIButton *)sender {
    [self requestHttp:YES];
    
}

- (void)delayInSeconds:(CGFloat)delayInSeconds block:(dispatch_block_t) block {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC),  dispatch_get_main_queue(), block);
}

- (void)requestData {
    for (NSInteger i = 0; i < _dataArr.count; i ++) {
        LiveModel *model = [[LiveModel alloc] initWithDic:_dataArr[i]];
        
        [_tableArr addObject:model];
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [_tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    InformTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InformTableViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    LiveModel *model = _tableArr[indexPath.row];
    [cell configureCellDataModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
    
    if ([userID isEqualToString:@"1"]) {
        LogonViewController *logonVC = [LogonViewController new];
//        logonVC.logonStr = @"1";
        logonVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        UINavigationController *loginNav = [[UINavigationController alloc]initWithRootViewController:logonVC];
        //模态弹出  这里
        [self presentViewController:loginNav animated:YES completion:nil];
        
    }else {
        LiveModel *model = _tableArr[indexPath.row];
        PlaybackViewController *playbackVC = [[PlaybackViewController alloc] init];
        playbackVC.model = model;
    
        playbackVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:playbackVC animated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _tableArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kScreenHeight / 2;
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
