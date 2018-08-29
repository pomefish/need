//
//  ExchangeMoneyViewController.m
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2018/5/14.
//  Copyright © 2018年 ShangKe. All rights reserved.
//

#import "ExchangeMoneyViewController.h"
#import "changeMoneyView.h"
@interface ExchangeMoneyViewController ()<UITextFieldDelegate>
@property (nonatomic,strong)UILabel *numLabel;
@property (nonatomic,strong)UILabel *totalLabel;
@property (nonatomic,strong)UIButton  *changeButton;
@property (nonatomic,strong)UIImageView *imgeView;
@property (nonatomic,strong)changeMoneyView *changeView;
@property (nonatomic,strong)UIView *bgView;



@end

@implementation ExchangeMoneyViewController

- (UIView *)bgView{
    if (!_bgView) {
        self.bgView = [[UIView alloc] initWithFrame:self.view.bounds];
        _bgView.backgroundColor = [UIColor blackColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgAction:)];
        [self.bgView addGestureRecognizer:tap];
        _bgView.alpha = 0.7;
    }
    return _bgView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"邀请好友";
     self.navigationController.navigationBar.barTintColor = kCustomNavColor;
    leftBarButton(@"returnImage");
    self.imgeView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight)];
    _imgeView.image = [UIImage imageNamed:@"inviteMoney.jpg"];
    _imgeView.userInteractionEnabled = YES;
    [self.view addSubview:_imgeView];
    
//    CGFloat hhimage = 0.578 *kScreenWidth;
    
   // CGFloat widthImage = 358;
    CGFloat widthImage = 0.955 *kScreenWidth;
     CGFloat hhimage = widthImage/1.5;

     UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - widthImage)/2, 10, widthImage,widthImage/1.5)];
    headImageView.image = [UIImage imageNamed:@"yue"];
    [_imgeView addSubview:headImageView];
    
    CGFloat hh = 30;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 50, headImageView.frame.size.width - 45, hh)];
    titleLabel.text = @"我的赏金：";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:21];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [headImageView addSubview:titleLabel];
    
    CGFloat hhNUm = 30;
    self.numLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, (hhimage - 10 - hh -hhNUm)/2 +35, headImageView.frame.size.width - 40, 30)];
    _numLabel.textColor = [UIColor whiteColor];
    _numLabel.font = [UIFont systemFontOfSize:22];
    _numLabel.textAlignment = NSTextAlignmentCenter;
  //  _numLabel.text = [NSString stringWithFormat:@"￥%@学习币",self.userMoney];
    
 //  NSString *strText = [NSString stringWithFormat:@"￥%@学习币",self.userMoney];
    NSString *string1 = @"￥";
    NSString *lastM =   [[NSUserDefaults standardUserDefaults] objectForKey:@"lastMoney"];
    if(lastM == nil){
         NSString *string2 =  [NSString stringWithFormat:@"￥%@学习币",self.userMoney];
        long len1 = [string1 length];
        long len2 = [self.userMoney length];
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:string2];
        [text addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:32] range:NSMakeRange(len1,len2)];
        
        _numLabel.attributedText = text;
        [headImageView addSubview:_numLabel];
    }else{
           NSString *string2 =  [NSString stringWithFormat:@"￥%@学习币",lastM];
        long len1 = [string1 length];
        long len2 = [lastM length];
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:string2];
        [text addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:32] range:NSMakeRange(len1,len2)];
        
        _numLabel.attributedText = text;
        [headImageView addSubview:_numLabel];
    }
   
   
    
    
//   CGFloat hhBag = 0.96 *kScreenWidth;//白色总高度
    
     UIImageView *footImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - widthImage)/2, CGRectGetMaxY(headImageView.frame)-40, widthImage,0.95 *widthImage)];
    footImageView.image = [UIImage imageNamed:@"whiteBag"];
    footImageView.userInteractionEnabled = YES;
    [_imgeView addSubview:footImageView];
    
    CGFloat labelH = 30;
    CGFloat totalh = kScreenWidth *0.24;//头部白色高度
    UILabel *headL = [[UILabel alloc] initWithFrame:CGRectMake(0, (totalh - labelH)/2+8 +20, footImageView.frame.size.width, labelH)];
    headL.text = @"邀请好友注册兑换";
    headL.textColor = [UIColor colorWithHexString:@"#E8363B"];
    headL.font = [UIFont systemFontOfSize:21];
    headL.textAlignment = NSTextAlignmentCenter;
    [footImageView addSubview:headL];
    
    
    CGFloat whiteH = 0.69 *kScreenWidth;//下面白色高度
    

    
    
    
    CGFloat padding = (whiteH -30 -30 - 20 - 30 - 10)/2;//中间2个的间距
    self.totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0.24 *kScreenWidth +35, footImageView.frame.size.width, labelH)];
    _totalLabel.text = @"1*5=5学习币";
    _totalLabel.textColor =  [UIColor colorWithHexString:@"#E8363B"];

    _totalLabel.font = [UIFont systemFontOfSize:28];
    _totalLabel.textAlignment = NSTextAlignmentCenter;
    [footImageView addSubview:_totalLabel];
    
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_totalLabel.frame)+padding - 35, footImageView.frame.size.width - 20, 20)];
    textLabel.text = @"*注册满5个起兑，每日可兑一次";
    textLabel.textColor = [UIColor blackColor];
    textLabel.font = [UIFont systemFontOfSize:14];
    textLabel.textAlignment = NSTextAlignmentCenter;
    [footImageView addSubview:textLabel];
    
    self.changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _changeButton.frame = CGRectMake((footImageView.frame.size.width - 180)/2, CGRectGetMaxY(textLabel.frame)+padding-50, 180, 50);
    [_changeButton setBackgroundImage:[UIImage imageNamed:@"change"] forState:UIControlStateNormal];
    [_changeButton addTarget:self action:@selector(handleChange:) forControlEvents:UIControlEventTouchUpInside];
    [footImageView addSubview:_changeButton];
    [self addNoticeForKeyboard];
    
}

