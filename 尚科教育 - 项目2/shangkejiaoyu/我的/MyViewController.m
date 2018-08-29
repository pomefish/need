//
//  MyViewController.m
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2017/6/15.
//  Copyright © 2017年 ShangKe. All rights reserved.
//

#import "MyViewController.h"
#import "LogonViewController.h"
#import "UIButton+WebCache.h"
#import "EnterpriseCentreCell.h"
#import "UIImageView+WebCache.h"
#import "UINavigationBar+PS.h"
#import "UIView+PS.h"

#import "InformationViewController.h"
#import "RechargeViewController.h"
#import "SettingViewController.h"
#import "MyCurriculumViewController.h"

#import "MyNotesViewController.h"
#import "StudyRecordViewController.h"
#import "MyCollectionViewController.h"

#import "PurchaseCurriculumViewController.h"
#import "PurchaseVedioViewController.h"

#import "TeachingViewController.h"
#import "InviteViewController.h"
#define WeakSelf(x)      __weak typeof (self) x = self

#define HalfF(x) ((x)/2.0f)

#define  Statur_HEIGHT   [[UIApplication sharedApplication] statusBarFrame].size.height
#define  NAVIBAR_HEIGHT  (self.navigationController.navigationBar.frame.size.height)
#define  INVALID_VIEW_HEIGHT (Statur_HEIGHT + NAVIBAR_HEIGHT)

@interface MyViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate> {
    CGFloat _lastPosition;
}
@property (nonatomic, strong) UITableView *tableView;
//@property (nonatomic, strong) SDZoomHeaderView *headerView;

//@property (nonatomic, strong) UIView       *bottomView;
@property (nonatomic, strong) UIScrollView *baseScrollView;
@property (nonatomic, strong) NSString           *resume;
@property (nonatomic, strong) NSDictionary       *dataDic;


@property (nonatomic, strong) UIButton      *headBackBtn;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel     *messageLabel;
@property (nonatomic, strong) UILabel     *nameLabel;

@property (nonatomic, copy) NSString *userMoney;
@property (nonatomic,copy)  NSString *tag;

@end

@implementation MyViewController

- (UIButton*)headBackBtn {
    if (!_headBackBtn) {
        _headBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_headBackBtn addTarget:self action:@selector(headBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _headBackBtn.userInteractionEnabled = YES;
        _headBackBtn.frame = CGRectMake(0, 0, kScreenWidth,kScreenHeight / 4);
    }
    return _headBackBtn;
}

- (UIImageView*)headImageView {
    if (!_headImageView) {
        _headImageView = [UIImageView new];
        _headImageView.image = [UIImage imageNamed:@"backgroundImage0.jpg"];
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headImageView.clipsToBounds = YES;
        _headImageView.backgroundColor = [UIColor orangeColor];
    }
    return _headImageView;
}

- (UIImageView*)avatarView {
    if (!_avatarView) {
        _avatarView = [UIImageView new];
        _avatarView.image = [UIImage imageNamed:@"tx"];
        _avatarView.contentMode = UIViewContentModeScaleToFill;
        _avatarView.size = CGSizeMake(80, 80);
//        [_avatarView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"tx"]];
        [_avatarView setLayerWithCr:_avatarView.width / 2];
    }
    return _avatarView;
}

- (UILabel*)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = [UIFont systemFontOfSize:18];
        _nameLabel.textColor = [UIColor whiteColor];
//        _nameLabel.text = @"请设置名字。";
    }
    return _nameLabel;
}

- (UILabel*)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [UILabel new];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.font = [UIFont systemFontOfSize:15];
        _messageLabel.textColor = [UIColor whiteColor];
        _messageLabel.text = @"点击设置基本信息。";
    }
    return _messageLabel;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.tableFooterView = [[UIView alloc]init];
        
        self.tableView.backgroundColor = kCustomColor(229, 236, 236);
        self.tableView.showsVerticalScrollIndicator = NO;
        
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [self.tableView registerNib:[UINib nibWithNibName:@"EnterpriseCentreCell" bundle:nil] forCellReuseIdentifier:@"EnterpriseCentreCell"];
    }
    
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tag = @"1";
    if ([self.tag isEqualToString:@"1"]) {
        self.tabBarItem.badgeValue=[NSString stringWithFormat:@""];
    }
    [self resetHeaderView];
    self.view.backgroundColor = kCustomColor(229, 236, 236);
    self.tableView.tableHeaderView = self.headBackBtn;
    [self.view addSubview:self.tableView];
    
    //导航
    [self.navigationController.navigationBar ps_setBackgroundColor:[UIColor clearColor]];
    
    rightBarButton(@"setting");
    self.navigationItem.title = @" ";
    
    [self.view addSubview:self.tableView];
    
}

