//
//  InviteViewController.m
//  mingtao
//
//  Created by Linlin Ge on 2016/12/14.
//  Copyright © 2016年 Linlin Ge. All rights reserved.
//

#import "InviteViewController.h"
#import "InviteCell.h"
#import "EnterpriseCentreCell.h"
#import "RewardRecordViewController.h"
#import "CustomAlertView.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDKUI.h>
#import "SGQRCode.h"//二维码
#import "TGWebViewController.h"
#import "ExchangeMoneyViewController.h"

@interface InviteViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSDictionary *dataDic;
@end

@implementation InviteViewController
- (UITableView *)tableView {
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
//        self.tableView =  [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,1.178 *kScreenWidth +100 +kScreenWidth/7.5 +kScreenWidth/7.5 ) style:UITableViewStyleGrouped];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.backgroundColor = kCustomColor(229, 236, 236);
        [self.tableView registerClass:[InviteCell class]  forCellReuseIdentifier:@"inviteCell"];
        
        [self.tableView registerNib:[UINib nibWithNibName:@"EnterpriseCentreCell" bundle:nil] forCellReuseIdentifier:@"enterpriseCentreCell"];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kCustomVCBackgroundColor;
    leftBarButton(@"returnImage");
    self.navigationController.navigationBar.barTintColor = kCustomNavColor;


    self.title = @"邀请好友";
    
    [self.view addSubview:self.tableView];
    NSString *invitationCode = [[NSUserDefaults standardUserDefaults] objectForKey:@"invitation_code"];
    NSString *string = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/newShare"];
    NSDictionary *userDic = @{
                              @"uid":USERID,
                              @"invitation_code":USERID
                              };
    [HttpRequest postWithURLString:string parameters:userDic success:^(id result) {
       NSLog(@"----分享----%@",result);
        _dataDic = result;
        
        [self.tableView reloadData];
    } failure:^(NSError *error) {
       // EPLog(@"----分享----%@",error);
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (indexPath.row == 0) {
        InviteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"inviteCell" forIndexPath:indexPath];
        
        [cell.invitationCodeBtn addTarget:self action:@selector(invitationCodeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.explainBtn  addTarget:self action:@selector(explainBtnClick:) forControlEvents:UIControlEventTouchUpInside];
  [cell.invitationCodeBgImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",skBannerUrl,_dataDic[@"image"]]] placeholderImage:[UIImage imageNamed:@"banner_default"]];
        [cell setupGenerate_Icon_QRCode:_dataDic[@"body"]];
        return cell;
    }else {
        EnterpriseCentreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"enterpriseCentreCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        switch (indexPath.row) {
            case 1:
                cell.redLabel.hidden = YES;

                cell.statusLabel.hidden = NO;
                cell.hadeImage.image = [UIImage imageNamed:@"reward_icon"];
                cell.nameLabel.text = @"邀请注册记录";
                if (![NSString cc_isNULLOrEmpty:_dataDic[@"count"]]) {
                    cell.statusLabel.text = [NSString stringWithFormat:@"已邀请%@人",_dataDic[@"count"]];
                }else {
                    cell.statusLabel.text = @"已邀请0人";
                }
                break;
//            case 2:
//                cell.hadeImage.image = [UIImage imageNamed:@"user_dynamic"];
//                cell.nameLabel.text = @"邀请消费注册记录";
//                break;
            case 2:
                cell.redLabel.hidden = YES;

                cell.hadeImage.image = [UIImage imageNamed:@"exchange_icon"];
                cell.nameLabel.text = @"兑换赏金";
                break;
            default:
                break;
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:{
            
        }
            break;
        case 1:{
           RewardRecordViewController *rewardRecordVC = [RewardRecordViewController new];

            [self.navigationController pushViewController:rewardRecordVC animated:YES];
        }
            break;

        case 2:{
            ExchangeMoneyViewController *exchangeRewardVC = [ExchangeMoneyViewController new];
            exchangeRewardVC.userMoney = _dataDic[@"user_money_y"];
            [self.navigationController pushViewController:exchangeRewardVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return  1.778 *kScreenWidth +64;//
        //return  616 +140-12 -25 +5;

    }else {
        return kScreenWidth / 7.5;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (0 == section) {
          UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.01)];
        return view;
    }
    UIView *viewbag = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    return viewbag;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.01)];
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (void)invitationCodeBtnClick:(UIButton *)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *shareAction = [UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self share];
        
    }];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"保存图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        //保存图片
        InviteCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [self saveImageToPhotos:cell.QRCodeImage.image];
        
    }];
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
    }];
    [alertController addAction:shareAction];
    [alertController addAction:yesAction];
    [alertController addAction:noAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

#pragma mark - - - 中间带有图标二维码生成
- (void)setupGenerate_Icon_QRCode:(NSString *)urlStr {
    
    CGFloat scale = 0.2;
    
    // 2、将最终合得的图片显示在UIImageView上
    InviteCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.QRCodeImage.image = [SGQRCodeGenerateManager generateWithLogoQRCodeData:urlStr logoImageName:@"personalLogo" logoScaleToSuperView:scale];
    
}
//实现该方法
- (void)saveImageToPhotos:(UIImage*)savedImage {
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    //因为需要知道该操作的完成情况，即保存成功与否，所以此处需要一个回调方法image:didFinishSavingWithError:contextInfo:
}

//回调方法
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:msg message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
    }];
    [alertController addAction:noAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)explainBtnClick:(UIButton *)sender {
    TGWebViewController *web = [[TGWebViewController alloc] init];
    web.url = _dataDic[@"url"];
    web.webTitle = @"APP使用说明";
    [self.navigationController pushViewController:web animated:NO];
}

- (void)share {
    //1、创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray   *imageArray = @[logo];
    if (imageArray)
    {
//        NSString *str = [NSString stringWithFormat:@"http://xueyuan.mingtaokeji.com/epin.htm"];
        //邀请码
        //NSString  *invitationCode = [[NSUserDefaults standardUserDefaults] objectForKey:@"invitation_code"];
        [shareParams SSDKSetupShareParamsByText:[NSString stringWithFormat:@"%@",_dataDic[@"info"]]
                                         images:imageArray
                                            url:[NSURL URLWithString:_dataDic[@"body"]]
                                          title:[NSString stringWithFormat:@"%@",_dataDic[@"title"]]
                                           type:SSDKContentTypeWebPage];
    }
    
    //2、分享
    [ShareSDK showShareActionSheet:nil
                             items:nil
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   
                   switch (state)
                   {
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
                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@", error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"确定"
                                                                     otherButtonTitles:nil];
                           [alertView show];
                           break;
                       }
                           
                       default:
                           break;
                   }
               }];

}

- (void)leftButton:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
   self.navigationController.navigationBar.barTintColor = kCustomNavColor;

    [self.navigationController.navigationBar setTitleTextAttributes: @{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]}];
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
