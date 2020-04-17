//
//  TouZiController.m
//  WorldHuitong
//
//  Created by TXHT on 16/5/23.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import "TouZiController.h"
#import "TouZiView.h"
#import "JiaXiQuan.h"
#import "GTMBase64.h"
#import "CheckDetaileController.h"
#import "RegShuangQianViewController.h"
#import "InCome.h"

@interface TouZiController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)TouZiView *head;
@property(nonatomic,assign)NSInteger touZinumber;         //投资份额/金额
@property(nonatomic,assign)NSInteger canInvesterNumber;   //可投份额/金额
@property(nonatomic,assign)BOOL selectImage;              //加息券选中
@property(nonatomic,strong)NSArray *jiaxis;               //加息券数组
@property(nonatomic,strong)NSString  *coupon_id;          //加息券id
@property(nonatomic,strong)UIButton *tempBtn;             //中间的button
@property(nonatomic,strong)NSString *coupon_lixi;         //加息券的收益
@property(nonatomic,strong)NSString *lixi;                //全部利息
@property(nonatomic,strong)NSString *date_time;           //时间
//
@property(nonatomic,strong)NSArray *inComes;             //收益数组
@end


@implementation TouZiController

//是否选中加息券
-(void)xuanzhong:(UIButton *)sender
{

    if ([_head.investNumber.text isEqualToString:@""]) {
      
        [HTView alterTitle:@"投资金额不能为0"];
    }else{
    
        [[Tools shareTools]progressWithTitle:@"请稍候..." OnView:self.view];

        //2.多个选中一个
        if (_tempBtn == nil){
            sender.selected = YES;
            _tempBtn = sender;
        }
        else if (_tempBtn != nil && _tempBtn == sender){
            sender.selected = !sender.selected;
            
        }
        else if (_tempBtn!= sender && _tempBtn!=nil){
            _tempBtn.selected = NO;
            sender.selected = YES;
            _tempBtn = sender;
        }
        
        if (sender.selected == YES) {
            [sender setImage:[UIImage imageNamed:@"jiaxi_select"] forState:UIControlStateSelected];
            JiaXiQuan *jiaxi = _jiaxis[sender.tag];
            _coupon_id = jiaxi.ID;
            
            
            //有加息券->计算一次预期收益
            [self yuQiInComWithText:_head.investNumber.text];
            
            [[Tools shareTools]hidenHud];
            
        }else if(sender.selected == NO){
            
            [sender setImage:[UIImage imageNamed:@"jiaxi_nomer"] forState:UIControlStateNormal];
            
            //无加息券->计算一次预期收益
            _coupon_id = nil;
            [self yuQiInComWithText:_head.investNumber.text];
            
            [[Tools shareTools]hidenHud];

        }

    }

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //加息券
    [self getJiaXiQuan];
    
    //创建tableview
    [self creatTableView];
    
}

#pragma ----UITableViewDataSource----

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{return 0;}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]init];
    }
    return cell;
}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self creatHeadView];
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{return _head.LiJiInvest.frame.origin.y + 44 + 20 + 110 * _jiaxis.count;}


