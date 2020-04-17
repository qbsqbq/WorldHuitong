//
//  CounterController.m
//  WorldHuitong
//
//  Created by TXHT on 16/4/13.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//计算器

#import "CounterController.h"
#import "CounterView.h"
#import "CountDetaileController.h"
#import "Repayment.h"
@interface CounterController ()

            /**中间变量**/
@property(nonatomic,strong)UILabel *tempRepayment;   //还款方式
@property(nonatomic,strong)UITextField *tempPtype;   //产品类型
@property(nonatomic,strong)UITextField *tempReta;    //利率
@property(nonatomic,assign)int tempPeriod;          //期数

@property(nonatomic,strong)CounterView *counterView;
@property(nonatomic,strong)NSString *repaymentText;   //记录还款方式
@property(nonatomic,strong)NSArray *replayments;      //还款详情数组
@property(nonatomic,assign)BOOL isHaveDian;
@property(nonatomic,strong)UIActionSheet *asHuankuan; //还款方式ActionSheet
@property(nonatomic,strong)UIActionSheet *asProdcot;  //产品类型ActionSheet

@end

@implementation CounterController

-(CounterView *)counterView
{
    if (!_counterView) {
         _counterView = [[[NSBundle mainBundle] loadNibNamed:@"CounterView" owner:self options:nil] lastObject];
        _counterView.borrowedMoney.delegate = self;
        _counterView.inPutDay.delegate = self;
        [_counterView.inPutDay addTarget:self action:@selector(inPutDayChanged) forControlEvents:UIControlEventEditingChanged];
        _counterView.inPutDay.hidden = YES;
        _counterView.tian.hidden = YES;

        self.tempPtype = _counterView.pType;
        self.tempRepayment = _counterView.repayment;
        self.tempReta = _counterView.nianReta;
       
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView)];
        [_counterView addGestureRecognizer:tap];
        
        [[HTView shareHTView] setView:_counterView.bg_view cornerRadius:4];
        [[HTView shareHTView] setView:_counterView.startCount cornerRadius:4];
        [[HTView shareHTView] setView:_counterView.bg_result cornerRadius:4];
        [_counterView.detaileBtn setTitleColor:HT_COLOR forState:UIControlStateNormal];
        [_counterView.startCount setBackgroundColor:HT_COLOR];
    }
    return _counterView;

}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self creatTableView];

}

#pragma ----UITableViewDataSource----
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]init];
    }
    return cell;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    [self.counterView.prodcTypeBtn addTarget:self action:@selector(prodcTypeAction) forControlEvents:UIControlEventTouchUpInside];
     [self.counterView.repaymentTypeBtn addTarget:self action:@selector(repaymentTypeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.counterView.startCount addTarget:self action:@selector(startCount) forControlEvents:UIControlEventTouchUpInside];
    [self.counterView.detaileBtn addTarget:self action:@selector(detaileAction) forControlEvents:UIControlEventTouchUpInside];

    return self.counterView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
     return _counterView.bg_result.frame.origin.y + 182;
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
    [self textFieldResig];
    return YES;
}

-(void)tapView
{
    [self textFieldResig];
}
-(void)inPutDayChanged
{
    self.tempPeriod = [self.counterView.inPutDay.text floatValue];
}

