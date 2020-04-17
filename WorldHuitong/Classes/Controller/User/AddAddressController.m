//
//  AddAddressController.m
//  WorldHuitong
//
//  Created by TXHT on 16/8/30.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import "AddAddressController.h"
#import "AddressManageController.h"
#import "AddAddressHead.h"
#import "UIView+RGSize.h"
@interface AddAddressController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong)AddAddressHead *head;

//view
@property (weak, nonatomic) IBOutlet UIPickerView *pickView;
@property (strong, nonatomic) IBOutlet UIView *pickerBgView;
@property (strong, nonatomic) UIView *maskView;

//data
@property (strong, nonatomic) NSDictionary *pickerDic;
@property (strong, nonatomic) NSArray *provinceArray;
@property (strong, nonatomic) NSArray *cityArray;
@property (strong, nonatomic) NSArray *townArray;
@property (strong, nonatomic) NSArray *selectedArray;
@end

@implementation AddAddressController


#pragma mark - init view
- (void)initView {
    
    self.maskView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.maskView.backgroundColor = [UIColor blackColor];
    self.maskView.alpha = 0;
    [self.maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideMyPicker)]];
    
    self.pickerBgView.width = kScreenWidth;
}

-(AddAddressHead *)head
{
    if (!_head) {
        _head = [[[NSBundle mainBundle]loadNibNamed:@"AddAddressHead" owner:self options:nil] lastObject];
        _head.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeigth);
        _head.userName.delegate = self;
        _head.phone.delegate = self;
        _head.detaileAddress.delegate = self;
        _head.corde.delegate = self;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView)];
        [_head addGestureRecognizer:tap];
        
        if (_naTitle) {
            self.title = _naTitle;
            //赋值
            _head.userName.text = _address.consignee;
            _head.phone.text = _address.phone;
            _head.province.text = _address.prov;
            _head.city.text = _address.city;
            _head.area.text = _address.dist;
            _head.detaileAddress.text = _address.street;
            _head.corde.text = _address.zip_code;
        }else{
            self.title = @"新增收货地址";
        }
        

    }
    return _head;
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self settingView];
    
    [self getPickerData];
    
    [self initView];
}

#pragma ----UITableViewDataSource----
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
    [self.head.provinceBtn addTarget:self action:@selector(provinceAction) forControlEvents:UIControlEventTouchUpInside];
    [self.head.cityBtn addTarget:self action:@selector(cityAction) forControlEvents:UIControlEventTouchUpInside];
    [self.head.arearBtn addTarget:self action:@selector(arearAction) forControlEvents:UIControlEventTouchUpInside];
    [self.head.finished addTarget:self action:@selector(finishedAction) forControlEvents:UIControlEventTouchUpInside];
    return self.head;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.head.finished.frame.origin.y + 60;
}



#pragma ----UITextFieldDelegate----
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark 键盘的出现与消失时改变tableView的fram
-(void)keyboardWillShow:(NSNotification*)note
{
    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeigth  - 64 - keyBoardRect.size.height);
}

-(void)keyboardWillHide:(NSNotification*)note
{
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeigth - 64);
}

-(void)tapView
{
    [self resignFR];
}
-(void)resignFR
{
    [_head.userName resignFirstResponder];
    [_head.phone resignFirstResponder];
    [_head.corde resignFirstResponder];
    [_head.detaileAddress resignFirstResponder];
}


#pragma mark - get data
- (void)getPickerData {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Address" ofType:@"plist"];
    self.pickerDic = [[NSDictionary alloc] initWithContentsOfFile:path];
    self.provinceArray = [self.pickerDic allKeys];
    self.selectedArray = [self.pickerDic objectForKey:[[self.pickerDic allKeys] objectAtIndex:0]];
    
    if (self.selectedArray.count > 0) {
        self.cityArray = [[self.selectedArray objectAtIndex:0] allKeys];
    }
    
    if (self.cityArray.count > 0) {
        self.townArray = [[self.selectedArray objectAtIndex:0] objectForKey:[self.cityArray objectAtIndex:0]];
    }
    
}

#pragma mark - UIPicker Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.provinceArray.count;
    } else if (component == 1) {
        return self.cityArray.count;
    } else {
        return self.townArray.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [self.provinceArray objectAtIndex:row];
    } else if (component == 1) {
        return [self.cityArray objectAtIndex:row];
    } else {
        return [self.townArray objectAtIndex:row];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component == 0) {
        return 110;
    } else if (component == 1) {
        return 100;
    } else {
        return 110;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        self.selectedArray = [self.pickerDic objectForKey:[self.provinceArray objectAtIndex:row]];
        if (self.selectedArray.count > 0) {
            self.cityArray = [[self.selectedArray objectAtIndex:0] allKeys];
        } else {
            self.cityArray = nil;
        }
        if (self.cityArray.count > 0) {
            self.townArray = [[self.selectedArray objectAtIndex:0] objectForKey:[self.cityArray objectAtIndex:0]];
        } else {
            self.townArray = nil;
        }
    }
    [pickerView selectedRowInComponent:1];
    [pickerView reloadComponent:1];
    [pickerView selectedRowInComponent:2];
    
    if (component == 1) {
        if (self.selectedArray.count > 0 && self.cityArray.count > 0) {
            self.townArray = [[self.selectedArray objectAtIndex:0] objectForKey:[self.cityArray objectAtIndex:row]];
        } else {
            self.townArray = nil;
        }
        [pickerView selectRow:1 inComponent:2 animated:YES];
    }
    
    [pickerView reloadComponent:2];
}