- (void)resetHeaderView {
    self.headImageView.frame = self.headBackBtn.bounds;
    [self.headBackBtn addSubview:self.headImageView];
    
    self.avatarView.centerX = self.headBackBtn.centerX;
    self.avatarView.centerY = self.headBackBtn.centerY -  HalfF(100);
    [self.headBackBtn addSubview:self.avatarView];
    
    self.messageLabel.y = CGRectGetMaxY(self.avatarView.frame) + HalfF(100);
    self.messageLabel.size = CGSizeMake(kScreenWidth - HalfF(30), 20);
    self.messageLabel.centerX = self.headBackBtn.centerX;
    [self.headBackBtn addSubview:self.messageLabel];
    
    //    self.nameLabel.frame = CGRectMake(CGRectGetMaxY(self.avatarView.frame) + HalfF(30),kScreenWidth/2 - 100, 200, 20);
    self.nameLabel.y = CGRectGetMaxY(self.avatarView.frame) + HalfF(40);
    self.nameLabel.size = CGSizeMake(kScreenWidth - HalfF(30), 30);
    self.nameLabel.centerX = self.headBackBtn.centerX;
    
    [self.headBackBtn addSubview:self.nameLabel];
    
}

#pragma mark --- 查看个人信息 ---
- (void)getViewResumeRequest {
    NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
    if (user != nil) {
        
    NSString *string = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/user_detail"];
    NSDictionary *dic = @{
                          @"uid":user
                          };
    [HttpRequest postWithURLString:string parameters:dic success:^(id result) {
        NSLog(@"----=查看个人信息-----%@",result);
        _resume = result[@"msg"];
        _dataDic = result[@"body"];
        [_avatarView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",skBannerUrl,_dataDic[@"avatar"]]] placeholderImage:[UIImage imageNamed:@"tx.png"]];
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@%@",skBannerUrl,_dataDic[@"avatar"]] forKey:@"avatar"];
        if ([user isEqualToString:@"1"]) {
            _nameLabel.text = @"游客状态！";
        }else {
            if (_dataDic[@"nickname"] != nil) {
                _nameLabel.text = _dataDic[@"nickname"];
                
// [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@@%@",_dataDic[@"name"], _dataDic[@"work_type"]] forKey:@"nickname"];
                
            }else {
                _nameLabel.text = @"点击设置基本信息！";
            }

        }
        
        _messageLabel.text = _dataDic[@"remark"];
        
        [self.tableView reloadData];
    } failure:^(NSError *NSError) {
//        NSLog(@"查看个人信息%@",NSError);
    }];
    }
}

#pragma mark --- 区数量 ---
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1 ) {
        return 2;
    }
    if (section == 2 ) {
        return 2;
    }
    if (section == 3) {
        return 1;
    }
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 0.0f;
    }
    return 45.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return 0.01;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0 || section == 1) {
        UIView *header = [[UIView alloc] init];
        header.frame = CGRectMake(0, 0, kScreenWidth, 0.01);
        return header;
        
    }
    UIView *header = [[UIView alloc] init];
    header.frame = CGRectMake(0, 0, kScreenWidth, 10);
    
    return header;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *header = [[UIView alloc] init];
    header.frame = CGRectMake(0, 0, kScreenWidth, 0.01);
    return header;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        return cell;
    }else {
        EnterpriseCentreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EnterpriseCentreCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        switch (indexPath.section) {
            case 1:
                if (indexPath.row == 0) {
                    if (_userMoney != nil) {
                        NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ 学习币",_userMoney]];
                        //获取要调整颜色的文字位置,调整颜色
                        NSRange range1=[[hintString string]rangeOfString:[NSString stringWithFormat:@"%@",_userMoney]];
//                        [hintString addAttribute:NSForegroundColorAttributeName value:kCustomColor(255, 155, 0) range:range1];
                          [hintString addAttribute:NSForegroundColorAttributeName value:kCustomViewColor range:range1];
                        cell.nameLabel.attributedText = hintString;
                    }else {
                        NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"0 学习币"]];
                        //获取要调整颜色的文字位置,调整颜色
                        NSRange range1=[[hintString string]rangeOfString:[NSString stringWithFormat:@"0"]];
//                        [hintString addAttribute:NSForegroundColorAttributeName value:kCustomColor(255, 155, 0) range:range1];
                          [hintString addAttribute:NSForegroundColorAttributeName value:kCustomViewColor range:range1];
                        cell.nameLabel.attributedText = hintString;

                    }
                    
                    NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
                    if ([user isEqualToString:@"1"]) {
                        NSString *userMoney = [[NSUserDefaults standardUserDefaults] objectForKey:@"userMoney"];
                        if (userMoney != nil) {
                            NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ 学习币",userMoney]];
                            //获取要调整颜色的文字位置,调整颜色
                            NSRange range1=[[hintString string]rangeOfString:[NSString stringWithFormat:@"%@",userMoney]];
//                            [hintString addAttribute:NSForegroundColorAttributeName value:kCustomColor(255, 155, 0) range:range1];
                            [hintString addAttribute:NSForegroundColorAttributeName value:kCustomViewColor range:range1];
                            cell.nameLabel.attributedText = hintString;
                        }
                    }
                    
                    //                    cell.statusLabel.frame = CGRectMake(kScreenWidth - 80, 10, 40, 40);
                    cell.nameLeftConstraint.constant = -15;
                    cell.statusLabel.textColor = [UIColor whiteColor];
                    cell.statusLabel.font = [UIFont systemFontOfSize:12];
                    cell.statusWidthConstraint.constant = 60;
                    cell.statusLabel.textAlignment = NSTextAlignmentCenter;
                    cell.statusLabel.clipsToBounds = YES;
                    cell.statusLabel.layer.cornerRadius = 2;
                    cell.statusLabel.text = @"充值";
//                    cell.statusLabel.backgroundColor = kCustomColor(255, 155, 0);
                    cell.statusLabel.backgroundColor = kCustomViewColor;
                    cell.statusLabel.hidden = NO;
                    cell.redLabel.hidden = YES;
                }
                if (indexPath.row == 1) {
                    if ([self.tag isEqualToString:@"1"]) {
                        cell.redLabel.hidden = NO;
                    }else{
                        cell.redLabel.hidden = YES;

                    }
                    cell.statusLabel.hidden = NO;
                    cell.hadeImage.image = [UIImage imageNamed:@"record_icon"];
                    cell.nameLabel.text = @"邀请好友";
                    cell.statusLabel.text = @"高额赏金等您拿";
                    cell.lineView.hidden = YES;

                }
                break;
            case 2:
                cell.redLabel.hidden = YES;

                if (indexPath.row == 0) {
                    cell.hadeImage.image = [UIImage imageNamed:@"user_notes"];
                    cell.nameLabel.text = @"学习记录";
                }
                if (indexPath.row == 1) {
                    cell.hadeImage.image = [UIImage imageNamed:@"user_dynamic"];
                    cell.nameLabel.text = @"我的课程";
                }
                break;
            case 3:
                cell.redLabel.hidden = YES;

                if (indexPath.row == 0) {
                    cell.hadeImage.image = [UIImage imageNamed:@"user_teaching"];
                    cell.nameLabel.text = @"教学服务";
                }

                break;
            default:
                break;
        }
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 1:
            if (indexPath.row == 0) {
                RechargeViewController *rechargeVC = [RechargeViewController new];
                rechargeVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:rechargeVC animated:YES];
            }
            if (indexPath.row == 1) {
                
                InviteViewController *inviteVC = [InviteViewController new];
                inviteVC.hidesBottomBarWhenPushed  = YES;
                [self.navigationController pushViewController:inviteVC animated:YES];
                
            }
            break;
        case 2:
            
            if (indexPath.row == 0) {
                
                MyNotesViewController *myNotesVC = [[MyNotesViewController alloc] initWithAddVCARY:@[[StudyRecordViewController new],[MyCollectionViewController new]]TitleS:@[@"最近学习", @"我的收藏"]];
                myNotesVC.navigationController.navigationBar.barTintColor = kCustomViewColor;
                myNotesVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:myNotesVC animated:YES];
            }
            if (indexPath.row == 1) {
                MyCurriculumViewController *myCurriculumVC = [[MyCurriculumViewController alloc]initWithAddVCARY:@[[PurchaseCurriculumViewController new],[PurchaseVedioViewController new]]TitleS:@[@"已购课程", @"已购视频"]];
                myCurriculumVC.navigationController.navigationBar.barTintColor = kCustomViewColor;
                myCurriculumVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:myCurriculumVC animated:YES];
            }
            
            break;
        case 3:
            if (indexPath.row == 0) {
                TeachingViewController *teachingVC = [TeachingViewController new];
                teachingVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:teachingVC animated:YES];
                
            }
