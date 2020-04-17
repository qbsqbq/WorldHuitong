//
//  BankCardController.m
//  WorldHuitong
//
//  Created by TXHT on 16/6/23.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import "BankCardController.h"
#import "BankCardView.h"
#import "Province.h"

#define dateSpan 30//时间滚轮跨度 前后多少年

@interface BankCardController ()
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)BankCardView *head;
@property(nonatomic,strong)NSMutableArray *provinces;  //数组
@property(nonatomic,strong)NSMutableArray *provinceTitle;

//
@property (nonatomic, strong) UIView* selectView;
@property (nonatomic, strong) UIPickerView* pickerView;
@property (nonatomic, strong) UIPickerView* secPickView;
@property (nonatomic, strong) UIButton* sureBtn;
@property (nonatomic, strong) UIButton* cancelBtn;
@property(nonatomic,strong)NSArray *oneComponentData;  //第一个选择器第一列的数据

//选择那个类型-银行-省份-城市
@property (nonatomic, strong) NSString* titleType;
@property (nonatomic, strong) NSString* pricenseID;
@property (nonatomic, strong) NSString* bankValue;         //银行的id
//@property (nonatomic, strong) NSString* priceseName;     //省份名
@property (nonatomic, strong) NSString *cityID;            //城市名



@end

@implementation BankCardController
-(BankCardView *)head
{
    if (!_head) {
        _head = [[[NSBundle mainBundle]loadNibNamed:@"BankCardView" owner:self options:nil] lastObject];
        _head.frame = CGRectMake(0, 0, kScreenWidth, 386);
        _head.bankCarNo.delegate = self;
        _head.kaihu_bankName.delegate = self;
        [[HTView shareHTView]setView:_head.bg_viewF cornerRadius:4];
        [[HTView shareHTView]setView:_head.bg_viewH cornerRadius:4];
        [[HTView shareHTView]setView:_head.shureBtn cornerRadius:4];
        _head.shureBtn.backgroundColor = HT_COLOR;
        
        

    }
    return _head;

}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self creatTableView];
    
    [self setUpSelectView];
    
    //监听键盘出现和消失
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
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


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    self.head.kaiHu_userName.text = [NSString stringWithFormat:@"%@**",[_realName substringToIndex:1]];
    [self.head.chooseBankBtn addTarget:self action:@selector(chooseBankAction) forControlEvents:UIControlEventTouchUpInside];
    [self.head.choosePricenseBtn addTarget:self action:@selector(choosePricenseAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.head.chooseCityBtn addTarget:self action:@selector(chooseCityAction) forControlEvents:UIControlEventTouchUpInside];
     [self.head.shureBtn addTarget:self action:@selector(shureAction) forControlEvents:UIControlEventTouchUpInside];
    
    return self.head;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 386;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_head.bankCarNo resignFirstResponder];
    [_head.kaihu_bankName resignFirstResponder];
    return YES;
}


-(void)tapView
{
    [_head.bankCarNo resignFirstResponder];
    [_head.kaihu_bankName resignFirstResponder];
}

#pragma mark 键盘的出现与消失
-(void)keyboardWillShow:(NSNotification*)note
{
    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeigth - 64 - keyBoardRect.size.height);
}

-(void)keyboardWillHide:(NSNotification*)note
{
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeigth - 64);
}

#pragma ***************处理数据********************


/**提交按钮**/
-(void)shureAction
{
    if ([_head.bankCarNo.text isEqualToString:@""] || _bankValue == nil || _pricenseID == nil
        || _cityID == nil || [_head.kaihu_bankName.text isEqualToString:@""]) {
        [HTView alterTitle:@"信息没有填写完整哦!"];
    }else{
    
        [[Tools shareTools]progressWithTitle:@"正在提交..." OnView:self.navigationController.view];
        [_head.kaihu_bankName resignFirstResponder];
        [_head.bankCarNo resignFirstResponder];
        NSDictionary *dic = @{
                              @"module":@"account",
                              @"q":@"add_user_bank",
                              @"method":@"post",
                              @"account":_head.bankCarNo.text,
                              @"bank":_bankValue,
                              @"province":_pricenseID,
                              @"city":_cityID,
                              @"branch":[Tools utf8:_head.kaihu_bankName.text],
                              @"user_id":[Tools HtUserId],
                              };
        NSString *str = [[Tools shareTools]dictionaryToJson:dic];
        NSString *htStr = [[Tools shareTools]htstr:str];
        NSString *md5Str = [[Tools shareTools]md5:htStr];
        NSDictionary *par = @{@"diyou":str,@"sign":md5Str};
        
        [HYBNetworking getWithUrl:kBaseUrl refreshCache:NO params:par success:^(id response) {
            
            //        NSLog(@"%@",response);
            
            [[Tools shareTools]hidenHud];
            if ([response[@"result"] isEqualToString:@"error"]) {
                
                [Tools alterWithTitle:response[@"error_remark"]];
            }else if([response[@"result"] isEqualToString:@"success"]){
                
                UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"提示" message:@"恭喜您，银行卡认证成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alter show];
            }
            
        } fail:^(NSError *error) {
            
            [[Tools shareTools]hidenHud];
            
        }];
    
    }
    
    
    
}

