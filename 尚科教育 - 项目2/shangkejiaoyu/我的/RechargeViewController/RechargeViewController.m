//
//  RechargeViewController.m
//  mingtao
//
//  Created by Linlin Ge on 2017/6/6.
//  Copyright © 2017年 Linlin Ge. All rights reserved.
//

#import "RechargeViewController.h"
#import "RechargeRecordViewController.h"
#import <StoreKit/StoreKit.h>
#import "XHPKit.h"
#import "AFHTTPSessionManager.h"
@interface RechargeViewController () <SKPaymentTransactionObserver,SKProductsRequestDelegate>
@property (nonatomic, strong) NSString *moneyID;
@property (nonatomic, strong) NSArray *labelArray;
@property (nonatomic, assign) NSInteger senderNumber;
@property (nonatomic, strong) NSArray *moneyArray;
@property (nonatomic, strong) NSString *order_sn;

@property (nonatomic, strong) NSArray *productIDArr;
@end

@implementation RechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = kCustomVCBackgroundColor;
    self.navigationController.navigationBar.barTintColor = kCustomNavColor;
    self.title = @"请选择充值条件";
    leftBarButton(@"returnImage");
    
    NSArray *array = @[@"6币",@"30币",@"50币",@"108币"];
    _labelArray = @[@"售价：6.00元",@"售价：30.00元（送5币）",@"售价：50.00元（送15币）",@"售价108.00元（送35币）"];
    for (NSInteger  i = 0; i < array.count ; i++ ) {
        _moneyNumberBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _moneyNumberBtn.frame = CGRectMake(10+(kScreenWidth/2.2+10)*(i%2), 30+(60+10)*(i/2), kScreenWidth/2.2  , 60);
        _moneyNumberBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _moneyNumberBtn.titleLabel.numberOfLines = 0;
        _moneyNumberBtn.layer.borderColor = kCustomViewColor.CGColor;
        _moneyNumberBtn.layer.borderWidth = 0.5f;
        _moneyNumberBtn.layer.cornerRadius = 3.0f;
        _moneyNumberBtn.layer.masksToBounds = YES;
        _moneyNumberBtn.tag = 1000 + i;
        _moneyNumberBtn.contentEdgeInsets = UIEdgeInsetsMake(-20,0, 0, 0);
        [_moneyNumberBtn addTarget:self action:@selector(moneyNumberBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        //button.frame = CGRectMake(按钮距离屏幕最左侧的距离+（按钮的宽+两个按钮的距离）*（i%按钮列数），按钮距离屏幕最上侧的距离+（按钮的高+两个按钮的上下距离）*（i/按钮列数），按钮的宽，按钮的高)；
        [_moneyNumberBtn setTitle:array[i] forState:UIControlStateNormal];
        [_moneyNumberBtn setTitleColor:kCustomViewColor forState:UIControlStateNormal];
        [_moneyNumberBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [self.bgView addSubview:self.moneyNumberBtn];
        
        _moneyNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(10+(kScreenWidth/2.2+10)*(i%2), 40+(60+10)*(i/2), kScreenWidth/2.2  , 60)];
        _moneyNumberLabel.textColor = kCustomViewColor;
        _moneyNumberLabel.font = [UIFont systemFontOfSize:10];
        _moneyNumberLabel.text = _labelArray[i];
        _moneyNumberLabel.tag = 10000 + i;
        _moneyNumberLabel.textAlignment = NSTextAlignmentCenter;
        [self.bgView addSubview:_moneyNumberLabel];
    }
    [self.recordBtn addTarget:self action:@selector(recordBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.rechargeBtn.userInteractionEnabled = NO;
    [self.rechargeBtn addTarget:self action:@selector(rechargeBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}

- (void)moneyNumberBtnClick:(UIButton *)sender {
    NSLog(@"%ld",(long)sender.tag);
    self.rechargeBtn.userInteractionEnabled = YES;
    
    _senderNumber = sender.tag;
    for (int i = 0; i<10; i ++) {
        if (sender.tag == 1000 + i) {
            sender.selected = YES;
            sender.backgroundColor = kCustomViewColor;
            [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            UILabel *label = (UILabel *)[self.view viewWithTag:10000 + i];
            label.textColor = [UIColor whiteColor];
            continue;
        }
        UIButton *btn = (UIButton *)[self.view viewWithTag:1000 + i];
        btn.selected = NO;
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitleColor:kCustomViewColor forState:UIControlStateNormal];
        
        UILabel *label = (UILabel *)[self.view viewWithTag:10000 + i];
        label.textColor = kCustomViewColor;
    }
}

- (void)rechargeBtnClick:(UIButton *)sender {
    NSLog(@"充值");
    NSLog(@"%ld",(long)_senderNumber);
    if (_senderNumber == 0) {
        
    }
    _moneyArray = @[@"6",@"30",@"50",@"108"];
    _productIDArr = @[@"6B",@"30B",@"50B",@"108B"];
    
    NSString *user = [[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];
    if (user != nil) {
        
        NSArray *bodyArr = @[@"充值：6.00元",@"充值：30.00元（送5币）",@"充值：50.00元（送15币）",@"充值108.00元（送35币）"];
        
        NSString *str = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/payment_order"];
        NSDictionary *dic = @{
                              @"shop_price":_moneyArray[_senderNumber - 1000],
                              @"uid":user,
                              @"goods_name":bodyArr[_senderNumber - 1000]
                              };
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];

        [HttpRequest postWithURLString:str parameters:dic success:^(id success) {
            NSLog(@"生成订单%@",success);
            _order_sn = success[@"order_sn"];
            _moneyID = [NSString stringWithFormat:@"%@", _productIDArr[_senderNumber - 1000]];

            // 设置购买队列的监听器
            [[SKPaymentQueue defaultQueue] addTransactionObserver:self];

            if([SKPaymentQueue canMakePayments]){
                //productID就是你在创建购买项目时所填写的产品ID
                [self requestProductData: _moneyID];
            }else{
                //            self.ringIndicator.hidden = YES;
                //                    NSLog(@"不允许程序内付费");
                UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                                     message:@"请先开启应用内付费购买功能。"
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles: nil];
                [alertError show];
            }

        } failure:^(NSError *error) {
            NSLog(@"生成订单%@",error);
        }];
        
//        NSString *user = [[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];
//
//        [HttpRequest postWithURLString:str parameters:dic success:^(id success) {
//              [MBProgressHUD hideHUDForView:self.view animated:YES];
//            NSLog(@"生成订单%@",success);
//            _order_sn = success[@"order_sn"];
//           _moneyID = [NSString stringWithFormat:@"%@", _productIDArr[_senderNumber - 1000]];
//            if ([user isEqualToString:@"27"]) {
//                // 设置购买队列的监听器
//                [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
//
//                if([SKPaymentQueue canMakePayments]){
//                    //productID就是你在创建购买项目时所填写的产品ID
//                    [self requestProductData: _moneyID];
//                }else{
//                    //            self.ringIndicator.hidden = YES;
//                    //                    NSLog(@"不允许程序内付费");
//                    UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:@"温馨提示"
//                                                                         message:@"请先开启应用内付费购买功能。"
//                                                                        delegate:nil
//                                                               cancelButtonTitle:@"确定"
//                                                               otherButtonTitles: nil];
//                    [alertError show];
//                }
//            }else {
//                if (_order_sn != nil) {
//                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择支付方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//                    UIAlertAction *ZFB = [UIAlertAction actionWithTitle:@"支付宝支付" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
//                        //ZFB
//                        [self ali:_order_sn];
//
//                    }];
////                    UIAlertAction *WX = [UIAlertAction actionWithTitle:@"微信支付" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
////                        //WX
////
////                        [self XHPKitWx:_order_sn];
////                    }];
//                    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
//                        [MBProgressHUD hideHUDForView:self.view animated:YES];
//                    }];
//                    [alertController addAction:ZFB];
////                    [alertController addAction:WX];
//                    [alertController addAction:cancel];
//                    [self presentViewController:alertController animated:YES completion:nil];
//
//
//
//                }else {
////                    EPLog(@"---没有生成订单---");
//
//                    [MBProgressHUD showMessage:@"请求失败，请稍后再试！" toView:self.view delay:1.0];
//                }
//            }
//        } failure:^(NSError *error) {
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//
//            NSLog(@"生成订单%@",error);
//            [MBProgressHUD showMessage:@"请求失败，请稍后再试！" toView:self.view delay:1.0];
//        }];
    }
    
}
#pragma  mark --------自己加支付宝支付 --------
  //  NSString *urlStr = @"https://app.mingtaokeji.com/index.php/Home/Pay/appPay";
- (void)ali:(NSString *)order_sn {

     NSString *urlStr = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/Home/Pay/appPay"];
  
        NSDictionary *dic = @{
                          @"id":order_sn,
                          };
    [HttpRequest postWithURLString:urlStr parameters:dic success:^(id success) {
        NSLog(@"订单详情%@",success);
        if(![XHPKit isAliAppInstalled]){
            NSLog(@"未安装ZFB");
            return;
        }

        NSString *app_id = [self utf:success[@"mygoods"][@"app_id"]];
        NSString *biz_content = [self utf:success[@"mygoods"][@"biz_content"]];
        NSString *format = [self utf:success[@"mygoods"][@"format"]];

        NSString *charset = [self utf:success[@"mygoods"][@"charset"]];
        NSString *method = [self utf:success[@"mygoods"][@"method"]];
        NSString *notify_url = [self utf:success[@"mygoods"][@"notify_url"]];
        NSString *sign_type = [self utf:success[@"mygoods"][@"sign_type"]];
        NSString *timestamp = [self utf:success[@"mygoods"][@"timestamp"]];
        NSString *version = [self utf:success[@"mygoods"][@"version"]];
        NSString *sign =success [@"mygoods"][@"sign"];

        NSString *str12e = [NSString stringWithFormat:@"app_id=%@&biz_content=%@&charset=%@&format=%@&method=%@&notify_url=%@&sign_type=%@&timestamp=%@&version=%@",app_id,biz_content,charset,format,method,notify_url,sign_type,timestamp,version];

        NSString *newsign = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)sign, NULL, (CFStringRef)@"!*'();:@&=+ $,./?%#[]", kCFStringEncodingUTF8));

        //ZFB订单签名,此签名由后台签名订单后生成,并返回给客户端(与官方SDK一致)
        //注意:请将下面值设置为你自己真实订单签名,便可进行实际支付
        NSString *orderSign = [NSString stringWithFormat:@"%@&sign=%@",str12e,newsign];
//        EPLog(@"------------%@",orderSign);

        //传入ZFB订单签名 和 自己App URL Scheme,拉起支付宝支付
        [[XHPKit defaultManager] alipOrder:orderSign fromScheme:@"XHPKitExample" completed:^(NSDictionary *resultDict) {
            NSLog(@"支付结果:\n%@",resultDict);
            NSInteger status = [resultDict[@"resultStatus"] integerValue];
            if(status == 9000){//支付成功
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [MBProgressHUD showMessage:@"充值成功！" toView:self.view delay:2.0];

            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    } failure:^(NSError *error) {
        NSLog(@"订单详情%@",error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showMessage:@"订单请求失败，请稍后再试！" toView:self.view delay:1.0];
    }];
}

- (NSString *)utf:(NSString *)str {
    NSString *strUTF = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return strUTF;
}
#pragma mark ------------------支付宝支付结束
#pragma mark - 请求商品
//请求商品
- (void)requestProductData:(NSString *)type{
    NSLog(@"-------------请求对应的产品信息----------------");
    NSArray *product = [[NSArray alloc] initWithObjects:type, nil];
    
    NSSet *nsset = [NSSet setWithArray:product];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
    request.delegate = self;
    [request start];
    //[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}

#pragma mark 收到产品返回信息
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    //        self.ringIndicator.hidden = YES;
    NSLog(@"--------------收到产品反馈消息---------------------");
    NSArray *product = response.products;
    if([product count] == 0){
        //            [self showHUDTipWithTitle:@"没有该商品"];
        NSLog(@"--------------没有商品------------------");
        return;
    }
    
    SKProduct *p = nil;
    for (SKProduct *pro in product) {
        NSLog(@"pro info");
        NSLog(@"SKProduct 描述信息：%@", [pro description]);
        NSLog(@"localizedTitle 产品标题：%@", [pro localizedTitle]);
        NSLog(@"localizedDescription 产品描述信息：%@", [pro localizedDescription]);
        NSLog(@"price 价格：%@", [pro price]);
        NSLog(@"productIdentifier Product id：%@", [pro productIdentifier]);
        
        if([pro.productIdentifier isEqualToString:_moneyID]){
            p = pro;
            NSString *money = [NSString stringWithFormat:@"%@",[pro price]];
        }else{
            NSLog(@"不不不相同");
        }
    }
    SKPayment *payment = [SKPayment paymentWithProduct:p];
    //    SKPayment *payment = [SKPayment paymentWithProductIdentifier:PayKey];
    NSLog(@"发送购买请求");
    [[SKPaymentQueue defaultQueue] addPayment:payment];

}

//请求失败
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    //     [self showHUDTipWithTitle:@"请求失败,错误"];
    //        self.ringIndicator.hidden = YES;
    NSLog(@"------------------错误-----------------:%@", error);
    UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Alert",NULL) message:[error localizedDescription]
                                                       delegate:nil cancelButtonTitle:NSLocalizedString(@"Close",nil) otherButtonTitles:nil];
    [alerView show];
}

- (void)requestDidFinish:(SKRequest *)request{
    //    [self showHUDTipWithTitle:@"反馈信息结束"];
    NSLog(@"------------反馈信息结束-----------------");
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

#pragma mark 监听购买结果
//监听购买结果
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
    //        self.ringIndicator.hidden = YES;
    NSLog(@" 监听购买结果 -----paymentQueue--------");
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:{
                NSLog(@"-----交易完成 --------");
                //交易完成
                [self commitSeversSucceeWithTransaction:transaction];
            }
            
                break;
            case SKPaymentTransactionStateFailed:{
                NSLog(@"-----交易失败 --------");
                //交易失败
                [self failedTransaction:transaction];
                
            }
                break;
            case SKPaymentTransactionStateRestored:{
                NSLog(@"-----已经购买过该商品(重复支付) --------");
                //已经购买过该商品
                [self restoreTransaction:transaction];
                //                 [self commitSeversSucceeWithTransaction:transaction];
                
                
            }
            case SKPaymentTransactionStatePurchasing:  {
                //商品添加进列表
                NSLog(@"-----商品添加进列表 --------");
            }
                break;
            default:
                break;
        }
    }
}

