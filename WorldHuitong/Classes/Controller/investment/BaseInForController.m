//
//  BaseInForController.m
//  WorldHuitong
//
//  Created by TXHT on 16/6/3.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import "BaseInForController.h"
#import "BaseInForView.h"
#import "BorryerInForView.h"//借款人信息
#import "BorrowInfo.h"      //借款信息
#import "BorrowerInfo.h"
#import "UIImageView+WebCache.h"
@interface BaseInForController ()
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)BorrowInfo *borrowInfo; //借款信息
@property(nonatomic,strong)BorrowerInfo *borrowerInfo; //借款人信息

@property(nonatomic,strong)BaseInForView *head;
@property(nonatomic,strong)BorryerInForView *foot;


@end

@implementation BaseInForController


-(BaseInForView *)head
{
    if (!_head) {
        _head = [[[NSBundle mainBundle]loadNibNamed:@"BaseInForView" owner:self options:nil] lastObject];
        [[HTView shareHTView]setView:_head.bg_viewF cornerRadius:4];
        [[HTView shareHTView]setView:_head.bg_viewH cornerRadius:4];
        _head.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeigth);
        
    }
    return _head;
}
- (void)viewDidLoad {
   
    [super viewDidLoad];

    [self creatTableView];
    
    [self loadBorryData];
    
    [self loadBorryerInfoData];
    
    
    
    //1.自动刷新
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
       
        [self loadBorryData];
        [self loadBorryerInfoData];
    }];
    


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
        cell = [[UITableViewCell alloc]init];
    }
    return cell;
}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    [self setValueForHead];
    return self.head;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return _head.bg_viewF.frame.origin.y + 200;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    BorryerInForView *foot = [[[NSBundle mainBundle]loadNibNamed:@"BorryerInForView" owner:self options:nil] lastObject];
    [[HTView shareHTView]setView:foot.bg_view cornerRadius:4];

    foot.sex.text = _borrowerInfo.sex;
    foot.moth_incom.text = _borrowerInfo.income_name;
    foot.borthData.text = _borrowerInfo.birthday;
    foot.isMerry.text = _borrowerInfo.marry_status_name;
    foot.work_city.text = _borrowerInfo.work_city;
    foot.xueli.text = _borrowerInfo.edu;
    foot.work_time.text = _borrowerInfo.work_year;     //工作年限
    foot.company_scale.text = _borrowerInfo.company_size; //公司规模
    foot.company_nature.text = _borrowerInfo.company_type_name;
    
    if ([_borrowerInfo.house_status isEqualToString:@""]) {
        foot.isHouse.text = @"未购房";
    }else{
        foot.isHouse.text = @"已购房";
    }
    
    if ([_borrowerInfo.is_car isEqualToString:@""]) {
        foot.isCar.text = @"未购车";
    }else{
        foot.isCar.text = @"已购车";
    }
    
    foot.thePost.text = _borrowerInfo.company_position;
    return foot;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 558;

}

#pragma ----请求数据----

//借款信息数据
-(void)loadBorryData
{
    NSDictionary *dic = @{
                          @"user_id":_borryer_userID,
                          @"method":@"get",
                          @"module":@"borrow",
                          @"q":@"get_count_user_repay_count"
                          };
    NSString *str = [[Tools shareTools]dictionaryToJson:dic];
    NSString *htStr = [[Tools shareTools]htstr:str];
    NSString *md5Str = [[Tools shareTools]md5:htStr];
    NSDictionary *par = @{@"diyou":str,@"sign":md5Str};
    
    [HYBNetworking getWithUrl:kBaseUrl refreshCache:NO params:par success:^(id response) {
        
//     NSLog(@"================%@",response);
        _borrowInfo = [BorrowInfo mj_objectWithKeyValues:response];
        [self.tableView reloadData];
        [_tableView.mj_header endRefreshing];
        
    } fail:^(NSError *error) {
        [_tableView.mj_header endRefreshing];

        
    }];
    
}

//借款人信息数据
-(void)loadBorryerInfoData
{
    [[Tools shareTools]progressWithTitle:@"请稍候..." OnView:self.view];
    NSDictionary *dic = @{
                          @"user_id":_borryer_userID,
                          @"method":@"get",
                          @"module":@"users",
                          @"q":@"get_info_one"
                          };
    NSString *str = [[Tools shareTools]dictionaryToJson:dic];
    NSString *htStr = [[Tools shareTools]htstr:str];
    NSString *md5Str = [[Tools shareTools]md5:htStr];
    NSDictionary *par = @{@"diyou":str,@"sign":md5Str};
    
    [HYBNetworking getWithUrl:kBaseUrl refreshCache:NO params:par success:^(id response) {
//        NSLog(@"================%@",response);
        
        _borrowerInfo = [BorrowerInfo mj_objectWithKeyValues:response];
        [self.tableView reloadData];
        [[Tools shareTools]hidenHud];
        [_tableView.mj_header endRefreshing];

    } fail:^(NSError *error) {
        [[Tools shareTools]hidenHud];
        [_tableView.mj_header endRefreshing];

    }];
}

