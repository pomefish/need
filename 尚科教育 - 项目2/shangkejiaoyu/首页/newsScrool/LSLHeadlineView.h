//
//  LSLHeadlineView.h
//  仿淘宝
//
//  Created by it001 on 17/3/31.
//  Copyright © 2017年 it001. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol LSLHeadlineViewDelegate <NSObject>

- (void)selectBtnWithIndex:(NSInteger)index;

@end



@interface LSLHeadlineView : UIView

@property (strong, nonatomic) NSArray *images;


@property (weak, nonatomic, readonly) UIPageControl *pageControl;


@property (assign, nonatomic, getter=isScrollDirectionPortrait) BOOL scrollDirectionPortrait;

@property (assign, nonatomic) id<LSLHeadlineViewDelegate>delegate;

@end
