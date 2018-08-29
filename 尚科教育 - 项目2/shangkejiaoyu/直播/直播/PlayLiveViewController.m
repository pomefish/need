//
//  PlayLiveViewController.m
//  mingtao
//
//  Created by Linlin Ge on 2017/8/14.
//  Copyright © 2017年 Linlin Ge. All rights reserved.
//

#import "PlayLiveViewController.h"
#import "PlayLiveModel.h"
#import "NoDataView.h"
#import "LiveTableViewCell.h"
#import "RechargeViewController.h"

//#import <AlivcLiveVideo/AlivcLiveVideo.h>
//#import "AlivcLiveViewController.h"

#import "CustomAlertView.h"

#import "VideoPlayViewController.h"

#import "LogonViewController.h"
#import "InviteViewController.h"
@interface PlayLiveViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *tableArr;
@property (nonatomic, assign) NSInteger numberOfPageSize;
@property (nonatomic, strong) NoDataView *noDataView;

@property (nonatomic, strong) UIButton *liveButton;
@property (nonatomic, copy) NSString  *pushUrl;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic,assign)NSInteger tag;//标记用邀请码进过直播间，再次进则不需要

@end

@implementation PlayLiveViewController

- (UITableView *)tableView {
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 110) style:UITableViewStylePlain];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.tableFooterView = [UIView new];
        self.tableView.separatorStyle = NO;//隐藏Cell线
        self.tableView.backgroundColor = kCustomVCBackgroundColor;
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [self.tableView registerNib:[UINib nibWithNibName:@"LiveTableViewCell" bundle:nil] forCellReuseIdentifier:@"LiveTableViewCell"];
    }
    return _tableView;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.navigationController.navigationBar.barTintColor = kCustomViewColor;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];

    
    _tableArr = [NSMutableArray array];
    _dataArr = [NSMutableArray array];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self.view addSubview:self.tableView];
    [self configoreNoDataView];
    

    
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
}
    
#pragma mark -- 查看个人资料环信使用


