//
//  LiveView.h
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2017/11/17.
//  Copyright © 2017年 ShangKe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LiveView : UIView

@property (strong, nonatomic) UIViewController  *viewController;
@property (strong, nonatomic) UIView            *segmentView;
/**
 滑块按钮
 
 @param frame selfFrame
 @param segmentViewHeight 按钮高度
 @param titleArray 按钮名
 @param controller 主控住器
 @param lineW 选中条宽度
 @param lineH 选中条高度
 @parma buttonY button高度
 @return self
 */
- (instancetype)initWithFrame:(CGRect)frame
            SegmentViewHeight:(CGFloat)segmentViewHeight
                   titleArray:(NSArray *)titleArray
                   Controller:(UIViewController *)controller
                    lineWidth:(float)lineW
                   lineHeight:(float)lineH
                      buttonY:(float)buttonY;

@end