//选择银行
-(void)chooseBankAction
{
    [_head.bankCarNo resignFirstResponder];
    _titleType = @"bank";

    [self loadBankType];
    
    [_secPickView removeFromSuperview];
    [_selectView addSubview:_pickerView];
    [_pickerView becomeFirstResponder];
    _selectView.hidden = !_selectView.hidden;
    
}

//选择省份
- (void)choosePricenseAction:(UIButton *)btn
{
    _titleType = @"pricense";
    [self loadProvince];
    
    [_secPickView removeFromSuperview];
    [_selectView addSubview:_pickerView];
    [_pickerView becomeFirstResponder];
    _selectView.hidden = !_selectView.hidden;
}

//选择城市
-(void)chooseCityAction
{
    if (_pricenseID == nil) {
        
        [HTView alterTitle:@"请先选择省份"];
    }else{
    
        _titleType = @"city";
        [self loadCitise];
        
        [_secPickView removeFromSuperview];
        [_selectView addSubview:_pickerView];
        [_pickerView becomeFirstResponder];
        _selectView.hidden = !_selectView.hidden;
    }
    
  
    
}

//加载银行类型数据
-(void)loadBankType
{
    NSDictionary *dic= @{
                         @"method":@"get",
                         @"module":@"trust",
                         @"q":@"get_bank_item",
                         @"client":@"IOS"
                         };
    NSString *str = [[Tools shareTools]dictionaryToJson:dic];
    NSString *htStr = [[Tools shareTools]htstr:str];
    NSString *md5Str = [[Tools shareTools]md5:htStr];
    NSDictionary *par = @{@"diyou":str,@"sign":md5Str};
    
    [HYBNetworking getWithUrl:kBaseUrl refreshCache:NO params:par success:^(id response){
        
//       NSLog(@"bank=%@",response[@"bank"]);

        _provinces = [Province mj_objectArrayWithKeyValuesArray:response[@"bank"]];
        [_pickerView reloadComponent:0];
        
    } fail:^(NSError *error) {
        
    }];


}

//加载省份数据
-(void)loadProvince
{
    NSDictionary *dic= @{
                         @"method":@"get",
                         @"module":@"trust",
                         @"q":@"get_province_list",
                         @"client":@"IOS"
                         };
    NSString *str = [[Tools shareTools]dictionaryToJson:dic];
    NSString *htStr = [[Tools shareTools]htstr:str];
    NSString *md5Str = [[Tools shareTools]md5:htStr];
    NSDictionary *par = @{@"diyou":str,@"sign":md5Str};
    
    [HYBNetworking getWithUrl:kBaseUrl refreshCache:NO params:par success:^(id response){
        
//    NSLog(@"%@",response[@"list"]);
        _provinces = [Province mj_objectArrayWithKeyValuesArray:response[@"list"]];
        [_pickerView reloadComponent:0];
        
    } fail:^(NSError *error) {
        
//        NSLog(@"%@",error);
    }];
    
    
}

