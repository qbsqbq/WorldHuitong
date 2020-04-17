//
//  CountDetaileCell.m
//  WorldHuitong
//
//  Created by TXHT on 16/5/26.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import "CountDetaileCell.h"

@implementation CountDetaileCell

- (void)awakeFromNib {
    // Initialization code
}

+(instancetype)CountDetaileCellWithModle:(Repayment*)modle RepaymentText:(NSString *)repaymentText
{
    CountDetaileCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"CountDetaileCell" owner:self options:nil] lastObject];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [[HTView shareHTView]setView:cell.bg_view cornerRadius:4];
    
    //期数
    cell.dataNumber.text = [NSString stringWithFormat:@"第%@期",modle.i];
    
    //时间
    cell.time.text = [Tools dateFormatterShort:[modle.repay_time intValue]];
    
    //月还款本息
    if ([repaymentText isEqualToString:@"endday"]) {
        cell.monthBenJinLable.text = @"到期还款本金:";
        cell.monthBenXiLable.text = @"到期还款本息:";
    }else{
        cell.monthBenJinLable.text = @"月还款本金:";
        cell.monthBenXiLable.text = @"月还款本息:";
    }
    cell.monthBenXi.text = [NSString stringWithFormat:@"￥%.2f",[modle.account_all floatValue]];

    
    //月还款本金
    cell.monthBenJIn.text = [NSString stringWithFormat:@"￥%.2f",[modle.account_capital floatValue]];

    //利息
    cell.lixi.text = [NSString stringWithFormat:@"￥%.2f",[modle.account_interest floatValue]];

    //余额
    cell.yue.text = [NSString stringWithFormat:@"￥%.2f",[modle.account_other floatValue]];

    
    return cell;
}
@end
