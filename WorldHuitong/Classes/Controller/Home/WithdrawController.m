//
//  WithdrawController.m
//  WorldHuitong
//
//  Created by TXHT on 16/4/11.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import "WithdrawController.h"
#import "RechargeView.h"
#import "GTMBase64.h"
#import "WithdtaDetaileController.h"
#import "TiXianMoneyNotController.h"
@interface WithdrawController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)UIButton *tempButton;
@property(nonatomic,assign)BOOL isHaveDian;
@property(nonatomic,strong)RechargeView *headView;


@end

@implementation WithdrawController

-(RechargeView *)headView
{
    if (!_headView) {
      _headView = [[[NSBundle mainBundle] loadNibNamed:@"RechargeView" owner:self options:nil] lastObject];
        
        [[HTView shareHTView] setView:_headView.bg_view cornerRadius:4];
        [[HTView shareHTView] setView:_headView.submit cornerRadius:4];
        _headView.wangYingTableBtn.hidden = YES;
        _headView.title.text = @"提现金额";
        _headView.textField.delegate = self;
        _tempButton = _headView.submit;
        _headView.alterTitle.text = @"注意：根据央行规定通知，为客户安全考虑，通过快捷支付充值的资金到账后提现只能提到同一张卡，如需帮助，请联系客服:400-168-0111。";
        [_headView.textField addTarget:self action:@selector(changeNumber:) forControlEvents:UIControlEventEditingChanged];
        
        [_headView.submit addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView)];
        [_headView addGestureRecognizer:tap];
        
    }
    return _headView;


}
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    [self creatNavigationBar];
    
}

#pragma ----UITableViewDataSource----
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell  = [[UITableViewCell alloc]init];
    }
    return cell;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    float balance = [[NSUserDefaults standardUserDefaults]floatForKey:@"balance"];

    if (balance >= 100) {
        self.headView.textField.placeholder = [NSString stringWithFormat:@"可提现金额:%.2f",balance];
    }else{
        self.headView.textField.placeholder = [NSString stringWithFormat:@"可提现金额:0.00"];
    }
    
    return self.headView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 260;
}

#pragma ----事件处理----
-(void)changeNumber:(UITextField*)sender
{
    if ([sender.text isEqualToString:@""]) {
        _tempButton.backgroundColor = [UIColor lightGrayColor];
        _tempButton.enabled = NO;
    }
    else{
        _tempButton.backgroundColor = HT_COLOR;
        _tempButton.enabled = YES;
    }
}

-(void)submit
{
    [_headView.textField resignFirstResponder];
    
    
    //检测网络
    [HTView isWiffOnView:self.view];
    
    if ([_headView.textField.text floatValue] < 100) {
        
        [HTView alterTitle:@"提现金额不能小于100.00元"];
    }else if ([_headView.textField.text floatValue] >= 10000000) {
        
        [HTView alterTitle:@"超过10000000.00元请您去官网提现"];
    }else{
       
        [[Tools shareTools]progressWithTitle:@"请稍候..." OnView:self.view];
        NSString *inforStr = [[Tools shareTools]dictionaryToJson:@{@"client_type":@"IOS"}];
        NSString *infor = [GTMBase64 encodeBase64String:inforStr];
        NSDictionary*diccc = @{
                               @"method":@"post",
                               @"module":@"trust",
                               @"q":@"cash",
                               @"user_id":[Tools HtUserId],
                               @"money":[NSNumber numberWithFloat:[_headView.textField.text floatValue]],
                               @"info":infor
                               };
        
        NSString *str = [[Tools shareTools]dictionaryToJson:diccc];
        NSString *strHT = [[Tools shareTools]htstr:str];
        NSString *md5Par = [[Tools shareTools] md5:strHT];
        NSDictionary *par = @{@"diyou":str,@"sign":md5Par};
        
        [HYBNetworking getWithUrl:kBaseUrl refreshCache:NO params:par success:^(id response) {
//          NSLog(@"%@",response);
            
            [[Tools shareTools]hidenHud];
            if ([response[@"result"] isEqualToString:@"error"]) { //失败
                
                [Tools alterWithTitle:response[@"error_remark"]];
            }else{                                                //成功
                
                if (response[@"data"]) {     //成功返回的提示
                    if ([response[@"data"][@"result"] isEqualToString:@"false"]) {
                       
                        [Tools alterWithTitle:response[@"data"][@"remark"]];

                    }else{                   //无提示->完成提现
                    
                        NSString *baseUrl = [GTMBase64 decodeBase64String:response[@"data"][@"form"]];
                        NSString *utfUrl = [baseUrl stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                        self.hidesBottomBarWhenPushed = YES;
                        WithdtaDetaileController *WithdtaDetail  = [[WithdtaDetaileController alloc]init];
                        WithdtaDetail.url = utfUrl;
                        [self.navigationController pushViewController:WithdtaDetail animated:YES];

                    }
                }
                
            }
            
        } fail:^(NSError *error) {
            [[Tools shareTools]hidenHud];
            
        }];

        
    }
    
}

#pragma ----UITextFieldDelegate----

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField.text rangeOfString:@"."].location==NSNotFound) {
        _isHaveDian = NO;
    }
    if ([string length]>0)
    {
        unichar single=[string characterAtIndex:0];//当前输入的字符
        if ((single >='0' && single<='9') || single=='.')//数据格式正确
        {
            //首字母不能为0和小数点
            if([textField.text length]==0){
                if(single == '.'){
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
                if (single == '0') {
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            if (single=='.')
            {
                if(!_isHaveDian)//text中还没有小数点
                {
                    _isHaveDian=YES;
                    return YES;
                }else
                {
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            else
            {
                if (_isHaveDian)//存在小数点
                {
                    //判断小数点的位数
                    NSRange ran=[textField.text rangeOfString:@"."];
                    NSInteger tt = range.location - ran.location;
                    if (tt <= 2){
                        return YES;
                    }else{
                        return NO;
                    }
                }
                else
                {
                    return YES;
                }
            }
        }else{//输入的数据格式不正确
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    else
    {
        return YES;
    }
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_headView.textField resignFirstResponder];
    return YES;
}

-(void)tapView
{
    [_headView.textField resignFirstResponder];
}

-(void)creatNavigationBar
{
    UIBarButtonItem *rigthBtn = [[UIBarButtonItem alloc]initWithTitle:@"提现记录" style:UIBarButtonItemStylePlain target:self action:@selector(tixianNote)];
    self.navigationItem.rightBarButtonItem = rigthBtn;
    
    self.tableView.tableFooterView = [[UIView alloc]init];

}

//提现记录
-(void)tixianNote
{
    self.hidesBottomBarWhenPushed = YES;
    TiXianMoneyNotController *moneyNoteVC = [[TiXianMoneyNotController alloc]init];
    [self.navigationController pushViewController:moneyNoteVC animated:YES];
    
}

@end