#pragma mark -- 获取直播列表
- (void)getLiveRequestHttp:(BOOL)isPull {
    
    if (isPull) {
        _numberOfPageSize = 1;
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/zhibo_new"];
              NSString *user = [[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];
    NSDictionary *dic = @{@"page":@(_numberOfPageSize),
                          @"pagesize":@"10",
                          @"uid":user
                          };
    [HttpRequest postWithURLString:urlStr parameters:dic success:^(id success) {
        _noDataView.hidden = YES;
        
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];

        SKLog(@"------直播列表-------%@",success);
        
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
//        SKLog(@"------_dataArr--------%ld",_dataArr.count);
        if (_dataArr.count == 0) {
            _noDataView.hidden = NO;
        }
        [self requestData];
        
        NSInteger num = 0;
        for (NSDictionary *dic in success[@"body"]) {
            if ([dic[@"status"] isEqualToString:@"1"]) {
                num++;
            }
        }

    } failure:^(NSError *error) {
        SKLog(@"------直播列表-------%@",error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [_tableArr removeAllObjects];
        [_tableView reloadData];
        _noDataView.hidden = NO;
        
    }];
    
}

- (void)delayInSeconds:(CGFloat)delayInSeconds block:(dispatch_block_t) block {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC),  dispatch_get_main_queue(), block);
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
    
    LiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LiveTableViewCell" forIndexPath:indexPath];
    PlayLiveModel *model = _tableArr[indexPath.row];
    if ([model.status isEqualToString:@"1"]) {
    cell.appointmentBtn.hidden = YES;
    }
//    [cell.appointmentBtn addTarget:self action:@selector(appointmentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell configurePlayLiveCellDataModel:model];
    
    cell.appointmentBtn.tag = indexPath.row;
    cell.backgroundColor = [UIColor clearColor];
    cell.appointmentBtn.backgroundColor = [UIColor clearColor];
    [cell.appointmentBtn setTitle:@"" forState:UIControlStateNormal];
    [cell.contactBtn addTarget:self action:@selector(handleInvite:) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleCellInvite:)];
    cell.contactLabel.userInteractionEnabled = YES;
    [cell.contactLabel addGestureRecognizer:tap];
    
    
   NSString *payStatus = [NSString stringWithFormat:@"%@",model.is_pay];
     NSString *rankStatus = [NSString stringWithFormat:@"%@",model.rank_list];
    [[NSUserDefaults standardUserDefaults]setObject:payStatus forKey:@"paymoney"];
    if ([payStatus isEqualToString:@"1"] || [rankStatus isEqualToString:@"1"]) {
        [cell.buyBtn setTitle:@"已购买" forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"paymoney"];
    }else{
        [cell.buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"paymoney"];
    }
    
    [cell.buyBtn addTarget:self action:@selector(handleBuy:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)appointmentBtnClick:(UIButton *)sender {
    SKLog(@"--------预约。。。-------%ld",(long)sender.tag);
    
    PlayLiveModel *model = _tableArr[sender.tag];
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
    if ([userID isEqualToString:@"1"]) {
        [MBProgressHUD showMessage:@"请先登录！" toView:self.tableView delay:3.0];
        return;
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/collect_zhibo"];
    
    NSDictionary *dic = @{@"uid":userID,
                          @"zhibo_id":model.ID
                          };
    [HttpRequest postWithURLString:urlStr parameters:dic success:^(id success) {
        SKLog(@"------报名-------%@",success);
        if ([success[@"code"] isEqualToNumber:@0]) {
            [MBProgressHUD showMessage:@"请先登录！" toView:self.tableView delay:3.0];
        }else if ([success[@"code"] isEqualToNumber:@1]) {
            [MBProgressHUD showMessage:@"参数错误！" toView:self.tableView delay:3.0];
        }else if ([success[@"code"] isEqualToNumber:@2]) {
            [MBProgressHUD showMessage:@"已经报名过了！" toView:self.tableView delay:3.0];
        }else if ([success[@"code"] isEqualToNumber:@3]) {
            [MBProgressHUD showMessage:@"报名成功！" toView:self.tableView delay:3.0];
        }else if ([success[@"code"] isEqualToNumber:@4]) {
            [MBProgressHUD showMessage:@"报名失败，请再试试！" toView:self.tableView delay:3.0];
        }
    } failure:^(NSError *error) {
        SKLog(@"------预约-------%@",error);
        [MBProgressHUD showMessage:@"网络错误，请重新预约！" toView:self.tableView delay:3.0];
        
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
    if ([userID isEqualToString:@"1"]) {
        LogonViewController *logonVC = [LogonViewController new];
        //        logonVC.logonStr = @"1";
        logonVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        UINavigationController *loginNav = [[UINavigationController alloc]initWithRootViewController:logonVC];
        //模态弹出这里
        [self presentViewController:loginNav animated:YES completion:nil];
        
    }else {
        PlayLiveModel *model = _tableArr[indexPath.row];
//        NSLog(@"mmm = %@   %@  %@ ",model.rank_list,model.is_pay,model.status);
        NSString *pay = [[NSUserDefaults standardUserDefaults] objectForKey:@"paymoney"];
        if ([model.status isEqualToString:@"0"]) {
            [AlertView(@"温馨提示", @"直播还未开始！", @"确定", nil) show];
        }else  if ([model.status isEqualToString:@"2"]) {
            [AlertView(@"温馨提示", @"直播已经结束！", @"确定", nil) show];
        }else if ([model.status isEqualToString:@"1"]){
            if ([model.rank_list isEqualToString:@"1"] ) {
                // 有权限直接进入
                VideoPlayViewController *liveVc = [[VideoPlayViewController alloc] init];
                liveVc.model = model;
                liveVc.hidesBottomBarWhenPushed = YES;
                [self.navigationController  pushViewController:liveVc animated:YES];

            }else if([pay isEqualToString:@"1"]){
                // 购买的直接进入
                VideoPlayViewController *liveVc = [[VideoPlayViewController alloc] init];
                liveVc.model = model;
                liveVc.hidesBottomBarWhenPushed = YES;
                [self.navigationController  pushViewController:liveVc animated:YES];
            }
            
            else{
                //没有权限的话，没有购买的，有房间号直接进入
                if (model.key != nil   && ![model.key isEqualToString:@""] ) {
                    
                    if (self.tag == 1) {
                        VideoPlayViewController *liveVc = [[VideoPlayViewController alloc] init];
                        liveVc.model = model;
                        liveVc.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:liveVc animated:YES];
                    }else{
                        
                        CustomAlertView *alertView=[CustomAlertView alertViewWithCancelbtnClicked:^{
                            
                        } andSureBtnClicked:^(NSString *name, NSString *idnumber){
                            NSLog(@"-------确定按钮点击后 姓名和身份证号参数----%@,%@",name,idnumber);
                            //保存修改后的姓名和身份证号
                            if ([name isEqualToString:model.key]) {
                                VideoPlayViewController *liveVc = [[VideoPlayViewController alloc] init];
                                liveVc.model = model;
                                liveVc.hidesBottomBarWhenPushed = YES;
                                [self.navigationController  pushViewController:liveVc animated:YES];
                                self.tag = 1;
                                
                            }else {
                                [MBProgressHUD showMessage:@"验证码错误！" toView:self.tableView delay:2.0];
                            }
                            
                        } withName:@"23" withidcard:@"33"];
                        UIView *keywindow=[UIApplication sharedApplication].keyWindow;
                        [keywindow addSubview:alertView];
                    }

                }else{
                  //购买过的进入
                    if ([pay isEqualToString:@"1"]) {
                        VideoPlayViewController *liveVc = [[VideoPlayViewController alloc] init];
                        liveVc.model = model;
                        liveVc.hidesBottomBarWhenPushed = YES;
                        [self.navigationController  pushViewController:liveVc animated:YES];
                    }else{
                      [MBProgressHUD showMessage:@"请先购买该视频,再观看！" toView:self.view delay:1.0];
                    }
                   
                    
                }
            }

        }
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tableArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//  return kScreenHeight / 1.9+20;
    return kScreenHeight / 1.9+20 +20;


}


- (void)configoreNoDataView {
    _noDataView = [[NoDataView alloc] initWithFrame:CGRectMake(0, -60, kScreenWidth, kScreenHeight)];
    _noDataView.hidden = YES;
    [_noDataView noDataViewTryImage:@"no_data" tryLabel:@"您暂时没有直播！" tryBtn:@"刷新试试！"];
    [_noDataView.tryBtn addTarget:self action:@selector(tryBttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_noDataView];
}

- (void)tryBttonClick:(UIButton *)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self getLiveRequestHttp:YES];
}

#pragma mark -- 点击底部中间邀请按钮跳到二维码页面
- (void)handleInvite:(UIButton *)sender{
    InviteViewController *inviteVC =  [InviteViewController new];
    inviteVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:inviteVC animated:YES];
}

- (void)handleCellInvite:(UITapGestureRecognizer *)tap{
    InviteViewController *inviteVC =  [InviteViewController new];
    inviteVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:inviteVC animated:YES];
}
#pragma mark -----  点击立即购买
- (void)handleBuy:(UIButton *)sender{
    LiveTableViewCell *cell = (LiveTableViewCell *)[sender superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    PlayLiveModel *model = _tableArr[indexPath.row];
    NSString *payStatus = [[NSUserDefaults standardUserDefaults] objectForKey:@"paymoney"];
    [[NSUserDefaults standardUserDefaults] setObject:model.zhibo_price forKey:@"zhibo_money"];
     [[NSUserDefaults standardUserDefaults] setObject:model.ID forKey:@"zhibo_ID"];
//    NSLog(@"学习币购买 sss = %@  %@",payStatus,model.zhibo_price);
    
    if ([payStatus isEqualToString:@"1"]) {
        [MBProgressHUD showMessage:@"已经购买过该视频,可直接观看！" toView:self.view delay:1.0];
        return;
    }
    
    NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
    if ([user isEqualToString:@"1"]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示！" message:@"您现在为游客状态，您所购买的视频只能在本设备上观看，若想多设备观看，请登录账号！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *boye = [UIAlertAction actionWithTitle:@"继续购买" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [self touristsPay];
        }];
        UIAlertAction *girl = [UIAlertAction actionWithTitle:@"去登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            LogonViewController *logonVC = [LogonViewController new];
            UINavigationController *loginNav = [[UINavigationController alloc]initWithRootViewController:logonVC];
            //模态弹出  这里
            [self presentViewController:loginNav animated:YES completion:nil];
        }];
        [alertController addAction:boye];
        [alertController addAction:girl];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }else {
        [AlertView(@"温馨提示！", @"确定要购买此视频？", @"取消", @"确定") show];
    }
    
}