#pragma 处理事件
//开始计算
-(void)startCount
{
    [self textFieldResig];

    //检测网络
    if (![Tools isConnectionAvailable]) {
        
        [HTView isWiffOnView:self.view];
    }else{

        //有无输入金额
        [[Tools shareTools]progressWithTitle:@"正在计算..." OnView:self.view];
        if ([_counterView.borrowedMoney.text  isEqualToString:@""]) {
            
            [[Tools shareTools]hidenHud];
            [Tools alterWithTitle:@"请输入借款金额"];
        }else if (![_counterView.borrowedMoney.text  isEqualToString:@""] && [_tempPtype.text isEqualToString:@""]){
            
            [[Tools shareTools]hidenHud];
            [Tools alterWithTitle:@"请选择产品类型"];
        }else if(self.tempPeriod == 0){
            
            [[Tools shareTools]hidenHud];
            [Tools alterWithTitle:@"请输入天数"];
        }else if([_counterView.repayment.text isEqualToString:@""]){
            
            [[Tools shareTools]hidenHud];
            [Tools alterWithTitle:@"请选择还款方式"];
        }else {

            //开始计算收益
            _counterView.bg_result.hidden = NO;
            NSDictionary*diccc = @{
                                   @"module":@"borrow",
                                   @"q":@"calculator",
                                   @"method":@"post",
                                   @"account":_counterView.borrowedMoney.text,
                                   @"apr":self.tempReta.text,
                                   @"period":[NSString stringWithFormat:@"%d",self.tempPeriod],
                                   @"style":self.repaymentText
                                   };
            
            NSString *str = [[Tools shareTools]dictionaryToJson:diccc];
            NSString *strHT = [[Tools shareTools]htstr:str];
            NSString *md5Par = [[Tools shareTools] md5:strHT];
            NSDictionary *par = @{@"diyou":str,@"sign":md5Par};
            
            [HYBNetworking getWithUrl:kBaseUrl refreshCache:NO params:par success:^(id response) {
                [[Tools shareTools]hidenHud];
//              NSLog(@"%@",response);
                
                //分装数组模型
                _replayments  = [Repayment mj_objectArrayWithKeyValuesArray:response[@"list"]];
          
                //月利率/天利率
                if ([self.repaymentText isEqualToString:@"endday"]) { //日利率
                      _counterView.monthrRete.text =  [[NSString stringWithFormat:@"%.2f",[_counterView.nianReta.text floatValue] / 12 / 30] stringByAppendingString:@"%"];
                    _counterView.mothrReteLable.text = @"日利率:";
                    _counterView.mothRepayLable.text = @"到期将偿还:";
                }else{                                                 //月利率
                    _counterView.monthrRete.text =  [[NSString stringWithFormat:@"%.2f",[_counterView.nianReta.text floatValue] / 12] stringByAppendingString:@"%"];
                    _counterView.mothrReteLable.text = @"月利率:";
                    _counterView.mothRepayLable.text = @"每个月将偿还:";


                }
                
                //还款本息总额
                NSString *lixi = response[@"total"][@"total_interest"];
                NSString *bengJin = response[@"total"][@"total_capital"];
                float allAmount = [lixi floatValue] + [bengJin floatValue];
                _counterView.amount.text = [NSString stringWithFormat:@"￥%.2f",allAmount];

                
                /**按月付息到期还本**/
                if ([_counterView.repayment.text isEqualToString:@"按月付息"]) {
                    
                    //每一月偿还
                    _counterView.monthRepay.text = [NSString stringWithFormat:@"￥%.4f",[[response[@"list"] firstObject][@"account_all"]floatValue]];

               /**等额本息**/
                }else if ([_counterView.repayment.text isEqualToString:@"等额本息"]){
                    
                    _counterView.monthRepay.text = [NSString stringWithFormat:@"￥%@",[response[@"list"] firstObject][@"account_all"]];

               /**其他**/
                }else{
                    
                    //每一月偿还
                    _counterView.monthRepay.text = [NSString stringWithFormat:@"￥%.2f",[response[@"total"][@"total_all"]floatValue]];
                }
                
                        
            } fail:^(NSError *error) {
               
                [[Tools shareTools]hidenHud];
            }];
            
        }
        
        
    }
}


-(void)creatTableView
{
    self.view.userInteractionEnabled = YES;
    self.navigationItem.title = @"投资计算器";
    
    _counterView = [self counterView];
    _counterView.bg_result.hidden = YES;
    
    //
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake( 0, 0, kScreenWidth,kScreenHeigth)];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [[UIView alloc]init];
    tableView.backgroundColor = RGBA_COLOR(241, 241, 241, 1);
    [self.view addSubview:tableView];

}


//选择产品的类型
-(void)prodcTypeAction
{
    [self textFieldResig];
    _asProdcot = [[UIActionSheet alloc]initWithTitle:@"请选择产品类型" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"一月标",@"二月标",@"三月标",@"四月标",@"六月标",@"天标",nil];
    _asProdcot.actionSheetStyle = UIActionSheetStyleAutomatic;
    [_asProdcot showInView:self.view];
}

