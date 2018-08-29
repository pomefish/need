//
//  AreaViewController.h
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2018/3/26.
//  Copyright © 2018年 ShangKe. All rights reserved.
//
typedef void(^newBlock) (NSString *);

#import <UIKit/UIKit.h>
@interface AreaViewController : UIViewController
@property (nonatomic,assign)NSInteger flag;
@property (nonatomic,copy)NSString *frontText;//接收上一界面的地区名字

@property (nonatomic,copy)newBlock block;
- (void)text:(newBlock)block;
@end