//借款信息
-(void)setValueForHead
{
    //发布借款次数
    if (_borrowInfo.borrow_loan_num) {
        NSString *borrow_times = [NSString stringWithFormat:@"发布借款:  %@次",_borrowInfo.borrow_loan_num];
        _head.faBuBorry.attributedText = [HTView setLableColorText:borrow_times loc:5 Color:[UIColor lightGrayColor] FontOfSize:17];
    }else{
        NSString *borrow_times = [NSString stringWithFormat:@"发布借款: 0次"];
        _head.faBuBorry.attributedText = [HTView setLableColorText:borrow_times loc:5 Color:[UIColor lightGrayColor] FontOfSize:17];
    }

    
    //成功借款
    if (_borrowInfo.borrow_success_num) {
        NSString*borrow_success_num = [NSString stringWithFormat:@"成功借款:  %@笔",_borrowInfo.borrow_success_num];
        _head.borryed.attributedText = [HTView setLableColorText:borrow_success_num loc:5 Color:[UIColor lightGrayColor]FontOfSize:17];
    }else{
        NSString*borrow_success_num = [NSString stringWithFormat:@"成功借款:  0笔"];
        _head.borryed.attributedText = [HTView setLableColorText:borrow_success_num loc:5 Color:[UIColor lightGrayColor]FontOfSize:17];
    }
    
    //还清笔数
    if (_borrowInfo.repay_yes_times) {
        NSString*repay_yes_times = [NSString stringWithFormat:@"还清笔数:  %@笔",_borrowInfo.repay_yes_times];
        _head.huanQing.attributedText = [HTView setLableColorText:repay_yes_times loc:5 Color:[UIColor lightGrayColor]FontOfSize:17];
    }else{
        NSString*repay_yes_times = [NSString stringWithFormat:@"还清笔数:  0笔"];
        _head.huanQing.attributedText = [HTView setLableColorText:repay_yes_times loc:5 Color:[UIColor lightGrayColor]FontOfSize:17];
    }
  
    
    //逾期笔数
    if (_borrowInfo.repay_late_no_num) {
        NSString*repay_late_no_num = [NSString stringWithFormat:@"逾期笔数:  %@笔",_borrowInfo.repay_late_no_num];
        _head.yuQiNumber.attributedText = [HTView setLableColorText:repay_late_no_num loc:5 Color:[UIColor lightGrayColor]FontOfSize:17];
    }else{
        NSString*repay_late_no_num = [NSString stringWithFormat:@"逾期笔数:  0笔"];
        _head.yuQiNumber.attributedText = [HTView setLableColorText:repay_late_no_num loc:5 Color:[UIColor lightGrayColor]FontOfSize:17];
    
    }
   
    
    //借款总额
    if (_borrowInfo.borrow_success_account) {
        _head.total_account.text = [NSString stringWithFormat:@"￥%@",_borrowInfo.borrow_success_account];
   }else {
        _head.total_account.text = [NSString stringWithFormat:@"￥0.00"];
    }
    
    //待还金额
    if (_borrowInfo.repay_wait_account) {
        _head.daihuan_money.text = [NSString stringWithFormat:@"￥%@",_borrowInfo.repay_wait_account];

    }else{
        _head.daihuan_money.text = [NSString stringWithFormat:@"￥0.00"];
    }

    
    //逾期金额
    if (_borrowInfo.repay_late_no_account) {
        _head.yuqi_money.text = [NSString stringWithFormat:@"￥%@",_borrowInfo.repay_late_no_account];

    }else{
        _head.yuqi_money.text = [NSString stringWithFormat:@"￥0.00"];

    }
    
    //头像
    _head.user_icon.layer.cornerRadius = 25;
    _head.user_icon.clipsToBounds = YES;
    [_head.user_icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseImageUrl,_borrowerInfo.avatar_url]]placeholderImage:[UIImage imageNamed:@"avatordefault"]];
    //用户名
    NSString *users = [_borryerName substringToIndex:1];
    _head.user_address.text = [NSString stringWithFormat:@"%@***",users];
    
    //还款表现
    _head.user_name.textColor = HT_TCOLOR;
    
    //实名认证
    if (![_user_info.realname isEqualToString:@""]) {
        _head.reamName.image = [UIImage imageNamed:@"realName_yes"];
    }else{
        _head.reamName.image = [UIImage imageNamed:@"realName_no"];
    }
    
    //邮箱认证
    if (_user_info.email_status == 1) {
        _head.email.image = [UIImage imageNamed:@"emali_yes"];
    }else{
        _head.email.image = [UIImage imageNamed:@"emali_no"];
    }
    
    //手机号认证
    if (![_user_info.phone  isEqual: @""]) {
        _head.phone.image = [UIImage imageNamed:@"phone_yes"];
    }else{
        _head.phone.image = [UIImage imageNamed:@"phone_no"];
    }


}

-(void)creatTableView
{
    self.navigationItem.title = @"基本信息";
    self.view.backgroundColor = HT_BG_COLOR;
    if ([_vcType isEqualToString:@"home"]) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeigth)];
    }else{
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeigth - 64)];
    }
    
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
}

@end
