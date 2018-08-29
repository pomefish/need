//
//  YDPopViewController.h
//  CCFrameDemo
//
//  Created by Clyde on 2017/12/8.
//  Copyright © 2017年 ChenLY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YDPopViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIButton *mainButton;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;

@property (nonatomic, copy) void (^mainButtonBlock)(void);
@property (nonatomic, copy) void (^closeButtonBlock)(void);

@property (nonatomic, assign) NSInteger typeInt;

@property (nonatomic, copy) NSString *activity_thumb;
@end