#pragma mark -- 游客购买
- (void)touristsPay {
               [MBProgressHUD showMessage:@"请先登录再购买！" toView:self.view delay:1.0];

//   // NSString * vedioID = [[NSUserDefaults standardUserDefaults] objectForKey:_dataDic[@"id"]];
//    NSString * vedioID  = @"2";
//    if ([vedioID isEqualToString:@"2"]) {
//        [MBProgressHUD showMessage:@"已经购买过该视频！" toView:self.view delay:1.0];
//    }else {
//        NSString *moneyStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"userMoney"];
//      //  NSString *shopPrice = _dataDic[@"shop_price"];
//        NSString *shopPrice = @"30.00";
//        NSInteger m = [moneyStr integerValue];
//
//        NSInteger k = [shopPrice integerValue];
//
//        if (m < k) {
//            // [MBProgressHUD showMessage:@"余额不足，请先充值！" toView:self.view delay:1.0];
//            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示！" message:@"余额不足，请先充值！" preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *boye = [UIAlertAction actionWithTitle:@"再看看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
//            }];
//            UIAlertAction *girl = [UIAlertAction actionWithTitle:@"去充值" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
//                RechargeViewController *rechargeVC = [RechargeViewController new];
//                [self.navigationController pushViewController:rechargeVC animated:YES];
//            }];
//            [alertController addAction:boye];
//            [alertController addAction:girl];
//            [self presentViewController:alertController animated:YES completion:nil];
//        }else {
//            NSString *userMoney = [NSString stringWithFormat:@"%ld",m - k];
//            [[NSUserDefaults standardUserDefaults] setObject:userMoney forKey:@"userMoney"];
////            [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:_dataDic[@"id"]];
////            [[NSUserDefaults standardUserDefaults] setObject:_dataDic[@"id"] forKey:@"vedioID"];
////
////            VideoPayCell *purchaseBtn = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
////            [purchaseBtn.purchaseBtn setTitle:@"已购买！" forState:UIControlStateNormal];
//
//
//            [MBProgressHUD showMessage:@"购买成功，您可以观看该视频了！" toView:self.view delay:1.0];
//
//        }
//    }
}



- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {

    if (buttonIndex == 1) {
        NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
        if ([user isEqualToString:@"1"]) {
            [self touristsPay];
        }else {

            NSString *user = [[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];
            NSString *userPhone = [[NSUserDefaults standardUserDefaults] objectForKey:@"userPhone"];

            NSString *str = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/user_money"];
            NSDictionary *dic = @{
                                  @"uid":user
                                  };

            [HttpRequest postWithURLString:str parameters:dic success:^(id success) {
                NSLog(@"账户余额%@",success);
                NSString *userMoney = success[@"user_money"];
                NSString *zhiMoney = [[NSUserDefaults standardUserDefaults] objectForKey:@"zhibo_money"];
                 NSString *zhiID = [[NSUserDefaults standardUserDefaults] objectForKey:@"zhibo_ID"];
                
                if (userMoney >= zhiMoney) {

                    NSString *str = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/zhibo_order"];
                    NSDictionary *dic = @{
                                          @"zhibo_id":zhiID,
                                          @"userid":user,
                                          @"username":userPhone
                                          };
                    [HttpRequest postWithURLString:str parameters:dic success:^(id success) {
                        NSLog(@"生成订单%@",success);
                        if ([success[@"code"] isEqualToNumber:@3]) {
                            [MBProgressHUD showMessage:@"该视频不支持购买！" toView:self.view delay:1.0];
                        }else if ([success[@"code"] isEqualToNumber:@4]) {
                            [self getBalancePaymentOrderNumber:success[@"order_sn"]];
                        }else if ([success[@"code"] isEqualToNumber:@5]) {
                            [MBProgressHUD showMessage:@"订单生产失败！" toView:self.view delay:1.0];
                        }else if ([success[@"code"] isEqualToNumber:@6]) {
                            [MBProgressHUD showMessage:@"已经购买过该视频！" toView:self.view delay:1.0];
                        }
                    } failure:^(NSError *error) {
                        NSLog(@"生成订单%@",error);
                    }];

                }else {
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示！" message:@"余额不足，请先充值！" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *boye = [UIAlertAction actionWithTitle:@"再看看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    }];
                    UIAlertAction *girl = [UIAlertAction actionWithTitle:@"去充值" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                        RechargeViewController *rechargeVC = [RechargeViewController new];
                        [self.navigationController pushViewController:rechargeVC animated:YES];
                    }];
                    [alertController addAction:boye];
                    [alertController addAction:girl];
                    [self presentViewController:alertController animated:YES completion:nil];
                }
            } failure:^(NSError *error) {
                NSLog(@"账户余额%@",error);
            }];
        }
    }
}