//交易结束
- (void)completeTransaction: (SKPaymentTransaction *)transaction
{
    NSLog(@" 交易结束 -----completeTransaction--------");
    
    // Remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}

- (void)commitSeversSucceeWithTransaction:(SKPaymentTransaction *)transaction
{
    
    NSString * productIdentifier = transaction.payment.productIdentifier;
    NSLog(@"productIdentifier Product id：%@", productIdentifier);
    NSString *transactionReceiptString= nil;
    
    //系统IOS7.0以上获取支付验证凭证的方式应该改变，切验证返回的数据结构也不一样了。
    
    
    if(iOS7 >= 7.0){
        // 验证凭据，获取到苹果返回的交易凭据
        // appStoreReceiptURL iOS7.0增加的，购买交易完成后，会将凭据存放在该地址
        NSURLRequest * appstoreRequest = [NSURLRequest requestWithURL:[[NSBundle mainBundle]appStoreReceiptURL]];
        NSError *error = nil;
        NSData * receiptData = [NSURLConnection sendSynchronousRequest:appstoreRequest returningResponse:nil error:&error];
        
        transactionReceiptString = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        
        NSString *bodyString = [NSString stringWithFormat:@"{\"receipt-data\":\"%@\"}",transactionReceiptString ];
        
        NSData *badyData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
        //创建请求到苹果官方进行购买验证
        //测试环境
//                NSString *urlStr = @"https://sandbox.itunes.apple.com/verifyReceipt";
        //发布环境
                NSString *urlStr = @"https://buy.itunes.apple.com/verifyReceipt";
        NSURL *url=[NSURL URLWithString:urlStr];
        NSMutableURLRequest *requestM = [NSMutableURLRequest requestWithURL:url];
        requestM.HTTPBody = badyData;
        requestM.HTTPMethod = @"POST";
        //创建连接并发送同步请求
        NSError *eerror=nil;
        NSData *responseData=[NSURLConnection sendSynchronousRequest:requestM returningResponse:nil error:&eerror];
        NSLog(@"--------eerror----------%@",eerror);
        if (eerror) {
            NSLog(@"验证购买过程中发生错误，错误信息：%@",error.localizedDescription);
            return;
        }
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",dic);
        if([dic[@"status"] intValue] == 0){
            NSLog(@"购买成功！");
            NSDictionary *dicReceipt= dic[@"receipt"];
            NSDictionary *dicInApp=[dicReceipt[@"in_app"] firstObject];
            NSString *productIdentifier= dicInApp[@"product_id"];//读取产品标识
            
            NSString *user = [[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];
            if ([user isEqualToString:@"1"]) {
                NSString *userMoneyStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"userMoney"];
                NSArray *touristsMoneyArray = @[@"6",@"35",@"65",@"143"];
                
                NSInteger a = [userMoneyStr intValue];
                NSString * b = touristsMoneyArray[_senderNumber - 1000];
                NSInteger c = [b intValue];
                NSString *userMoney = [NSString stringWithFormat:@"%ld",a + c];
                [[NSUserDefaults standardUserDefaults] setObject:userMoney forKey:@"userMoney"];
                
            }else {
                NSString *str = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/notifyios"];
                
                NSDate *date = [NSDate date];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateStyle:NSDateFormatterMediumStyle];
                [formatter setTimeStyle:NSDateFormatterShortStyle];
                [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
                NSString *DateTime = [formatter stringFromDate:date];
                NSArray *bodyArr = @[@"充值：6.00元",@"充值：30.00元（送5币）",@"充值：50.00元（送15币）",@"充值108.00元（送35币）"];
                
                NSDictionary *dic = @{
                                      @"out_trade_no":_order_sn,
                                      @"trade_status":@"TRADE_SUCCESS",
                                      @"body":bodyArr[_senderNumber - 1000],
                                      @"receipt_amount":_moneyArray[_senderNumber - 1000],
                                      @"trade_no":dicInApp[@"transaction_id"],//内购订单号
                                      @"notify_time":DateTime
                                      };
                [HttpRequest postWithURLString:str parameters:dic success:^(id success) {
                    NSLog(@"完成交易%@",success);
                    [self.navigationController popViewControllerAnimated:YES];
                } failure:^(NSError *error) {
                    NSLog(@"完成交易失败%@",error);
                }];
            }
            
            //如果是消耗品则记录购买数量，非消耗品则记录是否购买过
//             NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
//            if ([productIdentifier isEqualToString:@"123"]) {
//            int purchasedCount=[defaults integerForKey:productIdentifier];//已购买数量
//            [[NSUserDefaults standardUserDefaults] setInteger:(purchasedCount+1) forKey:productIdentifier];
//            }else{
//            [defaults setBool:YES forKey:productIdentifier];
//            }
            
        }
        
        
        
    }else{
        
        NSData * receiptData = transaction.transactionReceipt;
        //transactionReceiptString = [receiptData base64EncodedString];
        transactionReceiptString = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        
    }
    NSLog(@"transactionReceiptString == %@",transactionReceiptString);
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    // 向自己的服务器验证购买凭证
    [self                           SendRequestWithtransactionReceiptString:transactionReceiptString Transaction:transaction];
    
    
}

- (void)SendRequestWithtransactionReceiptString:(NSString *)transactionReceiptString Transaction:(SKPaymentTransaction *)transaction {
    
    
}
//记录交易
-(void)recordTransaction:(NSString *)product{
    NSLog(@"-----记录交易--------");
}

//处理下载内容
-(void)provideContent:(NSString *)product{
    NSLog(@"-----下载--------");
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    if(transaction.error.code != SKErrorPaymentCancelled) {
        NSLog(@"购买失败");
        UIAlertView *alerView2 =  [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                             message:@"购买该套餐失败，请重新尝试购买"
                                                            delegate:nil cancelButtonTitle:NSLocalizedString(@"关闭",nil) otherButtonTitles:nil];
        
        [alerView2 show];
    } else {
        NSLog(@"用户取消交易");
        
        UIAlertView *alerView2 =  [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                             message:@"您已取消该购买"
                                                            delegate:nil cancelButtonTitle:NSLocalizedString(@"关闭",nil) otherButtonTitles:nil];
        
        [alerView2 show];
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}


-(void) paymentQueueRestoreCompletedTransactionsFinished: (SKPaymentTransaction *)transaction{
    
}


- (void) restoreTransaction: (SKPaymentTransaction *)transaction
{
    NSLog(@" 交易恢复处理");
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}

- (void) paymentQueue:(SKPaymentQueue *) paymentQueue restoreCompletedTransactionsFailedWithError:(NSError *)error{
    NSLog(@"-------paymentQueue----");
}

#pragma mark connection delegate
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"connection==%@",  [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
}

-(void)dealloc
{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];//解除监听
}

- (void)recordBtnClick:(UIButton *)sender {
    RechargeRecordViewController *rechargeRecordVC = [RechargeRecordViewController new];
    rechargeRecordVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:rechargeRecordVC animated:YES];

}

- (void)leftButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
