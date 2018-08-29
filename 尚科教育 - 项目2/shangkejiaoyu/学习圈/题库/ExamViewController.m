//
//  ExamViewController.m
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2018/4/8.
//  Copyright © 2018年 ShangKe. All rights reserved.
//
#define fontsize [UIFont systemFontOfSize:13]

#import "ExamViewController.h"
#import "HWQuestionsModel.h"
#import "myExamCell.h"
#import "UILabel+Size.h"
#import "SelModel.h"
@interface ExamViewController ()
@property (nonatomic, strong) HWQuestionsModel *model;
@property (nonatomic, strong) NSMutableArray *questionsArray;
@property (nonatomic, strong) NSMutableArray *selArr;
@property (nonatomic, strong) SelModel *selModel;
@property (nonatomic,assign)NSInteger i;


@end

@implementation ExamViewController

- (NSMutableArray *)questionsArray
{
    if (!_questionsArray) {
        _questionsArray = [NSMutableArray array];
    }
    
    return _questionsArray;
}

- (NSMutableArray *)selArr
{
    if (!_selArr) {
        _selArr = [NSMutableArray array];
    }
    
    return _selArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    leftBarButton(@"returnImage");
 self.i = 1;
   [self.tableView registerClass:[myExamCell class] forCellReuseIdentifier:@"mycell"];
    [self initData];
    
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
            NSLog(@"----=查看问题信息-----%@",result);
            
            NSString *stuStr = [NSString stringWithFormat:@"%@", result[@"status"]];
            if ( [stuStr isEqualToString:@"1"]) {
                NSArray *array = result[@"body"];
                for (NSDictionary *dic in array) {
                    self.model = [[HWQuestionsModel alloc] initWithDic:dic];
                    [self.questionsArray addObject:_model];
                }
                NSString *JSONString = result[@"exams"];
                // 字符串进行UTF8编码, 编码为流
                NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
                // 将流转换为字典
                NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
                NSLog(@"1 == %@",dataDict);
                for (NSDictionary *userSeldic in dataDict[@"body"]) {
                    self.selModel = [[SelModel alloc] initWithDic:userSeldic];
                    [self.selArr addObject:_selModel];
                }

                NSLog(@"ccc =%@   bb = %@",_questionsArray,_selArr);
                [self.tableView reloadData];
            }
            
        } failure:^(NSError *NSError) {
        }];
    }
}

//json字符串转为字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
//        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _questionsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

