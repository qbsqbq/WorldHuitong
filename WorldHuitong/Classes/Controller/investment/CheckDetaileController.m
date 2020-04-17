//
//  CheckDetaileController.m
//  WorldHuitong
//
//  Created by TXHT on 16/5/31.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import "CheckDetaileController.h"
#import "CheckDetaileView.h"
#import "CheckDetaileCell.h"
#import "InCome.h"
@interface CheckDetaileController ()
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSString *award;      //奖励金额
@property(nonatomic,strong)NSString *all_lixi;   //利息金额


@end

@implementation CheckDetaileController

- (void)viewDidLoad {
  
    [super viewDidLoad];
    
    [self creatTableView];
    
}

#pragma ----UITableViewDataSource----

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{return _inComes.count;}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CheckDetaileCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"CheckDetaileCell" owner:self options:nil] lastObject];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [[HTView shareHTView]setView:cell.bg_view cornerRadius:4];
    InCome *inCome = _inComes[indexPath.row];

    //时间
    cell.shou_data.text = inCome.date_time;

    //类型
    if ([inCome.type isEqualToString:@"lixi"]) {
        cell.money_type.text = @"利息";
    }else{
        cell.money_type.text = @"本息";
    }
    
    //收款总额
    cell.shou_account.text = [NSString stringWithFormat:@"￥%.2f",[_coupon_lixi floatValue]/_inComes.count + [inCome.account_all floatValue]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;

}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CheckDetaileView *head = [[[NSBundle mainBundle]loadNibNamed:@"CheckDetaileView" owner:self options:nil] lastObject];
    head.frame = CGRectMake(0, 0, kScreenWidth, 132);
    
    [[HTView shareHTView]setView:head.bg_viewf cornerRadius:4];
  
    //借款期限
    head.qixian.text = _biao.borrow_period_name;

    //含利息
    head.lixi.text = [NSString stringWithFormat:@"￥%.2f",[_lixi floatValue] - [_coupon_lixi floatValue]];

    //含奖金
    if (_coupon_lixi) {
        head.bonus.text = [NSString stringWithFormat:@"￥%.2f",[_coupon_lixi floatValue]];
    }else {
        head.bonus.text = [NSString stringWithFormat:@"￥0.00"];
    }

    return head;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  150;
}


-(void)creatTableView
{
    self.navigationItem.title = @"收益明细";
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -30, kScreenWidth, kScreenHeigth + 30) style:UITableViewStyleGrouped];
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = HT_BG_COLOR;
    [self.view addSubview:_tableView];

}

@end