//确认认购
-(void)LiJiInvestAction
{
    [_head.investNumber resignFirstResponder];
    [HTView isWiffOnView:self.view];
    [[Tools shareTools]progressWithTitle:@"请稍候..." OnView:self.view];
    NSDictionary *dic = nil;
    NSString *title = nil;
    NSString *inforStr = [[Tools shareTools]dictionaryToJson:@{@"client_type":@"IOS"}];
    NSString *infor = [GTMBase64 encodeBase64String:inforStr];
    
    //用户没有加息券的时候参数usecsq是空值
    if (_coupon_id == nil) {
        _coupon_id = @"";
    }
    
    if ([_biao.borrow_type isEqualToString:@"roam"]) {  //流转表
        title = @"请输入投资份额";
       
       dic = @{
                              @"module":@"trust",
                              @"q":@"tender",
                              @"borrow_nid":_detaileBiao.borrow_nid,
                              @"user_id":[Tools HtUserId],
                              @"tender_account":[NSNumber numberWithFloat:[_head.investNumber.text doubleValue] * kaccount_min],
                              @"method":@"post",
                              @"info":infor,
                              @"usecsq":_coupon_id
                              };
    }else {                                             //非流转标
    title = @"请输入投资金额";
       dic = @{
                              @"module":@"trust",
                              @"q":@"tender",
                              @"borrow_nid":_detaileBiao.borrow_nid,
                              @"user_id":[Tools HtUserId],
                              @"tender_account":[NSNumber numberWithFloat:[_head.investNumber.text floatValue]],
                              @"method":@"post",
                              @"info":infor,
                              @"usecsq":_coupon_id
                              };
    }
    
    if ([_head.investNumber.text  isEqualToString:@""]) {
        
        [[Tools shareTools]progressWithTitle:title Image:kFimage OnView:self.view Hide:2];
    }else{
       
        NSString *str = [[Tools shareTools]dictionaryToJson:dic];
        NSString *htStr = [[Tools shareTools]htstr:str];
        NSString *md5Str = [[Tools shareTools]md5:htStr];
        NSDictionary *par = @{@"diyou":str,@"sign":md5Str};
        
        [HYBNetworking getWithUrl:kBaseUrl refreshCache:NO params:par success:^(id response) {
            RegShuangQianViewController *shangqianVC = [[RegShuangQianViewController alloc]init];
//            NSLog(@"%@",response);
           
            [[Tools shareTools]hidenHud];
            if (![response[@"result"] isEqualToString:@"success"]) {
               
                [Tools alterWithTitle:response[@"error_remark"]];
            }else{
            
                NSString *url = response[@"data"][@"url"];
                NSString *baseUrl = [GTMBase64 decodeBase64String:url];
                NSString *utf8Url = [baseUrl stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                shangqianVC.url = utf8Url;
                shangqianVC.alterTitle = @"恭喜您,投资成功!";
                [self.navigationController pushViewController:shangqianVC animated:YES];
            }
            
        } fail:^(NSError *error) {
            [[Tools shareTools]hidenHud];

        }];

    }

    
}

//预期收益-数据
-(void)yuQiInComWithText:(NSString *)text
{
    NSNumber *account = nil;
    if ([_biao.borrow_type isEqualToString:@"roam"]) {   //流转标
       
        account = [NSNumber numberWithFloat:[text doubleValue] * kaccount_min];
    }else {         //非流转标
       
        account = [NSNumber numberWithFloat:[text floatValue]];
    }
    
    NSDictionary *dic = nil;
    if (!_coupon_id) { //无加息券
        dic = @{
                  @"module":@"borrow",
                  @"q":@"get_income",
                  @"borrow_nid":_detaileBiao.borrow_nid,
                  @"user_id":[Tools HtUserId],
                  @"account":account,
                  @"method":@"post",
                  };
    }else{            //有加息券
            dic = @{
                  @"module":@"borrow",
                  @"q":@"get_income",
                  @"borrow_nid":_detaileBiao.borrow_nid,
                  @"user_id":[Tools HtUserId],
                  @"account":account,
                  @"method":@"post",
                  @"coupon_id":_coupon_id
                  };
            }
    
    NSString *str = [[Tools shareTools]dictionaryToJson:dic];
    NSString *htStr = [[Tools shareTools]htstr:str];
    NSString *md5Str = [[Tools shareTools]md5:htStr];
    NSDictionary *par = @{@"diyou":str,@"sign":md5Str};
    
    [HYBNetworking getWithUrl:kBaseUrl refreshCache:NO params:par success:^(id response) {
//    NSLog(@"预期收益：%@",response);
        
        //预期收益
        _head.income.text = [NSString stringWithFormat:@"%.2f元",[response[@"all"] floatValue]];
       
        //收益数组
         _inComes = [InCome mj_objectArrayWithKeyValuesArray:response[@"list"]];

        //利息
        _lixi = response[@"lixi"];
        
        //加息券的收益
        _coupon_lixi = response[@"coupon_lixi"];
        
    } fail:^(NSError *error) {

    }];

}

//查看明细
-(void)lookDetailsAction
{
    [HTView isWiffOnView:self.view];

    if ([_head.investNumber.text doubleValue] > 0) {
        CheckDetaileController *detaileVC = [[CheckDetaileController alloc]init];
        detaileVC.biao = _biao;
        detaileVC.coupon_lixi = _coupon_lixi;
        detaileVC.lixi = _lixi;
        detaileVC.inComes = _inComes;
        [self.navigationController pushViewController:detaileVC animated:YES];
    }else{
        [[Tools shareTools]progressWithTitle:@"暂无明细" Image:kFimage OnView:self.view Hide:2];
    }
    
}

//减
-(void)subNumberAcition
{
    [_head.investNumber resignFirstResponder];

    [HTView isWiffOnView:self.view];

    _touZinumber = [_head.investNumber.text doubleValue];
    
    
    if ([_biao.borrow_type isEqualToString:@"roam"]) {      //流转标
        
        if (_touZinumber > 1) {
            
            _touZinumber = _touZinumber - 1;
            _head.investNumber.text = [NSString stringWithFormat:@"%ld",(long)_touZinumber];
            
            [self yuQiInComWithText:[NSString stringWithFormat:@"%ld",(long)_touZinumber]];
        }else{
            _touZinumber = 0;
            _head.investNumber.text = @"";
            [self yuQiInComWithText:[NSString stringWithFormat:@"%ld",(long)_touZinumber]];
        }
        
    }else{                //非流转标
        if (_touZinumber > 100) {
            _touZinumber = _touZinumber - 100;
            _head.investNumber.text = [NSString stringWithFormat:@"%ld",(long)_touZinumber];
           
            [self yuQiInComWithText:[NSString stringWithFormat:@"%ld",(long)_touZinumber]];
        }else{
             _touZinumber = 0;
            _head.investNumber.text = @"";
             [self yuQiInComWithText:[NSString stringWithFormat:@"%ld",(long)_touZinumber]];
        }
    
    }
    
    //设置button
    if (_touZinumber < 1) {
        _head.LiJiInvest.backgroundColor = [UIColor lightGrayColor];
        _head.LiJiInvest.userInteractionEnabled = NO;
    }else{
        
        _head.LiJiInvest.backgroundColor = HT_COLOR;
        _head.LiJiInvest.userInteractionEnabled = YES;
    }

    
   
}

//加
-(void)addNumberAcition
{
    [_head.investNumber resignFirstResponder];
    [HTView isWiffOnView:self.view];

    _touZinumber = [_head.investNumber.text doubleValue];
    [self userAble];

    if ([_biao.borrow_type isEqualToString:@"roam"]) {   //流转标
        
        if (_touZinumber >= 0 && _touZinumber < _canInvesterNumber) {
            
            _touZinumber = _touZinumber + 1;
            _head.investNumber.text = [NSString stringWithFormat:@"%ld",(long)_touZinumber];
            [self yuQiInComWithText:[NSString stringWithFormat:@"%ld",(long)_touZinumber]];
            
        }else if (_touZinumber >= _canInvesterNumber){
            
            _head.investNumber.text = [NSString stringWithFormat:@"%ld",(long)_canInvesterNumber];
            [self yuQiInComWithText:[NSString stringWithFormat:@"%ld",(long)_canInvesterNumber]];
            
        }

    }else{    //非流转标
    
    if (_touZinumber >= 0 && _touZinumber < _biao.borrow_account_wait) {
       
        _touZinumber = _touZinumber + 100;
        _head.investNumber.text = [NSString stringWithFormat:@"%ld",(long)_touZinumber];
        [self yuQiInComWithText:[NSString stringWithFormat:@"%ld",(long)_touZinumber]];
    
    }else if (_touZinumber >= _biao.borrow_account_wait){
        
        _head.investNumber.text = [NSString stringWithFormat:@"%d",_biao.borrow_account_wait];
        [self yuQiInComWithText:[NSString stringWithFormat:@"%d",_biao.borrow_account_wait]];
  
    }
      
    }
    
}

//加息券列表
-(void)getJiaXiQuan
{
    NSDictionary *dic = @{
                          @"user_id":[Tools HtUserId],
                          @"code":@"huitong_tender1",
                          @"method":@"get",
                          @"module":@"coupon",
                          @"q":@"expired"
                          };
    NSString *str = [[Tools shareTools]dictionaryToJson:dic];
    NSString *htStr = [[Tools shareTools]htstr:str];
    NSString *md5Str = [[Tools shareTools]md5:htStr];
    NSDictionary *par = @{@"diyou":str,@"sign":md5Str};
    
    [HYBNetworking getWithUrl:kBaseUrl refreshCache:NO params:par success:^(id response) {
        
//    NSLog(@"%@",response);
        
        //添加加息券
        _jiaxis = [[NSArray alloc]init];
        _jiaxis = [JiaXiQuan mj_objectArrayWithKeyValuesArray:response[@"list"]];
        [self.tableView reloadData];

    
    } fail:^(NSError *error) {
        
    }];


}

#pragma ----UITextFieldDelegate----

- (void)getInvestNumber:(UITextField*)textField
{
    if ([textField.text isEqualToString:@""]) {
        _head.LiJiInvest.backgroundColor = [UIColor lightGrayColor];
        _head.LiJiInvest.userInteractionEnabled = NO;
    }else{
        
        _head.LiJiInvest.backgroundColor = HT_COLOR;
        _head.LiJiInvest.userInteractionEnabled = YES;}

    if ([_biao.borrow_type isEqualToString:@"roam"]) {      //流转标
        
        if ([textField.text doubleValue] >= _canInvesterNumber) {
            
            _head.investNumber.text = [NSString stringWithFormat:@"%ld",_canInvesterNumber];
            
            [self yuQiInComWithText:[NSString stringWithFormat:@"%ld",_canInvesterNumber]];
            
            }else{
                
                [self yuQiInComWithText:textField.text];
            }
   
    }else{         //非流转标
        
        if ([textField.text doubleValue] >= _biao.borrow_account_wait) {
            
            _head.investNumber.text = [NSString stringWithFormat:@"%d",_biao.borrow_account_wait];
            
            [self yuQiInComWithText:[NSString stringWithFormat:@"%d",_biao.borrow_account_wait]];
            
        }else{
            
            [self yuQiInComWithText:textField.text];
        }

    
    }
   
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.head.investNumber resignFirstResponder];
    
    return YES;
}