- (void)getBalancePaymentOrderNumber:(NSString *)OrderNumber {
    NSString *user = [[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];
    NSString *str = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/payment"];
    NSDictionary *dic = @{
                          @"order_sn":OrderNumber,
                          @"uid":user,
                          @"type":@"2"
                          };
    [HttpRequest postWithURLString:str parameters:dic success:^(id success) {
        NSLog(@"余额支付%@",success);
        if ([success[@"code"] isEqualToNumber:@3]) {
            [MBProgressHUD showMessage:@"已购买过，请勿重新购买！" toView:self.view delay:1.0];
        }else if ([success[@"code"] isEqualToNumber:@4]) {

            [MBProgressHUD showMessage:@"购买成功！" toView:self.view delay:1.0];

             [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"paymoney"];
           LiveTableViewCell  *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            [cell.buyBtn setTitle:@"已购买" forState:UIControlStateNormal];

        }else if ([success[@"code"] isEqualToNumber:@5]) {
            [MBProgressHUD showMessage:@"购买失败！" toView:self.view delay:1.0];
        }else if ([success[@"code"] isEqualToNumber:@6]) {
            [MBProgressHUD showMessage:@"余额不足，请先充值！" toView:self.view delay:1.0];
        }
    } failure:^(NSError *error) {
        NSLog(@"余额支付%@",error);
        [MBProgressHUD showMessage:@"购买失败！" toView:self.view delay:1.0];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
//    if () {//有观看权限
//       // 直接进去观看
//    }else{
//        //没有观看权限
//        if () {//该直播有直播房间号（后台有时间会加号，有时间为不加）
//      //号码输入正确进去观看
//        //号码错误提示错误
//        }else{
//            if () {//购买成功
//                //直接进去观看
//
//
//            }else{
//               //提示先购买再观看
//            }
//        }
//    }
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
