//
//  InvestMiddleCell.m
//  WorldHuitong
//
//  Created by TXHT on 16/5/4.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import "InvestMiddleCell.h"

@implementation InvestMiddleCell

+(instancetype)InvestMiddleCell:(UITableView*)tableView Modle:(InverstedBiao*)biao
{
    InvestMiddleCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"InvestMiddleCell" owner:self options:nil] lastObject];
    [[HTView shareHTView]setView:cell.bg_view cornerRadius:4];
    

        cell.principal.text = [NSString stringWithFormat:@"%.2f元",biao.account_tender];
    
    //应收本息
    float bengXi = biao.account_tender + biao.recover_account_interest;
    cell.interest.text = [NSString stringWithFormat:@"%.2f元",bengXi];
    
    //已赚奖励
    cell.reward.text = [NSString stringWithFormat:@"%.2f元",biao._award_account];
    
    return cell;
    
    
}


@end