-(TouZiView*)creatHeadView
{
    _head = [[[NSBundle mainBundle] loadNibNamed:@"TouZiView" owner:self options:nil] lastObject];
    _head.frame = CGRectMake(0, 0, kScreenWidth, _head.LiJiInvest.frame.origin.y + 44 + 20 + 110 * 6);
    
    [_head.subAction addTarget:self action:@selector(subNumberAcition) forControlEvents:UIControlEventTouchUpInside];
    [_head.addAction addTarget:self action:@selector(addNumberAcition) forControlEvents:UIControlEventTouchUpInside];
    [_head.detailsAction addTarget:self action:@selector(lookDetailsAction) forControlEvents:UIControlEventTouchUpInside];
    [_head.LiJiInvest addTarget:self action:@selector(LiJiInvestAction) forControlEvents:UIControlEventTouchUpInside];
    [_head.investNumber addTarget:self action:@selector(getInvestNumber:) forControlEvents:UIControlEventAllEditingEvents];
    
    //设置
    [[HTView shareHTView]setView:_head.bg_view cornerRadius:4];
    [[HTView shareHTView]setView:_head.LiJiInvest cornerRadius:4];
    _head.LiJiInvest.backgroundColor = [UIColor lightGrayColor];
    _head.LiJiInvest.userInteractionEnabled  = NO;
    _head.investNumber.delegate = self;
    
    float balance = [[NSUserDefaults standardUserDefaults]floatForKey:@"balance"];

    //赋值-可投份额
    if ([_biao.borrow_type isEqualToString:@"roam"]) {      //流转标
        _head.canInvestLable.text = @"可投份额:";
        _head.investMoney.text = @"投资份额:";
        
        //最大可投份额
        if (balance >= 100) {
            _head.investNumber.placeholder = [NSString stringWithFormat:@"余额可投%.f",balance / 100];
        }else{
            _head.investNumber.placeholder = @"余额不足";
        }
        _head.fenOryuan.text = @"份";
        _head.canInvestNumber.text = [NSString stringWithFormat:@"%d份",_biao.borrow_account_wait / kaccount_min];
   
    }else{       //非流转标
        _head.canInvestLable.text = @"可投金额:";
        _head.investMoney.text = @"投资金额:";
        _head.fenOryuan.text = @"元";
       
        //最大可投金额
        if (balance >= 100) {
            if (balance >= 10000) {
                _head.investNumber.placeholder = [NSString stringWithFormat:@"余额可投%.2f万",balance / 10000];
            }else{
                _head.investNumber.placeholder = [NSString stringWithFormat:@"余额可投%.f",balance];
            }
        }else{
            _head.investNumber.placeholder = @"余额不足";
        }
        _head.canInvestNumber.text = [NSString stringWithFormat:@"%d元",_biao.borrow_account_wait];
    }
    
        
/**加息券**/
        for (int i = 0;  i < _jiaxis.count; i ++) {
             JiaXiQuan *jiaxiquan = _jiaxis[i];
            //按钮
            UIView *button = [[UIView alloc]initWithFrame:CGRectMake(10, _head.LiJiInvest.frame.origin.y + 64 + i * 110, kScreenWidth - 20, 100)];
            [_head addSubview:button];
            
            
            //比例
            UIImageView *retaImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
            retaImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"reta%@",jiaxiquan.rate]];
            [button addSubview:retaImage];
            
            //详细
            UIImageView *detaileImg = [[UIImageView alloc]initWithFrame:CGRectMake(100, 0, button.frame.size.width - 100, 100)];
            detaileImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"detaile%@",jiaxiquan.rate]];
            [button addSubview:detaileImg];
            
            //时间
            UILabel *timeLable = [[UILabel alloc]initWithFrame:CGRectMake(100 + 20, 100 * 2 / 3, detaileImg.frame.size.width - 20, 30)];
            timeLable.text = [NSString stringWithFormat:@"截止日期:%@",[Tools dateFormatter:jiaxiquan.maturitytime]];
            timeLable.font = [UIFont systemFontOfSize:12];
            timeLable.textColor = [UIColor lightGrayColor];
            [button addSubview:timeLable];
            
            //选中的button
            UIButton *selectBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth - 20, 100)];
            [selectBtn addTarget:self action:@selector(xuanzhong:) forControlEvents:UIControlEventTouchUpInside];
             selectBtn.imageEdgeInsets = UIEdgeInsetsMake(0, button.bounds.size.width - 60, 55, 0);
            [selectBtn setImage:[UIImage imageNamed:@"jiaxi_nomer"] forState:UIControlStateNormal];
            selectBtn.tag = i;
            [button addSubview:selectBtn];
        
    }
    return _head;

}

-(void)creatTableView
{
    self.navigationItem.title = @"投资";
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.view.backgroundColor = HT_BG_COLOR;
    _touZinumber = 0;
    
    //可投份额
    _canInvesterNumber = _biao.borrow_account_wait / kaccount_min;
    

}

#pragma ----UITextFieldDelegate----

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if ([string length]>0)
    {
        unichar single=[string characterAtIndex:0];//当前输入的字符
        if ((single >='0' && single<='9'))//数据格式正确
        {
            //首字母不能为0和小数点
            if([textField.text length]==0){
               
                if (single == '0') {
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
                    return YES;

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

-(void)userAble
{
    if (!_touZinumber > 1.00) {
        _head.LiJiInvest.backgroundColor = [UIColor lightGrayColor];
        _head.LiJiInvest.userInteractionEnabled = NO;
    }else{
        
        _head.LiJiInvest.backgroundColor = HT_COLOR;
        _head.LiJiInvest.userInteractionEnabled = YES;}

}


@end
