//
//  MyCollectionViewController.m
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2017/6/21.
//  Copyright © 2017年 ShangKe. All rights reserved.
//

#import "MyCollectionViewController.h"
#import "CollectVideoCell.h"
#import "VedioPlayerViewController.h"
#import "StudyModel.h"
//#import "VedioViewController.h"
#import "VedioPlayerViewController.h"

@interface MyCollectionViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *videoArray;
@property (nonatomic, strong) NSMutableArray *videoDataArr;
@property (nonatomic, assign) NSInteger         numberOfPageSize;

@end

@implementation MyCollectionViewController

- (UITableView *)tableView {
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 100) style:UITableViewStylePlain];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.tableFooterView = [UIView new];
        self.tableView.backgroundColor = kCustomVCBackgroundColor;
        //        self.tableView.allowsSelection = NO;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerNib:[UINib nibWithNibName:@"CollectVideoCell" bundle:nil] forCellReuseIdentifier:@"collectVideoCell"];
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
    [self getCollectVideoList:YES];
    
    __typeof (self) __weak weakSelf = self;
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf getCollectVideoList:YES];
    }];
    
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [weakSelf getCollectVideoList:NO];
        
    }];

}

- (void)getCollectVideoList:(BOOL)isPull {
    if (isPull) {
        _numberOfPageSize = 1;
    }
    NSUserDefaults* user = [[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];
    if (user != nil) {
        //        NSLog(@"---=----%@",_model.ID);
        NSString *str = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/collected_listone"];
        NSDictionary *dic = @{
                              @"page":@(_numberOfPageSize),
                              @"pagesize":@"10",
                              @"uid":user
                              
                              };
        [HttpRequest postWithURLString:str parameters:dic success:^(id success) {
            NSLog(@"收藏视频列表%@",success);
            _videoDataArr = success[@"body"];
            [self.tableView.header endRefreshing];
            [self.tableView.footer endRefreshing];
            if (_numberOfPageSize == 1) {
                [_videoArray removeAllObjects];
            }
            BOOL isMore = _videoArray.count > 0 && _videoArray.count < 10;
            if (isMore) {
                [self.tableView.footer noticeNoMoreData];
                _numberOfPageSize --;
            }
            _numberOfPageSize ++;
            
            for (NSDictionary *dic in success[@"body"]) {
                StudyModel *model = [[StudyModel alloc] initWithDic:dic];
                if (!_videoArray) {
                    _videoArray = [NSMutableArray array];
                }
                [_videoArray addObject:model];
            }
            if (_videoDataArr.count <= 0) {
                [self noDataView];
            }
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            [self noDataView];
            NSLog(@"收藏视频列表%@",error);
        }];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CollectVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"collectVideoCell" forIndexPath:indexPath];
    [cell.noCollectionBtn addTarget:self action:@selector(noCollectionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.noCollectionBtn.tag = 1000 + indexPath.row;
    cell.backgroundColor = [UIColor clearColor];
    StudyModel*model = _videoArray[indexPath.row];
    [cell configureCellDataModel:model];
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _videoArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    StudyModel *model = _videoArray[indexPath.row];
    VedioPlayerViewController *vedioPlayerVC = [VedioPlayerViewController new];
    vedioPlayerVC.model = model;
    vedioPlayerVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vedioPlayerVC animated:YES];

//    CustomView2Controller *custom = [CustomView2Controller new];
//    NSUserDefaults* user = [[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];
//    if (user != nil) {
//        NSString *str = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/video_detail"];
//        NSDictionary *dic = @{
//                              @"id":_videoDataArr[indexPath.row][@"id"],
//                              @"uid":user,
//                              
//                              };
//        [HttpRequest postWithURLString:str parameters:dic success:^(id success) {
//            NSLog(@"---=----%@",dic);
//            StudyModel *model = [[StudyModel alloc] initWithDic:success[@"body"]];
//            custom.model = model;
//            custom.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:custom animated:YES];
//            NSLog(@"%@",success);
//        } failure:^(NSError *error) {
//            NSLog(@"%@",error);
//        }];
//    }
    
}

- (void)noCollectionBtnClick:(UIButton *)sender {
    NSUserDefaults* user = [[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];
    
    NSString *str = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/uncollection"];
    NSDictionary *dic = @{
                          @"goods_id":_videoDataArr[sender.tag - 1000][@"id"],
                          @"uid":user
                          };
    [HttpRequest postWithURLString:str parameters:dic success:^(id success) {
        NSLog(@"取消收藏视频成功%@",success);
        [MBProgressHUD showMessage:success[@"msg"] toView:self.view delay:1.0];
        
        [_videoArray removeObjectAtIndex:(sender.tag - 1000)];
        
        [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:(sender.tag - 1000) inSection:0]] withRowAnimation:(UITableViewRowAnimationLeft)];
        [_tableView reloadData];
        //        [self getCollectVideoList];
    } failure:^(NSError *error) {
        NSLog(@"取消收藏视频失败%@",error);
        [MBProgressHUD showMessage:@"取消收藏失败" toView:self.view delay:1.0];
    }];
}

- (void)noDataView {
    NoDataView *noData = [[NoDataView alloc] initWithFrame:self.tableView.frame];
    [noData noDataViewTryImage:@"no_data" tryLabel:@"暂无收藏视频!" tryBtn:@""];
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
