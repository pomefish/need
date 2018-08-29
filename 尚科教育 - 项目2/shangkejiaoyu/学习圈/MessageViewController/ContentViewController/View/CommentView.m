//
//  CommentView.m
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2018/1/13.
//  Copyright © 2018年 ShangKe. All rights reserved.
//

#import "CommentView.h"

@implementation CommentView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    self = [[[NSBundle mainBundle] loadNibNamed:@"CommentView" owner:self options:nil] lastObject];
    if (self) {
        self.frame = frame;
        self.layer.borderWidth = 1;
        
        self.layer.borderColor = [kCustomlightGrayColor CGColor];
        _commentTF.returnKeyType = UIReturnKeySend;//变为发送按钮
        
        [_collectionButton addTarget:self action:@selector(collectionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)collectionButtonClick:(UIButton *)sender {
    if (sender.selected) {
        [sender setImage:[UIImage imageNamed:@"collectBtn2"] forState:UIControlStateNormal];
    }else {
        [sender setImage:[UIImage imageNamed:@"collectBtn1"] forState:UIControlStateNormal];
    }
    sender.selected = !sender.selected;

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
