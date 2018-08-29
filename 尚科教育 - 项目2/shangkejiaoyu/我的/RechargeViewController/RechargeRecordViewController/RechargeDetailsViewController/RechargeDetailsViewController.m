//
//  RechargeDetailsViewController.m
//  mingtao
//
//  Created by Linlin Ge on 2017/6/7.
//  Copyright © 2017年 Linlin Ge. All rights reserved.
//

#import "RechargeDetailsViewController.h"
#import "RechargeDetailsCell.h"

@interface RechargeDetailsViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView  *tableView;
@property (nonatomic, strong) NSDictionary *dataDic;
@property (nonatomic, copy)   NSNumber     *code;
@end

@implementation RechargeDetailsViewController

- (UITableView *)tableView {
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.backgroundColor = kCustomColor(229, 236, 236);
        
        [self.tableView registerNib:[UINib nibWithNibName:@"RechargeDetailsCell" bundle:nil] forCellReuseIdentifier:@"rechargeDetailsCell"];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kCustomVCBackgroundColor;
    self.title = @"交易详情";
    leftBarButton(@"returnImage");
    
    [self.view addSubview:self.tableView];
    
    NSString *str = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/account_info"];
    NSDictionary *dic = @{
                          @"order_sn":_order_sn,
                          @"change_type":_change_type,
                          };
    NSLog(@"%@",dic);
    [HttpRequest postWithURLString:str parameters:dic success:^(id success) {
        NSLog(@"交易详情%@",success);
        _dataDic = success[@"body"];
        _code = success[@"code"];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"交易详情%@",error);
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        RechargeDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rechargeDetailsCell" forIndexPath:indexPath];
    if ([_code isEqualToNumber:@3]) {
        switch (indexPath.row) {
            case 0:
                cell.nameLabel.text = @"充值金额";
                cell.detailsLabel.text = _dataDic[@"order_amount"];
                cell.detailsLabel.textColor = kCustomColor(255, 155, 0);
                break;
            case 1:
                cell.nameLabel.text = @"支付状态";
                cell.detailsLabel.text = _dataDic[@"trade_status"];
                break;
            case 2:
                cell.nameLabel.text = @"支付方式";
                cell.detailsLabel.text = _dataDic[@"pay_name"];
                break;
            case 3:
                cell.nameLabel.text = @"支付创建时间";
                cell.detailsLabel.text = [self getTimeString:_dataDic[@"add_time"]];
                break;
            case 4:
                cell.nameLabel.text = @"交易订单号";
                cell.detailsLabel.text = _dataDic[@"order_sn"];
                break;
            case 5:
                cell.nameLabel.text = @"交易流水号";
                cell.detailsLabel.text = _dataDic[@"trade_no"];
                break;
            default:
                break;
        }
    }else {
        switch (indexPath.row) {
            case 0:
                cell.nameLabel.text = @"消费名称";
                cell.detailsLabel.text = _dataDic[@"goods_name"];
                break;
            case 1:
                cell.nameLabel.text = @"支付时间";
                cell.detailsLabel.text = [self getTimeString:_dataDic[@"pay_time"]];
                break;
            case 2:
                cell.nameLabel.text = @"消费金额";
                cell.detailsLabel.text = _dataDic[@"pay_money"];
                break;
            case 3:
                cell.nameLabel.text = @"消费类型";
                cell.detailsLabel.text = _dataDic[@"change_desc"];
                break;
            default:
                break;
        }
    }
    
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([_code isEqualToNumber:@5]) {
        return 4;
    }else {
        return 6;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 45.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        UIView *header = [[UIView alloc] init];
        header.frame = CGRectMake(0, 0, kScreenWidth, 0.01);
        return header;
        
    }
    UIView *header = [[UIView alloc] init];
    header.frame = CGRectMake(0, 0, kScreenWidth, 10);
    
    return header;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *header = [[UIView alloc] init];
    header.frame = CGRectMake(0, 0, kScreenWidth, 0.01);
    return header;
}
- (void)leftButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSString *)getTimeString:(NSString *)timeStringe {
    NSTimeInterval time=[timeStringe doubleValue];
    NSDate *compareDate = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    formater.dateFormat = @"YYYY-MM-dd  HH:mm:ss";
    NSString *timeStr = [formater stringFromDate:compareDate];
    
    return timeStr;
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
