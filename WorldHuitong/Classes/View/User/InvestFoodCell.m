//
//  InvestFoodCell.m
//  WorldHuitong
//
//  Created by TXHT on 16/5/4.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import "InvestFoodCell.h"

@implementation InvestFoodCell

+(instancetype)InvestFoodCell:(UITableView*)tableView Modle:(BiaoDate*)biaoDate
{
    InvestFoodCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"InvestFoodCell" owner:self options:nil] lastObject];
    [[HTView shareHTView]setView:cell.bg_view cornerRadius:4];
    
    //期数
    cell.dateNumber.text = [NSString stringWithFormat:@"第%@期",biaoDate.recover_period];
    
    //时间
    cell.date.text = [Tools dateFormatterShort:[biaoDate.recover_time intValue]];
    
    //应收金额
    cell.yinShou.text = [NSString stringWithFormat:@"%.2f元",[biaoDate.recover_account floatValue]];

    //实收本金
    cell.shiShouBenJin.text = [NSString stringWithFormat:@"%.2f元",[biaoDate.recover_capital_yes floatValue]];

    
    //实收利息
    cell.shiShouRate.text = [NSString stringWithFormat:@"%.2f元",[biaoDate.recover_interest_yes floatValue]];
    
    //逾期天数
    if ([biaoDate.late_days isEqualToString:@"0"]) {
        cell.yuQiData.textColor = [UIColor lightGrayColor];
    }
    cell.yuQiData.text = [NSString stringWithFormat:@"%@天",biaoDate.late_days];
    
    //状态
    if ([biaoDate.r_status isEqualToString:@"未还"]) {
        cell.stateLable.textColor = HT_WCOLOR;
    }else{
        cell.stateLable.textColor = HT_TCOLOR;
    }
    
    cell.stateLable.text = biaoDate.r_status;
    
    return cell;
    
    
}

@end
