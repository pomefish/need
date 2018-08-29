//
//  TGHeader.h
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2017/6/14.
//  Copyright © 2017年 ShangKe. All rights reserved.
//

#ifndef TGHeader_h
#define TGHeader_h
/********************************
 *屏幕的宽高＊
 *********************************/
//屏幕的宽度

#define KMainW  ([UIScreen mainScreen].bounds.size.width)

#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)
//屏幕的高度
//#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)

//self的宽度
#define kWidth   self.frame.size.width
//self的高度
#define kHeight  self.frame.size.height

//导航栏高度
//#define kNavHeight 64
//tabBar的高度
#define kTabHeight  ([[UIApplication sharedApplication] statusBarFrame].size.height > 20?83:49)

#define SKLog(...) printf("[%s] %s [第%d行]: %s\n", __TIME__ ,__PRETTY_FUNCTION__ ,__LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String])

#define iOS7 [[[UIDevice currentDevice] systemVersion] floatValue]

#define logo [UIImage imageNamed:@"iTunesArtwork"]
#define CompanyLogo [UIImage imageNamed:@"company"]

#define USERID  [[NSUserDefaults standardUserDefaults]objectForKey:@"userID"]

#define TOKEN [[NSUserDefaults standardUserDefaults]objectForKey:@"token"]
//加载中图片
#define loadingImage [UIImage imageNamed:@"loading"]

/**********************/
#define TitleSize [data.title boundingRectWithSize:CGSizeMake(KMainW - 10, MAXFLOAT) options: NSStringDrawingUsesLineFragmentOrigin|    NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size
/*******************************
 *自定义颜色*
 *********************************/
#define kCustomColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:0.9]
/******************************
 *headView*
 *********************************/
//主题颜色
//#define kCustomViewColor [UIColor colorWithRed:234.0/255.0 green:147.0/255.0 blue:23.0/255.0 alpha:1.0]
//e1172f
#define kCustomViewColor [UIColor colorWithRed:225.0/255.0 green:23.0/255.0 blue:47.0/255.0 alpha:1.0]
//辅助色
#define kCustomNavColor [UIColor colorWithRed:51.0/255.0 green:57.0/255.0 blue:73.0/255.0 alpha:1.0]

//页面背景颜色
#define kCustomVCBackgroundColor [UIColor colorWithRed:234.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0]

#define kCustomBttonColor [UIColor colorWithRed:64.0/255.0 green:150.0/255.0 blue:255.0/255.0 alpha:1.0]

#define kCustomlightGrayColor [UIColor colorWithRed:201.0/255.0 green:201.0/255.0 blue:201.0/255.0 alpha:1.0]


#define kCustomGreenColor [UIColor colorWithRed:0/255.0 green:179.0/255.0 blue:138/255.0 alpha:1.0]

#define kCustomOrangeColor [UIColor colorWithRed:255.0/255.0 green:155.0/255.0 blue:0/255.0 alpha:1.0]

/******************************
 *小弹框*
 *******************************/
#define AlertView(title,msg,cancelBtTitle,otherBtTitle) [[UIAlertView alloc]initWithTitle:title message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:cancelBtTitle,otherBtTitle, nil]

/******************************
 *UIBarButtonItem*
 *******************************/
#define leftBarButton(imageName) UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:imageName] style:UIBarButtonItemStylePlain target:self action:@selector(leftButton:)];\
leftButton.tintColor = [UIColor whiteColor];\
self.navigationItem.leftBarButtonItem = leftButton;

#define rightBarButton(imageName) UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:imageName] style:UIBarButtonItemStylePlain target:self action:@selector(rightButton:)];\
rightButton.tintColor = [UIColor whiteColor];\
self.navigationItem.rightBarButtonItem = rightButton;


#define SKUserDefaults [NSUserDefaults standardUserDefaults]

// iPhone X 2436 * 1125
#define IPHONEX ([UIScreen instancesRespondToSelector:@selector(currentMode)]  ? CGSizeEqualToSize([UIScreen mainScreen].currentMode.size, CGSizeMake(1125,2436)) : NO)

//是iPhone x  的话底部就留白34
#define kScreenHeight  (IPHONEX ? [UIScreen mainScreen].bounds.size.height - 34.0 : [UIScreen mainScreen].bounds.size.height)

//状态栏高度，
#define SYSTEM_STATUSHEIGHT ([[UIApplication sharedApplication] statusBarFrame].size.height)

//导航栏
#define SYSTEM_NAVHEIGHT (self.navigationController.navigationBar.frame.size.height == 0 ? 44 : self.navigationController.navigationBar.frame.size.height)

//导航栏高度 + 状态栏高度
#define kNavHeight  (SYSTEM_STATUSHEIGHT + 44)

#endif /* TGHeader_h */