//加载城市数据
-(void)loadCitise
{
   
    
        NSDictionary *dic = @{
                              @"method":@"get",
                              @"module":@"trust",
                              @"q":@"get_city_list",
                              @"pid":_pricenseID,
                              @"client":@"IOS"
                              };
        NSString *str = [[Tools shareTools]dictionaryToJson:dic];
        NSString *htStr = [[Tools shareTools]htstr:str];
        NSString *md5Str = [[Tools shareTools]md5:htStr];
        NSDictionary *par = @{@"diyou":str,@"sign":md5Str};
        
        [HYBNetworking getWithUrl:kBaseUrl refreshCache:NO params:par success:^(id response){
//        NSLog(@"%@",response);
            
            _provinces = [Province mj_objectArrayWithKeyValuesArray:response[@"list"]];
            [_pickerView reloadComponent:0];
            
        } fail:^(NSError *error) {
            
//            NSLog(@"%@",error);
        }];

    

}

//显示省份的第一个城市
-(void)chooseFirstCity
{
    NSDictionary *dic = @{
                          @"method":@"get",
                          @"module":@"trust",
                          @"q":@"get_city_list",
                          @"pid":_pricenseID,
                          @"client":@"IOS"
                          };
    NSString *str = [[Tools shareTools]dictionaryToJson:dic];
    NSString *htStr = [[Tools shareTools]htstr:str];
    NSString *md5Str = [[Tools shareTools]md5:htStr];
    NSDictionary *par = @{@"diyou":str,@"sign":md5Str};
    
    [HYBNetworking getWithUrl:kBaseUrl refreshCache:NO params:par success:^(id response){
//        NSLog(@"%@",response);
        
        _provinces = [Province mj_objectArrayWithKeyValuesArray:response[@"list"]];
        Province *pro = [_provinces firstObject];
        _cityID = pro.ID;
        _head.cityName.text = pro.name;
        [_pickerView reloadComponent:0];
        
    } fail:^(NSError *error) {
        
//        NSLog(@"%@",error);
    }];


}

- (void)setUpSelectView
{
    if (_selectView == nil) {
        
        _selectView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeigth - 240, kScreenWidth, 240)];
        _selectView.backgroundColor = HT_BG_COLOR;
        _selectView.hidden = YES;
        [self.view addSubview:_selectView];
        [self.view bringSubviewToFront:_selectView];
        
    }
    if (_cancelBtn == nil) {
        
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _cancelBtn.frame = CGRectMake(10, 5, 60, 40);
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:19];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelBtnEvent) forControlEvents:UIControlEventTouchUpInside];
        [_cancelBtn setTitleColor:HT_COLOR forState:UIControlStateNormal];
        [_selectView addSubview:_cancelBtn];
        
    }
    if (_sureBtn == nil) {
        
        _sureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _sureBtn.frame = CGRectMake(kScreenWidth - 70, 5, 60, 40);
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:19];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(sureBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
        [_sureBtn setTitleColor:HT_COLOR forState:UIControlStateNormal];

        [_selectView addSubview:_sureBtn];
        
    }
    if (_pickerView == nil) {
        
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, 160)];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.showsSelectionIndicator = YES;
        [_secPickView selectRow:dateSpan inComponent:0 animated:YES];
        _pickerView.backgroundColor = [UIColor whiteColor];
        
    }
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.provinces.count;
}

#pragma mark 实现协议UIPickerViewDelegate方法
- (NSString*)pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    Province *pro = self.provinces[row];
    return pro.name;

}


//取消按钮
- (void)cancelBtnEvent
{
    _selectView.hidden = YES;
}


//确认按钮
- (void)sureBtnEvent:(UIButton*)sender
{
    NSInteger row = [self.pickerView selectedRowInComponent:0];
    Province *pro = _provinces[row];
    NSString* selectedtitle = pro.name;
    
    if ([_titleType isEqualToString:@"pricense"]) {

        _pricenseID = pro.ID;
        self.head.privense.text = selectedtitle;
        [self chooseFirstCity];

    }else if([_titleType isEqualToString:@"bank"]){
        self.bankValue = pro.ID;
        self.head.bankName.text = selectedtitle;
    }else if ([_titleType isEqualToString:@"city"]){
    
        _cityID = pro.ID;
        self.head.cityName.text = selectedtitle;
    }
    

    _selectView.hidden = YES;
    
}

-(void)creatTableView
{
    self.view.backgroundColor = HT_BG_COLOR;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeigth - 64)];
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]init];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView)];
    [_tableView addGestureRecognizer:tap];
    
    self.navigationItem.title = @"银行卡认证";
}

#pragma ----UIAlertViewDelegate -----
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}



@end
