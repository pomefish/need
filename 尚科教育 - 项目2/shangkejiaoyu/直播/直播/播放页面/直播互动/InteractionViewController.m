//
//  InteractionViewController.m
//  mingtao
//
//  Created by Linlin Ge on 2017/11/13.
//  Copyright © 2017年 Linlin Ge. All rights reserved.
//

#import "InteractionViewController.h"
#import "InteractionCell.h"
#import "PlayLiveModel.h"

@interface InteractionViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *tableArr;
@property (nonatomic, assign) NSInteger numberOfPageSize;

@end

@implementation InteractionViewController

- (UITableView *)tableView {
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kScreenWidth *9/16 - 54) style:UITableViewStylePlain];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.tableFooterView = [UIView new];
        self.tableView.separatorStyle = NO;
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [self.tableView registerNib:[UINib nibWithNibName:@"InteractionCell" bundle:nil] forCellReuseIdentifier:@"interactionCell"];
    }
    
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tableArr = [NSMutableArray array];
    _dataArr = [NSMutableArray array];
    
    [self getLiveRequestHttp:YES];
    __typeof (self) __weak weakSelf = self;
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        
        [weakSelf getLiveRequestHttp:YES];
        
    }];
    
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        
        [weakSelf getLiveRequestHttp:NO];
        
    }];

    [self.view addSubview:self.tableView];

}

#pragma mark -- 直播互动列表
- (void)getLiveRequestHttp:(BOOL)isPull {
    
    if (isPull) {
        _numberOfPageSize = 1;
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/live_info"];
    NSDictionary *dic = @{@"page":@"1",
                          @"pagesize":@"10",
                          @"zhibo_id":_zhibo_id
                          };
    [HttpRequest postWithURLString:urlStr parameters:dic success:^(id success) {
//        _noDataView.hidden = YES;
//        
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        SKLog(@"------直播互动列表-------%@",success);
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
        SKLog(@"------_dataArr--------%ld",_dataArr.count);
//        if (_dataArr.count == 0) {
//            _noDataView.hidden = NO;
//        }
        [self requestData];
    } failure:^(NSError *error) {
        SKLog(@"------直播列互动列表-------%@",error);
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [_tableArr removeAllObjects];
        [_tableView reloadData];
//        _noDataView.hidden = NO;
        
    }];
    
}

- (void)requestData {
    for (NSInteger i = 0; i < _dataArr.count; i ++) {
        PlayLiveModel *model = [[PlayLiveModel alloc] initWithPlayLiveModelDic:_dataArr[i]];
        [_tableArr addObject:model];
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    [_tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InteractionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"interactionCell" forIndexPath:indexPath];
    
    PlayLiveModel *model = _tableArr[indexPath.row];
    [cell configurePlayLiveCellDataModel:model];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tableArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    PlayLiveModel *model = _tableArr[indexPath.row];
    
    return [InteractionCell cellForHeight:model];
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
