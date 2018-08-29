//
//  VedioPlayerViewController.m
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2017/7/20.
//  Copyright © 2017年 ShangKe. All rights reserved.
//

#import "VedioPlayerViewController.h"
#import "LMVideoPlayer.h"
#import "LMBrightnessView.h"

#import "Masonry.h"
#import "AppDelegate.h"

#import "VideoCell.h"
#import "VideoPayCell.h"
#import "VideoIntroduceCell.h"
#import "RelatedVideoCell.h"

#import "RechargeViewController.h"
//分享
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <IJKMediaFramework/IJKMediaFramework.h>
//多倍速view
#import "rateView.h"
@interface VedioPlayerViewController () <LMVideoPlayerDelegate, UITableViewDelegate, UITableViewDataSource>
{
    int _selectCell;
}

/** 状态栏的背景 */
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) LMVideoPlayer *player;
@property (nonatomic, strong) UIView *playerFatherView;
@property (nonatomic, strong) LMPlayerModel *playerModel;

/** 离开页面时候是否在播放 */
@property (nonatomic, assign) BOOL isPlaying;
/** 离开页面时候是否开始过播放 */
@property (nonatomic, assign) BOOL isStartPlay;

//@property (nonatomic, copy) NSString *videoID;
/** 新视频按钮 */
//@property (nonatomic, strong) UIButton *nextVideoBtn;
/** 下一页 */
//@property (nonatomic, strong) UIButton *nextPageBtn;


@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSDictionary *dataDic;
@property (nonatomic, strong) VideoCell *cell;
@property (nonatomic, strong) NSString *moneyID;
@property (nonatomic, assign) CGFloat contentHeight;

@property (nonatomic, strong) NSMutableArray *jobArray;
@property (nonatomic,copy)NSString *vidID;
//




@end

@implementation VedioPlayerViewController

- (UITableView *)tableView {
    if (_tableView == nil) {
       // UITableViewStyle style = UITableViewStyleGrouped;
//        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kScreenWidth *9/16 + 64, kScreenWidth, kScreenHeight - kScreenWidth *9/16 - 64) style:style];
        if (@available(iOS 11.0,*)) {
self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kScreenWidth *9/16 + 64, kScreenWidth, kScreenHeight - kScreenWidth *9/16 - 64) style:UITableViewStyleGrouped];
            
        }else{
self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kScreenWidth *9/16 + 64, kScreenWidth, kScreenHeight - kScreenWidth *9/16 - 64) style:UITableViewStylePlain];
        }
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

- (void)dealloc {
    NSLog(@"---------------dealloc------------------");
    [self.player destroyVideo];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.z
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    self.isStartPlay = NO;
    
    _selectCell = -1;
    

    [self.view addSubview:self.topView];
    [self.view addSubview:self.playerFatherView];
    [self.view addSubview:self.tableView];

    
    [self makePlayViewConstraints];
//
//   [self getVideoDetail:_model.modelID];

    [self getRelatedVideoList];
    
  

}


