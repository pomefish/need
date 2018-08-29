//
//  CommentsCell.m
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2018/1/13.
//  Copyright © 2018年 ShangKe. All rights reserved.
//

#import "CommentsCell.h"

@implementation CommentsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)customCommentsCellModel:(CommentsModel* )model {
    self.nameLabel.text = model.nickname;
   // self.commentLabel.text = model.content;

     NSString *version = [UIDevice currentDevice].systemVersion;
    if (version.doubleValue == 9.0) {
       self.commentLabel.text  = [model.content stringByRemovingPercentEncoding];
    }else{
      self.commentLabel.text  = [model.content stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    if ([model.avatar isEqualToString:@""]) {
        [self.headImage setBackgroundImage:[UIImage imageNamed:@"tx"] forState:UIControlStateNormal];
    }else{
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",skBannerUrl,model.avatar]] ];
        UIImage *backImage = [UIImage imageWithData:data ];
        [self.headImage setBackgroundImage:backImage forState:UIControlStateNormal];
    }
    
  
    
    self.timeLabel.text = [PoolsTool timestamp:model.add_time];
    
    
}

//Unicode转化为汉字:

- (NSString *)replaceUnicode:(NSString *)unicodeStr {
    
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2]stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
}

+ (CGFloat)cellForHeight:(CommentsModel *)model {
    CGSize  retSize = [model.content boundingRectWithSize:CGSizeMake(kScreenWidth - 100, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    CGFloat contentHeight = retSize.height +10;
//    if (model.isHomeVC) {
//        contentHeight = (retSize.height) > 200 ? 200 : (retSize.height+10);
//    }
//    if (model.content.length  < 1) {
//        contentHeight = 0;
//    }
    
    return contentHeight +80;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
