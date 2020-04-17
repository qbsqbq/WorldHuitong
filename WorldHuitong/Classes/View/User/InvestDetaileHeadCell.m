//
//  InvestDetaileHeadCell.m
//  WorldHuitong
//
//  Created by TXHT on 16/5/4.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import "InvestDetaileHeadCell.h"

@implementation InvestDetaileHeadCell

+(instancetype)InvestDetaileHeadCell:(UITableView*)tableView Modle:(InverstedBiao*)biao
{
    
    InvestDetaileHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InvestDetaileHeadCell"];
    [[HTView shareHTView]setView:cell.bg_view cornerRadius:4];
    cell.title.text = biao.name;
   
    //借款编号
    cell.number.text = biao.borrow_nid;
    
    //年利率
    cell.rate.text = [[NSString stringWithFormat:@"%.2f",biao.borrow_apr] stringByAppendingString:@"%"];
    
    //预期收益
        cell.expectedReturn.text = [NSString stringWithFormat:@"%.2f元",biao.recover_account_interest];

    //还款方式
    cell.PayMethod.text = biao.style_name;
    
    //期数
    cell.borry_dates.text = biao.borrow_period_name;
    
    //时间
    cell.borry_time.text = [NSString stringWithFormat:@"%@\n%@",[Tools dateFormatterShort:[biao.borrow_success_time intValue]],[Tools dateFormatterShort:biao.repay_last_time]];
    
    return cell;


}
@end
