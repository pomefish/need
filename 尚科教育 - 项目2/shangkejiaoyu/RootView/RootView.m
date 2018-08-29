//
//  RootView.m
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2017/6/15.
//  Copyright © 2017年 ShangKe. All rights reserved.
//

#import "RootView.h"
#import "HomeViewController.h"
#import "QuestionsViewController.h"
#import "LiveViewController.h"
#import "MyViewController.h"
#import "StudyCirclesViewController.h"

@implementation RootView

+ (void)logonRootView {
    
    UITabBarController *tabBar = [[UITabBarController alloc]init];
    [[UITabBar appearance] setTintColor:kCustomViewColor];
    
    // 字体颜色 选中
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0F], NSForegroundColorAttributeName : kCustomViewColor} forState:UIControlStateSelected];
    
    //字体颜色未选中
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:10.0F],  NSForegroundColorAttributeName:[UIColor colorWithRed:51.0/255.0 green:57.0/255.0 blue:73.0/255.0 alpha:1.0]} forState:UIControlStateNormal];
    //去掉tabBar黑线
//    tabBar.tabBar.backgroundImage = [UIImage imageNamed:@"tabBarImage"];
//    tabBar.tabBar.shadowImage = [[UIImage alloc]init];
    
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    [self middle:homeVC Titte:@"首页" showImage:@"home_ic" selectImage:@"ic_home"];
    UINavigationController *homeNav = [[UINavigationController alloc]initWithRootViewController:homeVC];
    
    StudyCirclesViewController *questionsVC = [[StudyCirclesViewController alloc] init];
    [self middle:questionsVC Titte:@"学习圈" showImage:@"ic_curriculum" selectImage:@"curriculum_ic"];
    UINavigationController *questionsNav = [[UINavigationController alloc]initWithRootViewController:questionsVC];
    
    LiveViewController *liveVC = [[LiveViewController alloc] init];
    [self middle:liveVC Titte:@"直播" showImage:@"live_ic" selectImage:@"ic_live"];
    UINavigationController *liveNav = [[UINavigationController alloc] initWithRootViewController:liveVC];
    
    MyViewController *myVC = [[MyViewController alloc] init];
    [self middle:myVC Titte:@"我的" showImage:@"my_ic" selectImage:@"ic_my"];
    
    UINavigationController *myNav = [[UINavigationController alloc]initWithRootViewController:myVC];
    

    tabBar.viewControllers = @[homeNav,questionsNav,liveNav,myNav];
    
    UIWindow *winder = [[[UIApplication sharedApplication]delegate]window];
    winder.rootViewController = tabBar;
    [winder makeKeyAndVisible];
    
}


//文字图片和选中图片
+ (void)middle:(UIViewController*)name Titte:(NSString*)tittle showImage:(NSString*)image selectImage:(NSString*)selectImage{
    
    name.title = tittle;
    name.tabBarItem.title = tittle;
//    name.tabBarItem.image = [UIImage imageNamed:image];
    name.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    name.tabBarItem.selectedImage = [UIImage imageNamed:selectImage];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
