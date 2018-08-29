//
//  QuesDetailViewController.m
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2018/3/31.
//  Copyright © 2018年 ShangKe. All rights reserved.
//

#import "QuesDetailViewController.h"
#import "QuesDetailView.h"
#import "BottomView.h"

//demo 里
#import "HWQuestionsModel.h"
#import "HWQuestionsFooterView.h"
#import "HWAnswerView.h"
#import "HWFillAnswerView.h"
#import "HWAnalysisView.h"
#import "UIColor+Hex.h"
#import "HWExercises_prefix.pch"

#import "totalCollectionViewCell.h"
#import "UILabel+Size.h"

@interface QuesDetailViewController ()<HWAnalysisViewDelegate, HWQuestionsFooterViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,assign)NSInteger tagID;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)NSMutableArray *statudataArr;//存储答过题的标题

@property (nonatomic, strong) NSMutableArray *selectedArray;

//demo里
@property (nonatomic, strong) NSMutableArray *questionsArray;
@property (nonatomic, strong) NSMutableArray *answerArray;
@property (nonatomic, strong) HWQuestionsModel *model;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UILabel *questionlabel;
@property (nonatomic, weak) UILabel *typeLabel;

@property (nonatomic, weak) HWQuestionsFooterView *footerView;
@property (nonatomic, weak) HWAnswerView *answerView;
@property (nonatomic, weak) HWFillAnswerView *fillAnswerView;
@property (nonatomic, weak) HWAnalysisView *analysisView;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic,copy)NSString *questionlabelText;
@property (nonatomic, assign) BOOL isCreatControl;

@property (nonatomic,assign)NSInteger rightCount;
@property (nonatomic,assign)NSInteger errorCount;
@property (nonatomic,assign)NSInteger cc;

@property (nonatomic,strong)UIButton *queBtn;
@property (nonatomic,strong)UIView *backView;
@property (nonatomic,strong)NSMutableArray *myselectArr;
@property (nonnull,copy)NSString *title;//  标记已经做过题目的名字


@end



@implementation QuesDetailViewController


- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray arrayWithCapacity:0];
    }
    return  _dataArr;
}

- (NSMutableArray *)statudataArr{
    if (!_statudataArr) {
        _statudataArr = [NSMutableArray arrayWithCapacity:0];
    }
    return  _statudataArr;
}

- (NSMutableArray *)myselectArr{
    if (!_myselectArr) {
        _myselectArr = [NSMutableArray arrayWithCapacity:0];
    }
    return  _myselectArr;
}
#pragma mark -----Demo
- (NSMutableArray *)questionsArray
{
    if (!_questionsArray) {
        _questionsArray = [NSMutableArray array];
    }
    
    return _questionsArray;
}
- (NSMutableArray *)answerArray
{
    if (!_answerArray) {
        _answerArray = [NSMutableArray array];
    }
    
    return _answerArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //设置导航栏标题并添加返回按钮
//    [self addBackBtnAndTitle:@"答题页面"];
    leftBarButton(@"returnImage");
    _rightCount = 0;
    _errorCount = 0;
    //初始化页码
    _page = 1;
    
    //（服务端数据库）
    [self initData];

    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
  
}

- (void)initData{
    NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
    
    if (user != nil) {
        
        NSString *string = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/questionnaire"];
        
        NSDictionary *dic = @{
                              @"uid":user,
                              @"certificate_id":self.idd
                              };
        __weak typeof(self) weakSelf = self;
        [HttpRequest postWithURLString:string parameters:dic success:^(id result) {
//           NSLog(@"----=查看问题信息-----%@",result);
            
         
            NSString *stuStr = [NSString stringWithFormat:@"%@", result[@"status"]];
            if ( [stuStr isEqualToString:@"1"]) {
                
                NSArray *array = result[@"body"];
                for (NSDictionary *dic in array) {
                            self.model = [[HWQuestionsModel alloc] initWithDic:dic];
                            [self.questionsArray addObject:_model];
                    [self.answerArray addObject:@""];
                    [self.dataArr addObject:@"2"];
                        }
                
                //获取题目信息，每次获取当前目标题目信息
                [weakSelf getQuestionsInfo];

            }
        } failure:^(NSError *NSError) {
        }];
        
    }


   
}

