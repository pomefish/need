//
//  VedioPlayerViewController.h
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2017/7/20.
//  Copyright © 2017年 ShangKe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudyModel.h"

@interface VedioPlayerViewController : UIViewController

@property (nonatomic, strong) StudyModel *model;
@property (nonatomic,copy)NSString *shareTitle;
@property (nonatomic,copy)NSString *shareContent;

@property (nonatomic, strong) NSURL *shareURL;
@property (nonatomic,assign) NSInteger freeId;
@end
