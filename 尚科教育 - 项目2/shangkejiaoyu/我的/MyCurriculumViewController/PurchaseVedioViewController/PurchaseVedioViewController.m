//
//  PurchaseVedioViewController.m
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2017/7/14.
//  Copyright © 2017年 ShangKe. All rights reserved.
//

#import "PurchaseVedioViewController.h"
#import "StudyRecordCell.h"
#import "StudyModel.h"
#import "NoDataView.h"
//#import "VedioViewController.h"
#import "VedioPlayerViewController.h"

@interface PurchaseVedioViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView    *tableView;
@property (nonatomic, strong) NSMutableArray *jobArray;
@property (nonatomic, strong) NSMutableArray *jobDataArr;
@property (nonatomic, assign) NSInteger      numberOfPageSize;


@end

@implementation PurchaseVedioViewController

- (UITableView *)tableView {
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 100) style:UITableViewStylePlain];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.tableFooterView = [UIView new];
        self.tableView.backgroundColor = kCustomVCBackgroundColor;
        //        self.tableView.allowsSelection = NO;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerNib:[UINib nibWithNibName:@"StudyRecordCell" bundle:nil] forCellReuseIdentifier:@"studyRecordCell"];
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.tableView];
    [self getCollectJobList:YES];
    
    __typeof (self) __weak weakSelf = self;
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getCollectJobList:YES];
    }];
    
    self.tableView.footer  = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf getCollectJobList:NO];
    }];
    
}

- (void)getCollectJobList:(BOOL)isPull {
    if (isPull) {
        _numberOfPageSize = 1;
    }
    NSUserDefaults* user = [[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];
    if (user != nil) {
        //        NSLog(@"---=----%@",_model.ID);
        NSString *str = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/my_shopp"];
        NSDictionary *dic = @{
                              @"page":@(_numberOfPageSize),
                              @"pagesize":@"10",
                              @"uid":user
                              
                              };
        [HttpRequest postWithURLString:str parameters:dic success:^(id success) {
//            NSLog(@"--=---%@",success);
            _jobDataArr = success[@"body"];
            [self.tableView.header endRefreshing];
            [self.tableView.footer endRefreshing];
            if (_numberOfPageSize == 1) {
                [_jobArray removeAllObjects];
            }
            BOOL isMore = _jobArray.count > 0 && _jobArray.count < 10;
            if (isMore) {
                [self.tableView.footer noticeNoMoreData];
                _numberOfPageSize --;
            }
            _numberOfPageSize ++;
            for (NSInteger i = 0; i <  [success[@"body"] count]; i ++) {
                
                for (NSDictionary *dic in success[@"body"][i][@"video_info"]) {
                    StudyModel *model = [[StudyModel alloc] initWithDic:dic];
                    if (!_jobArray) {
                        _jobArray = [NSMutableArray array];
                    }
                    [_jobArray addObject:model];
                }
            }
            if (![success[@"msg"] isEqualToNumber:@2]) {
                [self noDataView];
            }
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            NSLog(@"已购视频%@",error);
        }];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StudyRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"studyRecordCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    StudyModel*model = _jobArray[indexPath.row];
    [cell configureCellDataModel:model];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _jobArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //    RecruitmentVC *recruitmentVC = [RecruitmentVC new];
    //    recruitmentVC.recruitmentID = _jobDataArr[indexPath.row][@"id"];
    //    recruitmentVC.company_id = _jobDataArr[indexPath.row][@"company_id"];
    //    //        NSLog(@"---=----%@",_dataArr);
    //    //        recruitmentVC.model = model;
    //    recruitmentVC.hidesBottomBarWhenPushed = YES;
    //    [self.navigationController pushViewController:recruitmentVC animated:YES];
    StudyModel *model = _jobArray[indexPath.row];
    VedioPlayerViewController *searchVC = [VedioPlayerViewController new];
    searchVC.model = model;
    searchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:YES];

}

- (void)noDataView {
    NoDataView *noData = [[NoDataView alloc] initWithFrame:self.tableView.frame];
    [noData noDataViewTryImage:@"no_data" tryLabel:@"暂无已购视频!" tryBtn:@""];
    noData.tryBtn.hidden = YES;
    noData.backgroundColor = kCustomVCBackgroundColor;
    [self.tableView addSubview:noData];
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
