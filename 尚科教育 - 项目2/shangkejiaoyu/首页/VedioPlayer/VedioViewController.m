//
//  VedioViewController.m
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2017/6/26.
//  Copyright © 2017年 ShangKe. All rights reserved.
//

#import "VedioViewController.h"
#import <MediaPlayer/MPMoviePlayerController.h>

#import "LXControlView.h"
#import "UIImageView+WebCache.h"

#import "AppDelegate.h"
#import "VideoCell.h"
#import "VideoPayCell.h"
#import "VideoIntroduceCell.h"
#import "RelatedVideoCell.h"

#define iOS7 [[[UIDevice currentDevice] systemVersion] floatValue]

@interface VedioViewController ()<LXControlViewDelegate ,UITableViewDelegate, UITableViewDataSource>
@property (nonatomic,strong) NSArray *profuctIdArr;
@property (nonatomic,copy) NSString *currentProId;

@property(nonatomic,strong) LXControlView *contolView;
@property (strong, nonatomic) MPMoviePlayerController *player;
@property (strong, nonatomic) UIImageView *imageView;
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSDictionary *dataDic;
@property (nonatomic, strong) VideoCell *cell;

@property (nonatomic, strong) NSString *moneyID;

@property (nonatomic, strong) NSMutableArray *jobArray;

@end

@implementation VedioViewController