#pragma mark - 键盘通知
- (void)addNoticeForKeyboard {
    
    //注册键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    //注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

///键盘显示事件
- (void) keyboardWillShow:(NSNotification *)notification {
    
    //获取键盘高度，在不同设备上，以及中英文下是不同的
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    //计算出键盘顶端到inputTextView panel底端的距离(加上自定义的缓冲距离INTERVAL_KEYBOARD)

//    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//
//    //将视图上移计算好的偏移

     CGFloat widthImage = 0.955 *kScreenWidth;
    [UIView animateWithDuration:duration animations:^{
        _changeView.frame =  CGRectMake((kScreenWidth - widthImage)/2, kScreenHeight - 225 - kbHeight , widthImage, 225);
                }];
}

///键盘消失事件
- (void) keyboardWillHide:(NSNotification *)notify {
    // 键盘动画时间
    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //视图下沉恢复原状
    CGFloat widthImage = 0.955 *kScreenWidth;

    [UIView animateWithDuration:duration animations:^{
       self.changeView.frame = CGRectMake((kScreenWidth - widthImage)/2, kScreenHeight - 225, widthImage, 225);
    }];
}

- (void)leftButton:(UIButton*)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)handleChange:(UIButton *)btn{
  
    NSInteger money = [self.userMoney integerValue];
    if(money < 5){
        [MBProgressHUD showMessage:@"邀请好友注册满5金币可兑换！" toView:self.view delay:2.0];
    }
    else{
        CGFloat widthImage = 0.955 *kScreenWidth;
  
    self.changeView = [[changeMoneyView alloc]initWithFrame:CGRectMake((kScreenWidth - widthImage)/2, kScreenHeight - 225, widthImage, 225)];
        _changeView.amountTF.delegate = self;
    [_changeView.affirmBtn addTarget:self action:@selector(affirmAction:) forControlEvents:UIControlEventTouchUpInside];
    _changeView.backgroundColor = [UIColor colorWithHexString:@"#EDEDED" alpha:1.0];
    _changeView.amountTF.inputAccessoryView = [self addToolbar];
    [self.view addSubview:_changeView];

    }
}


- (UIToolbar *)addToolbar {
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 30)];
    toolbar.tintColor = [UIColor blackColor];
    toolbar.backgroundColor = [UIColor lightGrayColor];
    UIBarButtonItem *prevItem = [[UIBarButtonItem alloc] initWithTitle:@"  <  " style:UIBarButtonItemStylePlain target:self action:nil];
    UIBarButtonItem *nextItem = [[UIBarButtonItem alloc] initWithTitle:@"  >  " style:UIBarButtonItemStylePlain target:self action:nil];
    UIBarButtonItem *flbSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
  
    UIBarButtonItem *doneItem =   [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"完成",nil) style:UIBarButtonItemStylePlain target:self action:@selector(textFieldDone)];

    toolbar.items = @[prevItem,nextItem,flbSpace, doneItem];
    return toolbar;
}
- (void)affirmAction:(UIButton *)sender{

    NSInteger money = [self.userMoney integerValue];
        if(money < 5){
            [MBProgressHUD showMessage:@"邀请好友注册满5金币可兑换！" toView:self.view delay:3.0];
        }else if ([_changeView.amountTF.text integerValue] > money){
             [MBProgressHUD showMessage:@"请输入正确的数额" toView:self.view delay:2.0];
        }
        else{
            
             NSString *str = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/add_account"];
            
            NSDictionary *userDic = @{
                                      @"uid":USERID,
                              @"amount":_changeView.amountTF.text
                                      };
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];

            [HttpRequest postWithURLString:str parameters:userDic success:^(id result) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                NSLog(@"----兑换----%@",result);
                NSString *strStatus = [NSString stringWithFormat:@"%@",result[@"status"]];
                if ([strStatus isEqualToString:@"1"]) {
                    [MBProgressHUD showMessage:@"兑换成功！" toView:self.view delay:3.0];
                    [_changeView removeFromSuperview];
                    NSInteger changeMoney = [_changeView.amountTF.text integerValue];
                    NSInteger totalMoney = [self.userMoney integerValue];
               
                    NSString *lastMoney = [NSString stringWithFormat:@"%ld",totalMoney - changeMoney];
                    [[NSUserDefaults standardUserDefaults] setObject:lastMoney forKey:@"lastMoney"];
                    
                    
                }
            } failure:^(NSError *error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [MBProgressHUD showMessage:@"兑换失败！" toView:self.view delay:3.0];
            }];

      }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    [self.changeView.amountTF resignFirstResponder];
    self.changeView.hidden = YES;
}

- (void)textFieldDone{
    [self.changeView.amountTF resignFirstResponder];


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
