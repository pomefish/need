//
//  VedioViewController.h
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2017/6/26.
//  Copyright © 2017年 ShangKe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudyModel.h"

@interface VedioViewController : UIViewController
@property (nonatomic, assign) BOOL pageTabBarIsStopOnTop;

@property (nonatomic, strong) StudyModel *model;

@end
