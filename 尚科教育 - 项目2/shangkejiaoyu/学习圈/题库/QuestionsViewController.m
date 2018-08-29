//
//  QuestionsViewController.m
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2017/6/20.
//  Copyright © 2017年 ShangKe. All rights reserved.
//

#import "QuestionsViewController.h"
#import "NoDataView.h"
#import "QuestionsTableViewCell.h"
#import "MessageModel.h"
#import "ContentViewController.h"
#import "QuesDetailViewController.h"
#import "ExamViewController.h"

//#import "HWQuestionsVC.h"
@interface QuestionsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *tableArr;
@property (nonatomic, assign) NSInteger numberOfPageSize;
@property (nonatomic, strong) NoDataView *noDataView;

@end

@implementation QuestionsViewController

- (UITableView *)tableView {
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight -114)];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        //        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.tableFooterView = [[UIView alloc]init];
        //        self.tableView.backgroundColor = kCustomVCBackgroundColor;
        //        [self.tableView registerClass:[UITableView class] forCellReuseIdentifier:@"cell"];
        [self.tableView registerNib:[UINib nibWithNibName:@"QuestionsTableViewCell" bundle:nil] forCellReuseIdentifier:@"questionsTableViewCell"];
    }
    return _tableView;
}

- (void)viewWillAppear:(BOOL)animated{
    NSLog(@"测试完了");
     [self requestHttp:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.barTintColor = kCustomNavColor;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:16],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [self.view addSubview:self.tableView];
    
    _tableArr = [NSMutableArray array];
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
    [self configoreNoDataView];

}

- (void)requestHttp:(BOOL)isPull {
    
    if (isPull) {
        _numberOfPageSize = 1;
    }
//    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/questions"];
     NSString *urlStr = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/certificate"];
     NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
    NSDictionary *dic = @{@"page":@(_numberOfPageSize),
                          @"pagesize":@"10",
                           @"uid":user
                          };
    [HttpRequest postWithURLString:urlStr parameters:dic success:^(id success) {
        
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
//        NSLog(@"-=--课程%@",success);
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
        }else {
            _noDataView.hidden = YES;
        }
        [self requestData];
    } failure:^(NSError *error) {
        //        NSLog(@"资讯%@",error);
        [_tableArr removeAllObjects];
        [_tableView reloadData];
        _noDataView.hidden = NO;
        
    }];
    
}

- (void)requestData {
    for (NSInteger i = 0; i < _dataArr.count; i ++) {
        MessageModel *model = [[MessageModel alloc] initWithDic:_dataArr[i]];
        
        [_tableArr addObject:model];
    }
    
    [_tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QuestionsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"questionsTableViewCell" forIndexPath:indexPath];
    //    cell.backgroundColor = [UIColor clearColor];
    //    cell.titleLabel.text = _timetablesArr[indexPath.row];
    MessageModel *model = _tableArr[indexPath.row];
    [cell customCellModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageModel *model = _tableArr[indexPath.row];
    if ([model.type isEqualToString:@"0"]) {
        QuesDetailViewController *detailVC = [[QuesDetailViewController alloc] init];
        
        detailVC.idd = [NSString stringWithFormat:@"%@",model.id];
        detailVC .hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:detailVC animated:YES];
    }else{
        ExamViewController *examVC = [[ExamViewController alloc] init];
        
        examVC.idd = [NSString stringWithFormat:@"%@",model.id];
        examVC .hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:examVC animated:YES];
    }
   
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tableArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)configoreNoDataView {
    _noDataView = [[NoDataView alloc] initWithFrame:CGRectMake(0, -60, kScreenWidth, kScreenHeight)];
    [_noDataView noDataViewTryImage:@"no_data" tryLabel:@"暂无题目！" tryBtn:@"刷新试试！"];
    [_noDataView.tryBtn addTarget:self action:@selector(tryBttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_noDataView];
    
}

- (void)tryBttonClick:(UIButton *)sender {
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
