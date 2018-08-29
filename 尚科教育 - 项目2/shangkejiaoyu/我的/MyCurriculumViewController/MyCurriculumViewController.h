//
//  MyCurriculumViewController.h
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2017/6/21.
//  Copyright © 2017年 ShangKe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCurriculumViewController : UIViewController <UIScrollViewDelegate>
{
    NSArray  *_TitleAry;
    UIView   *_LineView;
    UIScrollView *_MeScroolView;
}

@property (nonatomic, strong) NSArray  *VCAry;

- (instancetype)initWithAddVCARY:(NSArray*)VCS TitleS:(NSArray*)TitleS;


@end
