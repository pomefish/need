//
//  MyNotesViewController.h
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2017/7/10.
//  Copyright © 2017年 ShangKe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyNotesViewController : UIViewController <UIScrollViewDelegate>
{
    NSArray  *_TitleAry;
    UIView   *_LineView;
    UIScrollView *_MeScroolView;
}

@property (nonatomic, strong) NSArray  *VCAry;

- (instancetype)initWithAddVCARY:(NSArray*)VCS TitleS:(NSArray*)TitleS;


@end
