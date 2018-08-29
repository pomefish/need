//
//  ScanImage.h
//  mingtao
//
//  Created by Linlin Ge on 2016/12/13.
//  Copyright © 2016年 Linlin Ge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ScanImage : NSObject
/**
 *  浏览大图
 *
 *  @param scanImageView 图片所在的imageView
 */
+(void)scanBigImageWithImageView:(UIImageView *)currentImageview;

@end