//            if (indexPath.row == 1) {
//
//                    InviteViewController *inviteVC = [InviteViewController new];
//                    inviteVC.hidesBottomBarWhenPushed  = YES;
//                    [self.navigationController pushViewController:inviteVC animated:YES];
//
//            }
            break;
        default:
            break;
            
    }
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offset_Y = scrollView.contentOffset.y;
    
    //    NSLog(@"上下偏移量 OffsetY:%f ->",offset_Y);
    
    //1.处理图片放大
    CGFloat imageH = self.headBackBtn.size.height;
    CGFloat imageW = kScreenWidth;
    
    //下拉
    if (offset_Y < 0)
    {
        CGFloat totalOffset = imageH + ABS(offset_Y);
        CGFloat f = totalOffset / imageH;
        
        //如果想下拉固定头部视图不动，y和h 是要等比都设置。如不需要则y可为0
        self.headImageView.frame = CGRectMake(-(imageW * f - imageW) * 0.5, offset_Y, imageW * f, totalOffset);
    }
    else
    {
        self.headImageView.frame = self.headBackBtn.bounds;
    }
    
    //2.处理导航颜色渐变  3.底部工具栏动画
    
    if (offset_Y > 50) {
        CGFloat alpha = MIN(1, 1 - ((50 + INVALID_VIEW_HEIGHT - offset_Y) / INVALID_VIEW_HEIGHT));
        
        //        [self.navigationController.navigationBar ps_setBackgroundColor:[kCustomViewColor colorWithAlphaComponent:alpha]];
        
        if (offset_Y - _lastPosition > 5) {
            //向上滚动
            _lastPosition = offset_Y;
            
        }else if (_lastPosition - offset_Y > 5) {
            // 向下滚动
            _lastPosition = offset_Y;
        }
       // self.title = alpha > 0.8? @"":@"";
    }else {
        //        [self.navigationController.navigationBar ps_setBackgroundColor:[kCustomViewColor colorWithAlphaComponent:0]];
    }
    
}

