//
//  LSLHotView.m
//  仿淘宝
//
//  Created by it001 on 17/3/31.
//  Copyright © 2017年 it001. All rights reserved.
//

#import "LSLHotView.h"

@interface LSLHotView ()

@property (weak, nonatomic) IBOutlet UILabel *MarkLabelOne;
@property (weak, nonatomic) IBOutlet UILabel *FirstLabel;

@property (weak, nonatomic) IBOutlet UILabel *MarlSeconrLabel;
@property (weak, nonatomic) IBOutlet UILabel *SecondLabel;

@end

@implementation LSLHotView

+ (instancetype)lslHotView {
    
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.MarkLabelOne.layer.borderWidth = 1.0;
//    self.MarkLabelOne.layer.borderColor = [UIColor redColor].CGColor;
//    self.MarlSeconrLabel.layer.borderWidth = 1.0;
//    self.MarlSeconrLabel.layer.borderColor = [UIColor redColor].CGColor;
//    self.MarlSeconrLabel.layer.cornerRadius = 2;
//    self.MarkLabelOne.layer.cornerRadius = 2;
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    
    return self;
}

- (void)setDic:(NSDictionary *)dic {
    _dic = dic;
    
    self.MarkLabelOne.text = dic[@"label1"];
    self.FirstLabel.text = dic[@"label2"];
    self.MarlSeconrLabel.text = dic[@"label3"];
    self.SecondLabel.text = dic[@"label4"];
    ;
    self.FirstLabel.textColor = kCustomNavColor;
    self.FirstLabel.font = [UIFont systemFontOfSize:14];
    self.SecondLabel.textColor = kCustomNavColor;
    self.SecondLabel.font = [UIFont systemFontOfSize:14];
}

@end
