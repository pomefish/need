//
//  ContentViewController.m
//  mingtao
//
//  Created by Linlin Ge on 2016/11/25.
//  Copyright © 2016年 Linlin Ge. All rights reserved.
//

#import "ContentViewController.h"
#import "WebviewProgressLine.h"

#import "RootView.h"
#import "CommentView.h"

#import "CommentsCell.h"
#import "CommentsModel.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

@interface ContentViewController () <UIWebViewDelegate, UIScrollViewDelegate, UITableViewDataSource,UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, assign) CGRect webViewHeight;
@property (nonatomic, copy) NSString *webStr;
@property (nonatomic, strong) NSMutableArray *dataSourceAry;

@property (nonatomic, strong) CommentView *commentView;

@property (nonatomic,strong) WebviewProgressLine  *progressLine;

@property (nonatomic, assign) NSInteger numberOfPageSize;
@property (nonatomic,copy)NSString *comStr;
@end

@implementation ContentViewController
- (UIWebView *)webView {
    if (_webView == nil) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 114)];
        _webView.backgroundColor = [UIColor clearColor];
        _webView.scalesPageToFit =YES;
        _webView.delegate =self;
        _webView.scrollView.bounces = NO;
        
//         _webStr = [NSString stringWithFormat:@"%@%@",HTTPURL,[NSString stringWithFormat:@"/Api/Public/index?id=%@",_contentModel.ID]];
        _webStr =[NSString stringWithFormat:@"http://newapp.mingtaokeji.com/article_app.php?id=%@",[NSString stringWithFormat:@"%@",_contentModel.ID]];
        
    
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_webStr] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:300.0]];
    }
    
    return _webView;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 50) style:UITableViewStylePlain];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.tableFooterView = [UIView new];
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [self.tableView registerNib:[UINib nibWithNibName:@"CommentsCell" bundle:nil] forCellReuseIdentifier:@"CommentsCell"];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _contentModel.title;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = kCustomNavColor;
    
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSFontAttributeName:[UIFont systemFontOfSize:15],
        NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    leftBarButton(@"returnImage");
    
    [self.view addSubview:self.tableView];
    [self.tableView addSubview:self.webView];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    self.progressLine = [[WebviewProgressLine alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 3)];
    self.progressLine.lineColor = kCustomViewColor;
    [self.view addSubview:self.progressLine];
    
    [self getCommentRequest:YES];
    __typeof (self) __weak weakSelf = self;
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        
        [weakSelf getCommentRequest:YES];
        
    }];
    
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        
        [weakSelf getCommentRequest:NO];
        
    }];

    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    _commentView = [[CommentView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 49, kScreenWidth, 50)];
    _commentView.commentTF.delegate = self;
    [_commentView.forwardButton addTarget:self action:@selector(forwardButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:_commentView];
    //注册键盘出现消失通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self getArticleLogRequest];
}
//键盘将要出现的通知回调方法
- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect keyboardBounds = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.commentView.frame = CGRectMake(0, kScreenHeight-keyboardBounds.size.height -50, kScreenWidth, 50);
}
//键盘将要消失的通知回调方法
- (void)keyboardWillHide:(NSNotification *)notification {
    
    self.commentView.frame = CGRectMake(0, kScreenHeight - 49, kScreenWidth, 50);
}

