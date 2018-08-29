//
//  QuesDetailView.h
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2018/4/1.
//  Copyright © 2018年 ShangKe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuesDetailView : UIView
@property (nonatomic,strong)UILabel *queaTypeLabel;
@property (nonatomic,strong)UILabel *queaTitleLabel;
@property (nonatomic,strong)UIButton *queaSelABtn;
@property (nonatomic,strong)UIButton *queaSelBBtn;
@property (nonatomic,strong)UIButton *queaSelCBtn;
@property (nonatomic,strong)UIButton *queaSelDBtn;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
