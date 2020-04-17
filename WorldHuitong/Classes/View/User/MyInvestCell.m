//
//  MyInvestCell.m
//  WorldHuitong
//
//  Created by TXHT on 16/5/3.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import "MyInvestCell.h"

@implementation MyInvestCell

+(instancetype)MyInvestCell:(UITableView*)tableView forIndexPath:(NSIndexPath*)indexPath DataArr:(NSArray*)arr
{
    MyInvestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyInvestCell" forIndexPath:indexPath];
    ;
    [[HTView shareHTView]setView:cell.bg_view cornerRadius:4];
    InverstedBiao *biao = arr[indexPath.row];
    
    //标名字
    cell.name.text = biao.borrow_name;
    
    //状态
    cell.state.text = biao.status_type_name;
    if ([biao.status_type_name isEqualToString:@"逾期中"]) {
        cell.state.textColor = [UIColor redColor];
    }else if([biao.status_type_name isEqualToString:@"回收中"]){
        cell.state.textColor = HT_TCOLOR;
    }else{
        cell.state.textColor = [UIColor lightGrayColor];
    }
    
    //总收益
    cell.allCount.text = [NSString stringWithFormat:@"%.2f",biao.recover_account_all_interest];
   
    //已收益
    cell.counted.text = [NSString stringWithFormat:@"%.2f",biao.recover_account_all_interest_yes];

    //待收益
    cell.counting.text = [NSString stringWithFormat:@"%.2f",biao.recover_account_all_interest_wait];

    
    //时间
    cell.time.text = [NSString stringWithFormat:@"起:%@\n终:%@",[Tools dateFormatterShort:biao.addtime],[Tools dateFormatterShort:biao.repay_last_time]];
    
    //总投资
    cell.allInvest.text = [NSString stringWithFormat:@"总投资(￥)%.2f",biao.account_tender];

    return cell;

}
@end
