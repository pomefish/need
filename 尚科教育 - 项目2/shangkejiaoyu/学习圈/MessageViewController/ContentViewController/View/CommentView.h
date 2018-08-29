//
//  CommentView.h
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2018/1/13.
//  Copyright © 2018年 ShangKe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentView : UIView
@property (weak, nonatomic) IBOutlet UITextField *commentTF;
@property (weak, nonatomic) IBOutlet UIButton *collectionButton;
@property (weak, nonatomic) IBOutlet UIButton *forwardButton;
- (instancetype)initWithFrame:(CGRect)frame;

@end
