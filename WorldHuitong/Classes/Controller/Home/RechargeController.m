//
//  RechargeController.m
//  WorldHuitong
//
//  Created by TXHT on 16/4/11.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import "RechargeController.h"
#import "RechargeView.h"
#import "GTMBase64.h"
#import "RechargeDetaileController.h"
#import "MoneyNoteViewController.h"   //记录
#import "ZiJingDaoZahngController.h"
@interface RechargeController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)UIButton *tempButton;
@property(nonatomic,strong)RechargeView *headView;
@property(nonatomic,assign)BOOL isHaveDian;
@end

@implementation RechargeController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self creatNavigationBar];
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.showsVerticalScrollIndicator = NO;


}


#pragma ----UITableViewDataSource----
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{return 0;}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    _headView = [[RechargeView alloc]initRview:self Button:nil];
    _headView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeigth - 64);
    _headView.title.text = @"充值金额";
     _tempButton = _headView.submit;
    _headView.textField.delegate = self;
    [_headView.wangYingTableBtn setTitleColor:HT_COLOR forState:UIControlStateNormal];
    [_headView.wangYingTableBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView)];
    [_headView addGestureRecognizer:tap];
    
    [_headView.textField addTarget:self action:@selector(changeNumber:) forControlEvents:UIControlEventEditingChanged];
    [_headView.wangYingTableBtn addTarget:self action:@selector(wangYingTableAction) forControlEvents:UIControlEventTouchUpInside];
    [_headView.submit addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    
    return _headView;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{ return kScreenHeigth - 64;}


#pragma ***************处理事件**********************************
-(void)wangYingTableAction
{
    self.hidesBottomBarWhenPushed = YES;
   ZiJingDaoZahngController *wangyingTable =  [[ZiJingDaoZahngController alloc]init];
    wangyingTable.url = @"https://www.huitongp2p.com/api/recommend/recharge_info.php";
    wangyingTable.headTitle = @"网银充值银行限额参考表";
    [self.navigationController pushViewController:wangyingTable animated:YES];

}
-(void)submit
{
    //检测网络
    [HTView isWiffOnView:self.view];
    
    [_headView.textField resignFirstResponder];
   
    if ([_headView.textField.text floatValue] < 100) {
       
        [Tools alterWithTitle:@"充值金额不能小于100.00元"];
    }else if ([_headView.textField.text floatValue] >= 10000000){
        [Tools alterWithTitle:@"大于10000000.00元请您去官网充值"];
    }else {

        [[Tools shareTools]progressWithTitle:@"请稍候..." OnView:self.view];
        NSString *inforStr = [[Tools shareTools]dictionaryToJson:@{@"client_type":@"IOS"}];
        NSString *infor = [GTMBase64 encodeBase64String:inforStr];
        NSDictionary*diccc = @{
                               @"method":@"post",
                               @"module":@"trust",
                               @"q":@"recharge",
                               @"user_id":[Tools HtUserId],
                               @"money":[NSNumber numberWithFloat:[_headView.textField.text floatValue]],
                               @"info":infor
                               };
        
        NSString *str = [[Tools shareTools]dictionaryToJson:diccc];
        NSString *strHT = [[Tools shareTools]htstr:str];
        NSString *md5Par = [[Tools shareTools] md5:strHT];
        NSDictionary *par = @{@"diyou":str,@"sign":md5Par};
        
        [HYBNetworking getWithUrl:kBaseUrl refreshCache:NO params:par success:^(id response) {
//            NSLog(@"%@",response);
           
            [[Tools shareTools]hidenHud];
            if ([response[@"result"] isEqualToString:@"error"]) {
               
                [Tools alterWithTitle:response[@"error_remark"]];
            
            }else{
            
                NSString *baseUrl = [GTMBase64 decodeBase64String:response[@"data"][@"form"]];
                NSString *utfUrl = [baseUrl stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                
                self.hidesBottomBarWhenPushed = YES;
                RechargeDetaileController *detaile = [[RechargeDetaileController alloc]init];
                detaile.url = utfUrl;
                [self.navigationController pushViewController:detaile animated:YES];
            }
           
        } fail:^(NSError *error) {
//           NSLog(@"%@",error);

            [[Tools shareTools]hidenHud];
        }];
    }
}

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
    UIBarButtonItem *rigthBtn = [[UIBarButtonItem alloc]initWithTitle:@"充值记录" style:UIBarButtonItemStylePlain target:self action:@selector(chongZhiNote)];
    self.navigationItem.rightBarButtonItem = rigthBtn;
    
}

//充值记录
-(void)chongZhiNote
{
    self.hidesBottomBarWhenPushed = YES;
    MoneyNoteViewController *moneyNoteVC = [[MoneyNoteViewController alloc]init];
    [self.navigationController pushViewController:moneyNoteVC animated:YES];

}

@end