//选择
- (void)choose {
    
    AddressManageController *addressmag = [[AddressManageController alloc]init];
    
    [self.navigationController pushViewController:addressmag animated:YES];
}


//选择省份
-(void)provinceAction
{
    [self resignFR];
    [self appresPickView];
    
}

//选择城市
-(void)cityAction
{
    [self resignFR];
    [self appresPickView];
    
}

//选择地区
-(void)arearAction
{
    [self resignFR];
    [self appresPickView];
}

//出现pickView
-(void)appresPickView
{
    [self.view addSubview:self.maskView];
    [self.view addSubview:self.pickerBgView];
    self.maskView.alpha = 0;
    self.pickerBgView.top = self.view.height;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0.3;
        self.pickerBgView.bottom = self.view.height;
    }];


}

//完成
-(void)finishedAction
{

    [self resignFR];
    NSDictionary *dic = nil;
    NSString *alter = nil;
    if ([_head.userName.text isEqualToString:@""]|| [_head.phone.text isEqualToString:@""]|| [_head.province.text isEqualToString:@""] || [_head.city.text isEqualToString:@""] ||
        [_head.area.text isEqualToString:@""] || [_head.detaileAddress.text isEqualToString:@""] || [_head.corde.text isEqualToString:@""]) {
        [Tools alterWithTitle:@"送货地址没有填写完整"];
        
    }else{
    if (_address) {  //修改
        alter = @"修改收货址成功";
        dic = @{
                  @"module":@"goods",
                  @"q":@"update_address",
                  @"method":@"post",
                  @"id":_address.ID,
                  @"user_id":[Tools HtUserId],
                  @"consignee":[Tools utf8:_head.userName.text],
                  @"prov":[Tools utf8:_head.province.text],
                  @"city":[Tools utf8:_head.city.text],
                  @"dist":[Tools utf8:_head.area.text],
                  @"street":[Tools utf8:_head.detaileAddress.text],
                  @"zip_code":_head.corde.text,
                  @"phone":_head.phone.text,
                  @"defult_address":@"0"
                  };
    }else{           //添加
    
        alter = @"添加收货地址成功";
        dic = @{
                  @"module":@"goods",
                  @"q":@"save_address",
                  @"method":@"post",
                  @"user_id":[Tools HtUserId],
                  @"consignee":[Tools utf8:_head.userName.text],
                  @"prov":[Tools utf8:_head.province.text],
                  @"city":[Tools utf8:_head.city.text],
                  @"dist":[Tools utf8:_head.area.text],
                  @"street":[Tools utf8:_head.detaileAddress.text],
                  @"zip_code":_head.corde.text,
                  @"phone":_head.phone.text,
                  @"defult_address":@"0"
                  };

    }
            if (![Tools isMobile:_head.phone.text]) {
                [Tools alterWithTitle:@"手机号码不正确"];
            }else if (![Tools isPost:_head.corde.text]){
                [Tools alterWithTitle:@"邮政编码不正确"];
            }else{
                [[Tools shareTools]progressWithTitle:@"请稍候..." OnView:self.view];
                NSString *str = [[Tools shareTools]dictionaryToJson:dic];
                NSString *htStr = [[Tools shareTools]htstr:str];
                NSString *md5Str = [[Tools shareTools]md5:htStr];
                NSDictionary *par = @{@"diyou":str,@"sign":md5Str};
                
                [HYBNetworking getWithUrl:kBaseUrl refreshCache:NO params:par success:^(id response) {
                    [[Tools shareTools]hidenHud];
                    if ([response[@"result"] isEqualToString:@"success"]) {
                        
                        [[Tools shareTools]progressWithTitle:alter Image:kTimage OnView:self.view Hide:1.5];
                        
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            if (_address) { //修改
                                
                                [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:6] animated:YES];
                            }else{          //添加
                                [self.navigationController popViewControllerAnimated:YES];
                            }
                            
                        });
                    }else{
                        [HTView alterTitle:response[@"error_remark"]];
                    }
                    
                    [_tableView reloadData];
                    
                } fail:^(NSError *error) {
                    [[Tools shareTools]hidenHud];
                    
                }];

            }
    }

}

#pragma pickView的取消与确定
- (IBAction)cancelBtn:(id)sender {
    [self hideMyPicker];

}

- (IBAction)shureBtn:(id)sender
{
    NSString *province = [self.provinceArray objectAtIndex:[self.pickView selectedRowInComponent:0]];
    NSString *city = [self.cityArray objectAtIndex:[self.pickView selectedRowInComponent:1]];
    NSString *arear = [self.townArray objectAtIndex:[self.pickView selectedRowInComponent:2]];
    
    _head.province.text = province;
    _head.city.text = city;
    _head.area.text = arear;
    [self hideMyPicker];

}


-(void)hideMyPicker
{
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0;
        self.pickerBgView.top = self.view.height;
    } completion:^(BOOL finished) {
        [self.maskView removeFromSuperview];
        [self.pickerBgView removeFromSuperview];
    }];

}


-(void)settingView
{
    [self.view addSubview:self.tableView];
    self.view.backgroundColor = HT_BG_COLOR;
    self.edgesForExtendedLayout = UIRectEdgeNone;

 
    
    //监听键盘出现和消失
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    _pickView.delegate = self;
    _pickView.dataSource = self;
    
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]init];
}





@end
