//
//  StudyRecordCell.m
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2017/6/22.
//  Copyright © 2017年 ShangKe. All rights reserved.
//

#import "StudyRecordCell.h"

@implementation StudyRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configureCellDataModel:(StudyModel *)model {
    if (![model.teacher isKindOfClass:[NSNull class]]) {
        self.describeLabel.text = model.teacher;
    }
    if (![model.title isKindOfClass:[NSNull class]]) {
        self.titleLabel.text = model.title;
    }
    if (![model.add_time isKindOfClass:[NSNull class]]) {
        self.timeLabel.text = @"";
        
//        self.timeLabel.text = [self timeInterval:model.add_time];
        NSString *str = [NSString stringWithFormat:@"%@%@",skImageUrl,model.fist_img];
        [self.videoImage sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:loadingImage];

    }
}

- (NSString *)timeInterval:(NSString *)getTime {
    NSTimeInterval time=[getTime doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateStr = [dateFormatter stringFromDate:detaildate];
    
    return currentDateStr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