- (void)rightButton:(UIButton *)sender {
    NSLog(@"rightButton");

    SettingViewController *settingVC = [SettingViewController new];
    settingVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:settingVC animated:YES];
}

- (void)headBtnClick:(UIButton *)sender {
    NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
    if ([user isEqualToString:@"1"]) {
        [AlertView(@"温馨提示", @"您现在为游客状态，请先登录！", @"取消", @"去登录") show];
        
    }else {
        
    InformationViewController *informationVC = [InformationViewController new];
    informationVC.dataDic = _dataDic;
    informationVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:informationVC animated:YES];
    }
}

#pragma mark AlertView
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSLog(@"....");
        LogonViewController *logonVC = [LogonViewController new];
        UINavigationController *loginNav = [[UINavigationController alloc]initWithRootViewController:logonVC];
        //模态弹出  这里
        [self presentViewController:loginNav animated:YES completion:nil];
    }
}

//导航透明
- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    NSString * user= [[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];
    if (user != nil) {
        NSString *str = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/user_money"];
        NSDictionary *dic = @{
                              @"uid":user
                              };
        
        [HttpRequest postWithURLString:str parameters:dic success:^(id success) {
            NSLog(@"账户余额%@",success);
            _userMoney = success[@"user_money"];
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:1];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        } failure:^(NSError *error) {
//            NSLog(@"账户余额%@",error);
        }];
    }
    [self getViewResumeRequest];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.tag = @"0";
    self.tabBarItem.badgeValue = nil;
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setShadowImage:nil];

    self.navigationController.navigationBar.barTintColor = kCustomNavColor;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:16],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

@end
