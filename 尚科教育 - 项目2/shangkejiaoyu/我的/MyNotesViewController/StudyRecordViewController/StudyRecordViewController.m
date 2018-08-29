//
//  StudyRecordViewController.m
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2017/6/21.
//  Copyright © 2017年 ShangKe. All rights reserved.
//

#import "StudyRecordViewController.h"
#import "StudyRecordCell.h"
#import "StudyModel.h"
#import "NoDataView.h"
//#import "VedioViewController.h"
#import "VedioPlayerViewController.h"

@interface StudyRecordViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView    *tableView;
@property (nonatomic, strong) NSMutableArray *jobArray;
@property (nonatomic, strong) NSMutableArray *jobDataArr;
@property (nonatomic, assign) NSInteger      numberOfPageSize;

@end

@implementation StudyRecordViewController

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
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = kCustomNavColor;

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
        NSString *str = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/learn_log_detail"];
        NSDictionary *dic = @{
                              @"page":@(_numberOfPageSize),
                              @"pagesize":@"10",
                              @"uid":user
                              
                              };
        [HttpRequest postWithURLString:str parameters:dic success:^(id success) {
            //            NSLog(@"--=---%@",_jobDic);
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
            for (NSDictionary *dic in success[@"body"]) {
                StudyModel *model = [[StudyModel alloc] initWithDic:dic];
                if (!_jobArray) {
                    _jobArray = [NSMutableArray array];
                }
                [_jobArray addObject:model];
            }
            if ([success[@"msg"] isEqualToString:@"无"]) {
                [self noDataView];
            }
            [self.tableView reloadData];
            NSLog(@"观看视频列表%@",success);
            
        } failure:^(NSError *error) {
            NSLog(@"观看视频列表%@",error);
        }];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StudyRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"studyRecordCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
//    [cell.cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    cell.cancelBtn.tag = 1000 + indexPath.row;
//    [cell.deliveryBtn addTarget:self action:@selector(deliveryBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    cell.deliveryBtn.tag = 2000 + indexPath.row;
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
    
    StudyModel *model = _jobArray[indexPath.row];
    VedioPlayerViewController *vedioPlayerVC = [VedioPlayerViewController new];
    vedioPlayerVC.model = model;
    vedioPlayerVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vedioPlayerVC animated:YES];
}

//#pragma mark ---  取消收藏 ---
//- (void)cancelBtnClick:(UIButton *)sender {
//    
//    NSUserDefaults* user = [[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];
//    
//    NSString *str = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/Api/Note/uncollection_recruit_info"];
//    NSDictionary *dic = @{
//                          @"recruit_info_id":_jobDataArr[sender.tag - 1000][@"id"],
//                          @"uid":user
//                          };
//    [HttpRequest postWithURLString:str parameters:dic success:^(id success) {
//        NSLog(@"取消收藏成功%@",success);
//        [MBProgressHUD showMessage:success[@"msg"] toView:self.view delay:1.0];
//        [_jobArray removeObjectAtIndex:(sender.tag - 1000)];
//        
//        [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:(sender.tag - 1000) inSection:0]] withRowAnimation:(UITableViewRowAnimationLeft)];
//        [self.tableView reloadData];
//    } failure:^(NSError *error) {
//        NSLog(@"取消收藏失败%@",error);
//        [MBProgressHUD showMessage:@"取消收藏失败" toView:self.view delay:1.0];
//        
//    }];
//}
//
//#pragma mark --- 发送简历 ---
//- (void)deliveryBtnClick:(UIButton *)sender {
//    NSLog(@"------发送简历-------");
//    NSUserDefaults *user = [[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];
//    if (user != nil) {
//        NSString *str = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/Api/Work/post_resume"];
//        NSDictionary *dic = @{
//                              @"uid":user,
//                              @"c_id":_jobDataArr[sender.tag - 2000][@"company_id"],
//                              @"recruit_id":_jobDataArr[sender.tag - 2000][@"id"]
//                              };
//        [HttpRequest postWithURLString:str parameters:dic success:^(id success) {
//            NSLog(@"投递简历%@",success);
//            [MBProgressHUD showMessage:success[@"msg"] toView:self.view delay:1.0];
//            
//            [self.tableView reloadData];
//        } failure:^(NSError *error) {
//            NSLog(@"投递简历%@",error);
//            [MBProgressHUD showMessage:@"投递失败！" toView:self.view delay:1.0];
//            
//        }];
//        
//    }else {
//        [AlertView(@"请先登录！", nil, nil, @"确定") show];
//    }
//    
//}

- (void)noDataView {
    NoDataView *noData = [[NoDataView alloc] initWithFrame:self.view.frame];
    [noData noDataViewTryImage:@"no_data" tryLabel:@"暂无!" tryBtn:@""];
    noData.tryBtn.hidden = YES;
    noData.backgroundColor = kCustomVCBackgroundColor;
    [self.view addSubview:noData];
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
