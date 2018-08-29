//
//  TimetablesViewController.m
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2017/6/30.
//  Copyright © 2017年 ShangKe. All rights reserved.
//

#import "TimetablesViewController.h"
#import "TimetablesView.h"
#import "PYPhotosView.h"
#import "ScanImage.h"
#import "TimetablesCell.h"
#import "TimetablesDetailsViewController.h"
#import "JFPictureBrowserView.h"

#import "MessageModel.h"
#import "ContentViewController.h"

@interface TimetablesViewController () <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource ,JFPictureBrowserViewDelegate>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *tableArr;


@property (nonatomic, strong) UIScrollView *mainScroll;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) PYPhotosView *flowPhotosView;
@end

@implementation TimetablesViewController

- (UITableView *)tableView {
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 114) style:UITableViewStylePlain];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.tableFooterView = [[UIView alloc]init];
        
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.backgroundColor = kCustomColor(229, 236, 236);
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [self.tableView registerNib:[UINib nibWithNibName:@"TimetablesCell" bundle:nil] forCellReuseIdentifier:@"timetablesCell"];
    }
    
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = kCustomVCBackgroundColor;
    
    [self.view addSubview:self.tableView];
    
    _tableArr = [NSMutableArray array];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/article_list"];
    NSDictionary *dic = @{
                          @"page":@"1",
                          @"pagesize":@"100",
                          @"cat_id":self.cat_id
                          };
    [HttpRequest postWithURLString:urlStr parameters:dic success:^(id success) {
        NSLog(@"课程表%@",success);
        _dataArr = [success objectForKey:@"body"];
        
        [self requestData];
        
    } failure:^(NSError *error) {
        NSLog(@"课程表%@",error);
        
    }];

}

- (void)requestData {
    for (NSInteger i = 0; i < _dataArr.count; i ++) {
        MessageModel *model = [[MessageModel alloc] initWithDic:_dataArr[i]];
        
        [_tableArr addObject:model];
    }
    
    [_tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TimetablesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"timetablesCell" forIndexPath:indexPath];
    MessageModel*model = _tableArr[indexPath.row];
    
    [cell customCellModel:model];
    
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tableArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kScreenWidth / 5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageModel *model = _tableArr[indexPath.row];
    
    ContentViewController *contenVC = [[ContentViewController alloc] init];
    contenVC.contentModel = model;
    contenVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:contenVC animated:YES];

    /*
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/subject_img"];
    [HttpRequest postWithURLString:urlStr parameters:nil success:^(id success) {
        NSLog(@"课程表%@",success);
        _imageArry = [NSMutableArray array];
        
        for (NSDictionary *dic in success[@"body"]) {
            NSString *imageStr = [NSString stringWithFormat:@"%@%@",skBannerUrl,dic[@"images"]];
            NSString *name = dic[@"name"];
            [_imageArry addObject:imageStr];
        }
        
        [JFPictureBrowserView clearImagesCache];
        JFPictureBrowserView *pictureBrowserView = [JFPictureBrowserView pictureBrowsweViewWithFrame:_tableView.frame delegate:self imageURLStringGroup:_imageArry];
        pictureBrowserView.startIndex = 1;//开始索引
        [pictureBrowserView showInView:self.view];
        UIApplication *ap = [UIApplication sharedApplication];
        [ap.keyWindow addSubview:pictureBrowserView];

       // [self configureImageViews:_imageArry];
    } failure:^(NSError *error) {
        NSLog(@"课程表%@",error);
        
    }];
    
   
    
     TimetablesDetailsViewController *timetablesDetailsVC = [TimetablesDetailsViewController new];
     timetablesDetailsVC.hidesBottomBarWhenPushed = YES;
     [self.navigationController pushViewController:timetablesDetailsVC animated:YES];
     */
    
}
    /*
    _mainScroll = [[UIScrollView alloc] init];
    _mainScroll.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    _mainScroll.delegate = self;
    [self.view addSubview:_mainScroll];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/subject_img"];
    [HttpRequest postWithURLString:urlStr parameters:nil success:^(id success) {
        NSLog(@"课程表%@",success);
        _imageArry = [NSMutableArray array];
        _nameArry = [NSMutableArray array];
        
        for (NSDictionary *dic in success[@"body"]) {
            NSString *imageStr = [NSString stringWithFormat:@"%@%@",skBannerUrl,dic[@"images"]];
            NSString *name = dic[@"name"];
            [_imageArry addObject:imageStr];
            [_nameArry addObject:name];
        }
        [self addView];
    } failure:^(NSError *error) {
        NSLog(@"课程表%@",error);
        
    }];

    
}

- (void)addView {
    for (NSInteger i = 0; i < _imageArry.count; i++) {
        TimetablesView *timetablesView = [[TimetablesView alloc] initWithFrame:CGRectMake(i%2*kScreenWidth / 2 + 10 , i/2*(kScreenHeight / 3 + 20)+ 15, kScreenWidth / 2 - 20, kScreenHeight / 3)];
        timetablesView.btn.tag = i + 1000;
        timetablesView.titleLabel.text = _nameArry[i];
        [timetablesView.btn sd_setImageWithURL:_imageArry[i] forState:UIControlStateNormal placeholderImage:loadingImage];
        [timetablesView.btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.mainScroll addSubview:timetablesView];
        _mainScroll.contentSize = CGSizeMake(kScreenWidth, (kScreenHeight / 3) *i);
    }

}
- (void)btnClick:(UIButton *)sender {
    NSLog(@"------------%ld",(long)sender.tag);
    
    [ScanImage scanBigImageWithImageView:sender.imageView];
}

    NSArray *arr = [NSArray arrayWithObject:_imageArry[sender.tag - 1000]];
    [self configureImageViews:arr];
}
 
*/

- (void)configureImageViews:(NSArray *)imageAry {
    CGFloat imageWidth = (kScreenWidth - 120)/3;
    CGFloat imageContentViewHeight;
    if (imageAry.count > 0) {
        imageContentViewHeight = (imageWidth + 10)* ((imageAry.count - 1)/3 + 1);
    } else {
        imageContentViewHeight = 0;
    }
    [_flowPhotosView removeFromSuperview];
    // 2.1 创建一个流水布局photosView(默认为流水布局)
    _flowPhotosView = [PYPhotosView photosView];
    // 设置缩略图数组
    _flowPhotosView.thumbnailUrls = imageAry;
    // 设置原图地址
    _flowPhotosView.originalUrls = imageAry;
    // 设置分页指示类型
    _flowPhotosView.pageType = PYPhotosViewPageTypeLabel;
    _flowPhotosView.py_x = 0;
    _flowPhotosView.py_y = 0;
    _flowPhotosView.photoWidth = imageWidth;
    _flowPhotosView.photoHeight = imageWidth;
    _flowPhotosView.photoMargin = 5;
    // 3. 添加到指定视图中
    [self.view addSubview:_flowPhotosView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