//    static NSString *ID = @"cell";
//
//    myExamCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
//    
//  //  如果队列中没有该类型cell，则会返回nil，这个时候就需要自己创建一个cell
//    if (!cell) {
//         cell = [[myExamCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
//    }
    
     myExamCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell" forIndexPath:indexPath];
        // 禁止选中
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        cell.selected  = NO;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
       self.model = self.questionsArray[indexPath.row];

        SelModel  *selModel = self.selArr[indexPath.row];
    
        
        if ([_model.question_type isEqualToString:@"1"]) {
            NSString *danStr = @"单选题";
            cell.queaTypeLabel.text = danStr;
        }else{
            NSString *danStr = @"多选题";
            cell.queaTypeLabel.text = danStr;
        }
        
        cell.queaTitleLabel.text = _model.question;
        CGSize titleHSize = [cell.queaTitleLabel boundingRectWithSize:CGSizeMake(kScreenWidth -90, MAXFLOAT)];
        
        cell.queaTitleLabel.frame = CGRectMake(CGRectGetMaxX(cell.queaTypeLabel.frame)+5, 12, kScreenWidth-90, titleHSize.height);
        
        //问题试图加载
        NSArray *arrays  = [NSMutableArray arrayWithCapacity:0];
        NSString *string = selModel.select;
        if ([string isEqualToString:@""]) {
            arrays = nil;
        }else{
            arrays= [string componentsSeparatedByString:@"###"];
            
        }
         [cell.answerView reloadViewWithFrame:CGRectMake(0, CGRectGetMaxY(cell.queaTitleLabel.frame) + 15, KMainW, 0) style:[_model.question_type intValue] - 1 answerArray:_model.question_selectArray  userAnswers:arrays];
        
     //   NSLog(@"aaa = %@  ",cell.answerView.selectAnswer);
       

        //  解析试图加载
        cell.analyView.line.hidden = YES;
        if ([selModel.select rangeOfString:@"|"].location == NSNotFound ) {
          //  NSLog(@"aaa = %@   bbb = %@",selModel.select,_model.question);

            if ([selModel.select isEqualToString:_model.question_answer] ) {
                cell.analyView.tfView.image = [UIImage imageNamed:@"exerc_analysisView_right"];
                
            }else{
                
                cell.analyView.tfView.image = [UIImage imageNamed:@"exerc_analysisView_fause"];
                
            }

        }else{
            
           // NSLog(@"sel = %@   model = %@",selModel.select,_model.question);

            NSString *strUrl = [selModel.select stringByReplacingOccurrencesOfString:@"|" withString:@"###"];
            
            if ([strUrl isEqualToString:_model.question_answer] ) {
                cell.analyView.tfView.image = [UIImage imageNamed:@"exerc_analysisView_right"];
                
            }else{
                cell.analyView.tfView.image = [UIImage imageNamed:@"exerc_analysisView_fause"];
                
            }

        }
        
        if ([_model.question_answer rangeOfString:@"###"].location == NSNotFound){
            cell.analyView.trueAnswerLabel.text = [NSString stringWithFormat:@"答案：%@", _model.question_answer];
        }else{
            NSString *strUrl = [_model.question_answer stringByReplacingOccurrencesOfString:@"###" withString:@","];
            cell.analyView.trueAnswerLabel.text = [NSString stringWithFormat:@"答案：%@", strUrl];
        }

      
      
        cell.analyView.anaInfoLabel.text = _model.question_describe;
        
        CGFloat labelW = kScreenWidth - 20;

        CGSize titleSize = [cell.analyView.trueAnswerLabel boundingRectWithSize:CGSizeMake(kScreenWidth -20, MAXFLOAT)];
        
        
        CGFloat trueAnswerLabelH = titleSize.height;
        cell.analyView.trueAnswerLabel.frame = CGRectMake(10, 40, labelW, trueAnswerLabelH);
        
        //刷新解析详情标签
        
        CGSize inSize = [cell.analyView.anaInfoLabel boundingRectWithSize:CGSizeMake(kScreenWidth - 20, MAXFLOAT)];
        
        CGFloat anaInfoLabelH = inSize.height;
        
        cell.analyView.anaInfoLabel.frame = CGRectMake(10, CGRectGetMaxY(cell.analyView.trueAnswerLabel.frame) +2, labelW, anaInfoLabelH);
        
        //刷新视图区域
        cell.analyView.anaView.hidden = NO;
        cell.analyView.anaView.frame = CGRectMake(0, 44, KMainW, 15 + 15 + 10 + trueAnswerLabelH + 10 + anaInfoLabelH);
        cell.analyView.frame = CGRectMake(0, CGRectGetMaxY(cell.answerView.frame) + 10, kScreenWidth, 44 + cell.analyView.anaView.frame.size.height);
        
        //改变自身区
        CGRect frame = cell.analyView.frame;
        frame.size.height = 44 + cell.analyView.anaView.bounds.size.height;
        CGFloat temH =  CGRectGetMaxY(cell.answerView.frame) + frame.size.height + 20;
        
        self.tableView.rowHeight = temH;

        NSLog(@"ccc = %@",_model.question);
    
    
    _i++;
    return cell;
}

//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 350;
//}


//返回按钮点击事件
- (void)leftButton:(UIBarButtonItem *)item{
    [self.navigationController popViewControllerAnimated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