- (void)addLearningRecordsVideoTime {
    NSLog(@"vvvvv = %f",self.player.playerMgr.currentTime);
    if (self.player.playerMgr.currentTime == 0) {
        return;
    }
    CGFloat i = self.player.playerMgr.currentTime / self.player.playerMgr.duration;
    
    NSString *str = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/add_log"];
    NSDictionary *dic = @{
                          @"id":_model.modelID,
                          @"uid":USERID,
                          @"progress":[NSString stringWithFormat:@"%.2f", i],
                          @"play_time":@(self.player.playerMgr.currentTime)
                          };
    [HttpRequest postWithURLString:str parameters:dic success:^(id success) {
       NSLog(@"-----------学习时间------------%@",success);
    } failure:^(NSError *error) {
    NSLog(@"-----------学习时间----------%@",error);
    }];
}
- (void)getVideoDetail:(NSString *)videoID {
    NSString *user = [[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];
    
    NSString *str = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/video_detail"];
    NSDictionary *dic = @{
                          @"id":videoID,
                          @"uid":user,
                          };
    [HttpRequest postWithURLString:str parameters:dic success:^(id success) {
//    NSLog(@"wwwwwww视频%@",success);

        _dataDic = success[@"body"];
        [MBProgressHUD hideHUDForView:self.tableView animated:YES];
        
        NSString  *encodedString = [_dataDic[@"video_url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        LMPlayerModel *model = [[LMPlayerModel alloc] init];
        model.videoURL = [NSURL URLWithString:encodedString];
        //我加
        //是否从上次播放时间播放
        if (![NSString cc_isNULLOrEmpty:_dataDic[@"play_time"]]) {
            model.viewTime = [_dataDic[@"play_time"] integerValue];
        }
        //我加结束
        self.vidID = [NSString stringWithFormat:@"%@",_dataDic[@"id"]];
         self.shareTitle = _dataDic[@"title"];

        model.seekTime =  self.player.playerMgr.currentTime;
//        NSLog(@"sss = %ld   vvv = %ld",model.seekTime,model.viewTime);
        model.placeholderImageURLString = [NSString stringWithFormat:@"%@%@",skImageUrl,_dataDic[@"fist_img"]];
        LMVideoPlayer *player = [LMVideoPlayer videoPlayerWithView:self.playerFatherView delegate:self playerModel:model];
        self.player = player;
        
        
        [self.tableView reloadData];
        
        [[NSUserDefaults standardUserDefaults] setObject:_dataDic[@"id"] forKey:@"vedioID"];
        [[NSUserDefaults standardUserDefaults] setObject:_dataDic[@"shop_price"] forKey:@"priceStatus"];
        if ([user isEqualToString:@"1"]) {
            NSString * vedioID = [[NSUserDefaults standardUserDefaults] objectForKey:_dataDic[@"id"]];
            if ([vedioID isEqualToString:@"2"]) {
                [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"pay_status"];
            }else {
                [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"pay_status"];
            }
        }else {
            NSString *payStatus = [NSString stringWithFormat:@"%@",_dataDic[@"pay_status"]];
            NSString *shopPrice = [NSString stringWithFormat:@"%@",_dataDic[@"shop_price"]];
            
            if ([payStatus isEqualToString:@"2"] || [shopPrice isEqualToString:@"0.00"]) {
                [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"pay_status"];
            }else {
                [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"pay_status"];
            }
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [MBProgressHUD hideHUDForView:self.tableView animated:YES];
        [MBProgressHUD showMessage:@"加载失败！" toView:self.view delay:1.0];
        
    }];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
//    [self.view addSubview:self.tableView];

}
//-----------------------
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    // pop回来时候是否自动播放
    if (self.player && self.isPlaying) {
        self.isPlaying = NO;
        [self.player playVideo];
    }
    LMBrightnessViewShared.isStartPlay = self.isStartPlay;
    
    //横竖屏选择，在视图出现的时候，将allowRotate改为1，
    AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.allowRotation = 1;
    [self getVideoDetail:_model.modelID];
}
#pragma mark --- 相关视频 ---
- (void)getRelatedVideoList {
    
    NSString *str = [NSString stringWithFormat:@"%@%@",sHTTPURL,relatedVideo];
    NSDictionary *dic = @{
                          @"id":_model.modelID,
                          };
    [HttpRequest postWithURLString:str parameters:dic success:^(id success) {
//        NSLog(@"相关视频%@",success);
        for (NSDictionary *dic in success[@"body"]) {
            StudyModel *model = [[StudyModel alloc] initWithDic:dic];
            if (!_jobArray) {
                _jobArray = [NSMutableArray array];
            }
            [_jobArray addObject:model];
        }
        
        [self.tableView reloadData];
    } failure:^(NSError *error) {
       // NSLog(@"相关视频%@",error);
    }];
    
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
        
   
      
        if (self.freeId  == 1) {

            [_cell.shareImage setImage:[UIImage imageNamed:@"share_icon"]];
           [_cell.shareVideoBtn setTitle:@"分享" forState:UIControlStateNormal];
            [_cell.shareVideoBtn addTarget:self action:@selector(shareVideoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            _cell.shareImage.hidden = YES;
            _cell.shareVideoBtn.hidden = YES;
        }
        

        [[NSUserDefaults standardUserDefaults] setObject:is_attention forKey:@"isAttention"];
        

        [_cell.collectionBtn addTarget:self action:@selector(collectionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        return _cell;
    }
    
    if (indexPath.section == 1) {
        VideoPayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"videoPayCell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor clearColor];
        [cell.purchaseBtn addTarget:self action:@selector(purchaseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        NSString *priceStr = [NSString stringWithFormat:@"%@",_dataDic[@"shop_price"]];
        if ([priceStr isEqualToString:@"0.00"]) {
             cell.shopPriceLabel.text = @"免费";
        }else{
           cell.shopPriceLabel.text = _dataDic[@"shop_price"];
        }
        
        NSString *payStatus = [NSString stringWithFormat:@"%@",_dataDic[@"pay_status"]];
        if ([payStatus isEqualToString:@"2"]) {
            [cell.purchaseBtn setTitle:@"已购买" forState:UIControlStateNormal];
            cell.textPriceLabel.hidden = YES;
            cell.shopPriceLabel.hidden = YES;
            
        }else {
            [cell.purchaseBtn setTitle:@"立即购买" forState:UIControlStateNormal];
            cell.textPriceLabel.hidden = NO;
            cell.shopPriceLabel.hidden = NO;
        }
        
        if ([_dataDic[@"shop_price"] isEqualToString:@"0.00"]) {
            cell.purchaseBtn.hidden = YES;
        }
        
        NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
        if ([user isEqualToString:@"1"]){
            NSString *vedioID = [[NSUserDefaults standardUserDefaults] objectForKey:@"vedioID"];
            if (vedioID != nil) {
                NSString *payStatus = [[NSUserDefaults standardUserDefaults] objectForKey:vedioID];
                if ([payStatus isEqualToString:@"2"]) {
                    [cell.purchaseBtn setTitle:@"已购买" forState:UIControlStateNormal];
                }
            }
        }
        
        return cell;
    }
    if (indexPath.section == 2) {
        VideoIntroduceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"videoIntroduceCell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor clearColor];
        cell.nameLabel.text = _dataDic[@"title"];
        
        cell.timeLabel.text = [NSString stringWithFormat:@"上传时间：%@",[self timeInterval:_dataDic[@"add_time"]]];
        if (![_dataDic[@"teacher"] isKindOfClass:[NSNull class]]) {
            cell.teacherLabel.text = [NSString stringWithFormat:@"讲师：%@",_dataDic[@"teacher"]];
        }
        if (![_dataDic[@"brief"] isKindOfClass:[NSNull class]]) {
            if (_dataDic[@"brief"] == nil) {
                cell.briefLabel.text = @"暂无简介";
            
            }else {
                cell.briefLabel.text = _dataDic[@"brief"];
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
        
        indexPath.row == _selectCell ? (cell.titleLabel.textColor =[UIColor orangeColor]) : (cell.titleLabel.textColor = [UIColor blackColor] );
        
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3) {
        _selectCell = (int)indexPath.row ;
        StudyModel *model = _jobArray[indexPath.row];
        [self getVideoDetail:model.modelID];
        
        RelatedVideoCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        cell.titleLabel.textColor = [UIColor orangeColor];
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


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc] init];
    header.frame = CGRectMake(0, 0, kScreenWidth, 0.01);
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
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

#pragma mark --- 视频收藏 ---
- (void)collectionBtnClick:(UIButton *)sender {
    
    NSUserDefaults *user = [[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];
    if (user == nil) {
        [AlertView(@"温馨提示!", @"请先登录。", @"确定", nil) show];
    }else {
        NSString *is_attention = [[NSUserDefaults standardUserDefaults] objectForKey:@"isAttention"];
        if ([is_attention isEqualToString:@"0"]) {
            _cell.collectionImage.image = [UIImage imageNamed:@"ic_light_star"];
            
            [self videoCollection];
            
        }else {
            _cell.collectionImage.image = [UIImage imageNamed:@"videoCollection"];
            [self cancelVideoCollection];
        }
    }
    
}


- (void)videoCollection {
    NSUserDefaults* user = [[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];
    if (user != nil) {
        NSString *str = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/collection"];
        NSDictionary *dic = @{
                              @"goods_id":_dataDic[@"id"],
                              @"uid":user,
                              };
        [HttpRequest postWithURLString:str parameters:dic success:^(id success) {
//            NSLog(@"收藏视频%@",success);
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isAttention"];
            
        } failure:^(NSError *error) {
//            NSLog(@"收藏视频%@",error);
        }];
    }
}

- (void)cancelVideoCollection {
    NSUserDefaults* user = [[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];
    if (user != nil) {
        NSLog(@"---=----%@",_model.modelID);
        NSString *str = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/uncollection"];
        NSDictionary *dic = @{
                              @"goods_id":_dataDic[@"id"],
                              @"uid":user,
                              };
        [HttpRequest postWithURLString:str parameters:dic success:^(id success) {
//            NSLog(@"收藏视频%@",success);
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"isAttention"];
        } failure:^(NSError *error) {
//            NSLog(@"收藏视频%@",error);
        }];
    }
}



//#pragma mark ---------- share分享视频
- (void)shareVideoBtnClick:(UIButton *)sender {
//  NSArray* imageArray = @[[UIImage imageNamed:@"iTunesArtwork.png"]];
//    //        （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
 

    NSString *strUrl = [NSString stringWithFormat:@"http://newapp.mingtaokeji.com/goods_share.php?id=%@",_vidID];
          NSString *imageUrl =  [NSString stringWithFormat:@"%@%@",skImageUrl,_dataDic[@"fist_img"]];
        NSArray* imageArray = [NSArray array];
    if ([_dataDic[@"fist_img"] isEqualToString:@""] || _dataDic[@"fist_img"] == nil) {
        imageArray = @[@"http://newapp.mingtaokeji.com/data/article/1520046328028079266.png"];
    }else {
        imageArray = @[imageUrl];
    }
    if (imageArray) {
    
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"分享内容 @value(url)"
                                         images:imageArray
                                            url:[NSURL URLWithString:strUrl]
                                          title:self.shareTitle
                                           type:SSDKContentTypeWebPage];
        //有的平台要客户端分享需要加此方法，例如微博
        [shareParams SSDKEnableUseClientShare];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                 items:nil
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           default:
                               break;
                       }
                   }
         ];
//    }
}
}
//
#pragma mark ------付费视频
- (void)purchaseBtnClick:(UIButton *)sender {
    
    NSString *payStatus = [[NSUserDefaults standardUserDefaults] objectForKey:@"pay_status"];
    if ([payStatus isEqualToString:@"2"]) {
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
    NSString * vedioID = [[NSUserDefaults standardUserDefaults] objectForKey:_dataDic[@"id"]];
    if ([vedioID isEqualToString:@"2"]) {
        [MBProgressHUD showMessage:@"已经购买过该视频！" toView:self.view delay:1.0];
    }else {
        NSString *moneyStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"userMoney"];
        NSString *shopPrice = _dataDic[@"shop_price"];
        NSInteger m = [moneyStr integerValue];
        
        NSInteger k = [shopPrice integerValue];
        
        if (m < k) {
            // [MBProgressHUD showMessage:@"余额不足，请先充值！" toView:self.view delay:1.0];
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
        }else {
            NSString *userMoney = [NSString stringWithFormat:@"%ld",m - k];
            [[NSUserDefaults standardUserDefaults] setObject:userMoney forKey:@"userMoney"];
            [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:_dataDic[@"id"]];
            [[NSUserDefaults standardUserDefaults] setObject:_dataDic[@"id"] forKey:@"vedioID"];

            VideoPayCell *purchaseBtn = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
            [purchaseBtn.purchaseBtn setTitle:@"已购买！" forState:UIControlStateNormal];
            
            [MBProgressHUD showMessage:@"购买成功，您可以观看该视频了！" toView:self.view delay:1.0];

        }
    }
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
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"payIS"];
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

//----------------------------------------

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    // push出下一级页面时候暂停
    if (self.player && !self.player.isPauseByUser) {
        self.isPlaying = YES;
        [self.player pauseVideo];
    }
    
    LMBrightnessViewShared.isStartPlay = NO;
    
    //横竖屏选择，在视图出现的时候，将allowRotate改为0，
    AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.allowRotation = 0;
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationPortrait;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}


#pragma mark - 添加子控件的约束
- (void)makePlayViewConstraints {
    
    if (kScreenWidth) {
        [self.playerFatherView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20);
            make.leading.trailing.mas_equalTo(0);
            // 这里宽高比16：9,可自定义宽高比
            make.height.mas_equalTo(self.playerFatherView.mas_width).multipliedBy(2.0f/3.0f);
        }];
    } else {
        [self.playerFatherView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20);
            make.leading.trailing.mas_equalTo(0);
            // 这里宽高比16：9,可自定义宽高比
            make.height.mas_equalTo(self.playerFatherView.mas_width).multipliedBy(9.0f/16.0f);
        }];
    }
    
    [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_offset(0);
    }];
    
 
}

#pragma mark - 屏幕旋转
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        [self.playerFatherView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(20);
        }];
        self.tableView.hidden = NO;
        
    }else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        
        [self.playerFatherView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset( - 10);
            make.height.mas_equalTo(self.playerFatherView.mas_width).multipliedBy(9.0f/15.50f);
            
        }];
        self.tableView.hidden = YES;
    }
}

