//
//  VideoPlayViewController.m
//  LZHPlayer
//
//  Created by lzh on 16/8/9.
//  Copyright © 2016年 lzh. All rights reserved.
//

#import "XYVideoPlayerView.h"
#import "XYVideoModel.h"
#import "AppDelegate.h"

#import "Masonry.h"

#import "VideoPlayViewController.h"

#import "SDImageCache.h"

#import "PlayLiveIngViewController.h"
#import "VideoPlayPagerView.h"

#import "InteractionViewController.h"

#import "EaseRefreshTableViewController.h"

#import <IJKMediaFramework/IJKMediaFramework.h>

@interface VideoPlayViewController ()<XYVideoPlayerViewDelegate> {
    UIView *_headPlayerView;
}
@property (nonatomic, strong) VideoPlayPagerView *pagerView;


@property (weak, nonatomic) IBOutlet UIView *videoBackView;

/** 视频播放视图 */
@property (nonatomic, strong) XYVideoPlayerView *playerView;

@property(nonatomic, strong) id<IJKMediaPlayback>    player;

@end

@implementation VideoPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //横竖屏选择，在视图出现的时候，将allowRotate改为1，
    AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.allowRotation = 1;
    
    NSString *userPsw = [[NSUserDefaults standardUserDefaults] objectForKey:@"userPsw"];
    NSString *userPhone = [[NSUserDefaults standardUserDefaults] objectForKey:@"userPhone"];
    
    EMError *loginError = [[EMClient sharedClient] loginWithUsername:[NSString stringWithFormat:@"sk%@",userPhone] password:userPsw];
    if (!loginError) {
        SKLog(@"环信登录成功!");
    }else {
        SKLog(@"环信登录失败！");
    }
    [self setUI];
    [self getPersonalInformation];
}

- (void)getPersonalInformation {
    NSString * user= [[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];
    NSString *string = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/user_detail"];
    NSDictionary *userDic = @{
                              @"uid":user
                              };
    [HttpRequest postWithURLString:string parameters:userDic success:^(id result) {
//        NSLog(@"----=查看个人资料-----%@",result);
        
        [[NSUserDefaults standardUserDefaults] setObject:result[@"body"][@"nickname"] forKey:@"nickname"];
        [[NSUserDefaults standardUserDefaults] setObject:result[@"body"][@"user_rank"] forKey:@"type"];
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@%@",skBannerUrl,result[@"body"][@"avatar"]] forKey:@"avatar"];

    } failure:^(NSError *error) {
        NSLog(@"----=查看个人资料-----%@",error);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
      [self getPersonalInformation];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
//状态栏显示控制
- (BOOL)prefersStatusBarHidden {
    return YES;//隐藏为YES，显示为NO
}

- (void)setUI{
    // 创建视频播放控件
    
    self.playerView = [XYVideoPlayerView videoPlayerView];
    self.playerView.frame = CGRectMake(0, 0, kScreenWidth, kScreenWidth *9/16);
    self.playerView.backgroundColor = [UIColor clearColor];
    self.playerView.delegate = self;
    NSString *backImageUrl = [NSString stringWithFormat:@"%@%@",skBannerUrl,_model.zhibo_thumb];
    [self.playerView.backImage sd_setImageWithURL:[NSURL URLWithString:backImageUrl] placeholderImage:[UIImage imageNamed:@"loading"]];
    [self.view addSubview:self.playerView];
    self.playerView = self.playerView;
    
//    NSString *str = [NSString stringWithFormat:@"http://xueyuan.mingtaokeji.com/admin/video/20170907/运营/线上电商平台介绍.mp4"];
    NSString *str = [NSString stringWithFormat:@"%@",_model.flv];
    NSString* encodedString = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    XYVideoModel *model = [[XYVideoModel alloc]init];
    model.url = [NSURL URLWithString:encodedString];
    model.name = _model.zhibo_title;
    self.playerView.videoModel = model;
    //[self.playerView changeCurrentplayerItemWithVideoModel:model];
    
    [self addChildViewControllers];
    [self initLayoutPagerView];
    
}

- (void)addChildViewControllers{
    
    InteractionViewController *interactionVC = [InteractionViewController new];
    interactionVC.zhibo_id = _model.ID;
    [self addChildViewController:interactionVC];
    

}

- (void)initLayoutPagerView{
    _pagerView = [[VideoPlayPagerView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.playerView.frame) + 5, kScreenWidth, kScreenHeight / 1.48)
                                      SegmentViewHeight:50
                                             titleArray:@[@"主讲"]
                                             Controller:self
                                              lineWidth:kScreenWidth / 6.5
                                     lineHeight:0];
    
    [self.view addSubview:_pagerView];
    
}

#pragma mark - 屏幕旋转
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        self.playerView.frame = CGRectMake(0, 0, kScreenWidth, kScreenWidth *9/16);
        _pagerView.hidden = NO;
        
    }else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        
        self.playerView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        _pagerView.hidden = YES;
    }
}


#pragma mark XYVideoPlayerViewDelegate
- (void)fullScreenWithPlayerView:(XYVideoPlayerView *)videoPlayerView
{
    if (self.playerView.isRotate) {
        [UIView animateWithDuration:0.3 animations:^{
            _headPlayerView.transform = CGAffineTransformRotate(self.videoBackView.transform, M_PI_2);
            _headPlayerView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            self.playerView.frame = _headPlayerView.bounds;
            _pagerView.hidden = YES;

            
        }];
        
    }else{
        
        [UIView animateWithDuration:0.3 animations:^{
            _headPlayerView.transform = CGAffineTransformIdentity;
            _headPlayerView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width*9/16);
            self.playerView.frame = _headPlayerView.bounds;
            _pagerView.hidden = NO;

        }];
        
    }
}
- (void)backToBeforeVC{
    
    if (!self.playerView.isRotate) {
        //横竖屏选择，在视图出现的时候，将allowRotate改为0，
        AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        delegate.allowRotation = 0;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)dealloc{
    
    [self.playerView deallocPlayer];
}

// 只支持两个方向旋转
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait |UIInterfaceOrientationMaskLandscapeLeft |UIInterfaceOrientationMaskLandscapeRight;
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
