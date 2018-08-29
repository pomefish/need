//
//  PlaybackViewController.m
//  mingtao
//
//  Created by Linlin Ge on 2017/11/6.
//  Copyright © 2017年 Linlin Ge. All rights reserved.
//

#import "PlaybackViewController.h"
#import "LMVideoPlayer.h"
#import "LMBrightnessView.h"

#import "Masonry.h"
#import "AppDelegate.h"
@interface PlaybackViewController ()<LMVideoPlayerDelegate>
/** 状态栏的背景 */
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) LMVideoPlayer *player;
@property (nonatomic, strong) UIView *playerFatherView;
@property (nonatomic, strong) LMPlayerModel *playerModel;

/** 离开页面时候是否在播放 */
@property (nonatomic, assign) BOOL isPlaying;
/** 离开页面时候是否开始过播放 */
@property (nonatomic, assign) BOOL isStartPlay;


/** 新视频按钮 */
//@property (nonatomic, strong) UIButton *nextVideoBtn;
/** 下一页 */
//@property (nonatomic, strong) UIButton *nextPageBtn;

@property (nonatomic, strong) NSDictionary *dataDic;
@property (nonatomic, assign) CGFloat contentHeight;


@property (nonatomic, strong) NSMutableArray *packageBrandArr;
@property (nonatomic, assign) BOOL isMoreData;

@property (nonatomic, strong) NSDictionary *PackageBrandDic;

@property (nonatomic, strong) NSMutableArray *categoryArr;
@property (nonatomic, strong) NSMutableArray *brandIDArr;

@property (nonatomic, copy) NSString *moneyNumber;
@property (nonatomic, copy) NSString *moneyName;

@property (nonatomic, copy) NSString *videoID;

@end

@implementation PlaybackViewController

- (void)dealloc {
    NSLog(@"---------------dealloc------------------");
    [self.player destroyVideo];
    
    //移除观察者，Observer不能为nil
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kCustomVCBackgroundColor;
    self.navigationController.navigationBar.hidden = YES;
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 300, 300, 60)];
//    label.backgroundColor = [UIColor redColor];
//    [self.view addSubview:label];
    self.isStartPlay = NO;
    //    [self.view addSubview:self.nextVideoBtn];
    //    [self.view addSubview:self.nextPageBtn];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.playerFatherView];
    
    [self makePlayViewConstraints];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    [self getVideoUrlRequestUrlID:_model.link_url];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"pay_status"];
}

#pragma mark -- 视频播放地址
- (void)getVideoUrlRequestUrlID:(NSString *)urlID {
    
    NSString *str = [NSString stringWithFormat:@"%@",urlID];
    NSString* encodedString = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    LMPlayerModel *model = [[LMPlayerModel alloc] init];
    model.videoURL = [NSURL URLWithString:encodedString];
    //        model.seekTime = 20;
    model.viewTime = 200;
    model.title = _model.title;
    model.placeholderImageURLString = [NSString stringWithFormat:@"%@%@",ImageURL,_model.image];
    LMVideoPlayer *player = [LMVideoPlayer videoPlayerWithView:self.playerFatherView delegate:self playerModel:model];
    self.player = player;
    
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
        
        self.playerFatherView.frame = CGRectMake(0, 0, kScreenWidth, kScreenWidth *9/16);
    } else {
        
        self.playerFatherView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    }
    
    [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_offset(0);
    }];
    
    //    [self.nextVideoBtn mas_updateConstraints:^(MASConstraintMaker *make) {
    //        make.centerX.mas_equalTo(self.view);
    //        make.bottom.mas_equalTo(self.view).offset(-130);
    //        make.height.mas_offset(30);
    //        make.width.mas_offset(150);
    //    }];
    
    //    [self.nextPageBtn mas_updateConstraints:^(MASConstraintMaker *make) {
    //        make.centerX.mas_equalTo(self.view);
    //        make.bottom.mas_equalTo(self.view).offset(-80);
    //        make.height.mas_offset(30);
    //        make.width.mas_offset(150);
    //    }];
}

#pragma mark - 屏幕旋转
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        self.playerFatherView.frame = CGRectMake(0, 0, kScreenWidth, kScreenWidth *9/16);
        
    }else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        
        self.playerFatherView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    }
}

// 只支持两个方向旋转
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait |UIInterfaceOrientationMaskLandscapeLeft |UIInterfaceOrientationMaskLandscapeRight;
}

#pragma mark - LMVideoPlayerDelegate
/** 返回按钮被点击 */
- (void)playerBackButtonClick {
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
        _topView.backgroundColor = [UIColor redColor];
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

//侧滑返回
- (void)willMoveToParentViewController:(UIViewController *)parent{
    [super willMoveToParentViewController:parent];
    NSLog(@"%s,%@",__FUNCTION__,parent);
    // push出下一级页面时候暂停
    if (self.player && !self.player.isPauseByUser) {
        self.isPlaying = YES;
        [self.player pauseVideo];
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
