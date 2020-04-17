//
//  MoneyNoteCell.m
//  WorldHuitong
//
//  Created by TXHT on 16/6/2.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import "MoneyNoteCell.h"
@implementation MoneyNoteCell

+(instancetype)MoneyNoteCellWithIndexPath:(NSIndexPath*)indexPath Modle:( MoneyNote *)modle Who:(NSString *)who
{
    MoneyNoteCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"MoneyNoteCell" owner:self options:nil] lastObject];
    if ([who isEqualToString:@"chongzhi"]) {
        
        //充值金额
//        if ([modle.money floatValue] >= 10000) {
//            cell.account.text = [NSString stringWithFormat:@"￥%.4f万",[modle.money floatValue] / 10000];
//        }else{
            cell.account.text = [NSString stringWithFormat:@"￥%@",modle.money];
//        }
        
        //时间
        cell.time.text = [Tools dateFormatter:[modle.addtime intValue]];
        
        //充值方式
        cell.title.text = modle.payment_name;
        
        //充值状态
        if ([modle.status isEqualToString:@"0"]) {
            cell.state_name.text = @"审核中";
            
        }if ([modle.status isEqualToString:@"1"]) {
            cell.state_name.text = @"充值成功";
            
        }if ([modle.status isEqualToString:@"0"]) {
            cell.state_name.text = @"充值失败";
            
        }

    }else if([who isEqualToString:@"tixian"]){
        //提现金额
//        if ([modle.credited floatValue] >= 10000) {
//            cell.account.text = [NSString stringWithFormat:@"￥%.2f万",[modle.credited floatValue] / 10000];
//        }else{
            cell.account.text = [NSString stringWithFormat:@"￥%@",modle.credited];
//        }
        
        //时间
        cell.time.text = [Tools dateFormatter:[modle.addtime intValue]];
        
        //提现方式
        cell.title.text = @"提现";
        
        //提现状态
        if ([modle.status isEqualToString:@"0"]) {
            cell.state_name.text = @"审核中";
            
        }if ([modle.status isEqualToString:@"1"]) {
            cell.state_name.text = @"提现成功";
            
        }if ([modle.status isEqualToString:@"2"]) {
            cell.state_name.text = @"提现失败";
            
        }if ([modle.status isEqualToString:@"3"]) {
            cell.state_name.text = @"用户取消";
        }

    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone; 
        return cell;

}

@end
