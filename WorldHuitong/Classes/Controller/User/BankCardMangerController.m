//
//  BankCardMangerController.m
//  WorldHuitong
//
//  Created by TXHT on 16/6/24.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import "BankCardMangerController.h"
#import "ModifyBankCarCell.h"
#import "ModifyBankCardController.h"
@interface BankCardMangerController ()
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSString *bankName;
@property(nonatomic,strong)NSString *bankNo;
@property(nonatomic,strong)NSString *account_all;
@property(nonatomic,strong)NSString *ID;
@property(nonatomic,strong)NSString *account;




@end

@implementation BankCardMangerController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self creatTableView];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    [self loadBankCardData];
}

#pragma ----UITableViewDataSource----
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{return 1;}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ModifyBankCarCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"ModifyBankCarCell" owner:self options:nil] lastObject];
    [[HTView shareHTView]setView:cell.bg_view cornerRadius:4];
    cell.bankName.text = _bankName;
    cell.bankCard_number.text = _bankNo;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(10, 20, kScreenWidth - 20, 44)];
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"修改银行卡" forState:UIControlStateNormal];
    button.backgroundColor = HT_COLOR;
    [[HTView shareHTView]setView:button cornerRadius:4];
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    [button addTarget:self action:@selector(modifyBankCardAction) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:button];
    return headView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 54;
    
}

//修改银行卡
-(void)modifyBankCardAction
{
    ModifyBankCardController *modifyBCvc = [[ModifyBankCardController alloc]init];
    modifyBCvc.realName = _realName;
    modifyBCvc.bankId = _ID;
    modifyBCvc.account_all = _account_all;
    modifyBCvc.account = _account;
    [self.navigationController pushViewController:modifyBCvc animated:YES];
    
}

//获取银行卡信息
-(void)loadBankCardData
{
    [[Tools shareTools]progressWithTitle:@"请稍候..." OnView:self.view];
    
    NSDictionary *dic= @{
                         @"module":@"trust",
                         @"q":@"get_users_bank",
                         @"method":@"get",
                         @"user_id":[Tools HtUserId]
                         };
    NSString *str = [[Tools shareTools]dictionaryToJson:dic];
    NSString *htStr = [[Tools shareTools]htstr:str];
    NSString *md5Str = [[Tools shareTools]md5:htStr];
    NSDictionary *par = @{@"diyou":str,@"sign":md5Str};
    
    [HYBNetworking getWithUrl:kBaseUrl refreshCache:NO params:par success:^(id response){
       
//            NSLog(@"%@",response);
        [[Tools shareTools]hidenHud];
        _bankName = response[@"bank_name"];
        _bankNo = response[@"account"];
        _account_all = response[@"account_all"];
        _ID = response[@"id"];
        _account = response[@"account"];
        [self.tableView reloadData];
        
    } fail:^(NSError *error) {
        
        [[Tools shareTools]hidenHud];
        
    }];
    
    
    
}
-(void)creatTableView
{
    self.view.backgroundColor = HT_BG_COLOR;
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]init];
    
    self.navigationItem.title = @"银行卡认证";
}



@end
