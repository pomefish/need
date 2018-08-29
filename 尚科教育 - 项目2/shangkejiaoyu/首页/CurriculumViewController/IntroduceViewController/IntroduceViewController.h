//
//  IntroduceViewController.h
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2017/6/19.
//  Copyright © 2017年 ShangKe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntroduceViewController : UIViewController
@property (nonatomic, copy) NSString *catID;
@property (nonatomic, copy) NSString *titleText;

//标记从哪个页面跳转过来的，请求不同的接口数据
@property (nonatomic,assign)NSInteger tagId;
//从哪免费页面跳转过来的标记一下，请求不同的接口数据
@property (nonatomic,assign)NSInteger freeID;


@end