-(void)repaymentTypeAction
{
    [self textFieldResig];
    _asHuankuan = [[UIActionSheet alloc]initWithTitle:@"请选择还款方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"按月付息",@"到期还本还息",nil];
    _asHuankuan.actionSheetStyle = UIActionSheetStyleAutomatic;
    [_asHuankuan showInView:self.view];

}

//查看详情
-(void)detaileAction
{
    self.hidesBottomBarWhenPushed = YES;
    CountDetaileController *countDetaile = [[CountDetaileController alloc]init];
    countDetaile.replayments = _replayments;
    countDetaile.repaymentType = self.repaymentText;
    countDetaile.vcType = _vcType;
    [self.navigationController pushViewController:countDetaile animated:YES];
}

#pragma ----UIActionSheetDelegate----
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet == _asProdcot) {
        
   
        switch (buttonIndex) {
            case 0:
                _counterView.repaymentTypeBtn.userInteractionEnabled = NO;
                _counterView.jaintou.hidden = YES;
                self.counterView.inPutDay.text = @"";
                self.counterView.inPutDay.hidden = YES;
                self.counterView.tian.hidden = YES;
                self.tempReta.text = @"10%";
                self.tempRepayment.text = @"到期还本还息";
                self.tempPtype.text = @"一月标";
                self.repaymentText = @"end";
                self.tempPeriod = 1;
                break;
            case 1:
                _counterView.repaymentTypeBtn.userInteractionEnabled = YES;
                _counterView.jaintou.hidden = NO;
                self.counterView.inPutDay.text = @"";
                self.counterView.inPutDay.hidden = YES;
                self.counterView.tian.hidden = YES;
                self.tempReta.text = @"11%";
                self.tempRepayment.text = @"";
                self.tempPtype.text = @"二月标";
                self.repaymentText = @"endmonth";
                self.tempPeriod = 2;
                break;
            case 2:
                _counterView.repaymentTypeBtn.userInteractionEnabled = YES;
                _counterView.jaintou.hidden = NO;
                self.counterView.inPutDay.text = @"";
                self.counterView.inPutDay.hidden = YES;
                self.counterView.tian.hidden = YES;
                self.tempReta.text = @"12%";
                self.tempRepayment.text = @"";
                self.tempPtype.text = @"三月标";
                self.repaymentText = @"end";
                self.tempPeriod = 3;
                break;
            case 3:
                _counterView.repaymentTypeBtn.userInteractionEnabled = YES;
                _counterView.jaintou.hidden = NO;
                self.counterView.inPutDay.text = @"";
                self.counterView.inPutDay.hidden = YES;
                self.counterView.tian.hidden = YES;
                self.tempReta.text = @"12%";
                self.tempPtype.text = @"四月标";
                self.tempRepayment.text = @"";
                self.repaymentText = @"endmonth";
                self.tempPeriod = 4;
                break;
            case 4:
                _counterView.repaymentTypeBtn.userInteractionEnabled = YES;
                _counterView.jaintou.hidden = NO;
                self.counterView.inPutDay.text = @"";
                self.counterView.inPutDay.hidden = YES;
                self.counterView.tian.hidden = YES;
                self.tempReta.text = @"13%";
                self.tempRepayment.text = @"";
                self.tempPtype.text = @"六月标";
                self.repaymentText = @"endmonth";
                self.tempPeriod = 6;
                break;
            case 5:
                _counterView.repaymentTypeBtn.userInteractionEnabled = NO;
                _counterView.jaintou.hidden = YES;
                self.counterView.inPutDay.hidden = NO;
                self.counterView.tian.hidden = NO;
                self.tempReta.text = @"7.2%";
                self.tempRepayment.text = @"按天计息到期还本还息";
                self.tempPtype.text = @"天标";
                self.repaymentText = @"endday";
                self.tempPeriod = 0;
                break;

            default:
                break;
    
        }
        
    }else if (actionSheet == _asHuankuan){
        switch (buttonIndex) {
            case 0:
                self.repaymentText = @"endmonth";
                self.tempRepayment.text = @"按月付息";

                break;

            case 1:
                self.repaymentText = @"end";
                self.tempRepayment.text = @"到期还本还息";

            default:
                break;
        }
    }
 
}

-(void)textFieldResig
{
    [_counterView.inPutDay resignFirstResponder];
    [_counterView.nianReta resignFirstResponder];
    [_counterView.borrowedMoney resignFirstResponder];

}

@end
