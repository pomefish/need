//
//  SharePopViewController.h
//  mingtao
//
//  Created by Linlin Ge on 2018/1/9.
//  Copyright © 2018年 Linlin Ge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SharePopViewController : UIViewController

@property (nonatomic, copy) void(^shareBtnBlock)(void);
@property (nonatomic, copy) void(^closeBtnBlock)(void);

@end
