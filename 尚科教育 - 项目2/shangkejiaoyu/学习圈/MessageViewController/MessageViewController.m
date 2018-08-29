//
//  MessageViewController.m
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2017/6/30.
//  Copyright © 2017年 ShangKe. All rights reserved.
//

#import "MessageViewController.h"
#import "NoDataView.h"
#import "MessageCell.h"
#import "MessageModel.h"
#import "ContentViewController.h"

@interface MessageViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *tableArr;
@property (nonatomic, assign) NSInteger numberOfPageSize;
@property (nonatomic, strong) NoDataView *noDataView;

@end

@implementation MessageViewController

- (UITableView *)tableView {
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 114) style:UITableViewStylePlain];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.tableFooterView = [UIView new];
        [self.tableView registerClass:[MessageCell class] forCellReuseIdentifier:@"customCell"];
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.barTintColor = kCustomNavColor;
    
    
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
    
    if (isPull) {
        _numberOfPageSize = 1;
    }
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
    if (!userID) {
        return;
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/article"];
    NSDictionary *dic = @{@"page":@(_numberOfPageSize),
                          @"pagesize":@"10",
                          @"uid":userID
                          
                          };
    [HttpRequest postWithURLString:urlStr parameters:dic success:^(id success) {
        _noDataView.hidden = YES;
        
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        NSLog(@"--------通知------%@",success);
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
        [self requestData];
        if (_dataArr.count == 0) {
            [self configoreNoDataView];
        }
    } failure:^(NSError *error) {
               NSLog(@"通知失败%@",error);
        [_tableArr removeAllObjects];
        [_tableView reloadData];
        _noDataView.hidden = NO;
        
    }];
    
}

- (void)configoreNoDataView {
    _noDataView = [[NoDataView alloc] initWithFrame:CGRectMake(0, -60, kScreenWidth, kScreenHeight)];
    _noDataView.hidden = YES;
    [_noDataView noDataViewTryImage:@"no_data" tryLabel:@"暂无消息！" tryBtn:@"刷新试试！"];
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
        MessageModel *model = [[MessageModel alloc] initWithDic:_dataArr[i]];
        [_tableArr addObject:model];
    }
    
    [_tableView reloadData];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"customCell" forIndexPath:indexPath];
        MessageModel*model = _tableArr[indexPath.row];
        
        [cell customCellModel:model];
        return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MessageModel *model = _tableArr[indexPath.row];
    ContentViewController *contenVC = [[ContentViewController alloc] init];
    contenVC.contentModel = model;
    contenVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:contenVC animated:YES];
    
    MessageCell * cell = [tableView cellForRowAtIndexPath:indexPath];//即为要得到的cell
    cell.image.hidden = YES;
    if ( [model.article_log isEqualToString:@"0"]) {
        model.article_log = @"1";
        
        NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"countNumber"];
        NSLog(@"-----str--------%@",str);
        
        NSInteger num  = [str integerValue] - 1;
        
        NSLog(@"------num--------%ld",num);
        
        self.tabBarController.tabBar.items[1].badgeValue = num > 0 ? [NSString stringWithFormat: @"%ld", (long)num] : nil;
        NSString *count = [NSString stringWithFormat:@"%ld",num];
        NSLog(@"------count--------%@",count);
        [[NSUserDefaults standardUserDefaults] setObject:count forKey:@"countNumber"];
        
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return _tableArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 && indexPath.section == 0) {
        return kScreenWidth/2.2;
    }
    return 85.f;
}

//视图将要出现时 调用此方法
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestHttp:YES];
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
