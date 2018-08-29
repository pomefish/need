//
//  RechargeRecordViewController.m
//  mingtao
//
//  Created by Linlin Ge on 2017/6/7.
//  Copyright © 2017年 Linlin Ge. All rights reserved.
//

#import "RechargeRecordViewController.h"
#import "RechargeRecordCell.h"
#import "RechargeDetailsViewController.h"
#import "MJRefresh.h"
#import "RechargeRecordModel.h"

@interface RechargeRecordViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger         numberOfPageSize;
@property (nonatomic, strong) NSArray           *dataArr;
@property (nonatomic, strong) NSMutableArray    *imageArry;
@property (nonatomic, strong) NSMutableArray *dataSourceAry;

#define kSystemCustomCell @"kSystemCustomCell"

@end

@implementation RechargeRecordViewController
- (UITableView *)tableView {
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.backgroundColor = kCustomColor(229, 236, 236);
        
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kSystemCustomCell];
        [self.tableView registerNib:[UINib nibWithNibName:@"RechargeRecordCell" bundle:nil] forCellReuseIdentifier:@"rechargeRecordCell"];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kCustomVCBackgroundColor;
    self.title = @"交易记录";
    leftBarButton(@"returnImage");
    self.navigationController.navigationBar.barTintColor = kCustomNavColor;

    [self getRechargrRecordRequest:YES];
    [self.view addSubview:self.tableView];

    __typeof (self) __weak weakSelf = self;
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf getRechargrRecordRequest:YES];
    }];
    
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [weakSelf getRechargrRecordRequest:NO];
        
    }];
    
    
}

- (void)getRechargrRecordRequest:(BOOL)isPull {
    if (isPull) {
        _numberOfPageSize = 1;
    }
    
    NSString * user= [[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];
    NSLog(@"交易记录%@",user);
    NSString *str = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/account_log"];
    NSDictionary *dic = @{
                          @"page":@(_numberOfPageSize),
                          @"pagesize":@"10",
                          @"uid":user
                          };
    
    [HttpRequest postWithURLString:str parameters:dic success:^(id success) {
        NSLog(@"交易记录%@",success);
        _dataArr = success[@"body"];
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
            RechargeRecordModel *model = [[RechargeRecordModel alloc] initWithRechargeRecordModelDictionary:dic];
            if (!_dataSourceAry) {
                _dataSourceAry = [NSMutableArray array];
            }
            [_dataSourceAry addObject:model];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"交易记录%@",error);
    }];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSystemCustomCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
        imageView.image = [UIImage imageNamed:@"TransactionRecordImage.jpg"];
        [cell addSubview:imageView];
        return cell;
    }
    if (indexPath.section == 1) {
        RechargeRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rechargeRecordCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        RechargeRecordModel *model = _dataSourceAry[indexPath.row];
        
        
        [cell configureCellDataModel:model];

        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        RechargeDetailsViewController *rechargeDetailsVC = [RechargeDetailsViewController new];
        RechargeRecordModel *model = _dataSourceAry[indexPath.row];
        rechargeDetailsVC.change_type = model.change_type;
        rechargeDetailsVC.order_sn = model.order_sn;
        [self.navigationController pushViewController:rechargeDetailsVC animated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return _dataSourceAry.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 100.0f;
    }else {
        return 60.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    }
    return 0.01;
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
    header.frame = CGRectMake(0, 0, kScreenWidth, 0.01);
    
    return header;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *header = [[UIView alloc] init];
    header.frame = CGRectMake(0, 0, kScreenWidth, 0.01);
    return header;
}
- (void)leftButton:(UIButton *)sender {
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
