//
//  RewardRecordViewController.m
//  mingtao
//
//  Created by Linlin Ge on 2017/6/8.
//  Copyright © 2017年 Linlin Ge. All rights reserved.
//

#import "RewardRecordViewController.h"
#import "RewardRecordCell.h"
#import "RewardRecordModel.h"
#import "NoDataView.h"

@interface RewardRecordViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger         numberOfPageSize;
@property (nonatomic, strong) NSMutableArray *dataSourceAry;
@property (nonatomic, strong) NoDataView *noDataView;

@end

@implementation RewardRecordViewController

- (UITableView *)tableView {
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.backgroundColor = kCustomColor(229, 236, 236);
        self.tableView.tableFooterView = [UIView new];
        [self.tableView registerNib:[UINib nibWithNibName:@"RewardRecordCell" bundle:nil] forCellReuseIdentifier:@"rewardRecordCell"];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kCustomVCBackgroundColor;
    leftBarButton(@"returnImage");
    self.title = @"奖励记录";
      self.navigationController.navigationBar.barTintColor = kCustomNavColor;
    [self.view addSubview:self.tableView];
    
    [self getRewardRecordRequest:YES];
    
    __typeof (self) __weak weakSelf = self;
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf getRewardRecordRequest:YES];
    }];
    
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [weakSelf getRewardRecordRequest:NO];
        
    }];
    [self configoreNoDataView];
    _noDataView.hidden = YES;
}

- (void)getRewardRecordRequest:(BOOL)isPull {
    NSString * user= [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
    if (user != nil) {
        if (isPull) {
            _numberOfPageSize = 1;
        }
        NSString *str = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/wallet_log"];
        NSDictionary *dic = @{
                              @"uid":user,
                              @"page":@(_numberOfPageSize),
                              @"pagesize":@"10"
                              };
        
        [HttpRequest postWithURLString:str parameters:dic success:^(id success) {
            NSLog(@"领取学币记录%@",success);
            [self.tableView.header endRefreshing];
            [self.tableView.footer endRefreshing];
            
            if (_numberOfPageSize == 1) {
                [_dataSourceAry removeAllObjects];
            }
            BOOL isMore = _dataSourceAry.count > 0 && _dataSourceAry.count < 10;
            if (isMore) {
                [self.tableView.footer noticeNoMoreData];
                _numberOfPageSize --;
            }
            _numberOfPageSize ++;
            for (NSDictionary *dic in success[@"body"]) {
                RewardRecordModel *model = [[RewardRecordModel alloc] initWithRewardRecordModelDictionary:dic];
                if (!_dataSourceAry) {
                    _dataSourceAry = [NSMutableArray array];
                }
                [_dataSourceAry addObject:model];
            }
            [_tableView reloadData];

            if ([success[@"code"] isEqualToNumber:@2]) {
                [MBProgressHUD showMessage:@"暂无领取记录！" toView:self.tableView delay:1.0];
                _noDataView.hidden = NO;
            }
        } failure:^(NSError *error) {
            NSLog(@"领取学币记录%@",error);
        }];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RewardRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rewardRecordCell" forIndexPath:indexPath];
    RewardRecordModel *model = _dataSourceAry[indexPath.row];
    
    [cell configureCellDataModel:model];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSourceAry.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55.0f;
}

- (void)leftButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)configoreNoDataView {
    _noDataView = [[NoDataView alloc] initWithFrame:CGRectMake( 0, 0,  kScreenWidth, kScreenHeight)];
    _noDataView.backgroundColor = kCustomVCBackgroundColor;
    [_noDataView noDataViewTryImage:@"no_data" tryLabel:@"没有奖励记录！" tryBtn:@""];
    _noDataView.tryBtn.backgroundColor = kCustomVCBackgroundColor;
    [self.view addSubview:self.noDataView];
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