// 只支持两个方向旋转
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait |UIInterfaceOrientationMaskLandscapeLeft |UIInterfaceOrientationMaskLandscapeRight;
}

#pragma mark - LMVideoPlayerDelegate
/** 返回按钮被点击 */
- (void)playerBackButtonClick {
        [self addLearningRecordsVideoTime];
 
    [self.player destroyVideo];
    [self.navigationController popViewControllerAnimated:YES];
}



/** 控制层封面点击事件的回调 */
- (void)controlViewTapAction {
    
    if (_player) {
        [self.player autoPlayTheVideo];
        self.isStartPlay = YES;
    }
}


#pragma mark - getter
- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] init];
    }
    return _topView;
}

- (UIView *)playerFatherView {
    if (!_playerFatherView) {
        _playerFatherView = [[UIView alloc] init];
    }
    return _playerFatherView;
}

- (LMPlayerModel *)playerModel {
    if (!_playerModel) {
        _playerModel = [[LMPlayerModel alloc] init];
    }
    return _playerModel;
}
#pragma mark --- 时间戳转换 ---
- (NSString *)timeInterval:(NSString *)getTime {
    NSTimeInterval time=[getTime doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate:detaildate];
    
    return currentDateStr;
}

//- (UIButton *)nextVideoBtn {
//    if (!_nextVideoBtn) {
//        _nextVideoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_nextVideoBtn setTitle:@"当前页播放新视频" forState:UIControlStateNormal];
//        _nextVideoBtn.backgroundColor = [UIColor redColor];
//        [_nextVideoBtn addTarget:self action:@selector(nextVideoBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _nextVideoBtn;
//}

//- (UIButton *)nextPageBtn {
//    if (!_nextPageBtn) {
//        _nextPageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_nextPageBtn setTitle:@"下一页" forState:UIControlStateNormal];
//        _nextPageBtn.backgroundColor = [UIColor redColor];
//        [_nextPageBtn addTarget:self action:@selector(nextPageBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _nextPageBtn;
//}

@end