- (UITableView *)tableView {
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kScreenWidth *9/16 + 64, kScreenWidth, kScreenHeight - kScreenWidth *9/16 - 64) style:UITableViewStyleGrouped];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.tableFooterView = [UIView new];
        self.tableView.backgroundColor = kCustomVCBackgroundColor;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerNib:[UINib nibWithNibName:@"VideoCell" bundle:nil] forCellReuseIdentifier:@"videoCell"];
        [self.tableView registerNib:[UINib nibWithNibName:@"VideoPayCell" bundle:nil] forCellReuseIdentifier:@"videoPayCell"];
        [self.tableView registerNib:[UINib nibWithNibName:@"VideoIntroduceCell" bundle:nil] forCellReuseIdentifier:@"videoIntroduceCell"];
        [self.tableView registerNib:[UINib nibWithNibName:@"RelatedVideoCell" bundle:nil] forCellReuseIdentifier:@"relatedVideoCell"];
        
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.allowRotation = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
    
    //    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenWidth *9/16)];
    //    NSString *imageURL = [NSString stringWithFormat:@"%@%@",HTTP,_dataDic[@"brief"]];
    //    [image sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"load"]];
    //    [self.view addSubview:image];
    
    [self getRelatedVideoList];
    
    
    //    [_slidePageScrollView reloadData];
    self.view.backgroundColor = [UIColor blackColor];
    self.tabBarController.tabBar.hidden = YES;
    leftBarButton(@"returnImage");
    self.title = [NSString stringWithFormat:@"%@   ",_model.title];
    
    [self getVideoDetail:_model.modelID];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    [self.view addSubview:self.tableView];
    
}
- (void)getVideoDetail:(NSString *)videoID {
    
    NSString *user = [[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];
    NSString *str = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/video_detail"];
    NSDictionary *dic = @{
                          @"id":videoID,
                          @"uid":user,
                          };
    [HttpRequest postWithURLString:str parameters:dic success:^(id success) {
        _dataDic = success[@"body"];
        [MBProgressHUD hideHUDForView:self.tableView animated:YES];
        
//        NSString *str = [NSString stringWithFormat:@"%@%@",@"http://xueyuan.mingtaokeji.com/",_dataDic[@"video_url"]];
        NSString *str = _dataDic[@"video_url"];
        
        NSString* encodedString = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        self.contolView =[[LXControlView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenWidth *9/16) videoUrl:encodedString title:nil];
        self.contolView.delegate = self;
        //        self.contolView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"03"]];
        self.contolView.imgaeUrl = [NSString stringWithFormat:@"%@%@",skImageUrl,_dataDic[@"fist_img"]];
        self.title = [NSString stringWithFormat:@"%@   ",_dataDic[@"title"]];
        
        [self.view addSubview:self.contolView];
        [self studyRequest];
        [self.tableView reloadData];
        if (![_dataDic[@"pay_status"] isKindOfClass:[NSNull class]]) {
            [[NSUserDefaults standardUserDefaults] setObject:_dataDic[@"pay_status"] forKey:@"pay_status"];
        }else {
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"pay_status"];
        }
        
        NSLog(@"%@",success);
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [MBProgressHUD hideHUDForView:self.tableView animated:YES];
        [MBProgressHUD showMessage:@"加载失败！" toView:self.view delay:1.0];
        
    }];
    
}
#pragma mark --- 相关视频 ---
- (void)getRelatedVideoList {
    NSString *user = [[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];
    if (user != nil) {
        NSString *str = [NSString stringWithFormat:@"%@%@", sHTTPURL,relatedVideo];
        NSDictionary *dic = @{
                              @"id":_model.modelID,
                              };
        [HttpRequest postWithURLString:str parameters:dic success:^(id success) {
            NSLog(@"相关视频%@",success);
            for (NSDictionary *dic in success[@"body"]) {
                StudyModel *model = [[StudyModel alloc] initWithDic:dic];
                if (!_jobArray) {
                    _jobArray = [NSMutableArray array];
                }
                [_jobArray addObject:model];
            }
            
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            NSLog(@"相关视频%@",error);
        }];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        _cell = [tableView dequeueReusableCellWithIdentifier:@"videoCell" forIndexPath:indexPath];
        _cell.backgroundColor = [UIColor clearColor];
        _cell.click_countLabel.text = _dataDic[@"click_count"];
        NSString *is_attention = [NSString stringWithFormat:@"%@",_dataDic[@"is_attention"]];
        if ([is_attention isEqualToString:@"0"]) {
            _cell.collectionImage.image = [UIImage imageNamed:@"videoCollection"];
        }else {
            _cell.collectionImage.image = [UIImage imageNamed:@"ic_light_star"];
        }
        
        _cell.shareImage.image = [UIImage imageNamed:@"videoCollection"] ;                [_cell.shareVideoBtn addTarget:self action:@selector(shareVideoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_cell.collectionBtn addTarget:self action:@selector(collectionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        return _cell;
    }
    
    if (indexPath.section == 1) {
        VideoPayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"videoPayCell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor clearColor];
        [cell.purchaseBtn addTarget:self action:@selector(purchaseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.shopPriceLabel.text = _dataDic[@"shop_price"];
        if ([_dataDic[@"shop_price"] isEqualToString:@"0.00"]) {
            cell.purchaseBtn.hidden = YES;
        }
        return cell;
    }
    if (indexPath.section == 2) {
        VideoIntroduceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"videoIntroduceCell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor clearColor];
        cell.nameLabel.text = _model.title;
        
        cell.timeLabel.text = [NSString stringWithFormat:@"上传时间：%@",[self timeInterval:_dataDic[@"add_time"]]];
        if (![_model.teacher isKindOfClass:[NSNull class]]) {
            cell.teacherLabel.text = [NSString stringWithFormat:@"讲师：%@",_dataDic[@"teacher"]];
        }
        if (![_model.brief isKindOfClass:[NSNull class]]) {
            if (_model.brief == nil) {
                cell.briefLabel.text = @"暂无简介";
            }else {
                cell.briefLabel.text = _model.brief;
            }
        }
        //[cell.cellHeight addTarget:self action:@selector(cellHeightClick:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    if (indexPath.section == 3) {
        RelatedVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"relatedVideoCell" forIndexPath:indexPath];
        cell.timeLabel.hidden = YES;
        cell.backgroundColor = [UIColor clearColor];
        StudyModel *model = _jobArray[indexPath.row];
        [cell configureCellDataModel:model];
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3) {
        StudyModel *model = _jobArray[indexPath.row];
        [self getVideoDetail:model.modelID];
        //_URLString
        RelatedVideoCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        cell.titleLabel.textColor = [UIColor redColor];
        
    }else {
        
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 3) {
        return _jobArray.count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
  
    UIView *header = [[UIView alloc] init];
    header.frame = CGRectMake(0, 0, kScreenWidth, 0.01);
    
    return header;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *header = [[UIView alloc] init];
    header.frame = CGRectMake(0, 0, kScreenWidth, 0.01);
    return header;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 || indexPath.section == 1) {
        return 46;
    }else if (indexPath.section == 2) {
        return 120;
    }
    return 100;
}

//- (void)cellHeightClick:(UIButton *)sender {

//}

#pragma mark --- 视频收藏 ---
- (void)collectionBtnClick:(UIButton *)sender {
    
    NSUserDefaults *user = [[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];
    if (user == nil) {
        [AlertView(@"温馨提示!", @"请先登录。", @"确定", nil) show];
    }else {
        if (!sender.selected) {
            _cell.collectionImage.image = [UIImage imageNamed:@"videoCollection"];
            
            [self videoCollection];
        }else {
            _cell.collectionImage.image = [UIImage imageNamed:@"ic_light_star"];
            [self cancelVideoCollection];
            
        }
        sender.selected = !sender.selected;
        
    }
    
}

- (void)videoCollection {
    NSUserDefaults *user = [[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];
    if (user != nil) {
        NSString *str = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/collection"];
        NSDictionary *dic = @{
                              @"goods_id":_dataDic[@"id"],
                              @"uid":user,
                              };
        [HttpRequest postWithURLString:str parameters:dic success:^(id success) {
            NSLog(@"收藏视频%@",success);
            
        } failure:^(NSError *error) {
            NSLog(@"收藏视频%@",error);
        }];
    }
}

- (void)cancelVideoCollection {
    NSUserDefaults* user = [[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];
    if (user != nil) {
        //        NSLog(@"---=----%@",_model.ID);
        NSString *str = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/uncollection"];
        NSDictionary *dic = @{
                              @"goods_id":_dataDic[@"id"],
                              @"uid":user,
                              };
        [HttpRequest postWithURLString:str parameters:dic success:^(id success) {
            NSLog(@"收藏视频%@",success);
            NSString *is_attention;
            for (is_attention in _dataDic) {
                if ([is_attention isEqualToString:@"0"]) {
                    is_attention = @"1";
                }
            }
            
        } failure:^(NSError *error) {
            NSLog(@"收藏视频%@",error);
        }];
    }
}


#pragma mark ------付费视频
- (void)purchaseBtnClick:(UIButton *)sender {
    [AlertView(@"温馨提示！", @"确定要购买此视频？", @"取消", @"确定") show];
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSString *pay_status = [[NSUserDefaults standardUserDefaults] objectForKey:@"pay_status"];
        if ([pay_status isEqualToString:@"2"]) {
            [MBProgressHUD showMessage:@"该视频已经购买！" toView:self.view delay:1.0];
            return;
        }
        NSString *user = [[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];
        NSString *userPhone = [[NSUserDefaults standardUserDefaults] objectForKey:@"userPhone"];
        
        NSString *str = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/user_money"];
        NSDictionary *dic = @{
                              @"uid":user
                              };
        
        [HttpRequest postWithURLString:str parameters:dic success:^(id success) {
            NSLog(@"账户余额%@",success);
            NSString *userMoney = @"1";
            if (userMoney >= _dataDic[@"shop_price"]) {
                
                NSString *str = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/build_order"];
                NSDictionary *dic = @{
                                      @"goods_id":_dataDic[@"id"],
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
                [MBProgressHUD showMessage:@"余额不足，请先充值！" toView:self.view delay:1.0];
            }
        } failure:^(NSError *error) {
            NSLog(@"账户余额%@",error);
        }];
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
            [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"pay_status"];
            VideoPayCell *purchaseBtn = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
            [purchaseBtn.purchaseBtn setTitle:@"已购买！" forState:UIControlStateNormal];
            
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

- (NSString *)timeInterval:(NSString *)getTime {
    NSTimeInterval time=[getTime doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate:detaildate];
    
    return currentDateStr;
}

#pragma mark - dataSource
- (NSInteger)numberOfPageViewOnSlidePageScrollView {
    return self.childViewControllers.count;
}


-(void)dismissVC {
    NSLog(@"返回视频播放的回调");
    
}

-(void)playEnd {
    NSLog(@"播放结束的回调");
}

// 只支持两个方向旋转
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait |UIInterfaceOrientationMaskLandscapeLeft |UIInterfaceOrientationMaskLandscapeRight;
}

-(BOOL)shouldAutorotate {
    return YES;
}

- (void)leftButton:(UIButton *)sender {
    NSLog(@"返回本页 的回调");
    [self.contolView deletePlayer];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.allowRotation = NO;
    
}

- (void)didMoveToParentViewController:(UIViewController*)parent{
    [super didMoveToParentViewController:parent];
    NSLog(@"%s,%@",__FUNCTION__,parent);
    if(!parent){
        NSLog(@"页面pop成功了");
        [self.contolView deletePlayer];
    }
}

//添加
- (void)studyRequest {
    NSUserDefaults* user = [[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];
    if (user != nil) {
        NSLog(@"---=----%@",_model.modelID);
        NSString *str = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/learn_log"];
        NSDictionary *dic = @{
                              @"id":_model.modelID,
                              @"uid":user,
                              
                              };
        [HttpRequest postWithURLString:str parameters:dic success:^(id success) {
            NSLog(@"-------%@",success);
        } failure:^(NSError *error) {
            NSLog(@"--------%@",error);
        }];
    }
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