//获取题目信息，每次获取当前目标题目信息
- (void)getQuestionsInfo
{
    //更新模型
//    NSLog(@"ppp = %d",_page);
    if (_page <= _questionsArray.count) {
    
            _model = _questionsArray[_page - 1 ];
        NSLog(@"ttt = %@",_model.question);
   }

    //创建控件
    if (!_isCreatControl) [self creatControl];
    
    //刷新视图
    [self reloadView];
}

//保存做题记录，做过的题由服务端存储，不需要进行本地持久化保存
- (void)saveProgress
{
       if (([_model.question_type intValue] < 4 ) || ([_model.question_type intValue] > 3 && ![_fillAnswerView.fillAnswer isEqualToString:@""])) {
        
        NSString *qranswer = _answerView.hidden ? _fillAnswerView.fillAnswer : _answerView.selectAnswer;
        
        NSString *qrnum = _answerView.hidden ? _fillAnswerView.qrnum : _answerView.qrnum;
           
//
//      HWLog(@"保存做题记录参数：\n试题id：%ld\n页码：%ld\n填写的答案：%@\n填写的答案角标:%@", (long)_model.id, _page, qranswer, qrnum);

         NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
        
        if (user != nil) {
            
            NSString *string = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/add_exams_log"];
            NSString *str= [NSString stringWithFormat:@"%ld",(long)_rightCount];
            NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"id" ascending:YES]];
            [ _myselectArr sortUsingDescriptors:sortDescriptors];
            NSLog(@"排序后的数组%@",_myselectArr);
        
            
            NSDictionary *dd = @{@"body":_myselectArr};
            NSString *jsonStr = [self convertToJsonData:dd];

            NSDictionary *dic = @{
                                  @"uid":user,
                                  @"certificate_id":self.idd,
                                  @"score":str,
                                  @"setting":jsonStr
                                  };
            
            NSLog(@"上传的字典=%@",dic);
            __weak typeof(self) weakSelf = self;
            [HttpRequest postWithURLString:string parameters:dic success:^(id result) {
                NSString *stuStr = [NSString stringWithFormat:@"%@", result[@"status"]];
                          [self.navigationController popViewControllerAnimated:YES];
              
            } failure:^(NSError *NSError) {
                NSLog(@"查看个人信息%@",NSError);
            }];
            
        }

    }
    
}

// 字典转json字符串方法

-(NSString *)convertToJsonData:(NSDictionary *)dict

{
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
    
}

//创建控件
- (void)creatControl
{
    _isCreatControl = YES;
    //滚动视图
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, KMainH - 40-kNavHeight)];
    scrollView.showsVerticalScrollIndicator = NO;
    self.navigationController.navigationBar.translucent = YES;
    
    // 解决scrollView自动下移

    if(@available(iOS 11.0, *)){
        scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    //问题标签
    UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10+ kScreenWidth *(_page-1), 10, 60, 26)];
    typeLabel.font = [UIFont systemFontOfSize:15.f];
    typeLabel.textColor =  kCustomOrangeColor;
    typeLabel.textAlignment = NSTextAlignmentCenter;
    typeLabel.layer.borderWidth = 1;
    
    typeLabel.layer.cornerRadius =2;
    typeLabel.layer.borderColor =[UIColor colorWithRed:255.0/255.0 green:155.0/255.0 blue:0/255.0 alpha:1].CGColor;
    typeLabel.numberOfLines = 0;
    [scrollView addSubview:typeLabel];
    
    self.typeLabel = typeLabel;
    
    
    UILabel *questionLabel = [[UILabel alloc] init];
    questionLabel.font = [UIFont systemFontOfSize:15.f];
    questionLabel.numberOfLines = 0;
     //  questionLabel.adjustsFontForContentSizeCategory
   // = YES;
//    questionLabel.backgroundColor = [UIColor redColor ];
    [scrollView addSubview:questionLabel];
    self.questionlabel = questionLabel;
    
    //答案选择视图，单选、多选、判断
    HWAnswerView *answerView = [[HWAnswerView alloc] init];