- (void)getArticleLogRequest {
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/article_log"];
    NSDictionary *dic = @{
                          @"uid":userID,
                          @"cat_id":_contentModel.ID
                          };
    [HttpRequest postWithURLString:urlStr parameters:dic success:^(id success) {
        NSLog(@"----是否阅读过----%@",success);
    } failure:^(NSError *error) {
        NSLog(@"----是否阅读过----%@",error);
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"点击了发送");
    if ([_commentView.commentTF.text isEqualToString:@""]) {
        [MBProgressHUD showMessage:@"请填写评论内容！" toView:self.tableView delay:1.0];
        [self.view endEditing:YES];
    }else {
        NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/article_comments"];
        //iOS提供了直接获取系统版本号的方法：
        NSString *version = [UIDevice currentDevice].systemVersion;
        if (version.doubleValue == 9.0) {
           self.comStr = [_commentView.commentTF.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
            
        }else{
            
           self.comStr = [_commentView.commentTF.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
        }
    

        
        NSDictionary *dic = @{
                              @"uid":userID,
                              @"content":_comStr,
                              @"article_id":_contentModel.ID
                              };
        [HttpRequest postWithURLString:urlStr parameters:dic success:^(id success) {
            NSLog(@"-------发评论----%@",success);
            _commentView.commentTF.text = @"";
            [self.view endEditing:YES];
            [self getCommentRequest:YES];
        } failure:^(NSError *error) {
            NSLog(@"-------发评论----%@",error);
            
        }];
    }
    
    return YES;
}





- (void)getCommentRequest:(BOOL)isPull {
    if (isPull) {
        _numberOfPageSize = 1;
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/article_comments_list"];
    NSDictionary *dic = @{
                          @"page":@(_numberOfPageSize),
                          @"pagesize":@"10",
                          @"article_id":_contentModel.ID
                          };
    [HttpRequest postWithURLString:urlStr parameters:dic success:^(id success) {
        NSLog(@"kkkkk-------评论列表-----%@",success);
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        if (_numberOfPageSize == 1) {
            [_dataSourceAry removeAllObjects];
        }
        BOOL isMore = _dataSourceAry.count > 0 && _dataSourceAry.count < 10;
        if (isMore) {
            [_tableView.footer noticeNoMoreData];
            _numberOfPageSize --;
        }
        _numberOfPageSize ++;
        for (NSDictionary *dic in success[@"body"]) {
            CommentsModel *model = [[CommentsModel alloc] initWithCommentsModelDictionary:dic];
            if (!_dataSourceAry) {
                _dataSourceAry = [NSMutableArray array];
            }
            [_dataSourceAry addObject:model];
        }
        
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark --------webView的代理方法
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    _webViewHeight = webView.frame;
    _webViewHeight.size.width = kScreenWidth;
    _webViewHeight.size.height = 1;
    webView.frame = _webViewHeight;
    
    _webViewHeight.size.height = webView.scrollView.contentSize.height;
    
    webView.frame = _webViewHeight;
    
    [self.progressLine endLoadingAnimation];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell addSubview:_webView];
        return cell;
    }else {
        CommentsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentsCell" forIndexPath:indexPath];
        CommentsModel *model = _dataSourceAry[indexPath.row];
//        model.isHomeVC = YES;
//        [cell.zanButton addTarget:self action:@selector(zanButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell customCommentsCellModel:model];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0 && indexPath.section == 0) {
        NSLog(@"------------%f",_webViewHeight.size.height);
        return _webViewHeight.size.height + 10;
    }
    CommentsModel *model = _dataSourceAry[indexPath.row];
    return [CommentsCell cellForHeight:model];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else {
        return _dataSourceAry.count;
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self.progressLine startLoadingAnimation];
    NSLog(@"开始加载");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self.progressLine endLoadingAnimation];
}

- (void)forwardButtonClick:(UIButton *)sender {
//    NSArray* imageArray = @[[UIImage imageNamed:@"iTunesArtwork.png"]];
    //        （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    NSString *imageUrl = [NSString stringWithFormat:@"%@%@",skImageUrl,_contentModel.image];
        NSString *webshareStr =[NSString stringWithFormat:@"http://newapp.mingtaokeji.com/article_share.php?id=%@",[NSString stringWithFormat:@"%@",_contentModel.ID]];
    NSString *descriptionStr;
    if (![NSString cc_isNULLOrEmpty:_contentModel.descriptionStr]) {
        descriptionStr = _contentModel.descriptionStr;
    }else {
        descriptionStr = @"尚科教育，学习从这里起航！";
    }
    NSArray* imageArray = [NSArray array];
    if ([imageUrl isEqualToString:skImageUrl]) {
        imageArray = @[@"http://newapp.mingtaokeji.com/data/article/1520046328028079266.png"];
    }else {
        imageArray = @[imageUrl];
    }
    if (imageArray) {
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:descriptionStr
                                         images:imageArray
                                            url:[NSURL URLWithString:webshareStr]
                                          title:_contentModel.title
                                           type:SSDKContentTypeWebPage];
        //有的平台要客户端分享需要加此方法，例如微博
        [shareParams SSDKEnableUseClientShare];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                 items:nil
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           default:
                               break;
                       }
                   }
         ];}

}

- (void)leftButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
//    if ([_contentModel.descriptionStr isEqualToString:@""]) {
    [self dismissViewControllerAnimated:YES completion:nil];
    
//    [self.tabBarController setSelectedIndex:1];
//    }
   
}

//移除通知
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
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
