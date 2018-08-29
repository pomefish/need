//
//  MoreTableViewController.m
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2018/3/28.
//  Copyright © 2018年 ShangKe. All rights reserved.
//

#import "MoreTableViewController.h"
#import "MoreViewCell.h"
#import "HttpRequest.h"
@interface MoreTableViewController ()
@property (nonatomic,assign)CGFloat titleH;
@property (nonatomic,assign)CGFloat middleH;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation MoreTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    // 要文字
   
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSFontAttributeName:[UIFont systemFontOfSize:15],
                                                                       NSForegroundColorAttributeName:[UIColor redColor]}];
    
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"免费课程" style:UIBarButtonItemStylePlain target:nil action:nil];
//    [self.navigationItem.backBarButtonItem setImage:[UIImage imageNamed:@"returnImage"]];
//    
//    //注册cell
    [self.tableView registerClass:[MoreViewCell class] forCellReuseIdentifier:@"cell"];
    
    
    [self requestData];
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
    
    if (self.tag == 2) {
        return _dataArr.count;
        
    }else{
        return _dataArray.count;
    }}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MoreViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    self.titleH = cell.titleHeight;
    self.middleH = cell.middleHeight;
    if (self.tag == 1) {
        NSLog(@"ttttt = %ld",(long)self.tag);
        moreModel *model = self.dataArr[indexPath.row];
        NSLog(@"名字= %@",model.title);
        cell.model = model;

    }else{
        moreModel *model = self.dataArray[indexPath.row];
        cell.model = model;

   }

    // Configure the cell...
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat hh = 0.66 *kScreenWidth *0.4 + 20 ;
//     MoreViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    CGFloat HHH = 10 + self.titleH + 10 + self.middleH + 35;
   NSLog(@"高度= %f",self.titleH);
    return hh ;
}


- (void)requestData{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/free_video"];
    NSDictionary *did = @{@"":@""};
   
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/new_video"];
    if (self.idid) {
        self.dataArray = [NSMutableArray arrayWithCapacity:0];

        NSDictionary *di = @{@"cat_id":self.idid};
        
        NSLog(@"自己的ID= %@",_idid );
        [HttpRequest postWithURLString:urlString parameters:di success:^(id success) {
            NSLog(@"--22222Data----------%@",success);
            NSArray *arr = success[@"body"];
            self.dataArr = [NSMutableArray arrayWithCapacity:0];
            for (NSDictionary *dic in arr) {
                moreModel *model = [[moreModel alloc] initWithDic:dic];
                [self.dataArray addObject:model];
            }
            
            [self.tableView reloadData];
            
        } failure:^(NSError *error) {
            
        }];
        

    }else{
        [HttpRequest postWithURLString:urlStr parameters:did success:^(id success) {
            NSLog(@"--momomo----------%@",success);
            NSArray *arr = success[@"body"];
            self.dataArr = [NSMutableArray arrayWithCapacity:0];
            
            for (NSDictionary *dic in arr) {
                moreModel *model = [[moreModel alloc] initWithDic:dic];
                [self.dataArr addObject:model];
            }
            NSLog(@"111111请求的数组= %@",_dataArr);
            [self.tableView reloadData];
            
            
        } failure:^(NSError *error) {
            
        }];
    }
    
    
}




//左按钮返回
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
