//
//  UILabel+Size.m
//  TimeCapsuleCompleteEdition
//
//  Created by kunpeng on 15/11/26.
//  Copyright © 2015年 liukunpeng. All rights reserved.
//

#import "UILabel+Size.h"

@implementation UILabel (Size)

- (CGSize)boundingRectWithSize:(CGSize)size {
    
    NSDictionary *attribute = @{NSFontAttributeName:self.font};
    CGSize retSize = [self.text boundingRectWithSize:size
                                             options:NSStringDrawingTruncatesLastVisibleLine|
                                                     NSStringDrawingUsesLineFragmentOrigin|
                                                     NSStringDrawingUsesFontLeading
                                          attributes:attribute
                                             context:nil].size;
    NSLog(@"计算高度了");
    return retSize;
}
@end
