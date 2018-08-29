//
//  HomeCell.h
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2018/1/12.
//  Copyright © 2018年 ShangKe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudyCustomView.h"
#import "LSLHeadlineView.h"
#import "LSLHotView.h"
#import "HttpRequest.h"
#import "SGAdvertScrollView.h"
@interface HomeCell : UICollectionViewCell<LSLHeadlineViewDelegate,SGAdvertScrollViewDelegate>

@property (nonatomic, strong) NSArray *catNameArray;
@property (nonatomic, strong) NSArray *catIdArray;
@property (nonatomic, strong) NSArray *imageArray;

@property (nonatomic, strong) StudyCustomView *dianshangBtn;
@property (nonatomic, strong) StudyCustomView *meigongBtn;
@property (nonatomic, strong) StudyCustomView *sumaitongBtn;
@property (nonatomic, strong) StudyCustomView *clickBtn;
@property (nonatomic, strong) StudyCustomView *taughtBtn;
@property (nonatomic,strong) LSLHeadlineView *headlineView;
@property (nonatomic,strong)UIImageView *leftView;
@property (nonatomic,copy)NSString *imageStr;
@property (nonatomic,strong)NSMutableArray *titleArr;
@property (nonatomic,strong)SGAdvertScrollView *advertScrollView2;
@property (nonatomic,strong) UIView *gunView;
- (void)homeCellUi:(NSArray *)arr;
- (void)setTitleArray:(NSMutableDictionary *)titleLabelDic;

@end
