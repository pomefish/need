//
//  WebviewProgressLine.h
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2017/7/11.
//  Copyright © 2017年 ShangKe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebviewProgressLine : UIView
@property (nonatomic, assign) CGFloat width;

//进度条颜色
@property (nonatomic,strong) UIColor  *lineColor;

//开始加载
-(void)startLoadingAnimation;

//结束加载
-(void)endLoadingAnimation;

@end
