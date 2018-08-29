//
//  ThematicListViewController.m
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2018/1/13.
//  Copyright © 2018年 ShangKe. All rights reserved.
//

#import "ThematicListViewController.h"
#import "ThematicListCell.h"

@interface ThematicListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger numberOfPageSize;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *tableArr;
@property (nonatomic, strong) NoDataView *noDataView;

@end

@implementation ThematicListViewController

- (UITableView *)tableView {
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.tableFooterView = [UIView new];
        self.tableView.backgroundColor = kCustomVCBackgroundColor;
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [self.tableView registerNib:[UINib nibWithNibName:@"ThematicListCell" bundle:nil] forCellReuseIdentifier:@"ThematicListCell"];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    leftBarButton(@"returnImage");
    
    _tableArr = [NSMutableArray array];
    _dataArr = [NSMutableArray array];
    
    
    [self.view addSubview:self.tableView];
//    [self configoreNoDataView];
    
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

- (void)requestHttp:(BOOL)isPull {
    
    if (isPull) {
        _numberOfPageSize = 1;
    }
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
    if (!userID) {
        return;
    }
    
    
    if (self.tagId == 1) {
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/hot_article"];
        NSDictionary *di = @{@"page":@(_numberOfPageSize),
                             @"pagesize":@"10"
                             };
        __weak typeof (self)weakSelf = self;
        [HttpRequest postWithURLString:urlStr parameters:di success:^(id success) {
//            NSLog(@"------------%@",success);
            _noDataView.hidden = YES;
            
            [self.tableView.header endRefreshing];
            [self.tableView.footer endRefreshing];
            NSLog(@"-------栏目-----%@",success);
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
            for (NSInteger i = 0; i<[[success objectForKey:@"body"]count]; i++) {
                MessageModel *model = [[MessageModel alloc] initWithDic:[success objectForKey:@"body"][i]];
                
                [_tableArr addObject:model];
            }
            [self.tableView reloadData];
            //        if (_dataArr.count == 0) {
            //            [self configoreNoDataView];
            //        }
        } failure:^(NSError *error) {
            //        NSLog(@"资讯%@",error);
            [_tableArr removeAllObjects];
            [_tableView reloadData];
            _noDataView.hidden = NO;
            
        }];


    }else{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/article_list"];
    NSDictionary *dic = @{@"page":@(_numberOfPageSize),
                          @"pagesize":@"10",
                          @"uid":userID,
                          @"cat_id":_cat_id
                          };
    [HttpRequest postWithURLString:urlStr parameters:dic success:^(id success) {
        _noDataView.hidden = YES;
        
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        NSLog(@"-------栏目-----%@",success);
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
        for (NSInteger i = 0; i<[[success objectForKey:@"body"]count]; i++) {
            MessageModel *model = [[MessageModel alloc] initWithDic:[success objectForKey:@"body"][i]];
            
            [_tableArr addObject:model];
        }
        [self.tableView reloadData];
//        if (_dataArr.count == 0) {
//            [self configoreNoDataView];
//        }
    } failure:^(NSError *error) {
        //        NSLog(@"资讯%@",error);
        [_tableArr removeAllObjects];
        [_tableView reloadData];
        _noDataView.hidden = NO;
        
    }];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    ThematicListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ThematicListCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    MessageModel*model = _tableArr[indexPath.row];
    
    [cell customThematicListCellModel:model];
    cell.index = indexPath.row;
    cell.dataArr = _tableArr;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tableArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kScreenHeight / 1.8;
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
