//
//  rateView.h
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2018/8/9.
//  Copyright © 2018年 ShangKe. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PlayRateButtonDelegate <NSObject>

- (void)playButtonDelegateWithTag:(NSInteger)tag;

@end
@interface rateView : UIView
@property (nonatomic,weak) id <PlayRateButtonDelegate> delegate;
@end