//    answerView.backgroundColor = [UIColor greenColor];
    [scrollView addSubview:answerView];
    self.answerView = answerView;
    
    //答案填写视图，填空、简答
    HWFillAnswerView *fillAnswerView = [[HWFillAnswerView alloc] init];
    [scrollView addSubview:fillAnswerView];
    self.fillAnswerView = fillAnswerView;
    
    //底部视图
    HWQuestionsFooterView *footerView = [[HWQuestionsFooterView alloc] initWithFrame:CGRectMake(0 + kScreenWidth *(_page-1), KMainH - 40, KMainW, 40)];
    footerView.delegate = self;
//    self.cc = 1;
    [self.view addSubview:footerView];

    [footerView.rightImageView addTarget:self action:@selector(handleTotalQuea:) forControlEvents:UIControlEventTouchUpInside];
    
    
     [footerView.errorImageView addTarget:self action:@selector(handleTotalQuea:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.footerView = footerView;
}

//刷新布局
- (void)reloadView
{
    //刷新问题相关数据
    if ([_model.question_type isEqualToString:@"1"]) {
        NSString *danStr = @"单选题";
        self.typeLabel.text = danStr;
        NSString *questionlabelText = [NSString stringWithFormat:@"%@",   _model.question];
      NSString *str = [questionlabelText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        self.questionlabelText = str;
    }else{
        NSString *danStr = @"多选题";
        self.typeLabel.text = danStr;

        NSString *questionlabelText = [NSString stringWithFormat:@"%@",  _model.question];
         NSString *str  = [questionlabelText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        self.questionlabelText = str;
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
     paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    [paragraphStyle setLineSpacing:4.0f];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_questionlabelText];

    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:15.f], NSParagraphStyleAttributeName:paragraphStyle};
    CGFloat questionLabelH = [_questionlabelText boundingRectWithSize:CGSizeMake(KMainW - 85, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size.height;
    _questionlabel.attributedText = attributedString;
    _questionlabel.frame = CGRectMake( CGRectGetMaxX(self.typeLabel.frame)+ 5,12, KMainW - 85, questionLabelH);
    
    
//刷新答案相关数据
//    if ([_model.question_type intValue] < 4) {
        //答案选择视图，单选、多选、判断
        _answerView.hidden = NO;
        _fillAnswerView.hidden = YES;
    
    NSArray *arrays  = [NSMutableArray arrayWithCapacity:0];
    NSString *string = [_answerArray objectAtIndex:_page-1];
    
    if ([string isEqualToString:@""]) {
        arrays = nil;
    }else{
        arrays= [string componentsSeparatedByString:@"###"];
        
    }
//    NSLog(@"ssss = %@  %@",arrays,_model.question);
    [_answerView reloadViewWithFrame:CGRectMake(0, CGRectGetMaxY(_questionlabel.frame) + 15, KMainW, 0) style:[_model.question_type intValue] - 1 answerArray:_model.question_selectArray userAnswers:arrays];
        [_answerView reloadViewWithFrame:CGRectMake(0, CGRectGetMaxY(_questionlabel.frame) + 15, KMainW, 0) style:[_model.question_type intValue] - 1 answerArray:_model.question_selectArray userAnswers:arrays];
//    NSLog(@"刷新答案选项了");


    //刷新底部试图数据 F
    if (_page <= _questionsArray.count) {
         self.footerView.totalQueLabel.text = [NSString stringWithFormat:@"%ld/%lu", _page,(unsigned long)_questionsArray.count];

        
        if ([_statudataArr containsObject:_model.question]) {
            [self.footerView.btn setTitle:@"下一题" forState:UIControlStateNormal];
        }else{
             [self.footerView.btn setTitle:@"确定" forState:UIControlStateNormal];
        }
            
    }
    _scrollView.contentSize = CGSizeMake(KMainW, CGRectGetMaxY(_answerView.frame));

    //        HWLog(@"保存做题记录参数：\n试题id：%@\n页码：%ld\n填写的答案：%@\n填写的答案角标:%@", _model.questionid, _page, qranswer, qrnum);
}

#pragma mark - SXQuestionsFooterViewDelegate
- (void)questionsFooterView:(HWQuestionsFooterView *)questionsFooterView didClickOptionButton:(BOOL)isNextButton
{
    if ([questionsFooterView.btn.titleLabel.text isEqualToString:@"确定"]) {
        
        if ([_answerView.selectAnswer isEqualToString:@""]) {
            [MBProgressHUD showMessage:@"请先选择答案！" toView:self.scrollView  delay:1.0];
            
            
        }else{
            [_answerArray replaceObjectAtIndex:_page-1 withObject:_answerView.selectAnswer];
            if (_page == _questionsArray.count) {
                
                [questionsFooterView.btn setTitle:@"提交" forState: UIControlStateNormal];
                NSLog(@"想等了");
                [self loadViewanalyView];
                
            }else{
                
                [ questionsFooterView.btn setTitle:@"下一题" forState:UIControlStateNormal];
                //        // 解析页面加载
                [self loadViewanalyView];
//                if ([_statudataArr containsObject:_model.question]) {
//                    [self loadViewanalyView];
//
//                }else{
//                    _analysisView.hidden = YES;
//                }

              
            }
            
            
            if (_page <= _questionsArray.count) {
                
                if (_statudataArr == NULL) {
                    
                    if (![_answerView.selectAnswer isEqualToString:_model.question_answer]) {
                        _errorCount++;
                        [self.statudataArr addObject:_model.question];
                        
                    }else{
                        
                        _rightCount ++;
                        [self.statudataArr addObject:_model.question];
                    }
                    _footerView.rightILabel.text = [NSString stringWithFormat:@"%ld",(long)_rightCount];
                    _footerView.errorILabel.text = [NSString stringWithFormat:@"%ld",(long)_errorCount];
                }
                else{
                    
                    if (![_statudataArr containsObject:_model.question]) {
                        if (![_answerView.selectAnswer isEqualToString:_model.question_answer]) {
                            _errorCount++;
                            NSLog(@"答错了%d",_errorCount);
                            [self.statudataArr addObject:_model.question];
                            
                        }else{
                            
                            _rightCount ++;
                            NSLog(@"对了%ld",_rightCount);
                            [self.statudataArr addObject:_model.question];
                        }
                    }
                    _footerView.rightILabel.text = [NSString stringWithFormat:@"%ld",(long)_rightCount];
                    _footerView.errorILabel.text = [NSString stringWithFormat:@"%ld",(long)_errorCount];
                    
                                  }
                
                NSString *idStr = [NSString stringWithFormat:@"%ld",(long)_model.id];
                    NSDictionary *dic = @{@"id":idStr,@"select":_answerView.selectAnswer};
                if (![_myselectArr containsObject:dic]) {
                    [self.myselectArr addObject:dic];

                }
                NSLog(@"vvv = %ld",_myselectArr.count);
            }
        }
        
    }else  if ([questionsFooterView.btn.titleLabel.text isEqualToString:@"下一题"]){

        NSLog(@"22222");
        //更新页码
        if (_page < _questionsArray.count) {
            
            isNextButton ? _page++ : _page--;
            
            //获取目标题目信息
           [self getQuestionsInfo];
            if ([_statudataArr containsObject:_model.question]) {
                _analysisView.hidden = YES;
                [self loadViewanalyView];
                if(_page ==_questionsArray.count){
                    [self.footerView.btn setTitle:@"提交" forState:UIControlStateNormal];
                }else{
                    [self.footerView.btn setTitle:@"下一题" forState:UIControlStateNormal];
                }

            }else{
                _analysisView.hidden = YES;
                [self.footerView.btn setTitle:@"确定" forState:UIControlStateNormal];
                
                
            }
                   }
    }else{
        [self handleSubmit];
    }

       }

- (void)loadViewanalyView{
    CGFloat labelW = kScreenWidth - 20;
    _answerView.selectAnswer = [NSString stringWithFormat:@"%@", _answerArray[_page-1]];
    NSLog(@"_answerArray==%@", _answerArray);
    // 解析页面加载
    HWAnalysisView *analysisView = [[HWAnalysisView alloc] init];
    [_scrollView addSubview:analysisView];
    analysisView.frame = CGRectMake(0, CGRectGetMaxY(_answerView.frame), kScreenWidth, MAXFLOAT);
    self.analysisView = analysisView;
    
    //正确、错误提示图片
    
     NSString *tagStr = @"";
    NSLog(@"question_answer==%@", _model.question_answer);
    NSLog(@"_answerView.selectAnswer==%@", _answerView.selectAnswer);
    if ([_answerView.selectAnswer rangeOfString:@"|"].location == NSNotFound){
        if ([_model.question_answer isEqualToString:_answerView.selectAnswer] ) {
            _analysisView.tfView.image = [UIImage imageNamed:@"exerc_analysisView_right"];
            tagStr = @"1";
            
        }else{
            _analysisView.tfView.image = [UIImage imageNamed:@"exerc_analysisView_fause"];
            tagStr = @"0";
        }
        
    }else{
        NSString *strUrl = [_answerView.selectAnswer stringByReplacingOccurrencesOfString:@"|" withString:@"###"];
        if ([_model.question_answer isEqualToString:strUrl] ) {
            _analysisView.tfView.image = [UIImage imageNamed:@"exerc_analysisView_right"];
            tagStr = @"1";
            
        }else{
            _analysisView.tfView.image = [UIImage imageNamed:@"exerc_analysisView_fause"];
            tagStr = @"0";
        }
        
    }
    
    NSLog(@"%@",self.dataArr);
    if (self.dataArr.count > _page - 1 ) {
        [self.dataArr replaceObjectAtIndex:_page - 1 withObject:tagStr];
    }else{
        [self.dataArr addObject:tagStr];
    }
    
    
//    NSLog(@" 333 = %@",_answerView.selectAnswer);
    if ([_model.question_answer rangeOfString:@"###"].location == NSNotFound){
         _analysisView.trueAnswerLabel.text = [NSString stringWithFormat:@"答案：%@", _model.question_answer];
    }else{
        NSString *strUrl = [_model.question_answer stringByReplacingOccurrencesOfString:@"###" withString:@","];
         _analysisView.trueAnswerLabel.text = [NSString stringWithFormat:@"答案：%@", strUrl];
    }
    

    _analysisView.anaInfoLabel.text =[NSString stringWithFormat:@"%@",_model.question_describe];
    //        [_analysisView dismissAnalysisInfo];
    
    CGSize titleSize = [_analysisView.trueAnswerLabel boundingRectWithSize:CGSizeMake(kScreenWidth -20, MAXFLOAT)];
    
    
    CGFloat trueAnswerLabelH = titleSize.height;
    _analysisView.trueAnswerLabel.frame = CGRectMake(10, 40, labelW, trueAnswerLabelH);
    
    //刷新解析详情标签
    
    CGSize inSize = [_analysisView.anaInfoLabel boundingRectWithSize:CGSizeMake(kScreenWidth - 20, MAXFLOAT)];
    
    CGFloat anaInfoLabelH = inSize.height;
    
    _analysisView.anaInfoLabel.frame = CGRectMake(10, CGRectGetMaxY(_analysisView.trueAnswerLabel.frame)  +10, labelW, anaInfoLabelH);
    
    //刷新视图区域
    _analysisView.anaView.hidden = NO;
    _analysisView.anaView.frame = CGRectMake(0, 44, KMainW, 15 + 15 + 10 + trueAnswerLabelH + 10 + anaInfoLabelH);
    _analysisView.frame = CGRectMake(0, CGRectGetMaxY(_answerView.frame) + 10, kScreenWidth, 44 + _analysisView.anaView.frame.size.height);
    
    //改变自身区域
    CGRect frame = _analysisView.frame;
    frame.size.height = 44 + _analysisView.anaView.bounds.size.height;
    _analysisView.frame = frame;
    
    CGFloat temH =  CGRectGetMaxY(_answerView.frame) ;
    
    _scrollView.contentSize = CGSizeMake(KMainW, temH  + 10 + analysisView.bounds.size.height);
}



- (void)handleSubmit{
    if (_myselectArr.count < _questionsArray.count) {
        NSLog(@"题没做完");
        _analysisView.hidden = NO;

        UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle: @"还有题目没做完，请检查" message:nil delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
        alert1.tag = 10001;
        [alert1 show];
    }else{
        // 上传到服务器
        _analysisView.hidden = NO;

        UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle: @"确定上传吗" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        alert1.tag = 10002;
        [alert1 show];
    }
    
    
    
}


//提示框确认事件：上传服务器
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10001) {
        
    }else if (alertView.tag == 10002) {
        
        
        if (buttonIndex == 0) {
            //进入下一题
            [self saveProgress];
        }else{
            
        }
    }else{
        if (buttonIndex == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
//到此结束

//返回按钮点击事件
- (void)leftButton:(UIBarButtonItem *)item{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"还未完成答题，是否确定放弃测试，放弃测试下次进入重新答题" delegate:self cancelButtonTitle:@"放弃" otherButtonTitles:@"继续答题", nil];
    alert.tag = 10003;
    [alert show];
}


#pragma mark -----底部确认按钮点击事件
- (void)handleTotalQuea:(UITapGestureRecognizer *)tap{
    
    [self setUpCollectionView];
    UITapGestureRecognizer *tab = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleMiss:)];
    [_scrollView addGestureRecognizer:tab];
    
}

- (void)handleMiss:(UITapGestureRecognizer *)tap{
    [_collectionView removeFromSuperview];
    
}

- (void)setUpCollectionView{
    UICollectionViewFlowLayout *fl = [[UICollectionViewFlowLayout alloc]init];
    [fl setScrollDirection:UICollectionViewScrollDirectionVertical];

       fl.itemSize = CGSizeMake(40, 40);
    //布局
    fl.minimumInteritemSpacing = (kScreenWidth - 6 * 40)/5;
    
    fl.minimumLineSpacing = 10;
    float hang =  ceil(_questionsArray.count *1.0/6);

    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, kScreenHeight - 40 * hang - 10* (hang - 1) , kScreenWidth, 40 * hang + 10* (hang - 1)) collectionViewLayout:fl];
    if (kScreenHeight - 40 * hang - 10* (hang - 1) < 40 ) {
        
//        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,  kNavHeight , kScreenWidth, 40 * hang + 10* (hang - 1)) collectionViewLayout:fl];
          _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,  kNavHeight , kScreenWidth, kScreenHeight - kNavHeight) collectionViewLayout:fl];
    }
    _collectionView.dataSource = self;
    
    _collectionView.delegate = self;

    
    _collectionView.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0 ];
 
    self.collectionView.alwaysBounceVertical = YES;
    

    
    [self.view addSubview: _collectionView];
    
 
    
    [_collectionView registerClass:[totalCollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
}

#pragma mark -- dataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
    
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _questionsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
//    UICollectionViewCell *cell =  [];
    totalCollectionViewCell *cell = (totalCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    
    cell.titleLabel.text = [NSString stringWithFormat:@"%ld",indexPath.item + 1];
    if (self.dataArr.count == 0) {
//        提示框
        cell.titleLabel.textColor = [UIColor lightGrayColor];
        cell.titleLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
        cell.titleLabel.layer.cornerRadius = 20;
        cell.titleLabel.layer.borderWidth = 2;
        
    }else  if( self.dataArr.count ==_questionsArray.count){
        
               NSString *str = [NSString stringWithFormat:@"%@", self.dataArr[indexPath.row]];
        
            if ([str isEqualToString:@"1"]) {
                cell.titleLabel.textColor = [UIColor colorWithRed:0/255.0f green:179/255.0f blue:138/255.0f alpha:1.0];
         cell.titleLabel.layer.borderColor = [UIColor colorWithRed:0/255.0f green:179/255.0f blue:138/255.0f alpha:1.0].CGColor;
                cell.titleLabel.layer.borderWidth = 1;

                
            }else if([str isEqualToString:@"0"]) {
                cell.titleLabel.textColor = [UIColor redColor];
                cell.titleLabel.layer.borderColor = [UIColor redColor].CGColor;
                cell.titleLabel.layer.borderWidth = 1;

                
            }else{
                cell.titleLabel.textColor = [UIColor lightGrayColor];
                cell.titleLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
                cell.titleLabel.layer.borderWidth = 1;

                
            }

    }else {
        if (indexPath.row < _dataArr.count) {
            NSLog(@"aaa  =%@",_dataArr);
            NSString *str = [NSString stringWithFormat:@"%@", self.dataArr[indexPath.row]];
            
            if ([str isEqualToString:@"1"]) {
                cell.titleLabel.textColor = [UIColor colorWithRed:0/255.0f green:179/255.0f blue:138/255.0f alpha:1.0];
                cell.titleLabel.layer.borderColor = [UIColor colorWithRed:0/255.0f green:179/255.0f blue:138/255.0f alpha:1.0].CGColor;
                cell.titleLabel.layer.borderWidth = 1;
                
                
            }else if([str isEqualToString:@"0"]) {
                cell.titleLabel.textColor = [UIColor redColor];
                cell.titleLabel.layer.borderColor = [UIColor redColor].CGColor;
                cell.titleLabel.layer.borderWidth = 1;
                
                
            }else{
                cell.titleLabel.textColor = [UIColor lightGrayColor];
                cell.titleLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
                cell.titleLabel.layer.borderWidth = 1;
                
                
            }

        }else{
            cell.titleLabel.textColor = [UIColor lightGrayColor];
            cell.titleLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
            cell.titleLabel.layer.borderWidth = 1;
        }
    }
   
       return cell;
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(40, 40);
}



-( void )collectionView:( UICollectionView *)collectionView didSelectItemAtIndexPath:( NSIndexPath *)indexPath{
    NSLog(@"%ld",(long)indexPath.row);
    _page = indexPath.row + 1;
    if (_questionsArray.count != 0) {
        _analysisView.hidden = YES;
        self.model = self.questionsArray[indexPath.row];
//       [self reloadView];
        if ([_model.question_type isEqualToString:@"1"]) {
            NSString *danStr = @"单选题";
            self.typeLabel.text = danStr;
            NSString *questionlabelText = [NSString stringWithFormat:@"%@",   _model.question];
            //          NSString *questionlabelText = [NSString stringWithFormat:@" %@",  _model.question];
            self.questionlabelText = questionlabelText;
        }else{
            NSString *danStr = @"多选题";
            self.typeLabel.text = danStr;
            
            NSString *questionlabelText = [NSString stringWithFormat:@"%@", _model.question];
            self.questionlabelText = questionlabelText;
            
        }
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        
        [paragraphStyle setLineSpacing:4.0f];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_questionlabelText];
        NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:15.f], NSParagraphStyleAttributeName:paragraphStyle};
        CGFloat questionLabelH = [_questionlabelText boundingRectWithSize:CGSizeMake(KMainW - 85, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size.height;
        _questionlabel.attributedText = attributedString;
        _questionlabel.frame = CGRectMake( CGRectGetMaxX(self.typeLabel.frame)+ 5,12, KMainW - 85, questionLabelH);
     
        
        
        //刷新答案相关数据
        //    if ([_model.question_type intValue] < 4) {
        //答案选择视图，单选、多选、判断
        _answerView.hidden = NO;
        _fillAnswerView.hidden = YES;
        
        
        NSArray *arrays  = [NSMutableArray arrayWithCapacity:0];
        NSString *string = [_answerArray objectAtIndex:_page-1];

        if ([string isEqualToString:@""]) {
            arrays = nil;
        }else{
         arrays= [string componentsSeparatedByString:@"###"];
        
        }
        

        [_answerView reloadViewWithFrame:CGRectMake(0, CGRectGetMaxY(_questionlabel.frame) + 15, KMainW, 0) style:[_model.question_type intValue] - 1 answerArray:_model.question_selectArray userAnswers:arrays];
        
        //刷新底部试图数据 F
        if (_page <= _questionsArray.count) {
            self.footerView.totalQueLabel.text = [NSString stringWithFormat:@"%ld/%lu", indexPath.row + 1,(unsigned long)_questionsArray.count];
          
        }
        
//        for (NSString *title in _statudataArr) {
//            
//            NSLog(@"del.question,ti = %@   %@",_model.question,title);
//            if ([_model.question isEqualToString:title]) {
//                
//                [self loadViewanalyView];
//                  [self.footerView.btn setTitle:@"下一题" forState:UIControlStateNormal];
//            }else{
//                [self.footerView.btn setTitle:@"确定" forState:UIControlStateNormal];
//            }
//            }
        NSString *title  =  _model.question;
//        for ( _statudataArr containsObject:ti) {
        
            if ([_statudataArr containsObject:title]) {
                
                [self loadViewanalyView];
                if(_page ==_questionsArray.count){
                        [self.footerView.btn setTitle:@"提交" forState:UIControlStateNormal];
                }else{
                        [self.footerView.btn setTitle:@"下一题" forState:UIControlStateNormal];
                }
              
            }else{
                [self.footerView.btn setTitle:@"确定" forState:UIControlStateNormal];
            }
//        }
        
        [_collectionView removeFromSuperview];

    }
   
}


//提示框触发事件
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    NSLog(@"- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex");
//}
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
